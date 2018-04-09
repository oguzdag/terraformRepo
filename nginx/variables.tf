variable "access_key" {}
variable "secret_key" {}
data "aws_availability_zones" "available" {}

variable "region" {
  default = "us-east-1"
}

variable "aws_amis" {
  type = "map"

  default = {
    "us-east-1" = "ami-54825e2b" # Custom AMI built with packer
  }
}

variable "availability_zones" {
  default = "us-east-1a,us-east-1b"
}

variable "env_name" {
  default     = "esp-lb"
  description = "The name of the environment and resource namespacing."
}

variable "instance_type" {
  default = "t2.medium"
}

variable "vpc_cidr" {
  default = "10.0.0.0/16"
}

variable "subnet_cidr" {
  default = "10.0.0.0/24"
}
