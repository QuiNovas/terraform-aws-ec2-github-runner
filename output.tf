output "runner_aws_access_key_id" {
  value       = aws_iam_access_key.ec2_github_runner.id
  description = "The access key generated for the EC2 github runner."
}

output "runner_aws_secret_access_key" {
  value       = aws_iam_access_key.ec2_github_runner.secret
  sensitive   = true
  description = "The secret key generated for the EC2 github runner."
}

output "runner_iam_role_name" {
  value       = aws_iam_role.ec2_github_runner.name
  description = "The name of the EC2 github runner IAM role."
}

output "runner_subnet_id" {
  value       = aws_subnet.ec2_github_runner.id
  description = "ID of the EC2 github runner subnet."
}

output "runner_security_group_id" {
  value       = aws_security_group.ec2_github_runner.id
  description = "ID of the EC2 github runner security group."
}

output "ec2_runner_image_info_x86" {
  value       = var.architecture == "all" || var.architecture == "x86" ? aws_imagebuilder_image.ec2_github_runner_x86[0].output_resources : []
  description = "x86_64 architecture image information."
}

output "ec2_runner_image_info_arm64" {
  value       = var.architecture == "all" || var.architecture == "arm64" ? aws_imagebuilder_image.ec2_github_runner_arm64[0].output_resources : []
  description = "arm64 architecture image information."
}

output "runner_aws_region" {
  value       = data.aws_region.current.name
  description = "The EC2 github runner region."
}
