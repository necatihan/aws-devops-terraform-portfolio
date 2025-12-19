module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "~> 5.0"

  name = "${local.name_prefix}-vpc"
  cidr = "10.40.0.0/16"

  azs = slice(data.aws_availability_zones.available.names, 0, 3)

  public_subnets  = ["10.40.0.0/20", "10.40.16.0/20", "10.40.32.0/20"]
  private_subnets = ["10.40.128.0/20", "10.40.144.0/20", "10.40.160.0/20"]

  enable_nat_gateway = true
  single_nat_gateway = true

  enable_dns_hostnames = true
  enable_dns_support   = true

  public_subnet_tags = {
    "kubernetes.io/cluster/${local.eks_cluster_name}" = "shared"
    "kubernetes.io/role/elb"                          = "1"
  }

  private_subnet_tags = {
    "kubernetes.io/cluster/${local.eks_cluster_name}" = "shared"
    "kubernetes.io/role/internal-elb"                 = "1"
  }
}