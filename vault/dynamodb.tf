locals {
  dynamodb_table_name = "${var.dynamodb_table_name_override == "" ? format("vault-%s-%s", var.environment, var.project) : var.dynamodb_table_name_override}"
}

resource "aws_dynamodb_table" "vault_dynamodb_table" {
  name           = "${local.dynamodb_table_name}"
  read_capacity  = 5
  write_capacity = 5
  hash_key       = "Path"
  range_key      = "Key"

  attribute {
    name = "Key"
    type = "S"
  }

  attribute {
    name = "Path"
    type = "S"
  }

  tags {
    Name        = "${local.dynamodb_table_name}"
    Environment = "${var.environment}"
    Project     = "${var.project}"
  }

  lifecycle {
    ignore_changes = ["read_capacity", "write_capacity"]
  }
}

# Autoscaling

resource "aws_appautoscaling_target" "dynamodb_table_read_target" {
  count              = "${var.enable_dynamodb_autoscaling ? 1 : 0}"
  max_capacity       = "${var.dynamodb_max_read_capacity}"
  min_capacity       = "${var.dynamodb_min_read_capacity}"
  resource_id        = "table/${aws_dynamodb_table.vault_dynamodb_table.name}"
  scalable_dimension = "dynamodb:table:ReadCapacityUnits"
  service_namespace  = "dynamodb"
}

resource "aws_appautoscaling_target" "dynamodb_table_write_target" {
  count              = "${var.enable_dynamodb_autoscaling ? 1 : 0}"
  max_capacity       = "${var.dynamodb_max_write_capacity}"
  min_capacity       = "${var.dynamodb_min_write_capacity}"
  resource_id        = "table/${aws_dynamodb_table.vault_dynamodb_table.name}"
  scalable_dimension = "dynamodb:table:WriteCapacityUnits"
  service_namespace  = "dynamodb"
}

resource "aws_appautoscaling_policy" "dynamodb_table_read_policy" {
  count              = "${var.enable_dynamodb_autoscaling ? 1 : 0}"
  name               = "DynamoDBReadCapacityUtilization:${aws_appautoscaling_target.dynamodb_table_read_target.resource_id}"
  policy_type        = "TargetTrackingScaling"
  resource_id        = "${aws_appautoscaling_target.dynamodb_table_read_target.resource_id}"
  scalable_dimension = "${aws_appautoscaling_target.dynamodb_table_read_target.scalable_dimension}"
  service_namespace  = "${aws_appautoscaling_target.dynamodb_table_read_target.service_namespace}"

  target_tracking_scaling_policy_configuration {
    predefined_metric_specification {
      predefined_metric_type = "DynamoDBReadCapacityUtilization"
    }

    target_value = 70
  }
}

resource "aws_appautoscaling_policy" "dynamodb_table_write_policy" {
  count              = "${var.enable_dynamodb_autoscaling ? 1 : 0}"
  name               = "DynamoDBWriteCapacityUtilization:${aws_appautoscaling_target.dynamodb_table_write_target.resource_id}"
  policy_type        = "TargetTrackingScaling"
  resource_id        = "${aws_appautoscaling_target.dynamodb_table_write_target.resource_id}"
  scalable_dimension = "${aws_appautoscaling_target.dynamodb_table_write_target.scalable_dimension}"
  service_namespace  = "${aws_appautoscaling_target.dynamodb_table_write_target.service_namespace}"

  target_tracking_scaling_policy_configuration {
    predefined_metric_specification {
      predefined_metric_type = "DynamoDBWriteCapacityUtilization"
    }

    target_value = 70
  }
}
