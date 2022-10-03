data "aws_iam_policy_document" "ec2_assume_role" {
  statement {
    actions = [
      "sts:AssumeRole"
    ]
    principals {
      identifiers = [
        "ec2.amazonaws.com"
      ]
      type = "Service"
    }
  }
}

resource "aws_iam_role" "ec2_github_runner_imagebuilder_role" {
  name = "${var.environment}-ec2-github-runner-imagebuilder-role"
  managed_policy_arns = [
    "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore",
    "arn:aws:iam::aws:policy/EC2InstanceProfileForImageBuilder"
  ]
  assume_role_policy = data.aws_iam_policy_document.ec2_assume_role.json
}

resource "aws_iam_role" "ec2_github_runner_role" {
  name = "${var.environment}-ec2-github-runner-role"
  managed_policy_arns = [
    "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore",
  ]
  assume_role_policy = data.aws_iam_policy_document.ec2_assume_role.json
}
