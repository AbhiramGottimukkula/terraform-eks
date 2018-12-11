
data "aws_iam_policy_document" "worker_assume_role_policy" {
  statement {
    sid = "EKSClusterAssumeRole"

    actions = [
      "sts:AssumeRole",
    ]

    principals {
      type        = "Service"
      identifiers = ["ec2.amazonaws.com"]
    }
  }
}
  module "eks_worker_iam_role" {
  source                  = "./modules/iam_roles"
  role_name               = "${var.worker_role_name}"
  assume_role_policy_file = "${data.aws_iam_policy_document.worker_assume_role_policy.json}"
}


resource "aws_iam_role_policy_attachment" "worker-node-AmazonEKSWorkerNodePolicy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSWorkerNodePolicy"
  role       = "${module.eks_worker_iam_role.iam_role_name}"
}

resource "aws_iam_role_policy_attachment" "worker-node-AmazonEKS_CNI_Policy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKS_CNI_Policy"
  role       = "${module.eks_worker_iam_role.iam_role_name}"
}

resource "aws_iam_role_policy_attachment" "worker-node-AmazonEC2ContainerRegistryReadOnly" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly"
  role       = "${module.eks_worker_iam_role.iam_role_name}"
}

resource "aws_iam_instance_profile" "worker_node_eks" {
  name = "${var.worker_instance_profile_name}"
  role = "${module.eks_worker_iam_role.iam_role_name}"
}

resource "aws_security_group" "worker_eks_node" {
  name        = "${var.eks_worker_security_group_name}"
  vpc_id      = "${var.vpc_id}"

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}


resource "aws_security_group_rule" "worker-node-ingress-self" {
  description              = "Allow node to communicate with each other"
  from_port                = 0
  protocol                 = "-1"
  security_group_id        = "${aws_security_group.worker_eks_node.id}"
  source_security_group_id = "${aws_security_group.worker_eks_node.id}"
  to_port                  = 65535
  type                     = "ingress"
}

resource "aws_security_group_rule" "worker-node-ingress-cluster" {
  description              = "Allow worker Kubelets and pods to receive communication from the cluster control plane"
  from_port                = 1025
  protocol                 = "tcp"
  security_group_id        = "${aws_security_group.worker_eks_node.id}"
  source_security_group_id = "${aws_security_group.eks_master_cluster.id}"
  to_port                  = 65535
  type                     = "ingress"
}

resource "aws_security_group_rule" "eks-cluster-ingress-node-https" {
  description              = "Allow pods to communicate with the cluster API Server"
  from_port                = 443
  protocol                 = "tcp"
  security_group_id        = "${aws_security_group.eks_master_cluster.id}"
  source_security_group_id = "${aws_security_group.worker_eks_node.id}"
  to_port                  = 443
  type                     = "ingress"
}

data "aws_region" "current" {}

data "template_file" "eks_worker_userdata" {
  template = "${file("${path.module}/sh.tpl/eks_worker.sh.tpl")}"

  vars {
    certificate_authority = "${module.eks.cluster_certificate_authority}"
    eks_cluster_endpoint="${module.eks.cluster_endpoint}"
    cluster_name="${var.master_cluster_name}"
    region="${var.aws_region}"
  }
}
resource "aws_launch_configuration" "eks_worker" {
  associate_public_ip_address = false
  iam_instance_profile        = "${aws_iam_instance_profile.worker_node_eks.name}"
  image_id                    = "${var.eks_worker_ami_id}"
  instance_type               = "${var.eks_worker_instance_type}"
  name_prefix                 = "eks"
  security_groups             = ["${aws_security_group.worker_eks_node.id}"]
  key_name                    = "${var.key_name}"
  user_data_base64            = "${base64encode(data.template_file.eks_worker_userdata.rendered)}"
  enable_monitoring           = false

  lifecycle {
    create_before_destroy = true
  }
}
resource "aws_autoscaling_group" "eks_worker" {
  desired_capacity     = 3
  launch_configuration = "${aws_launch_configuration.eks_worker.id}"
  max_size             = 3
  min_size             = 1
  name                 = "${var.eks_worker_autoscaling_groupname}"
  vpc_zone_identifier  = ["${module.subnet_private_eks_a.priv_sub_id_out}",
    "${module.subnet_private_eks_b.priv_sub_id_out}",
    "${module.subnet_private_eks_c.priv_sub_id_out}"]


  tag {
    key                 = "kubernetes.io/cluster/${var.master_cluster_name}"
    value               = "owned"
    propagate_at_launch = true
  }
  tag {
    key                 = "Name"
    value               = "${var.master_cluster_name}-eks-worker"
    propagate_at_launch = true
  }
}

locals {
  config-map-aws-auth = <<CONFIGMAPAWSAUTH
apiVersion: v1
kind: ConfigMap
metadata:
  name: aws-auth
  namespace: kube-system
data:
  mapRoles: |
    - rolearn: ${module.eks_worker_iam_role.iam_role_arn}
      username: system:node:{{EC2PrivateDNSName}}
      groups:
        - system:bootstrappers
        - system:nodes
CONFIGMAPAWSAUTH
}

