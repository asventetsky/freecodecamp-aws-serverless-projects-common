variable "name" {}

variable "path_to_archive" {}

variable "lambda_role_arn" {}

variable "handler" {}

variable "environment_variables" {
  type = map(string)
}

variable "resource_tags" {
  type = map(string)
}
