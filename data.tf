data "aws_caller_identity" "playground" {}

data "aws_caller_identity" "dev" {
  provider = aws.dev
}

