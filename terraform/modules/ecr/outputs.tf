output "registry_url" {
  value = split("/", aws_ecr_repository.this.repository_url)[0]
}

output "repository_url" {
  value = aws_ecr_repository.this.repository_url
}
