resource "aws_iam_user" "ec2_github_runner_user" {
  name = "${var.environment}-ec2-github-runner"
}

resource "aws_iam_access_key" "ec2_github_runner_key" {
  user = aws_iam_user.ec2_github_runner_user.name
}

resource "aws_iam_user_policy" "ec2_github_runner_user_poily" {
  name = "${var.environment}-ec2-github-runner-user-policy"
  user = aws_iam_user.ec2_github_runner_user.name

  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": [
        "ec2:RunInstances",
        "ec2:TerminateInstances",
        "ec2:DescribeInstances",
        "ec2:DescribeInstanceStatus"
      ],
      "Resource": "*"
    },
    {
      "Effect": "Allow",
      "Action": [
        "ec2:ReplaceIamInstanceProfileAssociation",
        "ec2:AssociateIamInstanceProfile"
      ],
      "Resource": "*"
    },
    {
      "Effect": "Allow",
      "Action": "iam:PassRole",
      "Resource": "*"
    },
    {
      "Effect": "Allow",
      "Action": [
        "ec2:CreateTags"
      ],
      "Resource": "*",
      "Condition": {
        "StringEquals": {
          "ec2:CreateAction": "RunInstances"
        }
      }
    }
  ]
}

EOF
}