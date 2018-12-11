output "cluster_id" {
  value = "${aws_eks_cluster.eks_cluster.id}"
}

output "cluster_arn" {
  value = "${aws_eks_cluster.eks_cluster.arn}"
}

output "cluster_endpoint" {
  value = "${aws_eks_cluster.eks_cluster.endpoint}"
}

output "cluster_certificate_authority" {
  value = "${aws_eks_cluster.eks_cluster.certificate_authority.0.data}"
}
