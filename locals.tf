locals {
  default_commands = [
    "sudo yum -y update",
    "sudo yum -y install docker git gcc gcc-c++ make",
    "curl -sL https://rpm.nodesource.com/setup_20.x | sudo -E bash -",
    "sudo yum install -y nodejs",
    "sudo systemctl enable docker"
  ]
  image_builder_commands = var.imagebuilder_component_commands == [] ? local.default_commands : concat(local.default_commands, var.imagebuilder_component_commands)
}
