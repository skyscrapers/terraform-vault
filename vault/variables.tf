variable "project" {}

variable "environment" {}

variable "lb_internal" {
  default = false
}

variable "dns_root" {
  default = "production.skyscrape.rs"
}

variable "download_url_vault" {
  default     = "https://releases.hashicorp.com/vault/0.9.0/vault_0.9.0_linux_amd64.zip"
  description = "URL to download Vault"
}

variable "download_url_teleport" {
  description = "String(optional): The download url for Teleport."
  default     = "https://github.com/gravitational/teleport/releases/download/v2.3.5/teleport-v2.3.5-linux-amd64-bin.tar.gz"
}

variable "teleport_auth_server" {
  description = "String(optional): The hostname or ip of the Teleport auth server."
  default     = ""
}

variable "teleport_token_1" {
  description = "String(optional): The Teleport token for the first instance. This can be a dynamic short-lived token."
  default     = ""
}

variable "teleport_token_2" {
  description = "String(optional): The Teleport token for the second instance. This can be a dynamic short-lived token."
  default     = ""
}

variable "teleport_node_sg" {
  description = "String(optional): The security-group ID of the teleport server."
  default     = ""
}

variable "instance_type" {
  default = "t2.micro"
}

variable "ami" {}

variable "vault1_subnet" {}

variable "vault2_subnet" {}

variable "acm_arn" {}

variable "vpc_id" {}

variable "lb_subnets" {
  type = "list"
}

variable "vault_nproc" {
  default = "1"
}

variable "key_name" {}
