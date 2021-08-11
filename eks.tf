locals {
  cluster_name = "k8s-deployment"
}

resource "aws_eks_cluster" "deployment" {
  name     = local.cluster_name
  role_arn = aws_iam_role.eks_role.arn

  vpc_config {
    subnet_ids         = aws_subnet.public.*.id
    security_group_ids = [aws_security_group.eks_cluster.id, aws_security_group.eks_nodes.id]
  }

  tags = var.standard_tags

  # Ensure that IAM Role permissions are created before and deleted after EKS Cluster handling.
  # Otherwise, EKS will not be able to properly delete EKS managed EC2 infrastructure such as Security Groups.
  depends_on = [
    aws_iam_role_policy_attachment.eks_role-AmazonEKSClusterPolicy,
    aws_iam_role_policy_attachment.eks_role-AmazonEKSVPCResourceController,
  ]
}

resource "aws_eks_node_group" "deployment_nodes" {
  cluster_name    = aws_eks_cluster.deployment.name
  node_group_name = "deployment_nodes"
  node_role_arn   = aws_iam_role.node_role.arn
  subnet_ids      = aws_subnet.private.*.id
  instance_types  = ["t2.micro"]

  scaling_config {
    desired_size = 1
    max_size     = 1
    min_size     = 1
  }

  tags = var.standard_tags


  # Ensure that IAM Role permissions are created before and deleted after EKS Node Group handling.
  # Otherwise, EKS will not be able to properly delete EC2 Instances and Elastic Network Interfaces.
  depends_on = [
    aws_iam_role_policy_attachment.node_role-AmazonEKSWorkerNodePolicy,
    aws_iam_role_policy_attachment.node_role-AmazonEKS_CNI_Policy,
    aws_iam_role_policy_attachment.node_role-AmazonEC2ContainerRegistryReadOnly,
    aws_iam_role_policy_attachment.node_role-cluster_autoscaler,
  ]
}