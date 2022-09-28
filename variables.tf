variable "environment" {
  type = string
}

variable "base_cidr_block" {
  description = "The CIDR block for the VPC."
  type        = string
}

variable "region" {
  type    = string
  default = "us-east-1"
}