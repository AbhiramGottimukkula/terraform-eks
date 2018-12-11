locals {
  common_tags = {
    Environment = "${var.environment}"
  }
}

resource "aws_instance" "instance" {
  count                  = "${var.count}"
  ami                    = "${var.aws_ami_id}"
  instance_type          = "${var.instance_type}"
  subnet_id              = "${var.subnet_id}"
  key_name               = "${var.key_name}"
  vpc_security_group_ids = ["${var.vpc_security_group_ids }"]
  user_data              = "${var.user_data}"
  iam_instance_profile   = "${var.instance_profile}"

  root_block_device {
    volume_size = "${var.volume_size}"
  }

  tags = "${merge(
    local.common_tags,
    map(
        "Name", "${var.role} | ${var.environment}"
    ),
    map(
      "role","${var.role}"
    )
  )}"
}
