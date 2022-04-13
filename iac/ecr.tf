# assets_service repo
resource "aws_ecr_repository" "assets_service" {
  name                 = "assets_service"
  image_tag_mutability = "MUTABLE"

  image_scanning_configuration {
    scan_on_push = true
  }
}
# front_end_service repo
resource "aws_ecr_repository" "front_end_service" {
  name                 = "front_end_service"
  image_tag_mutability = "MUTABLE"

  image_scanning_configuration {
    scan_on_push = true
  }
}
# newsfeeds_service repo
resource "aws_ecr_repository" "newsfeeds_service" {
  name                 = "newsfeeds_service"
  image_tag_mutability = "MUTABLE"

  image_scanning_configuration {
    scan_on_push = true
  }
}
# quotes_service repo
resource "aws_ecr_repository" "quotes_service" {
  name                 = "quotes_service"
  image_tag_mutability = "MUTABLE"

  image_scanning_configuration {
    scan_on_push = true
  }
}
