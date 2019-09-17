locals {
  dynamodb_table_name = coalesce(var.dynamodb_table_name_override, format("vault-%s-%s", var.environment, var.project))
}

resource "aws_dynamodb_table" "vault_dynamodb_table" {
  count            = var.enable ? 1 : 0
  name             = local.dynamodb_table_name
  read_capacity    = 5
  write_capacity   = 5
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

  lifecycle {
    ignore_changes = [read_capacity, write_capacity]
  }
}

# Autoscaling

resource "aws_appautoscaling_target" "dynamodb_table_read_target" {
  count              = var.enable && var.enable_dynamodb_autoscaling ? 1 : 0
  max_capacity       = var.dynamodb_max_read_capacity
  min_capacity       = var.dynamodb_min_read_capacity
  resource_id        = "table/${aws_dynamodb_table.vault_dynamodb_table[0].name}"
  scalable_dimension = "dynamodb:table:ReadCapacityUnits"
  service_namespace  = "dynamodb"
}

resource "aws_appautoscaling_target" "dynamodb_table_write_target" {
  count              = var.enable && var.enable_dynamodb_autoscaling ? 1 : 0
  max_capacity       = var.dynamodb_max_write_capacity
  min_capacity       = var.dynamodb_min_write_capacity
  resource_id        = "table/${aws_dynamodb_table.vault_dynamodb_table[0].name}"
  scalable_dimension = "dynamodb:table:WriteCapacityUnits"
  service_namespace  = "dynamodb"
}

resource "aws_appautoscaling_policy" "dynamodb_table_read_policy" {
  count              = var.enable && var.enable_dynamodb_autoscaling ? 1 : 0
  name               = "DynamoDBReadCapacityUtilization:${aws_appautoscaling_target.dynamodb_table_read_target[0].resource_id}"
  policy_type        = "TargetTrackingScaling"
  resource_id        = aws_appautoscaling_target.dynamodb_table_read_target[0].resource_id
  scalable_dimension = aws_appautoscaling_target.dynamodb_table_read_target[0].scalable_dimension
  service_namespace  = aws_appautoscaling_target.dynamodb_table_read_target[0].service_namespace

  target_tracking_scaling_policy_configuration {
    predefined_metric_specification {
      predefined_metric_type = "DynamoDBReadCapacityUtilization"
    }

    target_value = 70
  }
}

resource "aws_appautoscaling_policy" "dynamodb_table_write_policy" {
  count              = var.enable && var.enable_dynamodb_autoscaling ? 1 : 0
  name               = "DynamoDBWriteCapacityUtilization:${aws_appautoscaling_target.dynamodb_table_write_target[0].resource_id}"
  policy_type        = "TargetTrackingScaling"
  resource_id        = aws_appautoscaling_target.dynamodb_table_write_target[0].resource_id
  scalable_dimension = aws_appautoscaling_target.dynamodb_table_write_target[0].scalable_dimension
  service_namespace  = aws_appautoscaling_target.dynamodb_table_write_target[0].service_namespace

  target_tracking_scaling_policy_configuration {
    predefined_metric_specification {
      predefined_metric_type = "DynamoDBWriteCapacityUtilization"
    }

    target_value = 70
  }
}
