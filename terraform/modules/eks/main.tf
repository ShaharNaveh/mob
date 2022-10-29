module "eks" {
  source  = "terraform-aws-modules/eks/aws"
  version = "18.30.2"

  cluster_name    = var.cluster_name
  cluster_version = var.cluster_version

  enable_irsa = var.enable_irsa

  vpc_id                         = var.vpc_id
  subnet_ids                     = var.subnet_ids
  cluster_endpoint_public_access = var.cluster_endpoint_public_access

  eks_managed_node_group_defaults = {
    disk_size      = 20
    instance_types = ["t2.small"]
    capacity_type  = "SPOT"
  }

  eks_managed_node_groups     = var.eks_managed_node_groups
  create_cloudwatch_log_group = var.create_cloudwatch_log_group
  cluster_enabled_log_types   = var.cluster_enabled_log_types
}
