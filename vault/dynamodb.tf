module "main_dynamodb_table" {
  source = "/Users/iuri/projects/skyscrapers/terraform-modules/terraform-vault/dynamodb-table"
  # source                        = "../dynamodb-table"
  enable                        = true
  dynamodb_table_name_override  = var.dynamodb_table_name_override
  environment                   = var.environment
  project                       = var.project
  enable_point_in_time_recovery = var.enable_point_in_time_recovery
  dynamodb_max_read_capacity    = var.dynamodb_max_read_capacity
  dynamodb_min_read_capacity    = var.dynamodb_min_read_capacity
  dynamodb_max_write_capacity   = var.dynamodb_max_write_capacity
  dynamodb_min_write_capacity   = var.dynamodb_min_write_capacity
  enable_dynamodb_autoscaling   = var.enable_dynamodb_autoscaling
}

module "replica_dynamodb_table" {
  source = "/Users/iuri/projects/skyscrapers/terraform-modules/terraform-vault/dynamodb-table"
  # source                        = "../dynamodb-table"
  enable                        = var.enable_dynamodb_replica_table
  dynamodb_table_name_override  = var.dynamodb_table_name_override
  environment                   = var.environment
  project                       = var.project
  enable_point_in_time_recovery = var.enable_point_in_time_recovery
  dynamodb_max_read_capacity    = var.replica_dynamodb_max_read_capacity
  dynamodb_min_read_capacity    = var.replica_dynamodb_min_read_capacity
  dynamodb_max_write_capacity   = var.dynamodb_max_write_capacity
  dynamodb_min_write_capacity   = var.dynamodb_min_write_capacity
  enable_dynamodb_autoscaling   = var.enable_dynamodb_autoscaling

  providers = {
    aws = aws.replica
  }
}

resource "aws_dynamodb_global_table" "vault_global_table" {
  count = var.enable_dynamodb_replica_table ? 1 : 0

  # A DynamoDB global table requires that the autoscaling on all replica tables are enabled
  # This will force such dependency as "depends_on" can't be used on modules
  name = index(
    [
      "needle",
      module.main_dynamodb_table.write_autoscaling_policy_arn,
      module.replica_dynamodb_table.write_autoscaling_policy_arn,
      module.main_dynamodb_table.read_autoscaling_policy_arn,
      module.replica_dynamodb_table.read_autoscaling_policy_arn,
    ],
    "needle",
  ) == 0 ? module.main_dynamodb_table.table_name : ""

  replica {
    region_name = data.aws_region.main.name
  }

  replica {
    region_name = data.aws_region.replica.name
  }
}
