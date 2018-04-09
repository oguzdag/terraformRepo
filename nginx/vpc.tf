resource "aws_vpc" "main" {
  cidr_block = "10.10.0.0/16"

  tags {
    Name      = "tf-${var.env_name}-vpc"
    ManagedBy = "Terraform"
  }
}

resource "aws_internet_gateway" "main" {
  vpc_id = "${aws_vpc.main.id}"

  tags {
    ManagedBy = "Terraform"
  }
}

resource "aws_route" "internet_access" {
  route_table_id         = "${aws_vpc.main.main_route_table_id}"
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = "${aws_internet_gateway.main.id}"
}

resource "aws_subnet" "public" {
  count                   = "${length(split(",",var.availability_zones))}"
  vpc_id                  = "${aws_vpc.main.id}"
  cidr_block              = "${cidrsubnet(aws_vpc.main.cidr_block, 8, count.index+1)}"
  map_public_ip_on_launch = true
  availability_zone       = "${element(split(",",var.availability_zones), count.index)}"

  tags {
    Name      = "${format("tf-aws-${var.env_name}-public-%03d", count.index+1)}"
    ManagedBy = "Terraform"
  }
}
