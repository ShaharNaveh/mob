terraform {
  backend "s3" {}

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "4.36.1"
    }
    helm = {
      source  = "hashicorp/helm"
      version = "2.7.1"
    }
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = "2.14.0"
    }
  }
}

provider "aws" {
  region = var.aws_region
  default_tags {
    tags = {
      Terraform            = true
      Terraform_Deployment = basename(abspath(path.root))
    }
  }
}

provider "kubernetes" {
  host                   = data.aws_eks_cluster.target.endpoint
  cluster_ca_certificate = base64decode(data.aws_eks_cluster.target.certificate_authority[0].data)
  token                  = data.aws_eks_cluster_auth.target.token
}

provider "helm" {
  kubernetes {
    host                   = data.aws_eks_cluster.target.endpoint
    cluster_ca_certificate = base64decode(data.aws_eks_cluster.target.certificate_authority[0].data)
    token                  = data.aws_eks_cluster_auth.target.token
  }
}

data "aws_eks_cluster" "target" {
  name = module.eks.cluster_id
}

data "aws_eks_cluster_auth" "target" {
  name = module.eks.cluster_id
}
