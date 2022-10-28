locals {
  az_ids = slice(data.aws_availability_zones.available.zone_ids, 0, var.azs_num)

  subnet_prefix_extension = 12
  zone_offset             = 8
}

data "aws_availability_zones" "available" {
  state = "available"
}

resource "aws_eip" "nat" {
  vpc = true
  tags = {
    Name = "${var.cluster_name}-eks-nat"
  }
}

module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "3.18.0"

  name                 = var.cluster_name
  cidr                 = var.vpc_cidr
  azs                  = slice(data.aws_availability_zones.available.names, 0, var.azs_num)
  enable_dns_hostnames = true

  // Dynamicly generating the subnets according to `var.azs_num`.
  // Making sure that all the public and private subnents are equally sparsed,
  // while making sure there's no collision.
  public_subnets = [
    for zone_id in local.az_ids : cidrsubnet(
      var.vpc_cidr,
      local.subnet_prefix_extension,
      tonumber(substr(zone_id, length(zone_id) - 1, 1)) + local.zone_offset - 1
    )
  ]
  private_subnets = [
    for zone_id in local.az_ids : cidrsubnet(
      var.vpc_cidr,
      local.subnet_prefix_extension,
      tonumber(substr(zone_id, length(zone_id) - 1, 1)) - 1
    )
  ]

  enable_nat_gateway     = true
  one_nat_gateway_per_az = false
  single_nat_gateway     = true
  reuse_nat_ips          = true
  external_nat_ip_ids    = [aws_eip.nat.id]

  enable_flow_log = false # Just to save some money

  // Tagging the VPC as "shared" and not "owned" because we are deploying the EC2 (CICD server) in this VPC as well."
  public_subnet_tags = {
    "kubernetes.io/cluster/${var.cluster_name}" = "shared"
    "kubernetes.io/role/elb"                    = 1
  }

  private_subnet_tags = {
    "kubernetes.io/cluster/${var.cluster_name}" = "shared"
    "kubernetes.io/role/internal-elb"           = 1
  }
}

module "security_group" {
  source  = "terraform-aws-modules/security-group/aws"
  version = "4.13.1"

  name   = "cicd"
  vpc_id = module.vpc.vpc_id

  egress_rules = ["all-all"]
  ingress_with_cidr_blocks = [
    {
      rule        = "ssh-tcp"
      cidr_blocks = "0.0.0.0/0"
    },
    {
      from_port   = 8080
      to_port     = 8080
      protocol    = "tcp"
      description = "Jenkins Server"
      cidr_blocks = "0.0.0.0/0"
    },
  ]
}
