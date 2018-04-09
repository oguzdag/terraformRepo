provider "aws" {
  access_key = "${var.access_key}"
  secret_key = "${var.secret_key}"
  region     = "${var.region}"
}

resource "aws_key_pair" "provisioner" {
  key_name   = "terransible_provisioner"
  public_key = "${file("keys/jenkins-key.pub")}"
}

terraform {
  backend "s3" {
    bucket = "terraform-remote-state-387746"
    key    = "aws10/jenkins-tfstate"
    region = "us-east-1"
  }
}
