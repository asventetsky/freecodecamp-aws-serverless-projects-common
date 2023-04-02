resource "aws_api_gateway_rest_api" "app" {
  name = var.api_gateway_name
}

resource "aws_api_gateway_deployment" "app" {
  rest_api_id = aws_api_gateway_rest_api.app.id
}

resource "aws_api_gateway_stage" "app" {
  stage_name = "dev"
  rest_api_id = aws_api_gateway_rest_api.app.id
  deployment_id = aws_api_gateway_deployment.app.id
}