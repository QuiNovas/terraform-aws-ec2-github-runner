locals {
  default_commands = [
    "sudo yum update",
    "sudo yum -y install docker git gcc openssl-devel bzip2-devel libffi-devel",
    "sudo systemctl enable docker"
  ]
  image_builder_commands = var.imagebuilder_component_commands == [] ? local.default_commands : concat(local.default_commands, var.imagebuilder_component_commands)
}
