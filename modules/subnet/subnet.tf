# create a subnet, to be included as part of private/public subnet modules

locals {
  common_tags = {
    Environment = "${var.environment}"
    Type        = "${var.purpose}"
  }
}

resource "aws_subnet" "subnet" {
  cidr_block              = "${var.cidr_block}"
  vpc_id                  = "${var.vpc_id}"
  map_public_ip_on_launch = "${var.map_public_ip_on_launch}"
  availability_zone       = "${var.aws_region}${var.availability_zone}"

  tags = "${merge(
    local.common_tags,
    map(
        "Name", "${var.environment} | ${var.purpose} | ${var.aws_region}${var.availability_zone}"
    )
  )}"
}
