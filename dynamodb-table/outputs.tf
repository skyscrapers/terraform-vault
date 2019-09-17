output "table_name" {
  value = join("", aws_dynamodb_table.vault_dynamodb_table.*.name)
}
