variable "resource_prefix" {}
variable "source_dir" {}
variable "function_name" {}
variable "runtime" {}
variable "handler" {}
variable "iam_role_arn" {}
variable "vpc_id" {}
variable "subnet_ids" {
    type = list(string)
}
variable "environment_variables" {
    type = map(string)
}
variable "libs_path" {}
