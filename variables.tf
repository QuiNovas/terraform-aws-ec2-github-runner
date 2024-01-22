variable "amazon_linux_version" {
  default     = "2"
  description = "The Amazon Linux major version. Either \"2\" or \"2023\"."
  type        = string
  validation {
    condition     = contains(["2", "2023"], var.amazon_linux_version)
    error_message = "Valid values for variable: \"amazon_linux_version\" are (2, 2023)."
  }
}

variable "architecture" {
  default     = "all"
  description = "Type of image architecture."
  type        = string
  validation {
    condition     = contains(["arm64", "x86", "all"], var.architecture)
    error_message = "Valid values for variable: \"architecture\" are (arm64, x86, all)."
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
