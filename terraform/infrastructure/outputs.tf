output "cicd_public_ip" {
  value = module.ec2.public_ip
}

output "registry_url" {
  value = module.ecr.registry_url
}

output "repository_url" {
  value = module.ecr.repository_url
}

