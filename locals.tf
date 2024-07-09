locals {
  runner_home_dir = "/usr/local/bin/actions-runner${var.runner_version}"
  runner_tar      = "actions-runner-linux-${var.architecture == "x86" ? "x64" : "arm64"}-${var.runner_version}.tar.gz"
  default_commands = [
    "sudo yum -y update",
    "sudo yum -y install docker git gcc gcc-c++ libicu make",
    "curl -sL https://rpm.nodesource.com/setup_20.x | sudo -E bash -",
    "sudo yum install -y nodejs",
    "sudo mkdir ${local.runner_home_dir}",
    "cd ${local.runner_home_dir}",
    "sudo curl -O -L https://github.com/actions/runner/releases/download/v${var.runner_version}/${local.runner_tar}",
    "sudo tar xzf ${local.runner_tar}",
    "sudo rm -f ${local.runner_tar}",
    "sudo systemctl enable docker",
  ]
  image_builder_commands = var.imagebuilder_component_commands == [] ? local.default_commands : concat(local.default_commands, var.imagebuilder_component_commands)
}
