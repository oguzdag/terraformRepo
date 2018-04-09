data "template_file" "nginx_userdata" {
  template = "${file("setup-lb.tpl")}"

  vars {
    s3_bucket_nginx_conf = "${var.s3_bucket_nginx_conf}"
  }
}
