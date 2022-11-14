resource "aws_vpc" "ec2_github_runner" {
  cidr_block           = var.base_cidr_block
  enable_dns_support   = true
  enable_dns_hostnames = true

  tags = {
    Environment = var.resource_prefix
    Name        = "AWS EC2 Github Runner"
  }
}

resource "aws_subnet" "ec2_github_runner" {
  vpc_id                  = aws_vpc.ec2_github_runner.id
  cidr_block              = cidrsubnet(var.base_cidr_block, 8, 2)
  map_public_ip_on_launch = true

  tags = {
    Environment = "${var.resource_prefix}"
    Name        = "AWS EC2 Github Runner"
  }
}

resource "aws_internet_gateway" "ec2_github_runner" {
  vpc_id = aws_vpc.ec2_github_runner.id

  tags = {
    Environment = "${var.resource_prefix}"
    Name        = "AWS EC2 Github Runner"
  }
}

resource "aws_default_route_table" "ec2_github_runner" {
  default_route_table_id = aws_vpc.ec2_github_runner.default_route_table_id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.ec2_github_runner.id
  }

  tags = {
    Environment = "${var.resource_prefix}"
    Name        = "AWS EC2 Github Runner"
  }
}
