variable "aws_region" {
  type        = string
  description = "AWS region"
  default     = "eu-north-1"
}

variable "aws_profile" {
  type        = string
  description = "AWS CLI profile name for local runs. Leave empty in CI."
  default     = "portfolio"
}

variable "project" {
  type        = string
  description = "Long project name (tags/docs)"
  default     = "aws-devops-terraform-portfolio"
}

variable "project_short" {
  type        = string
  description = "Short name for AWS resources with strict name limits"
  default     = "portfolio"
}

variable "env" {
  type        = string
  description = "Environment name"
  default     = "dev"
}

variable "owner" {
  type        = string
  description = "Owner tag"
  default     = "necatihan"
}

variable "cluster_version" {
  type        = string
  description = "EKS Kubernetes version"
  default     = "1.29"
}