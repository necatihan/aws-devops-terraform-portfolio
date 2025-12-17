variable "aws_region" {
  type    = string
  default = "eu-north-1"
}

variable "aws_profile" {
  type    = string
  default = ""
}

variable "project" {
  type    = string
  default = "aws-devops-terraform-portfolio"
}

variable "env" {
  type    = string
  default = "dev"
}

variable "repo" {
  type        = string
  description = "GitHub repo in the form owner/repo"
  default     = "necatihan/aws-devops-terraform-portfolio"
}

variable "lambda_reserved_concurrency" {
  type        = number
  description = "Optional reserved concurrency for the Lambda. Leave null if account concurrency is low."
  default     = null
}
