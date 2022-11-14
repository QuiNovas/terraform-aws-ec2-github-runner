resource "aws_vpc" "ec2_github_runner_vpc" {
  cidr_block           = var.base_cidr_block
  enable_dns_support   = true
  enable_dns_hostnames = true

  tags = {
    Environment = var.environment
    Name        = "AWS EC2 Github runner"
  }
}

resource "aws_subnet" "ec2_github_runner_subnet" {
  vpc_id                  = aws_vpc.ec2_github_runner_vpc.id
  cidr_block              = cidrsubnet(var.base_cidr_block, 8, 2)
  map_public_ip_on_launch = true

  tags = {
    Environment = "${var.environment}"
    Name        = "AWS EC2 Github runner"
  }
}
