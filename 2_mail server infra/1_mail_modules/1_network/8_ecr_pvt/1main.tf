resource "aws_ecr_repository" "repositories" {
  count             = length(var.repository_names)
  name              = var.repository_names[count.index]
  image_tag_mutability = var.image_tag_mutability
}

resource "aws_ecr_lifecycle_policy" "default" {
  count      = length(var.repository_names)
  policy     = jsonencode({
    rules = [
      {
        rulePriority = 1,
        description  = "Expire images older than ${var.image_expiration_days} days",
        selection    = {
          tagStatus     = "any",
          countType     = "sinceImagePushed",
          countUnit     = "days",
          countNumber   = var.image_expiration_days
        },
        action       = {
          type = "expire"
        }
      }
    ]
  })

  repository = aws_ecr_repository.repositories[count.index].name
}