variable "resource_prefix" {}
variable "db_username" {}
variable "db_password" {}
variable "vpc_id" {}
variable "subnet_ids" {
    type = list(string)
}
variable "ingress_security_group_ids" {
    type = list(string)
}
