resource "aws_iam_user" "ec2_github_runner" {
  name = "${var.resource_prefix}-ec2-github-runner"
}

resource "aws_iam_access_key" "ec2_github_runner" {
  user = aws_iam_user.ec2_github_runner.name
}

resource "aws_iam_user_policy" "ec2_github_runner" {
  name   = "${var.resource_prefix}-ec2-github-runner-user-policy"
  user   = aws_iam_user.ec2_github_runner.name
  policy = data.aws_iam_policy_document.ec2_github_runner.json
}

data "aws_iam_policy_document" "ec2_github_runner" {
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
