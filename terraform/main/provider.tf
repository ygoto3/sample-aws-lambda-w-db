provider "aws" {
    access_key = var.aws_access_key
    secret_key = var.aws_secret_key
    assume_role {
      role_arn = "arn:aws:iam::${var.aws_account_id}:role/${var.aws_assume_role_name}"
    }
    region     = var.region
}
