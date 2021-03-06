variable "access_key" {}
variable "secret_key" {}
data "aws_availability_zones" "available" {}

variable "region" {
  default = "us-east-1"
}

variable "aws_amis" {
  type = "map"

  default = {
    "ap-northeast-1" = "ami-dbc0bcbc"
    "ap-northeast-2" = "ami-6d8b5a03"
    "ap-south-1"     = "ami-9a83f5f5"
    "ap-southeast-1" = "ami-0842e96b"
    "ap-southeast-2" = "ami-881317eb"
    "ca-central-1"   = "ami-a1fe43c5"
    "eu-central-1"   = "ami-5900cc36"
    "eu-west-1"      = "ami-402f1a33"
    "eu-west-2"      = "ami-87848ee3"
    "sa-east-1"      = "ami-b256ccde"
    "us-east-1"      = "ami-b14ba7a7"
    "us-east-2"      = "ami-b2795cd7"
    "us-west-1"      = "ami-94bdeef4"
    "us-west-2"      = "ami-221ea342"
  }
}

variable "availability_zones" {
  default = "us-east-1a,us-east-1b"
}

variable "env_name" {
  default     = "esp-ci"
  description = "The name of the environment and resource namespacing."
}

variable "instance_type" {
  default = "m4.large"
}

variable "vpc_cidr" {
  default = "10.0.0.0/16"
}

variable "subnet_cidr" {
  default = "10.0.0.0/24"
}
