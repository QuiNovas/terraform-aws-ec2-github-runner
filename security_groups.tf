resource "aws_security_group" "ec2_github_runner_security_group" {
  name   = "${var.environment}-ec2-github-runner-security-group"
  vpc_id = aws_vpc.ec2_github_runner_vpc.id
  tags = {
    Environment = "${var.environment}"
    Name        = "AWS EC2 Github runner"
  }
}

resource "aws_security_group_rule" "ec2_github_runner_security_group_rule" {
  type              = "egress"
  from_port         = 0
  to_port           = 65535
  protocol          = "all"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.ec2_github_runner_security_group.id
}
