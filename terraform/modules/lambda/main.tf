data "archive_file" "lambda_source_file" {
    type        = "zip"
    source_dir  = "${var.source_dir}"
    output_path = "${path.module}/lambda.zip"
}

resource "aws_security_group" "lambda" {
    vpc_id = var.vpc_id
    tags = {
        "Name" = "${var.resource_prefix}-lambda-sg"
    }

    egress {
        from_port = 0
        to_port = 0
        protocol = "-1"
        cidr_blocks = [
            "0.0.0.0/0"
        ]
    }
}

resource "aws_lambda_function" "lambda_app" {
    function_name       = var.function_name
    filename            = data.archive_file.lambda_source_file.output_path
    source_code_hash    = data.archive_file.lambda_source_file.output_base64sha256
    runtime             = "python3.9"
    role                = var.iam_role_arn
    layers              = [aws_lambda_layer_version.libs.arn]

    handler             = var.handler

    vpc_config {
        subnet_ids         = var.subnet_ids
        security_group_ids = [aws_security_group.lambda.id]
    }

    environment {
        variables = var.environment_variables
    }
}

resource "aws_lambda_layer_version" "libs" {
    filename = "${var.libs_path}"
    source_code_hash = filebase64sha256("${var.libs_path}")
    layer_name = "libs"
    compatible_runtimes = ["python3.9"]
}

output "lambda_arn" {
  value = aws_lambda_function.lambda_app.arn
}

output "lambda_invoke_arn" {
  value = aws_lambda_function.lambda_app.invoke_arn  
}

output "lambda_security_group_id" {
  value = aws_security_group.lambda.id
}
