module "main_dynamodb_table" {
  source                        = "../dynamodb-table"
  enable                        = true
  dynamodb_table_name_override  = var.dynamodb_table_name_override
  environment                   = var.environment
  project                       = var.project
  enable_point_in_time_recovery = var.enable_point_in_time_recovery
  tags                          = local.tags
}

module "replica_dynamodb_table" {
  source                        = "../dynamodb-table"
  enable                        = var.enable_dynamodb_replica_table
  dynamodb_table_name_override  = var.dynamodb_table_name_override
  environment                   = var.environment
  project                       = var.project
  enable_point_in_time_recovery = var.enable_point_in_time_recovery
  tags                          = local.tags

  providers = {
    aws = aws.replica
  }
}

resource "aws_dynamodb_global_table" "vault_global_table" {
  count = var.enable_dynamodb_replica_table ? 1 : 0

  # Fake dependency for both child dynamodb tables
  name = [module.main_dynamodb_table.table_name, module.replica_dynamodb_table.table_name][0]

  replica {
    region_name = data.aws_region.main.name
  }

  replica {
    region_name = data.aws_region.replica.name
  }
}
