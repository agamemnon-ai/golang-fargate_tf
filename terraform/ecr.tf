resource "aws_ecr_repository" "golang-test" {
  name         = "golang-fargate_tf"
  force_delete = true

  encryption_configuration {
    encryption_type = "KMS"
  }

  tags = {
    Name    = "golang-fargate_tf"
    Project = var.project
    Env     = var.environment
  }
}