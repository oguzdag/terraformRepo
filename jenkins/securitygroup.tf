resource "aws_security_group" "public" {
  name        = "tf-${var.env_name}-public-sg"
  description = "Managed By Terraform"
  vpc_id      = "${aws_vpc.main.id}"

  tags {
    Name      = "tf-${var.env_name}-public-sg"
    ManagedBy = "Terraform"
  }

  ingress {
    from_port = 22
    to_port   = 22
    protocol  = "tcp"

    cidr_blocks = [
      "0.0.0.0/0",
    ]
  }

  ingress {
    from_port = 8080
    to_port   = 8080
    protocol  = "tcp"

    cidr_blocks = [
      "0.0.0.0/0",
    ]
  }

  ingress {
    from_port = 8090
    to_port   = 8090
    protocol  = "tcp"

    cidr_blocks = [
      "0.0.0.0/0",
    ]
  }

  egress {
    from_port = 0
    to_port   = 0
    protocol  = "-1"

    cidr_blocks = [
      "0.0.0.0/0",
    ]
  }
}
