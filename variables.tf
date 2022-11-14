variable "resource_prefix" {
  type        = string
  description = "The EC2 github runner environment."
}

variable "base_cidr_block" {
  description = "The CIDR block for the VPC."
  type        = string
}

variable "region" {
  type        = string
  default     = "us-east-1"
  description = "The EC2 github runner region."
}

variable "imagebuilder_component_commands" {
  type        = list(string)
  default     = []
  description = "Linux commands for imagebuilder component."
}