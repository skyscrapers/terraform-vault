# Terraform Vault

[![ci.skyscrape.rs](https://ci.skyscrape.rs/api/v1/teams/skyscrapers/pipelines/terraform-modules/jobs/test-terraform-vault-master/badge)](https://ci.skyscrape.rs/teams/skyscrapers/pipelines/terraform-modules?groups=terraform-vault)

Terraform module(s) to setup Vault on AWS

## Vault

This terraform module sets up a HA vault with a DynamoDB backend.
The module sets up TLS using Letsencrypt with dns-01 challenge.

Both vault servers are optionally configured with Teleport for SSH management.

Two route53 records are provided to access the individual instances.

![architecture-diagram](vault/images/vault-component.svg)

### Terraform providers

Because this module can be configured to setup a DynamoDB table in a separate region from the main table, it expects two Terraform providers: `aws` and `aws.replica`. If you want to enable the replica table, you'll need to create a second `aws` provider targeting the region you want to put the replica table in, and then pass it on to the module as `aws.replica`:

```tf
provider "aws" {
  region = "eu-west-1"
}

provider "aws" {
  alias  = "replica"
  region = "eu-west-2"
}

module "vault" {
  ...

  enable_dynamodb_replica_table = true

  providers = {
    aws = aws
    aws.replica = aws.replica
  }
}
```

If you don't want to enable the replica table, you still need to set the `providers` block in the vault module, but you can set the default `aws` provider in both "slots", like so:

```tf
provider "aws" {
  region = "eu-west-1"
}

module "vault" {
  ...

  enable_dynamodb_replica_table = false

  providers = {
    aws = aws
    aws.replica = aws
  }
}
```

### Available variables

| Name | Description | Type | Default | Required |
|------|-------------|:----:|:-----:|:-----:|
| acm\_arn | The ACM ARN to use on the alb | string | n/a | yes |
| acme\_server | ACME server where to point `certbot` on the Teleport server to fetch an SSL certificate. Useful if you want to point to the letsencrypt staging server. | string | `"https://acme-v01.api.letsencrypt.org/directory"` | no |
| ami | The AMI ID to use for the vault instances | string | n/a | yes |
| dns\_root | The root domain to configure for vault | string | `"production.skyscrape.rs"` | no |
| dynamodb\_max\_read\_capacity | The max read capacity of the Vault dynamodb table | string | `"100"` | no |
| dynamodb\_max\_write\_capacity | The max write capacity of the Vault dynamodb table | string | `"100"` | no |
| dynamodb\_min\_read\_capacity | The min read capacity of the Vault dynamodb table | string | `"5"` | no |
| dynamodb\_min\_write\_capacity | The min write capacity of the Vault dynamodb table | string | `"5"` | no |
| dynamodb\_table\_name\_override | Override Vault's DynamoDB table name with this variable. This module will generate a name if this is left empty (default behavior) | string | `""` | no |
| ec2\_instances\_cpu\_credits | The type of cpu credits to use | string | `"standard"` | no |
| enable\_dynamodb\_autoscaling | Enables the autoscaling feature on the Vault dynamodb table | string | `"true"` | no |
| enable\_dynamodb\_replica\_table | Setting this to true will create a DynamoDB table on another region and enable global tables for replication. The replica table is going to be managed by the 'replica' Terraform provider | string | `"false"` | no |
| enable\_point\_in\_time\_recovery | Whether to enable point-in-time recovery - note that it can take up to 10 minutes to enable for new tables. Note that [additional charges](https://aws.amazon.com/dynamodb/pricing/) will apply by enabling this setting | string | `"true"` | no |
| enable\_ui | Enables the [Vault UI](https://www.vaultproject.io/docs/configuration/ui/index.html) | string | `"true"` | no |
| environment | Name of the environment where to deploy Vault (just for naming reasons) | string | n/a | yes |
| instance\_type | The instance type to use for the vault servers | string | `"t2.micro"` | no |
| key\_name | Name of the sshkey to deploy on the vault instances | string | n/a | yes |
| lb\_internal | Should the ALB be created as an internal Loadbalancer | string | `"false"` | no |
| lb\_subnets | The subnets to use for the alb | list | n/a | yes |
| le\_email | The email address that's going to be used to register to LetsEncrypt | string | n/a | yes |
| project | Name of the project | string | n/a | yes |
| replica\_dynamodb\_max\_read\_capacity | The max read capacity of the Vault dynamodb replica table | string | `"5"` | no |
| replica\_dynamodb\_min\_read\_capacity | The min read capacity of the Vault dynamodb replica table | string | `"5"` | no |
| teleport\_auth\_server | The hostname or ip of the Teleport auth server. If empty, Teleport integration will be disabled (default). | string | `""` | no |
| teleport\_node\_sg | The security-group ID of the teleport server | string | `""` | no |
| teleport\_token\_1 | The Teleport token for the first instance. This can be a dynamic short-lived token | string | `""` | no |
| teleport\_token\_2 | The Teleport token for the second instance. This can be a dynamic short-lived token | string | `""` | no |
| teleport\_version | The Teleport version to deploy | string | `"3.1.8"` | no |
| vault1\_subnet | The subnet ID for the first vault instance | string | n/a | yes |
| vault2\_subnet | The subnet ID for the second vault instance | string | n/a | yes |
| vault\_nproc | The amount of nproc to configure vault with. Set this to the amount of CPU cores | string | `"1"` | no |
| vault\_version | The Vault version to deploy. Releases of this module have a default Vault version set. See the [releases page](https://github.com/skyscrapers/terraform-vault/releases). | string | n/a | yes |
| vpc\_id | The VPC id to launch the instances in | string | n/a | yes |

### Output

| Name | Description |
|------|-------------|
| alb\_arn | The alb ARN |
| alb\_id | The alb id |
| alb\_main\_target\_group | The default alb target group ARN |
| alb\_sg\_id | The alb security group ID |
| alb\_vault1\_target\_group | The vault1 target group ARN |
| alb\_vault2\_target\_group | The vault2 target group ARN |
| dynamodb\_table\_name | The Vault dynamodb table name |
| iam\_policy | The iam policy ARN used for vault |
| main\_dynamodb\_table\_region | Region where the main DynamoDB table will be created |
| replica\_dynamodb\_table\_region | Region where the replica DynamoDB table will be created, if enabled |
| sg\_id | The vault security-group id |
| vault1\_instance\_id | The vault1 instance ID |
| vault1\_role\_id | The vault1 instance-role ID |
| vault1\_role\_name | The vault1 instance-role name |
| vault1\_route53\_record | The vault1 route53 record id |
| vault2\_instance\_id | The vault2 instance ID |
| vault2\_role\_id | The vault2 instance-role ID |
| vault2\_role\_name | The vault2 instance-role name |
| vault2\_route53\_record | The vault2 route53 record id |
| vault\_route53\_record | The main vault route53 record id |

### Upgrades

#### From v2.x to v3.x

In v3.x of this module, the DynamoDB table creation has been moved inside a nested Terraform module. To avoid having to re-create such table, you'll need to move/rename it inside the state. The following Terraform commands should suffice:

```bash
terraform state mv module.ha_vault.aws_appautoscaling_policy.dynamodb_table_read_policy module.ha_vault.module.main_dynamodb_table.aws_appautoscaling_policy.dynamodb_table_read_policy
terraform state mv module.ha_vault.aws_appautoscaling_policy.dynamodb_table_write_policy module.ha_vault.module.main_dynamodb_table.aws_appautoscaling_policy.dynamodb_table_write_policy
terraform state mv module.ha_vault.aws_appautoscaling_target.dynamodb_table_read_target module.ha_vault.module.main_dynamodb_table.aws_appautoscaling_target.dynamodb_table_read_target
terraform state mv module.ha_vault.aws_appautoscaling_target.dynamodb_table_write_target module.ha_vault.module.main_dynamodb_table.aws_appautoscaling_target.dynamodb_table_write_target
terraform state mv module.ha_vault.aws_dynamodb_table.vault_dynamodb_table module.ha_vault.module.main_dynamodb_table.aws_dynamodb_table.vault_dynamodb_table
```

Additionally, if you want to enable DynamoDB global tables on an existing Vault setup, you'll first need to export all the current data, empty the table, enable the global tables feature and finally import your data back in the main table. You could do this with the [DynamoDB import/export tool](https://docs.aws.amazon.com/datapipeline/latest/DeveloperGuide/dp-importexport-ddb.html). The reason for this is that enabling the global tables feature in DynamoDB requires all the tables involved to be empty.

#### From v1.x to v2.x

Starting from v2.0.0 of this module, the name of Vault's DynamoDB table will be dynamically generated from the values of `"${var.project}"` and `"${var.environment}"`. In previous versions it was hardcoded to `vault-dynamodb-backend`, so to avoid breaking current deployments, we've introduced a new variable `dynamodb_table_name_override` to force a specific name for the DynamoDB table. So if you're upgrading from a previous version of the module, you'll probably want to set `dynamodb_table_name_override=vault-dynamodb-backend` so Terraform doesn't recreate the table.

## Examples

Check out the [examples](examples/) folder.

## Backup and restore

Since version [`2.1.0`](https://github.com/skyscrapers/terraform-vault/releases/tag/2.1.0) of this module, Vault's DynamoDB table has [point-in-time recovery](https://docs.aws.amazon.com/amazondynamodb/latest/developerguide/PointInTimeRecovery_Howitworks.html) enabled by default, which means that Vault data is being continuously backed up, and backups are retained for 35 days.

A restore operation will force you to create a brand new DynamoDB table, and if you do that you'll have to take some additional steps to fix the Terraform drift caused by that.

### Restore without global tables

Follow this process only if you don't have cross-region replication enabled. If you have that enabled, see the section below.

1. Stop the Vault EC2 instances
1. Restore your data to a new DynamoDB table.
1. Set `dynamodb_table_name_override` variable to the name of your new DynamoDB table
1. Remove the old DynamoDB table from the Terraform state (make sure to replace the name of the vault module you've used - `module.vault`)
    ```bash
    terraform state rm module.vault.module.main_dynamodb_table.aws_dynamodb_table.vault_dynamodb_table
    ```
1. Import the new DynamoDB table to the Terraform state (make sure to replace the name of the vault module and the name of your new DynamoDB table)
    ```bash
    terraform import module.vault.module.main_dynamodb_table.aws_dynamodb_table.vault_dynamodb_table yournewdynamotable
    ```
1. Taint the Vault instances so they are replaced with the new DynamoDB table name. You have to do this, as Terraform ignores any changes on the instances user-data, which is where the DynamoDB table name is set. **Note that doing this will force a replace of those instances in your next terraform apply**
    ```bash
    terraform taint -module ha_vault.vault1 aws_instance.instance
    terraform taint -module ha_vault.vault2 aws_instance.instance
    ```
1. Apply terraform. This should make the following changes:
    - Modify the IAM policy to grant access to the new DynamoDB table
    - Replace both Vault instances
    - Configure autoscaling to the new DynamoDB table (if capacity autoscaling is enabled)
1. Wait until the new EC2 instances are up and marked as healthy in the individual ALB target groups, then unseal vault
1. Decide what to do with the old DynamoDB table. You can keep it in case you want to do another restore, or you can just delete it

### Restore with global tables enabled

In case you also have cross-region replication (Global tables) enabled, the process is a bit more complex:

1. Stop the Vault EC2 instances
1. Restore your data to a new DynamoDB table.
1. Once the restore is finished, export the data from your new DynamoDB table to S3. You can do this with Data Pipeline following [this guide from AWS](https://docs.aws.amazon.com/datapipeline/latest/DeveloperGuide/dp-importexport-ddb-part2.html).
1. In next steps we're going to create a new DynamoDB table, so choose a name for it and set it in the `dynamodb_table_name_override` variable. Remember that DynamoDB table names must be unique. An alternative would be to remove the existing DynamoDB table and reuse the same name for the new table, but that way you would loose all the incremental backups from your old table. If you choose to do that, just remove the table from the AWS console and skip steps 4 and 5.
1. Remove the old DynamoDB tables from the Terraform state (make sure to replace the name of the vault module you've used - `module.vault`)
    ```bash
    terraform state rm module.vault.module.main_dynamodb_table.aws_dynamodb_table.vault_dynamodb_table
    terraform state rm module.vault.module.replica_dynamodb_table.aws_dynamodb_table.vault_dynamodb_table
    terraform state rm module.vault.aws_dynamodb_global_table.vault_global_table
    ```
1. Apply terraform targeting just the global table resource. This will create your new DynamoDB tables
    ```bash
    terraform apply -target module.vault.aws_dynamodb_global_table.vault_global_table -var-file myvars.tfvars
    ```
1. Import the Vault data from S3 to the newly created table. Same as with the export, you can do this with Data Pipeline following [this guide from AWS](https://docs.aws.amazon.com/datapipeline/latest/DeveloperGuide/dp-importexport-ddb-part1.html). *Note that as of this writing, the import data pipeline doesn't compute correctly the write capacity of a global table, as it adds the write capacity of all the tables belonging to the global table. So if there are two tables in a global table, both with a provisioned write capacity of 40, the data pipeline will assume the table has a provisioned write capacity of 80, and in consequence there will be a lot of throttled write requests. A workaround is to set the DynamoDB write throughput ratio of the pipeline to 0.5*
1. After the import is complete, taint the Vault instances so they are replaced with the new DynamoDB table name. You have to do this, as Terraform ignores any changes on the instances user-data, which is where the DynamoDB table name is set. **Note that doing this will force a replace of those instances in your next terraform apply**
    ```bash
    terraform taint -module ha_vault.vault1 aws_instance.instance
    terraform taint -module ha_vault.vault2 aws_instance.instance
    ```
1. Apply terraform. This should make the following changes:
    - Modify the IAM policy to grant access to the new DynamoDB table
    - Replace both Vault instances
    - Configure autoscaling to the new DynamoDB table (if capacity autoscaling is enabled)
1. Wait until the new EC2 instances are up and marked as healthy in the individual ALB target groups, then unseal vault
1. Decide what to do with the old DynamoDB table. You can keep it in case you want to do another restore, or you can just delete it
