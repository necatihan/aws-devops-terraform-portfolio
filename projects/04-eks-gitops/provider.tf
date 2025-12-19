provider "aws" {
  region  = var.aws_region
  profile = var.aws_profile != "" ? var.aws_profile : null

  default_tags {
    tags = {
      managed_by = "terraform"
      owner      = var.owner
      purpose    = "portfolio"
      project    = var.project
      env        = var.env
    }
  }
}