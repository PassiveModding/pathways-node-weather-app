resource "aws_ecr_repository" "this" {
  name = var.repo_name

  # mutable allows things like using a "LATEST" tag on the docker image.
  # ie. LATEST's image can change as it is updated. IMMUTABLE denies this behavior
  image_tag_mutability = "MUTABLE"
  image_scanning_configuration {
    scan_on_push = true
  }

  tags = var.tags
}

output "ecr_repository_url" {
  value = aws_ecr_repository.this.repository_url
}

resource "aws_ssm_parameter" "ecr_repository_name" {
  name  = "/${var.resource_name_prefix}/ecr/name"
  type  = "String"
  value = aws_ecr_repository.this.name
}
