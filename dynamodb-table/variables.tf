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

variable "dynamodb_max_read_capacity" {
  type = number
}

variable "dynamodb_min_read_capacity" {
  type = number
}

variable "dynamodb_max_write_capacity" {
  type = number
}

variable "dynamodb_min_write_capacity" {
  type = number
}

variable "enable_dynamodb_autoscaling" {
  type = bool
}

variable "enable" {
  type = bool
}
