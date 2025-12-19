locals {
  name_prefix      = "${var.project_short}-${var.env}"
  eks_cluster_name = "${local.name_prefix}-eks"
}