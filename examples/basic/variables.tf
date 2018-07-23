variable "vault_acm_arn" {
}

variable "vault_dns_root" {
}

variable "instance_type" {
  default = "t2.small"
}

variable "lb_internal" {
  default = "true"
}

variable "vault_version" {
  default = "0.10.3"
}

variable "cidr_block" {
  default = "172.30.0.0/16"
}

variable "custom_ami" {
  default = ""
}

variable "project" {
}

variable "le_staging" {
  default = false
}

variable "key_name" {
  default = ""
}
