resource "aws_imagebuilder_component" "ec2_github_runner" {
  name                  = "${var.environment}-ec2-github-runner"
  platform              = "Linux"
  version               = "1.0.0"
  supported_os_versions = ["Amazon Linux 2"]
  data = yamlencode({
    phases = [{
      name = "build"
      steps = [{
        action = "ExecuteBash"
        inputs = {
          commands = [
            "sudo yum update",
            "sudo yum install docker git gcc openssl-devel bzip2-devel libffi-devel",
            "systemctl enable docker",
            "cd /opt",
            "sudo wget https://www.python.org/ftp/python/${local.python_version}/Python-${local.python_version}.tgz",
            "sudo tar xzf Python-${local.python_version}.tgz",
            "cd Python-${local.python_version}",
            "sudo ./configure --enable-optimizations",
            "sudo make altinstall",
            "sudo rm -f /opt/Python-${local.python_version}.tgz"
          ]
        }
        name      = "${var.environment}-ec2-github-runner"
        onFailure = "Continue"
      }]
    }]
    schemaVersion = "1.0"
  })
  tags = {
    Environment = "${var.environment}"
    Name        = "AWS EC2 Github runner"
  }
}

resource "aws_imagebuilder_image_recipe" "ec2_github_runner" {
  component {
    component_arn = aws_imagebuilder_component.ec2_github_runner.arn
  }
  block_device_mapping {
    device_name = "/dev/xvdb"

    ebs {
      volume_size           = 100
      volume_type           = "gp2"
      delete_on_termination = true
    }
  }

  name         = "${var.environment}-ec2-github-runner"
  parent_image = "arn:aws:imagebuilder:${var.region}:aws:image/amazon-linux-2-x86/x.x.x"
  version      = "1.0.0"
  tags = {
    Environment = "${var.environment}"
    Name        = "AWS EC2 Github runner"
  }
}

resource "aws_iam_instance_profile" "ec2_github_runner" {
  name = "${var.environment}-ec2-github-runner"
  role = aws_iam_role.ec2_github_runner_role.name
  tags = {
    Environment = "${var.environment}"
    Name        = "AWS EC2 Github runner"
  }
}

resource "aws_imagebuilder_infrastructure_configuration" "ec2_github_runner" {
  instance_profile_name         = aws_iam_instance_profile.ec2_github_runner.name
  name                          = "${var.environment}-ec2-github-runner"
  instance_types                = ["m5d.xlarge", "m6a.xlarge"]
  terminate_instance_on_failure = true
  tags = {
    Environment = "${var.environment}"
    Name        = "AWS EC2 Github runner"
  }
}

resource "aws_imagebuilder_distribution_configuration" "ec2_github_runner" {
  name = "ec2_github_runner"
  distribution {
    ami_distribution_configuration {
      name = "ec2-github-runner-{{ imagebuilder:buildDate }}"
    }
    region = var.region
  }
  tags = {
    Environment = "${var.environment}"
    Name        = "AWS EC2 Github runner"
  }
}

resource "aws_imagebuilder_image" "ec2_github_runner" {
  distribution_configuration_arn   = aws_imagebuilder_distribution_configuration.ec2_github_runner.arn
  image_recipe_arn                 = aws_imagebuilder_image_recipe.ec2_github_runner.arn
  infrastructure_configuration_arn = aws_imagebuilder_infrastructure_configuration.ec2_github_runner.arn
  tags = {
    Environment = "${var.environment}"
    Name        = "AWS EC2 Github runner"
  }
}