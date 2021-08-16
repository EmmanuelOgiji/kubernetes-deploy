resource "aws_eks_cluster" "deployment" {
  name     = var.cluster_name
  role_arn = aws_iam_role.eks_role.arn

  vpc_config {
    security_group_ids      = [aws_security_group.eks_cluster.id]
    endpoint_private_access = true
    endpoint_public_access  = true
    subnet_ids              = concat(aws_subnet.public.*.id, aws_subnet.private.*.id)
  }

  enabled_cluster_log_types = ["api", "audit", "authenticator", "controllerManager", "scheduler"]

  tags = var.standard_tags

  # Ensure that IAM Role permissions are created before and deleted after EKS Cluster handling.
  # Otherwise, EKS will not be able to properly delete EKS managed EC2 infrastructure such as Security Groups.
  depends_on = [
    aws_iam_role_policy_attachment.eks_role-AmazonEKSClusterPolicy,
    aws_iam_role_policy_attachment.eks_role-AmazonEKSVPCResourceController,
    aws_iam_role_policy_attachment.eks-AmazonEKSServicePolicy
  ]
}

resource "aws_eks_node_group" "private" {
  cluster_name    = aws_eks_cluster.deployment.name
  node_group_name = "private-node-group-${var.cluster_name}"
  node_role_arn   = aws_iam_role.node_role.arn
  subnet_ids      = aws_subnet.private.*.id

  labels = {
    "type" = "private"
  }

  instance_types = var.instance_types

  scaling_config {
    desired_size = 1
    max_size     = 2
    min_size     = 1
  }

  depends_on = [
    aws_iam_role_policy_attachment.node_role-AmazonEKSWorkerNodePolicy,
    aws_iam_role_policy_attachment.node_role-AmazonEKS_CNI_Policy,
    aws_iam_role_policy_attachment.node_role-AmazonEC2ContainerRegistryReadOnly,
    aws_iam_role_policy_attachment.node_role-cluster_autoscaler,
  ]

  tags = var.standard_tags
}

resource "aws_eks_node_group" "public" {
  cluster_name    = aws_eks_cluster.deployment.name
  node_group_name = "public-node-group-${var.cluster_name}"
  node_role_arn   = aws_iam_role.node_role.arn
  subnet_ids      = aws_subnet.public.*.id

  labels = {
    "type" = "public"
  }

  instance_types = var.instance_types

  scaling_config {
    desired_size = 1
    max_size     = 2
    min_size     = 1
  }

  depends_on = [
    aws_iam_role_policy_attachment.node_role-AmazonEKSWorkerNodePolicy,
    aws_iam_role_policy_attachment.node_role-AmazonEKS_CNI_Policy,
    aws_iam_role_policy_attachment.node_role-AmazonEC2ContainerRegistryReadOnly,
    aws_iam_role_policy_attachment.node_role-cluster_autoscaler,
  ]

  tags = var.standard_tags
}
