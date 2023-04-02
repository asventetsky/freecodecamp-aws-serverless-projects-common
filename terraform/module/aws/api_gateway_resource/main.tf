resource "aws_api_gateway_resource" "app" {
  path_part = var.path_part
  parent_id = var.api_gateway_root_resource_id
  rest_api_id = var.api_gateway_id
}

resource "aws_api_gateway_method" "app" {
  rest_api_id = var.api_gateway_id
  resource_id = aws_api_gateway_resource.app.id
  http_method = var.method
  authorization = "NONE"
}

resource "aws_api_gateway_integration" "app" {
  depends_on = [aws_lambda_permission.app]

  rest_api_id = var.api_gateway_id
  resource_id = aws_api_gateway_method.app.resource_id
  http_method = aws_api_gateway_method.app.http_method

  integration_http_method = "POST"
  type = "AWS_PROXY"
  uri = var.lambda_invoke_arn
}

resource "aws_lambda_permission" "app" {
  statement_id  = "AllowAPIGatewayInvoke"
  action        = "lambda:InvokeFunction"
  function_name = var.lambda_function_name
  principal     = "apigateway.amazonaws.com"

  source_arn = "${var.api_gateway_execution_arn}/*/*"
}
