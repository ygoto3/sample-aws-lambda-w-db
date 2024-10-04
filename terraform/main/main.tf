module "lambda" {
    source          = "../modules/lambda"

    resource_prefix = "sample_lambda"
    source_dir      = "../../lambda/sample_lambda_app"
    function_name   = "sample_lambda_app"
    runtime         = "python3.9"
    handler         = "lambda_function.lambda_handler"
    iam_role_arn    = aws_iam_role.lambda_iam_role.arn
    vpc_id          = aws_vpc.main.id
    subnet_ids      = [aws_subnet.private.id, aws_subnet.private2.id]
    libs_path       = "../../lambda/layers/Layer.zip"

    environment_variables = {
        "DB_URL"    = var.aws_db_url
        "DB_PORT"   = var.aws_db_port
        "DB_NAME"   = var.aws_db_name
        "DB_USER"   = var.aws_db_username
        "DB_PASS"   = var.aws_db_password
    }
}

module "api_gateway" {
    source              = "../modules/api_gateway"

    resource_prefix     = "sample_lambda_api_gateway"
    iam_role_arn        = aws_iam_role.api_gateway_role.arn
    lambda_invoke_arn   = module.lambda.lambda_invoke_arn
}

module "rds" {
    source          = "../modules/rds"

    resource_prefix = "sample-lambda-rds"
    db_username     = var.aws_rds_username
    db_password     = var.aws_rds_password
    vpc_id          = aws_vpc.main.id
    subnet_ids      = [aws_subnet.private.id, aws_subnet.private2.id]
    ingress_security_group_ids = [module.lambda.lambda_security_group_id]
}
