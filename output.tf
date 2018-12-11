output "eks_private_route_a_id" {
  value = "${module.eks_private_route_a.priv_route_table_id_out}"
}

output "eks_private_route_b_id" {
  value = "${module.eks_private_route_b.priv_route_table_id_out}"
}
output "eks_private_route_c_id" {
  value = "${module.eks_private_route_c.priv_route_table_id_out}"
}
output "subnet_private_eks_a_id" {
  value = "${module.subnet_private_eks_a.priv_sub_id_out}"
}

output "subnet_private_eks_b_id" {
  value = "${module.subnet_private_eks_b.priv_sub_id_out}"
}
output "subnet_private_eks_c_id" {
  value = "${module.subnet_private_eks_c.priv_sub_id_out}"
}
output "cluster_iam_role_arn" {
  value = "${module.cluster_iam_role.iam_role_arn}"
}

output "cluster_iam_role_name" {
  value = "${module.cluster_iam_role.iam_role_name}"
}

output "eks_cluster_securitygroup_id" {
  value = "${aws_security_group.eks_master_cluster.id}"
}

output "eks_master_cluster_id" {
  value = "${module.eks.cluster_id}"
}

output "eks_master_cluster_arn" {
  value = "${module.eks.cluster_arn}"
}

output "eks_master_cluster_endpoint" {
  value = "${module.eks.cluster_endpoint}"
}

output "eks_master_cluster_certificate_authority" {
  value = "${module.eks.cluster_certificate_authority}"
}

output "kubeconfig" {
  value = "${local.kubeconfig}"
}

output "eks_workstation_instance_id" {
  value = "${module.eks_workstation_instance.aws_instance_id}"
}

output "eks_workstation_instance_private_ip" {
  value = "${module.eks_workstation_instance.aws_instance_private_ip}"
}
output "config-map-aws-auth" {
  value = "${local.config-map-aws-auth}"
}