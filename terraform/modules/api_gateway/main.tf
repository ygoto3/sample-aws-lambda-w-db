resource "aws_api_gateway_rest_api" "api" {
    name = "${var.resource_prefix}-api"

    body = jsonencode({
        openapi = "3.0.1"
        info = {
            title   = "api"
            version = "1.0"
        }
        paths = {
            "/items" = {
                get = {
                    x-amazon-apigateway-integration = {
                        httpMethod           = "POST"
                        payloadFormatVersion = "1.0"
                        type                 = "AWS_PROXY"
                        uri                  = var.lambda_invoke_arn
                        credentials          = var.iam_role_arn
                    }
                }
            }
        }
    })
}

resource "aws_api_gateway_deployment" "deployment" {
    rest_api_id = aws_api_gateway_rest_api.api.id
    stage_name  = "prod"
    triggers = {
        redeployment = sha1(jsonencode(aws_api_gateway_rest_api.api))
    }
}

resource "aws_api_gateway_rest_api_policy" "policy" {
    rest_api_id = aws_api_gateway_rest_api.api.id
    policy = jsonencode({
        Version = "2012-10-17",
        Statement = [
            {
                Effect = "Allow",
                Principal = "*",
                Action = "execute-api:Invoke",
                Resource = "${aws_api_gateway_rest_api.api.execution_arn}/*"
            }
        ]
    })
}
