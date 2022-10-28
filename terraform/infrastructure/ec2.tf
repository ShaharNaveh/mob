data "aws_ami" "amazon_linux" {
  most_recent = true

  filter {
    name   = "owner-alias"
    values = ["amazon"]
  }

  filter {
    name   = "name"
    values = ["amzn2-ami-hvm*"]
  }
}

module "key_pair" {
  source  = "terraform-aws-modules/key-pair/aws"
  version = "2.0.0"

  key_name           = "mob"
  create_private_key = true
}

module "ec2" {
  source = "../modules/ec2"

  name                   = "cicd"
  ami                    = data.aws_ami.amazon_linux.id
  key_name               = module.key_pair.key_pair_name
  subnet_id              = element(module.vpc.public_subnets, 0)
  vpc_security_group_ids = [module.security_group.security_group_id]
}

resource "aws_s3_object" "ec2_key" {
  bucket  = var.infrastructure_state_bucket
  key     = "artifacts/cicd.pem"
  content = module.key_pair.private_key_pem
}
