data "template_file" "nginx_userdata" {
  template = "${file("setup-lb.tpl")}"
}
