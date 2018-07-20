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

variable "download_url_vault" {
  description = "The download url for vault"
  default     = "https://releases.hashicorp.com/vault/0.9.0/vault_0.9.0_linux_amd64.zip"
}

variable "download_url_teleport" {
  description = "The download url for Teleport"
  default     = "https://github.com/gravitational/teleport/releases/download/v2.3.5/teleport-v2.3.5-linux-amd64-bin.tar.gz"
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
