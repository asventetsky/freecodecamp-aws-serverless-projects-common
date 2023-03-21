resource "aws_iam_role" "lambda" {
  name = "${var.lambda_name}-${var.region}-${var.env}"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Sid    = ""
        Principal = {
          Service = "lambda.amazonaws.com"
        }
      },
    ]
  })

  tags = var.resource_tags
}

resource "aws_iam_policy" "lambda" {
  name = "${var.lambda_name}-${var.region}-${var.env}"
  policy = var.policy_json_string

  tags = var.resource_tags
}

resource "aws_iam_role_policy_attachment" "lambda" {
  role = aws_iam_role.lambda.name
  policy_arn = aws_iam_policy.lambda.arn
}
