output "access_key_id" {
  value = aws_iam_access_key.ec2_github_runner_key.id
}

output "secret_key" {
  value     = aws_iam_access_key.ec2_github_runner_key.secret
  sensitive = true
}

output "role_name" {
  value = aws_iam_role.ec2_github_runner_role.name
}

output "subnet_id" {
  value = aws_subnet.ec2_github_runner_subnet.id
}

output "security_group" {
  value = aws_security_group.ec2_github_runner_security_group.id
}