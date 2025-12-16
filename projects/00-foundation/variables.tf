variable "aws_profile" {
  type        = string
  description = "AWS CLI profile name"
  default     = "portfolio"
}

variable "aws_region" {
  type        = string
  description = "AWS region for foundational resources"
  default     = "eu-north-1"
}

variable "project" {
  type    = string
  default = "aws-devops-terraform-portfolio"
}

variable "env" {
  type    = string
  default = "dev"
}

variable "tags" {
  type = map(string)
  default = {
    owner      = "necatihan"
    managed_by = "terraform"
    purpose    = "portfolio"
  }
}