variable "resource_prefix" {
  type        = string
  description = "The EC2 github runner environment."
}

variable "base_cidr_block" {
  description = "The CIDR block for the VPC."
  type        = string
}

variable "imagebuilder_component_commands" {
  type        = list(string)
  default     = []
  description = "Linux commands for imagebuilder component."
}

variable "architecture" {
  type        = string
  description = "Type of image architecture."
  default     = "all"
  validation {
    condition     = contains(["arm64", "x86", "all"], var.architecture)
    error_message = "Valid values for variable: \"architecture\" are (arm64, x86, all)."
  }
}
