output "nginx_public_ip" {
  value = "${aws_instance.nginx_ec2.public_ip}"
}

output "nginx_ec2_id" {
  value = "${aws_instance.nginx_ec2.id}"
}
