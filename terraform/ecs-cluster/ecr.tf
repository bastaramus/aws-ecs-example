resource "aws_ecr_repository" "ecr_example" {
  name                 = "ecr_example"

  image_scanning_configuration {
    scan_on_push = true
  }
}