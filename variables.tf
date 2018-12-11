variable "environment" {
  description = "The environment represented by the managed infrastructure."
}

variable "aws_region" {}
variable "aws_profile" {}

variable "forbidden_account_ids" {}

variable "vpc_id" {}

variable "eks_subnet_private_a" {}
variable "eks_subnet_private_b" {}
variable "eks_subnet_private_c" {}
variable "subnet_b_az" {
  default = "b"
}

variable "subnet_a_az" {
  default = "a"
}
variable "subnet_c_az" {
  default = "c"
}
variable "propagating_vgws" {}

variable "ubuntu_16_id" {}
variable "workstation_subnet_id" {
  
}
variable "key_name" {
  
}
variable "nat_gateway_id" {
  
}

variable "role_name" {}
variable "prefix" {}
variable "eks_master_security_group_name" {}
variable "master_cluster_name" {}
variable "eks_instance_type" {}
variable "worker_role_name" {}
variable "worker_instance_profile_name" {}
#-----------------------------------------
variable "eks_worker_ami_id" {}
variable "eks_worker_instance_type" {}
variable "eks_worker_autoscaling_groupname" {}
variable "eks_worker_security_group_name" {
  
}
