variable "api_gateway_name" {}

variable "stage" {}

variable "integrations" {
  description = "List of API gateway routes with integrations"
  type        = map(object({
    method = string
    path_part = string
    lambda_invoke_arn = string
    lambda_function_name = string
  }))
  default = {}
}
