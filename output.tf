output "runner_aws_access_key_id" {
  value = aws_iam_access_key.ec2_github_runner_key.id
}

output "runner_aws_secret_access_key" {
  value     = aws_iam_access_key.ec2_github_runner_key.secret
  sensitive = true
}

output "runner_iam_role_name" {
  value = aws_iam_role.ec2_github_runner_role.name
}

output "runner_subnet_id" {
  value = aws_subnet.ec2_github_runner_subnet.id
}

output "runner_security_group_id" {
  value = aws_security_group.ec2_github_runner_security_group.id
}

output "ec2_runner_image_info_x86" {
  value = aws_imagebuilder_image.ec2_github_runner_x86.output_resources
}

output "ec2_runner_image_info_arm64" {
  value = aws_imagebuilder_image.ec2_github_runner_arm64.output_resources
}

output "runner_aws_region" {
  value = var.region
}