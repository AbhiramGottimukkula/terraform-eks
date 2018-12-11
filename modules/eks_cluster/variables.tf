variable "cluster_name" {}
variable "cluster_role_arn" {}

variable "cluster_subnet_ids" {
  type = "list"
}

variable "cluster_security_group_ids" {
  type = "list"
}
