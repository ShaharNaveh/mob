
locals {
  alb_sa_name      = "aws-load-balancer-controller"
  alb_sa_namespace = "aws-load-balancer-controller"
}

module "aws_load_balancer_controller_irsa_role" {
  source  = "terraform-aws-modules/iam/aws//modules/iam-role-for-service-accounts-eks"
  version = "5.5.4"

  role_name        = "${local.alb_sa_name}-${var.cluster_name}"
  role_description = "Role for the AWS Load Balancer Controller. Corresponds to ${local.alb_sa_name} k8s ServiceAccount."

  attach_load_balancer_controller_policy = true

  oidc_providers = {
    ex = {
      provider_arn               = module.eks.oidc_provider_arn
      namespace_service_accounts = ["${local.alb_sa_namespace}:${local.alb_sa_name}"]
    }
  }
}

resource "helm_release" "aws_load_balancer_controller" {
  name       = "aws-load-balancer-controller"
  repository = "https://aws.github.io/eks-charts"
  chart      = "aws-load-balancer-controller"
  version    = "1.4.5"

  namespace        = local.alb_sa_namespace
  create_namespace = true

  atomic          = true
  cleanup_on_fail = true

  values = [yamlencode({
    clusterName       = module.eks.cluster_id
    enableCertManager = false
    enableShield      = false
    enableWaf         = false
    enableWafv2       = false
    serviceMonitor = {
      enabled = false
    }
    serviceAccount = {
      name = local.alb_sa_name
      annotations = {
        "eks.amazonaws.com/role-arn" = module.aws_load_balancer_controller_irsa_role.iam_role_arn
      }
    }
    }
  )]
}
