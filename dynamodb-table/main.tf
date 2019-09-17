locals {
  dynamodb_table_name = coalesce(var.dynamodb_table_name_override, format("vault-%s-%s", var.environment, var.project))
}

resource "aws_dynamodb_table" "vault_dynamodb_table" {
  count            = var.enable ? 1 : 0
  name             = local.dynamodb_table_name
  billing_mode     = "PAY_PER_REQUEST"
  hash_key         = "Path"
  range_key        = "Key"
  stream_enabled   = true
  stream_view_type = "NEW_AND_OLD_IMAGES"

  attribute {
    name = "Key"
    type = "S"
  }

  attribute {
    name = "Path"
    type = "S"
  }

  tags = {
    Name        = local.dynamodb_table_name
    Environment = var.environment
    Project     = var.project
  }

  point_in_time_recovery {
    enabled = var.enable_point_in_time_recovery
  }
}
