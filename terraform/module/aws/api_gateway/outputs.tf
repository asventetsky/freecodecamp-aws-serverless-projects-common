output "api_gateway_url" {
  value = aws_api_gateway_stage.app.invoke_url
}

output "id" {
  value = aws_api_gateway_rest_api.app.id
}

output "root_resource_id" {
  value = aws_api_gateway_rest_api.app.root_resource_id
}

output "execution_arn" {
  value = aws_api_gateway_rest_api.app.execution_arn
}