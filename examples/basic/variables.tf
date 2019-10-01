variable "vault_acm_arn" {
}

variable "vault_dns_root" {
}

variable "instance_type" {
  default = "t3.small"
}

variable "lb_internal" {
  default = true
}

variable "vault_version" {
}

variable "cidr_block" {
  default = "172.30.0.0/16"
}

variable "custom_ami" {
  default = null
}

variable "project" {
}

variable "acme_server" {
  default = "https://acme-v01.api.letsencrypt.org/directory"
}

variable "key_name" {
  default = null
}

variable "le_email" {
}
