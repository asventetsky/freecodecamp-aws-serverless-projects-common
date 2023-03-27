resource "aws_lambda_function" "lambda" {
  # If the file is not in the current working directory you will need to include a
  # path.module in the filename.
  function_name = var.name
  filename      = var.path_to_archive
  role          = var.lambda_role_arn
  source_code_hash = filebase64sha256(var.path_to_archive)
  handler = var.handler
  runtime = "python3.9"

  environment {
    variables = var.environment_variables
  }

  tags = var.resource_tags
}

resource "aws_cloudwatch_log_group" "lambda" {
  name = "/aws/lambda/${aws_lambda_function.lambda.function_name}"

  retention_in_days = 1
}
