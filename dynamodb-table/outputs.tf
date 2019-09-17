output "table_name" {
  value = join("", aws_dynamodb_table.vault_dynamodb_table.*.name)
}

output "write_autoscaling_policy_arn" {
  value = join("", aws_appautoscaling_policy.dynamodb_table_read_policy.*.arn)
}

output "read_autoscaling_policy_arn" {
  value = join("", aws_appautoscaling_policy.dynamodb_table_write_policy.*.arn)
}
