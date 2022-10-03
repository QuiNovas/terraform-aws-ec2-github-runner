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
          commands = local.image_builder_commands
        }
        name = "${var.environment}-ec2-github-runner"
      }]
    }]
    schemaVersion = "1.0"
  })
  tags = {
    Environment = "${var.environment}"
    Name        = "AWS EC2 Github runner"
  }
}

resource "aws_imagebuilder_image_recipe" "ec2_github_runner_arm64" {
  component {
    component_arn = aws_imagebuilder_component.ec2_github_runner.arn
  }
  block_device_mapping {
    device_name = "/dev/xvdb"

    ebs {
      volume_size           = 16
      volume_type           = "gp2"
      delete_on_termination = true
    }
  }

  name         = "${var.environment}-ec2-github-runner-arm64"
  parent_image = "arn:aws:imagebuilder:${var.region}:aws:image/amazon-linux-2-arm64/x.x.x"
  version      = "1.0.0"
  tags = {
    Environment = "${var.environment}"
    Name        = "AWS EC2 Github runner"
  }
}

resource "aws_imagebuilder_image_recipe" "ec2_github_runner_x86" {
  component {
    component_arn = aws_imagebuilder_component.ec2_github_runner.arn
  }
  block_device_mapping {
    device_name = "/dev/xvdb"

    ebs {
      volume_size           = 16
      volume_type           = "gp2"
      delete_on_termination = true
    }
  }

  name         = "${var.environment}-ec2-github-runner-x86"
  parent_image = "arn:aws:imagebuilder:${var.region}:aws:image/amazon-linux-2-x86/x.x.x"
  version      = "1.0.0"
  tags = {
    Environment = "${var.environment}"
    Name        = "AWS EC2 Github runner"
  }
}

resource "aws_iam_instance_profile" "ec2_github_runner" {
  name = "${var.environment}-ec2-github-runner"
  role = aws_iam_role.ec2_github_runner_imagebuilder_role.name
  tags = {
    Environment = "${var.environment}"
    Name        = "AWS EC2 Github runner"
  }
}

resource "aws_imagebuilder_infrastructure_configuration" "ec2_github_runner_arm64" {
  instance_profile_name         = aws_iam_instance_profile.ec2_github_runner.name
  name                          = "${var.environment}-ec2-github-runner-arm64"
  instance_types                = ["m6g.xlarge", "m6gd.xlarge"]
  terminate_instance_on_failure = true
  tags = {
    Environment = "${var.environment}"
    Name        = "AWS EC2 Github runner"
  }
}

resource "aws_imagebuilder_infrastructure_configuration" "ec2_github_runner_x86" {
  instance_profile_name         = aws_iam_instance_profile.ec2_github_runner.name
  name                          = "${var.environment}-ec2-github-runner-x86"
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

resource "aws_imagebuilder_image" "ec2_github_runner_arm64" {
  distribution_configuration_arn   = aws_imagebuilder_distribution_configuration.ec2_github_runner.arn
  image_recipe_arn                 = aws_imagebuilder_image_recipe.ec2_github_runner_arm64.arn
  infrastructure_configuration_arn = aws_imagebuilder_infrastructure_configuration.ec2_github_runner_arm64.arn
  tags = {
    Environment = "${var.environment}"
    Name        = "AWS EC2 Github runner arm64"
  }
}

resource "aws_imagebuilder_image" "ec2_github_runner_x86" {
  distribution_configuration_arn   = aws_imagebuilder_distribution_configuration.ec2_github_runner.arn
  image_recipe_arn                 = aws_imagebuilder_image_recipe.ec2_github_runner_x86.arn
  infrastructure_configuration_arn = aws_imagebuilder_infrastructure_configuration.ec2_github_runner_x86.arn
  tags = {
    Environment = "${var.environment}"
    Name        = "AWS EC2 Github runner x86"
  }
  depends_on = [
    aws_imagebuilder_image.ec2_github_runner_arm64
  ]
}