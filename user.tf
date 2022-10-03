resource "aws_iam_user" "ec2_github_runner_user" {
  name = "${var.environment}-ec2-github-runner"
}

resource "aws_iam_access_key" "ec2_github_runner_key" {
  user = aws_iam_user.ec2_github_runner_user.name
}

resource "aws_iam_user_policy" "ec2_github_runner_user_policy" {
  name   = "${var.environment}-ec2-github-runner-user-policy"
  user   = aws_iam_user.ec2_github_runner_user.name
  policy = data.aws_iam_policy_document.ec2_github_runner_policy_document.json
}

data "aws_iam_policy_document" "ec2_github_runner_policy_document" {
  statement {
    sid       = ""
    effect    = "Allow"
    resources = ["*"]

    actions = [
      "ec2:RunInstances",
      "ec2:TerminateInstances",
      "ec2:DescribeInstances",
      "ec2:DescribeInstanceStatus",
    ]
  }

  statement {
    sid       = ""
    effect    = "Allow"
    resources = ["*"]

    actions = [
      "ec2:ReplaceIamInstanceProfileAssociation",
      "ec2:AssociateIamInstanceProfile",
    ]
  }

  statement {
    sid       = ""
    effect    = "Allow"
    resources = ["*"]
    actions   = ["iam:PassRole"]
  }

  statement {
    sid       = ""
    effect    = "Allow"
    resources = ["*"]
    actions   = ["ec2:CreateTags"]

    condition {
      test     = "StringEquals"
      variable = "ec2:CreateAction"
      values   = ["RunInstances"]
    }
  }
}