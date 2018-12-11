resource "aws_eks_cluster" "eks_cluster" {
  name     = "${var.cluster_name}"
  role_arn = "${var.cluster_role_arn}"

  vpc_config {
    subnet_ids         = ["${var.cluster_subnet_ids}"]
    security_group_ids = ["${var.cluster_security_group_ids}"]
  }
}
