variable "architecture" {
  description = "Type of image architecture."
  type        = string
  validation {
    condition     = contains(["arm64", "x86"], var.architecture)
    error_message = "Valid values for variable: \"architecture\" are (arm64, x86)."
  }
}

variable "base_cidr_block" {
  description = "The CIDR block for the VPC."
  type        = string
}

variable "imagebuilder_component_commands" {
  description = "Linux commands for imagebuilder component."
  default     = []
  type        = list(string)
}

variable "resource_prefix" {
  description = "The EC2 github runner environment."
  type        = string
}
