variable "instance_type" {
  description = "Choose an instance type"
}

variable "environment" {
  description = "Environment resources belong to"
}

variable "aws_ami_id" {
  description = "AMI id for creating base"
}

variable "subnet_id" {
  description = "Id of the subnet where the instance should be launched"
}

variable "aws_region" {}
variable "key_name" {}

variable "vpc_security_group_ids" {
  type = "list"
}

variable "role" {}

variable "user_data" {
  default = ""
}

variable "volume_size" {
  default = 30
}

variable "instance_profile" {
  default = ""
}

variable "count" {
  default = 1
}
