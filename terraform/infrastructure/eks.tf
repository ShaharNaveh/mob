module "eks" {
  source = "../modules/eks"

  cluster_name    = var.cluster_name
  cluster_version = "1.23"

  vpc_id     = module.vpc.vpc_id
  subnet_ids = module.vpc.private_subnets

  eks_managed_node_groups = {
    spot-fleet = {
      min_size      = 1
      max_size      = 1
      desired_size  = 1
      capacity_type = "SPOT"
    }
  }
}
