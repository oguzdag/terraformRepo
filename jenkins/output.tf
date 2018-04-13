output "Jenkins_IP" {
  value = "${aws_eip.lb.public_ip}"
}
