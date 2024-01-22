resource "aws_imagebuilder_component" "ec2_github_runner" {
  name                  = "${var.resource_prefix}-ec2-github-runner"
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
        name = "${var.resource_prefix}-ec2-github-runner"
      }]
    }]
    schemaVersion = "1.0"
  })
  tags = {
    Environment = "${var.resource_prefix}"
    Name        = "AWS EC2 Github Runner"
  }
}

resource "aws_imagebuilder_image_recipe" "ec2_github_runner_arm64" {
  count = var.architecture == "all" || var.architecture == "arm64" ? 1 : 0
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

  name         = "${var.resource_prefix}-ec2-github-runner-arm64"
  parent_image = "arn:aws:imagebuilder:${data.aws_region.current.name}:aws:image/amazon-linux-${var.amazon_linux_version}-arm64/x.x.x"
  version      = "1.0.0"
  tags = {
    Environment = "${var.resource_prefix}"
    Name        = "AWS EC2 Github Runner"
  }
}

resource "aws_imagebuilder_image_recipe" "ec2_github_runner_x86" {
  count = var.architecture == "all" || var.architecture == "x86" ? 1 : 0
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

  name         = "${var.resource_prefix}-ec2-github-runner-x86"
  parent_image = "arn:aws:imagebuilder:${data.aws_region.current.name}:aws:image/amazon-linux-${var.amazon_linux_version}-x86/x.x.x"
  version      = "1.0.0"
  tags = {
    Environment = "${var.resource_prefix}"
    Name        = "AWS EC2 Github Runner"
  }
}

resource "aws_iam_role" "ec2_github_runner_imagebuilder" {
  name = "${var.resource_prefix}-ec2-github-runner-imagebuilder"
  managed_policy_arns = [
    "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore",
    "arn:aws:iam::aws:policy/EC2InstanceProfileForImageBuilder"
  ]
  assume_role_policy = data.aws_iam_policy_document.ec2_assume_role.json
}

resource "aws_iam_instance_profile" "ec2_github_runner_imagebuilder" {
  name = "${var.resource_prefix}-ec2-github-runner-imagebuilder"
  role = aws_iam_role.ec2_github_runner_imagebuilder.name
  tags = {
    Environment = "${var.resource_prefix}"
    Name        = "AWS EC2 Github Runner"
  }
}

resource "aws_imagebuilder_infrastructure_configuration" "ec2_github_runner_arm64" {
  count                         = var.architecture == "all" || var.architecture == "arm64" ? 1 : 0
  instance_profile_name         = aws_iam_instance_profile.ec2_github_runner_imagebuilder.name
  name                          = "${var.resource_prefix}-ec2-github-runner-arm64"
  instance_types                = ["m6g.xlarge", "m6gd.xlarge"]
  terminate_instance_on_failure = true
  tags = {
    Environment = "${var.resource_prefix}"
    Name        = "AWS EC2 Github Runner"
  }
}

resource "aws_imagebuilder_infrastructure_configuration" "ec2_github_runner_x86" {
  count                         = var.architecture == "all" || var.architecture == "x86" ? 1 : 0
  instance_profile_name         = aws_iam_instance_profile.ec2_github_runner_imagebuilder.name
  name                          = "${var.resource_prefix}-ec2-github-runner-x86"
  instance_types                = ["m5d.xlarge", "m6a.xlarge"]
  terminate_instance_on_failure = true
  tags = {
    Environment = "${var.resource_prefix}"
    Name        = "AWS EC2 Github Runner"
  }
}


resource "aws_imagebuilder_distribution_configuration" "ec2_github_runner" {
  name = "ec2_github_runner"
  distribution {
    ami_distribution_configuration {
      ami_tags = {
        Environment = "${var.resource_prefix}"
        Name        = "AWS EC2 Github Runner"
      }
      name = "ec2-github-runner-{{ imagebuilder:buildDate }}"
    }
    region = data.aws_region.current.name
  }
  tags = {
    Environment = "${var.resource_prefix}"
    Name        = "AWS EC2 Github Runner"
  }
}

resource "aws_imagebuilder_image" "ec2_github_runner_arm64" {
  count = var.architecture == "all" || var.architecture == "arm64" ? 1 : 0

  distribution_configuration_arn   = aws_imagebuilder_distribution_configuration.ec2_github_runner.arn
  image_recipe_arn                 = aws_imagebuilder_image_recipe.ec2_github_runner_arm64[0].arn
  infrastructure_configuration_arn = aws_imagebuilder_infrastructure_configuration.ec2_github_runner_arm64[0].arn

  tags = {
    Environment = "${var.resource_prefix}"
    Name        = "AWS EC2 Github Runner arm64"
  }
}

resource "aws_imagebuilder_image" "ec2_github_runner_x86" {
  count = var.architecture == "all" || var.architecture == "x86" ? 1 : 0
  depends_on = [
    aws_imagebuilder_image.ec2_github_runner_arm64[0]
  ]

  distribution_configuration_arn   = aws_imagebuilder_distribution_configuration.ec2_github_runner.arn
  image_recipe_arn                 = aws_imagebuilder_image_recipe.ec2_github_runner_x86[0].arn
  infrastructure_configuration_arn = aws_imagebuilder_infrastructure_configuration.ec2_github_runner_x86[0].arn

  tags = {
    Environment = "${var.resource_prefix}"
    Name        = "AWS EC2 Github Runner x86"
  }
}
