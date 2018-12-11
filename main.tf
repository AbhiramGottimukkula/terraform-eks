provider "aws" {
  version               = "~> 1.24.0"
  region                = "${var.aws_region}"
  profile               = "${var.aws_profile}"
  forbidden_account_ids = ["${var.forbidden_account_ids}"] # prevent accidental production shenanigans
}

terraform {
  backend "s3" {}
}
