# create a private route table, to be included as part of private subnet modules
# and associated to a NAT gateway

locals {
  common_tags = {
    Environment = "${var.environment}"
  }
}

resource "aws_route_table" "private_route_table" {
  vpc_id = "${var.vpc_id}"

  route {
    cidr_block     = "${var.cidr_block}"
    nat_gateway_id = "${var.nat_gateway_id}"
  }
  propagating_vgws = ["${var.propagating_vgws}"]

  tags = "${merge(
    local.common_tags,
    map(
        "Name", "${var.environment} | ${var.purpose} | route-table | ${var.aws_region}"
    )
  )}"
}
