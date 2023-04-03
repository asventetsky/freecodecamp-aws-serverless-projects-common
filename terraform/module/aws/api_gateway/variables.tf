variable "api_gateway_name" {}

variable "integrations" {
  description = "List of API gateway routes with integrations"
  type        = set(any)
  default     = []
}
