resource "aws_api_gateway_rest_api" "this" {
  name = var.api_gateway_name
}

resource "aws_api_gateway_deployment" "this" {
  depends_on = [aws_api_gateway_integration.this]

  rest_api_id = aws_api_gateway_rest_api.this.id

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_api_gateway_stage" "this" {
  stage_name = var.stage
  rest_api_id = aws_api_gateway_rest_api.this.id
  deployment_id = aws_api_gateway_deployment.this.id
}

#=============================================#
# Declare resources, methods and integrations #
#=============================================#
resource "aws_api_gateway_resource" "this" {
  for_each = var.integrations

  path_part = each.value.path_part
  parent_id = aws_api_gateway_rest_api.this.root_resource_id
  rest_api_id = aws_api_gateway_rest_api.this.id
}

resource "aws_api_gateway_method" "this" {
  for_each = var.integrations

  rest_api_id = aws_api_gateway_rest_api.this.id
  resource_id = aws_api_gateway_resource.this[each.key].id
  http_method = each.value.method
  authorization = "NONE"
}

resource "aws_lambda_permission" "this" {
  for_each = var.integrations

  action        = "lambda:InvokeFunction"
  function_name = each.value.lambda_function_name
  principal     = "apigateway.amazonaws.com"

  source_arn = "${aws_api_gateway_rest_api.this.execution_arn}/*/*"
}

resource "aws_api_gateway_integration" "this" {
  for_each = var.integrations

  rest_api_id = aws_api_gateway_rest_api.this.id
  resource_id = aws_api_gateway_resource.this[each.key].id
  http_method = aws_api_gateway_method.this[each.key].http_method

  integration_http_method = "POST"
  type = "AWS_PROXY"
  uri = each.value.lambda_invoke_arn
}
