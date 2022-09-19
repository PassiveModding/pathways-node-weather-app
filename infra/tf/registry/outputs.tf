output "ecr_repository_url" {
  value       = aws_ecr_repository.this.repository_url
  description = "the url which can be used to push/pull images from"
}
