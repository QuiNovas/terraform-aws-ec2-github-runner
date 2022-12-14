resource "aws_iam_role" "ec2_github_runner" {
  name = "${var.resource_prefix}-ec2-github-runner"
  managed_policy_arns = [
    "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore",
  ]
  assume_role_policy = data.aws_iam_policy_document.ec2_assume_role.json
}

resource "aws_iam_instance_profile" "ec2_github_runner" {
  name = aws_iam_role.ec2_github_runner.name
  role = aws_iam_role.ec2_github_runner.name
  tags = {
    Name = "AWS EC2 Github runner instance profile"
  }
}
