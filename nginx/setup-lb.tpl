#cloud-boothook
#!/bin/sh
echo "Creating tmp folder"
sudo mkdir -p /tmp/nginx_conf
echo "Downloading default.conf"
sudo aws s3 cp --region us-east-1 ${s3_bucket_nginx_conf} /tmp/nginx_conf --recursive
echo "Updating nginx conf folder"
sudo cp /tmp/nginx_conf/nginx.conf /etc/nginx/
sudo cp /tmp/nginx_conf/default.conf /etc/nginx/conf.d/
echo "Cleaning up tmp folder"
rm -rf /tmp/nginx_conf
nginx -s reload