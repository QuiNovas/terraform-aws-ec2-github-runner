resource "aws_vpc" "ec2_github_runner_vpc" {
  cidr_block           = var.base_cidr_block
  enable_dns_support   = true
  enable_dns_hostnames = true

  tags = {
    Environment = var.resource_prefix
    Name        = "AWS EC2 Github runner"
  }
}

resource "aws_subnet" "ec2_github_runner_subnet" {
  vpc_id                  = aws_vpc.ec2_github_runner_vpc.id
  cidr_block              = cidrsubnet(var.base_cidr_block, 8, 2)
  map_public_ip_on_launch = true

  tags = {
    Environment = "${var.resource_prefix}"
    Name        = "AWS EC2 Github runner"
  }
}

resource "aws_internet_gateway" "ec2_github_runner_internet_gateway" {
  vpc_id = aws_vpc.ec2_github_runner_vpc.id

  tags = {
    Environment = "${var.resource_prefix}"
    Name        = "AWS EC2 Github runner"
  }
}

resource "aws_route_table" "ec2_github_runner_route_table" {
  vpc_id = aws_vpc.ec2_github_runner_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.ec2_github_runner_internet_gateway.id
  }
}