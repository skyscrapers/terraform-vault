provider "aws" {}

provider "aws" {
  alias = "replica"
}

data "aws_caller_identity" "current" {}

data "aws_region" "main" {}

data "aws_region" "replica" {
  provider = aws.replica
}
