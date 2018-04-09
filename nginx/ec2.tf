resource "aws_instance" "nginx_ec2" {
  ami           = "${lookup(var.aws_amis, var.region)}"
  instance_type = "${var.instance_type}"
  key_name      = "${aws_key_pair.provisioner.key_name}"

  vpc_security_group_ids = [
    "${aws_security_group.public.id}",
  ]

  subnet_id                   = "${element(aws_subnet.public.*.id, 0)}"
  associate_public_ip_address = true
  source_dest_check           = false
  iam_instance_profile        = "${aws_iam_instance_profile.jenkins_profile.name}"

  user_data = "${data.template_file.nginx_userdata.rendered}"

  tags {
    Name            = "Jenkins-${var.env_name}-${var.region}"
    ManagedBy       = "Terraform"
    IamInstanceRole = "${aws_iam_role.jenkins_iam_role.name}"
  }
}
