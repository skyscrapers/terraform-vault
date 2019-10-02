variable "dynamodb_table_name_override" {
  default = null
  type    = string
}

variable "environment" {
  type = string
}

variable "project" {
  type = string
}

variable "enable_point_in_time_recovery" {
  type = bool
}

variable "enable" {
  type = bool
}

variable "tags" {
  default = null
  type    = map(string)
}
