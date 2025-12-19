module "eks" {
  source  = "terraform-aws-modules/eks/aws"
  version = "~> 20.0"

  cluster_name    = local.eks_cluster_name
  cluster_version = var.cluster_version

  vpc_id     = module.vpc.vpc_id
  subnet_ids = module.vpc.private_subnets

  enable_irsa = true

  cluster_endpoint_public_access       = true
  cluster_endpoint_public_access_cidrs = var.cluster_endpoint_public_access_cidrs

  cluster_enabled_log_types = [
    "api",
    "audit",
    "authenticator",
  ]

  cloudwatch_log_group_retention_in_days = 14

  # Encrypt Kubernetes secrets at rest (shows security maturity)
  cluster_encryption_config = {
    resources = ["secrets"]
  }

  eks_managed_node_groups = {
    default = {
      name = "${local.name_prefix}-ng"

      instance_types = ["t3.medium"]
      capacity_type  = "ON_DEMAND"

      min_size     = 1
      max_size     = 2
      desired_size = 1

      subnet_ids = module.vpc.private_subnets
    }
  }

  tags = {
    component = "eks"
  }
}