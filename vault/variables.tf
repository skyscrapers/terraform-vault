variable "project" {
  description = "Name of the project"
}

variable "environment" {
  description = "Name of the environment where to deploy Vault (just for naming reasons)"
}

variable "lb_internal" {
  description = "Should the ALB be created as an internal Loadbalancer"
  default     = false
}

variable "dns_root" {
  description = "The root domain to configure for vault"
  default     = "production.skyscrape.rs"
}

variable "vault_version" {
  description = "The Vault version to deploy"
}

variable "teleport_version" {
  description = "The Teleport version to deploy"
  default     = "3.1.8"
}

variable "teleport_auth_server" {
  description = "The hostname or ip of the Teleport auth server. If empty, Teleport integration will be disabled (default)."
  default     = ""
}

variable "teleport_token_1" {
  description = "The Teleport token for the first instance. This can be a dynamic short-lived token"
  default     = ""
}

variable "teleport_token_2" {
  description = "The Teleport token for the second instance. This can be a dynamic short-lived token"
  default     = ""
}

variable "teleport_node_sg" {
  description = "The security-group ID of the teleport server"
  default     = ""
}

variable "instance_type" {
  description = "The instance type to use for the vault servers"
  default     = "t2.micro"
}

variable "ami" {
  description = "The AMI ID to use for the vault instances"
}

variable "vault1_subnet" {
  description = "The subnet ID for the first vault instance"
}

variable "vault2_subnet" {
  description = "The subnet ID for the second vault instance"
}

variable "acm_arn" {
  description = "The ACM ARN to use on the alb"
}

variable "vpc_id" {
  description = "The VPC id to launch the instances in"
}

variable "lb_subnets" {
  description = "The subnets to use for the alb"
  type        = "list"
}

variable "vault_nproc" {
  description = "The amount of nproc to configure vault with. Set this to the amount of CPU cores"
  default     = "1"
}

variable "key_name" {
  description = "Name of the sshkey to deploy on the vault instances"
}

variable "enable_dynamodb_autoscaling" {
  description = "Enables the autoscaling feature on the Vault dynamodb table"
  default     = "true"
}

variable "dynamodb_max_read_capacity" {
  description = "The max read capacity of the Vault dynamodb table"
  default     = "100"
}

variable "dynamodb_min_read_capacity" {
  description = "The min read capacity of the Vault dynamodb table"
  default     = "5"
}

variable "replica_dynamodb_max_read_capacity" {
  description = "The max read capacity of the Vault dynamodb replica table"
  default     = "5"
}

variable "replica_dynamodb_min_read_capacity" {
  description = "The min read capacity of the Vault dynamodb replica table"
  default     = "5"
}

variable "dynamodb_max_write_capacity" {
  description = "The max write capacity of the Vault dynamodb table"
  default     = "100"
}

variable "dynamodb_min_write_capacity" {
  description = "The min write capacity of the Vault dynamodb table"
  default     = "5"
}

variable "dynamodb_table_name_override" {
  description = "Override Vault's DynamoDB table name with this variable. This module will generate a name if this is left empty (default behavior)"
  default     = ""
}

variable "acme_server" {
  description = "ACME server where to point `certbot` on the Teleport server to fetch an SSL certificate. Useful if you want to point to the letsencrypt staging server."
  default     = "https://acme-v01.api.letsencrypt.org/directory"
}

variable "le_email" {
  description = "The email address that's going to be used to register to LetsEncrypt"
}

variable "enable_point_in_time_recovery" {
  description = "Whether to enable point-in-time recovery - note that it can take up to 10 minutes to enable for new tables. Note that [additional charges](https://aws.amazon.com/dynamodb/pricing/) will apply by enabling this setting"
  default     = true
}

variable "enable_dynamodb_replica_table" {
  description = "Setting this to true will create a DynamoDB table on another region and enable global tables for replication. The replica table is going to be managed by the 'replica' Terraform provider"
  default     = false
}

variable "enable_ui" {
  description = "Enables the [Vault UI](https://www.vaultproject.io/docs/configuration/ui/index.html)"
  default     = true
}

variable "ec2_instances_cpu_credits" {
  description = "The type of cpu credits to use"
  default     = "standard"
}
