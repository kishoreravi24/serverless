# 1. Create API Gateway HTTP API
resource "aws_apigatewayv2_api" "api" { ... }

# 2. Create Lambda
resource "aws_lambda_function" "fastApi_lambda" { ... }

# 3. Integration: Link API Gateway to Lambda
resource "aws_apigatewayv2_integration" "lambda_integration" { ... }

# 4. Route: Define HTTP method and path
resource "aws_apigatewayv2_route" "default" { ... }

# 5. Stage: Deployment stage (like $default)
resource "aws_apigatewayv2_stage" "default" { ... }

# 6. Permission: Allow API Gateway to invoke Lambda
resource "aws_lambda_permission" "api_gw" { ... }


provider "aws"{
 region = "us-east-1"
}

# IAM role
resource "aws_iam_role" "test_role" {
  name = "test_role"

  # Terraform's "jsonencode" function converts a
  # Terraform expression result to valid JSON syntax.
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
}

resource "aws_lambda_function" "fastApi_lambda" {
  filename         = "fastApi.zip"
  function_name    = "fastApi_lambda"
  role             = aws_iam_role.test_role.arn
  handler          = "main.root"
  source_code_hash = filebase64sha256("fastApi.zip")

  runtime = "python3.12"
}

resource "aws_apigatewayv2_api" "api"{
 name = "fastApi-http-api"
 protocol_type = "HTTP"
}

resource "aws_apigatewayv2_integration" "lambda_integration" {
  api_id                = aws_apigatewayv2_api.api.id
  integration_type      = "AWS_PROXY"
  integration_uri       = aws_lambda_function.fastApi_lambda.invoke_arn
  integration_method    = "POST"
  payload_format_version = "2.0"
}


resource "aws_apigatewayv2_route" "default"{
 api_id = aws_apigatewayv2_api.api.id
 route_key = "GET /hello"
 target = "integrations/${aws_apigatewayv2_integration.lambda_integration.id}"
}

resource "aws_apigatewayv2_stage" "default"{
 api_id = aws_apigatewayv2_api.api.id
 name = "\$default"
 auto_deploy = true
}

resource "aws_lambda_permission" "api_gw"{
 statement_id = "AllowExecutionFromAPIGateway"
 action = "lambda:InvokeFunction"
 function_name = aws_lambda_function.fastApi_lambda.function_name
 principal = "apigateway.amazonaws.com"
 source_arn = "${aws_apigatewayv2_api.api.execution_arn}/*/*"
}

output "api_endpoint"{
 value = aws_apigatewayv2_api.api.api_endpoint
}



provider "aws"{
 region = "us-east-1"
}

# IAM role
resource "aws_iam_role" "test_role" {
  name = "test_role"

  # Terraform's "jsonencode" function converts a
  # Terraform expression result to valid JSON syntax.
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
}

resource "aws_lambda_function" "fastApi_lambda" {
  filename         = "fastApi.zip"
  function_name    = "fastApi_lambda"
  role             = aws_iam_role.test_role.arn
  handler          = "main.root"
  source_code_hash = filebase64sha256("fastApi.zip")

  runtime = "python3.12"
}

resource "aws_apigatewayv2_api" "api"{
 name = "fastApi-http-api"
 protocol_type = "HTTP"
}

resource "aws_apigatewayv2_integration" "lambda_integration" {
  api_id                = aws_apigatewayv2_api.api.id
  integration_type      = "AWS_PROXY"
  integration_uri       = aws_lambda_function.fastApi_lambda.invoke_arn
  integration_method    = "POST"
  payload_format_version = "2.0"
}


resource "aws_apigatewayv2_route" "default"{
 api_id = aws_apigatewayv2_api.api.id
 route_key = "GET /hello"
 target = "integrations/${aws_apigatewayv2_integration.lambda_integration.id}"
}

resource "aws_apigatewayv2_stage" "default"{
 api_id = aws_apigatewayv2_api.api.id
 name = "$default"
 auto_deploy = true
}

resource "aws_lambda_permission" "api_gw"{
 statement_id = "AllowExecutionFromAPIGateway"
 action = "lambda:InvokeFunction"
 function_name = aws_lambda_function.fastApi_lambda.function_name
 principal = "apigateway.amazonaws.com"
 source_arn = "${aws_apigatewayv2_api.api.execution_arn}/*/*"
}

output "api_endpoint"{
 value = aws_apigatewayv2_api.api.api_endpoint
}


