locals {
  # <= 32 chars safe prefix for resources with strict name limits
  short = "portfolio-${var.env}"
}