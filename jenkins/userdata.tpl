#!/bin/bash
export DEBIAN_FRONTEND=noninteractive
export HOME=/root

exec > >(tee /var/log/user-data.log|logger -t user-data -s 2>/dev/console) 2>&1

echo "BEGIN"

export ENV_NAME=${EnvName}
echo "${EnvName}" > /opt/env

while [ ! -e /dev/xvdf ]
do
    echo 'waiting for /dev/xvdf to attach'
    sleep 10
done
mkdir /data

if [[ $(file -s /dev/xvdf | awk '{ print $2 }') == data ]]
then
    mkfs -t ext4 /dev/xvdf > /tmp/mkfs.log
fi

echo '/dev/xvdf /data ext4 defaults 0 0' | tee -a /etc/fstab
mount /data > /tmp/mount.log

cd /var/lib

mkdir -p /data/jenkins
mkdir -p /data/docker

ln -s /data/jenkins jenkins
ln -s /data/docker docker

timedatectl set-timezone UTC

apt-get update
apt-get install -y git wget jq vim unzip ca-certificates

echo "Installing Docker"
apt-get install -y apt-transport-https curl gnupg2 software-properties-common
curl -fsSL https://download.docker.com/linux/debian/gpg | sudo apt-key add -
apt-key fingerprint 0EBFCD88
sudo add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/debian $(lsb_release -cs) stable"
apt-get update
apt-get install -y docker-ce

echo "Installing Oracle Java 8"
echo /usr/bin/debconf shared/accepted-oracle-license-v1-1 select true | /usr/bin/debconf-set-selections
echo "deb http://ppa.launchpad.net/webupd8team/java/ubuntu trusty main" | sudo tee /etc/apt/sources.list.d/oraclejava8.list
echo "deb-src http://ppa.launchpad.net/webupd8team/java/ubuntu trusty main" | sudo tee -a /etc/apt/sources.list.d/oraclejava8.list
apt-key adv --keyserver keyserver.ubuntu.com --recv-keys EEA14886
apt-get update
apt-get install -y oracle-java8-installer
apt-get install -y oracle-java8-set-default

echo "Installing Jenkins"
wget -q -O - https://pkg.jenkins.io/debian/jenkins.io.key | sudo apt-key add -
if ! grep -q "deb https://pkg.jenkins.io/debian binary/" /etc/apt/sources.list; then
    echo "deb https://pkg.jenkins.io/debian binary/" | sudo tee -a /etc/apt/sources.list
fi
apt-get update
apt-get install -y jenkins

echo "Removing Jenkins Security"
sed -i -e 's#^JAVA_ARGS="-Djava.awt.headless=true"#JAVA_ARGS="-Djava.awt.headless=true -Djenkins.install.runSetupWizard=false"#' /etc/default/jenkins
if grep -q "<authorizationStrategy class=\"hudson.security.FullControlOnceLoggedInAuthorizationStrategy\">" /var/lib/jenkins/config.xml; then
    rm /var/lib/jenkins/config.xml
fi

chown -h jenkins:root /var/lib/jenkins

printf '%s\n' 'Waiting for Jenkins to restart'
service jenkins restart  || {
    printf '%s\n' 'Failed to Start Jenkins'
    exit 1
}

printf  '%s\n' 'Adding Jenkins to update-rc.d'
update-rc.d jenkins defaults || {
    printf '%s\n' 'Failed to add Jenkins to update-rc.d'
    exit 1
}

until wget -O /root/jenkins-cli.jar http://localhost:8080/jnlpJars/jenkins-cli.jar; do
    echo "Trying to download jenkins-cli.jar attempt."
    sleep 10
done

java -jar /root/jenkins-cli.jar -s http://localhost:8080/ help || {
    printf '%s\n' 'Running jar for jenkins failed'
    exit 1
}

UPDATE_LIST=$( java -jar /root/jenkins-cli.jar -s http://localhost:8080/ list-plugins | grep -e ')$' | awk '{ print $1 }' );
if [ ! -z "$UPDATE_LIST" ]; then
    echo Updating Jenkins Plugins: $UPDATE_LIST;
    java -jar /root/jenkins-cli.jar -s http://127.0.0.1:8080/ install-plugin $UPDATE_LIST ;
fi

for each in "
    sectioned-view
    workflow-aggregator
    join
    ws-cleanup
    git
    git-client
    github
    github-api
    dashboard-view
    parameterized-trigger
    run-condition
    build-with-parameters
    credentials
    plain-credentials
    ssh-agent
    scm-api
    kubernetes
    thinBackup
    blueocean
    job-import-plugin
    slack
    role-strategy
    pipeline-utility-steps
";
do
    java -jar /root/jenkins-cli.jar -s http://localhost:8080/ install-plugin $each ;
done

java -jar /root/jenkins-cli.jar -s http://localhost:8080/ restart

until wget -O /root/jenkins-cli.jar http://localhost:8080/jnlpJars/jenkins-cli.jar; do
    echo "Trying to download jenkins-cli.jar attempt to check jenkins is backup and running."
    sleep 10
done

usermod -g docker jenkins

echo "Installing Terraform"
mkdir -p /opt/terraform
wget https://releases.hashicorp.com/terraform/0.10.3/terraform_0.10.3_linux_amd64.zip -O /opt/terraform/terraform_0.10.3_linux_amd64.zip
mv /usr/bin/terraform /usr/bin/terraform-old #failsafe
cd /opt/terraform ; unzip terraform_0.10.3_linux_amd64.zip
ln -s /opt/terraform/terraform /usr/bin/terraform
