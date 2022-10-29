module "eks" {
  source  = "terraform-aws-modules/eks/aws"
  version = "18.30.2"

  cluster_name    = var.cluster_name
  cluster_version = var.cluster_version

  enable_irsa = var.enable_irsa

  vpc_id                         = var.vpc_id
  subnet_ids                     = var.subnet_ids
  cluster_endpoint_public_access = var.cluster_endpoint_public_access

  node_security_group_additional_rules = {
    ingress_allow_access_from_control_plane = {
      type                          = "ingress"
      description                   = "Allow access from control plane to webhook port of AWS load balancer controller"
      protocol                      = "tcp"
      from_port                     = 9443
      to_port                       = 9443
      source_cluster_security_group = true
    }
  }

  eks_managed_node_group_defaults = {
    disk_size      = 20
    instance_types = ["t2.small"]
    capacity_type  = "SPOT"
  }

  eks_managed_node_groups     = var.eks_managed_node_groups
  create_cloudwatch_log_group = var.create_cloudwatch_log_group
  cluster_enabled_log_types   = var.cluster_enabled_log_types
}
