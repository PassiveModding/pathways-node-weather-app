resource "aws_ecr_repository" "this" {
  name = var.repo_name
  # ensures the repo is allowed to be destroyed by terraform even if it contains images
  force_delete = true

  # mutable allows things like using a "LATEST" tag on the docker image.
  # ie. LATEST's image can change as it is updated. IMMUTABLE denies this behavior
  image_tag_mutability = "MUTABLE"
  image_scanning_configuration {
    scan_on_push = true
  }

  tags = var.tags
}
