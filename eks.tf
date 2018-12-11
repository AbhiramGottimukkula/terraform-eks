locals {
  kubeconfig = <<KUBECONFIG
apiVersion: v1
clusters:
- cluster:
    server: ${module.eks.cluster_endpoint}
    certificate-authority-data: ${module.eks.cluster_certificate_authority}
  name: kubernetes
contexts:
- context:
    cluster: kubernetes
    user: aws
  name: aws
current-context: aws
kind: Config
preferences: {}
users:
- name: aws
  user:
    exec:
      apiVersion: client.authentication.k8s.io/v1alpha1
      command: aws-iam-authenticator
      args:
        - "token"
        - "-i"
        - "${var.master_cluster_name}"
KUBECONFIG
}

data "aws_iam_policy_document" "cluster_assume_role_policy" {
  statement {
    sid = "EKSClusterAssumeRole"

    actions = [
      "sts:AssumeRole",
    ]

    principals {
      type        = "Service"
      identifiers = ["eks.amazonaws.com"]
    }
  }
}
module "cluster_iam_role" {
  source                  = "modules/iam_roles"
  role_name               = "${var.role_name}"
  assume_role_policy_file = "${data.aws_iam_policy_document.cluster_assume_role_policy.json}"
}

resource "aws_iam_role_policy_attachment" "eks-cluster-AmazonEKSClusterPolicy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSClusterPolicy"
  role       = "${module.cluster_iam_role.iam_role_name}"
}

resource "aws_iam_role_policy_attachment" "eks-cluster-AmazonEKSServicePolicy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSServicePolicy"
  role       = "${module.cluster_iam_role.iam_role_name}"
}

resource "aws_security_group" "eks_master_cluster" {
  name        = "${var.eks_master_security_group_name}"
  description = "Cluster communication with worker nodes"
  vpc_id      = "${var.vpc_id}"

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    security_groups = ["${aws_security_group.worker_eks_node.id}"]
  }
}

resource "aws_security_group_rule" "eks_master_cluster_ingress_workstation_https" {
  cidr_blocks       = ["0.0.0.0/0"]
  description       = "Allow workstation to communicate with the cluster API Server"
  from_port         = 443
  protocol          = "tcp"
  security_group_id = "${aws_security_group.eks_master_cluster.id}"
  to_port           = 443
  type              = "ingress"
}

module "eks" {
  source           = "./modules/eks_cluster"
  cluster_name     = "${var.master_cluster_name}"
  cluster_role_arn = "${module.cluster_iam_role.iam_role_arn}"

  cluster_subnet_ids = ["${module.subnet_private_eks_a.priv_sub_id_out}",
    "${module.subnet_private_eks_b.priv_sub_id_out}",
     "${module.subnet_private_eks_c.priv_sub_id_out}",
  ]

  cluster_security_group_ids = ["${aws_security_group.eks_master_cluster.id}"]
}
