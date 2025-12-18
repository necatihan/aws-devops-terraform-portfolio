variable "aws_region" {
  type    = string
  default = "eu-north-1"
}

variable "aws_profile" {
  type        = string
  description = "Local AWS profile (leave empty in CI/CodeBuild)"
  default     = ""
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

variable "service_name" {
  type    = string
  default = "ecs-web"
}