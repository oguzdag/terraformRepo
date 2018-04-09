data "template_file" "jenkins_userdata" {
  template = "${file("userdata.tpl")}"

  vars {
    EnvName = "${var.env_name}"

    # The name of the bucket that will store our Jenkins resources. This was created in terraform-aws-init
    JenkinsBucket = "jenkins-files-${var.region}"
  }
}
