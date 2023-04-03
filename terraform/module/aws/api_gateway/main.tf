resource "aws_api_gateway_rest_api" "app" {
  name = var.api_gateway_name
}

resource "aws_api_gateway_resource" "app" {
  for_each = var.integrations

  path_part = each.value.path_part
  parent_id = aws_api_gateway_rest_api.app.root_resource_id
  rest_api_id = aws_api_gateway_rest_api.app.id
}

resource "aws_api_gateway_method" "app" {
  for_each = var.integrations

  rest_api_id = aws_api_gateway_rest_api.app.id
  resource_id = aws_api_gateway_resource.app[each.key].id
  http_method = each.value.method
  authorization = "NONE"
}

resource "aws_api_gateway_integration" "app" {
  for_each = var.integrations

  depends_on = [aws_lambda_permission.app]

  rest_api_id = aws_api_gateway_rest_api.app.id
  resource_id = aws_api_gateway_method.app.resource_id
  http_method = aws_api_gateway_method.app.http_method

  integration_http_method = "POST"
  type = "AWS_PROXY"
  uri = each.value.lambda_invoke_arn
}

resource "aws_lambda_permission" "app" {
  for_each = var.integrations

  statement_id  = "AllowAPIGatewayInvoke"
  action        = "lambda:InvokeFunction"
  function_name = each.value.lambda_function_name
  principal     = "apigateway.amazonaws.com"

  source_arn = "${aws_api_gateway_rest_api.app.execution_arn}/*/*"
}

resource "aws_api_gateway_deployment" "app" {
  rest_api_id = aws_api_gateway_rest_api.app.id

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_api_gateway_stage" "app" {
  stage_name = "dev"
  rest_api_id = aws_api_gateway_rest_api.app.id
  deployment_id = aws_api_gateway_deployment.app.id
}