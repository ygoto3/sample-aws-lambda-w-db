variable "aws_access_key" {}
variable "aws_secret_key" {}
variable "aws_account_id" {}
variable "aws_assume_role_name" {}
variable "aws_rds_username" {}
variable "aws_rds_password" {}
variable "aws_db_url" {}
variable "aws_db_port" {
    default = 5432
}
variable "aws_db_name" {}
variable "aws_db_username" {}
variable "aws_db_password" {}

variable "region" {
    default = "ap-northeast-1"
}
