output "ecr_repository_url" {
  value       = aws_ecr_repository.this.repository_url
  description = "the url which can be used to push/pull images from"
}

resource "aws_ssm_parameter" "ecr_repository_name" {
  name  = "/${var.ssm_resource_prefix}/ecr/name"
  type  = "String"
  value = aws_ecr_repository.this.name
}
