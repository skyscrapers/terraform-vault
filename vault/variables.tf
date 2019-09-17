variable "project" {
  description = "Name of the project"
  type        = string
}

variable "environment" {
  description = "Name of the environment where to deploy Vault (just for naming reasons)"
  type        = string
}

variable "lb_internal" {
  description = "Should the ALB be created as an internal Loadbalancer"
  default     = false
  type        = bool
}

variable "dns_root" {
  description = "The root domain to configure for vault"
  default     = "production.skyscrape.rs"
  type        = string
}

variable "vault_version" {
  description = "The Vault version to deploy"
  type        = string
}

variable "teleport_version" {
  description = "The Teleport version to deploy"
  default     = "3.1.8"
  type        = string
}

variable "teleport_auth_server" {
  description = "The hostname or ip of the Teleport auth server. If empty, Teleport integration will be disabled (default)."
  default     = null
  type        = string
}

variable "teleport_token_1" {
  description = "The Teleport token for the first instance. This can be a dynamic short-lived token"
  default     = null
  type        = string
}

variable "teleport_token_2" {
  description = "The Teleport token for the second instance. This can be a dynamic short-lived token"
  default     = null
  type        = string
}

variable "teleport_node_sg" {
  description = "The security-group ID of the teleport server"
  default     = null
  type        = string
}

variable "instance_type" {
  description = "The instance type to use for the vault servers"
  default     = "t2.micro"
  type        = string
}

variable "ami" {
  description = "The AMI ID to use for the vault instances"
  type        = string
}

variable "vault1_subnet" {
  description = "The subnet ID for the first vault instance"
  type        = string
}

variable "vault2_subnet" {
  description = "The subnet ID for the second vault instance"
  type        = string
}

variable "acm_arn" {
  description = "The ACM ARN to use on the alb"
  type        = string
}

variable "vpc_id" {
  description = "The VPC id to launch the instances in"
  type        = string
}

variable "lb_subnets" {
  description = "The subnets to use for the alb"
  type        = list(string)
}

variable "vault_nproc" {
  description = "The amount of nproc to configure vault with. Set this to the amount of CPU cores"
  default     = 1
  type        = number
}

variable "key_name" {
  description = "Name of the sshkey to deploy on the vault instances"
  default     = null
  type        = string
}

variable "enable_dynamodb_autoscaling" {
  description = "Enables the autoscaling feature on the Vault dynamodb table"
  default     = true
  type        = bool
}

variable "dynamodb_max_read_capacity" {
  description = "The max read capacity of the Vault dynamodb table"
  default     = 100
  type        = number
}

variable "dynamodb_min_read_capacity" {
  description = "The min read capacity of the Vault dynamodb table"
  default     = 5
  type        = number
}

variable "replica_dynamodb_max_read_capacity" {
  description = "The max read capacity of the Vault dynamodb replica table"
  default     = 5
  type        = number
}

variable "replica_dynamodb_min_read_capacity" {
  description = "The min read capacity of the Vault dynamodb replica table"
  default     = 5
  type        = number
}

variable "dynamodb_max_write_capacity" {
  description = "The max write capacity of the Vault dynamodb table"
  default     = 100
  type        = number
}

variable "dynamodb_min_write_capacity" {
  description = "The min write capacity of the Vault dynamodb table"
  default     = 5
  type        = number
}

variable "dynamodb_table_name_override" {
  description = "Override Vault's DynamoDB table name with this variable. This module will generate a name if this is left empty (default behavior)"
  default     = null
  type        = string
}

variable "acme_server" {
  description = "ACME server where to point `certbot` on the Teleport server to fetch an SSL certificate. Useful if you want to point to the letsencrypt staging server."
  default     = "https://acme-v01.api.letsencrypt.org/directory"
  type        = string
}

variable "le_email" {
  description = "The email address that's going to be used to register to LetsEncrypt"
  type        = string
}

variable "enable_point_in_time_recovery" {
  description = "Whether to enable point-in-time recovery - note that it can take up to 10 minutes to enable for new tables. Note that [additional charges](https://aws.amazon.com/dynamodb/pricing/) will apply by enabling this setting"
  default     = true
  type        = bool
}

variable "enable_dynamodb_replica_table" {
  description = "Setting this to true will create a DynamoDB table on another region and enable global tables for replication. The replica table is going to be managed by the 'replica' Terraform provider"
  default     = false
  type        = bool
}

variable "enable_ui" {
  description = "Enables the [Vault UI](https://www.vaultproject.io/docs/configuration/ui/index.html)"
  default     = true
  type        = bool
}

variable "ec2_instances_cpu_credits" {
  description = "The type of cpu credits to use"
  default     = "standard"
  type        = string
}
