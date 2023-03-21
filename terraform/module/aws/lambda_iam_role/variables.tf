variable "region" {}

variable "env" {}

variable "lambda_name" {}

variable "policy_json_string" {}

variable "resource_tags" {
  type = map(string)
}
