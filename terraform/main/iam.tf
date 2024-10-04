resource "aws_iam_role" "lambda_iam_role" {
    name                = "lambda_iam_role"
    assume_role_policy  = jsonencode({
        Version = "2012-10-17",
        Statement = [
            {
                Effect = "Allow",
                Principal = {
                    Service = "lambda.amazonaws.com"
                },
                Action = "sts:AssumeRole"
            }
        ]
    })
}

resource "aws_iam_role_policy" "lambda_access_policy" {
    name    = "lambda_access_policy"
    role    = aws_iam_role.lambda_iam_role.id
    policy  = jsonencode({
        Version = "2012-10-17",
        Statement = [
            {
                Effect = "Allow",
                Action = [
                    "logs:CreateLogGroup",
                    "logs:CreateLogStream",
                    "logs:PutLogEvents"
                ],
                Resource = "arn:aws:logs:*:*:*"
            }
        ]
    })
}

resource "aws_iam_role_policy_attachment" "lambda_access_policy_attachment" {
    role        = aws_iam_role.lambda_iam_role.id
    for_each    = toset([
        "arn:aws:iam::aws:policy/service-role/AWSLambdaVPCAccessExecutionRole"
    ])
    policy_arn  = each.value
}

resource "aws_iam_role" "api_gateway_role" {
    name               = "api_gateway_role"
    assume_role_policy = jsonencode({
        Version     = "2012-10-17",
        Statement   = [
            {
                Effect      = "Allow",
                Principal   = {
                    Service = "apigateway.amazonaws.com"
                },
                Action      = "sts:AssumeRole"
            }
        ]
    })
}

resource "aws_iam_role_policy_attachment" "api_gateway_policy_attachment" {
    role = aws_iam_role.api_gateway_role.id
    for_each = toset([
        "arn:aws:iam::aws:policy/service-role/AmazonAPIGatewayPushToCloudWatchLogs",
        "arn:aws:iam::aws:policy/service-role/AWSLambdaRole"
    ])
    policy_arn = each.value
}
