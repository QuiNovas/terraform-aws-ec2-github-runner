resource "aws_security_group" "ec2_github_runner" {
  name   = "${var.resource_prefix}-ec2-github-runner"
  vpc_id = aws_vpc.ec2_github_runner.id

  tags = {
    Environment = "${var.resource_prefix}"
    Name        = "AWS EC2 Github Runner"
  }
}

resource "aws_security_group_rule" "ec2_github_runner" {
  type              = "egress"
  from_port         = 0
  to_port           = 65535
  protocol          = "all"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.ec2_github_runner.id
}
