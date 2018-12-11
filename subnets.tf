module "eks_private_route_a" {
  source         = "./modules/routing_table_private"
  environment    = "${var.environment}"
  vpc_id         = "${var.vpc_id}"
  cidr_block     = "0.0.0.0/0"
  nat_gateway_id = "${var.nat_gateway_id}"
  purpose        = "eks-private-a"
  aws_region     = "${var.aws_region}"
}

module "subnet_private_eks_a" {
  source            = "./modules/subnet_private"
  environment       = "${var.environment}"
  cidr_block        = "${var.eks_subnet_private_a}"
  vpc_id            = "${var.vpc_id}"
  availability_zone = "${var.subnet_a_az}"
  prefix            = "${var.prefix}"
  aws_region        = "${var.aws_region}"
  route_table_id    = "${module.eks_private_route_a.priv_route_table_id_out}"
}

module "eks_private_route_b" {
  source         = "./modules/routing_table_private"
  environment    = "${var.environment}"
  vpc_id         = "${var.vpc_id}"
  cidr_block     = "0.0.0.0/0"
  nat_gateway_id = "${var.nat_gateway_id}"
  purpose        = "eks-private-b"
  aws_region     = "${var.aws_region}"
}

module "subnet_private_eks_b" {
  source            = "./modules/subnet_private"
  environment       = "${var.environment}"
  cidr_block        = "${var.eks_subnet_private_b}"
  vpc_id            = "${var.vpc_id}"
  availability_zone = "${var.subnet_b_az}"
  prefix            = "${var.prefix}"
  aws_region        = "${var.aws_region}"
  route_table_id    = "${module.eks_private_route_b.priv_route_table_id_out}"
}
module "eks_private_route_c" {
  source         = "./modules/routing_table_private"
  environment    = "${var.environment}"
  vpc_id         = "${var.vpc_id}"
  cidr_block     = "0.0.0.0/0"
  nat_gateway_id = "${var.nat_gateway_id}"
  purpose        = "eks-private-c"
  aws_region     = "${var.aws_region}"
}

module "subnet_private_eks_c" {
  source            = "./modules/subnet_private"
  environment       = "${var.environment}"
  cidr_block        = "${var.eks_subnet_private_c}"
  vpc_id            = "${var.vpc_id}"
  availability_zone = "${var.subnet_c_az}"
  prefix            = "${var.prefix}"
  aws_region        = "${var.aws_region}"
  route_table_id    = "${module.eks_private_route_c.priv_route_table_id_out}"
}
