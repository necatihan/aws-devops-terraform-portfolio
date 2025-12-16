variable "aws_profile" {
  type        = string
  description = "AWS CLI profile name"
  default     = "portfolio"
}

variable "aws_region" {
  type        = string
  description = "AWS region"
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

variable "owner" {
  type    = string
  default = "necatihan"
}

variable "trail_name" {
  type    = string
  default = "portfolio-org-trail"
}