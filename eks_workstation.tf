data "template_file" "eks_worstation_install" {
  template = "${file("${path.module}/sh.tpl/eks_workstation.sh.tpl")}"

  vars {
    kubectl_config = "${local.kubeconfig}"
    aws_auth = "${local.config-map-aws-auth}"
  }
}

module "eks_workstation_instance" {
  source        = "./modules/aws_instance"
  environment   = "${var.environment}"
  aws_ami_id    = "${var.ubuntu_16_id}"
  subnet_id     = "${var.workstation_subnet_id}"
  instance_type = "${var.eks_instance_type}"
  aws_region    = "${var.aws_region}"
  key_name      = "${var.key_name}"

  vpc_security_group_ids = [
    "${aws_security_group.eks_workstation_security_group.id}",
  ]

  role      = "${var.role_name}-eks-workstation"
  user_data = "${data.template_file.eks_worstation_install.rendered}"
}

resource "aws_security_group" "eks_workstation_security_group" {
  name   = "eks_workstation"
  vpc_id = "${var.vpc_id}"

  ingress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress = {
    from_port   = 0
    to_port     = 0
    protocol    = -1
    cidr_blocks = ["0.0.0.0/0"]
  }
}
