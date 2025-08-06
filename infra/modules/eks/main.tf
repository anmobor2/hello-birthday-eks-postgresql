resource "aws_eks_cluster" "main" {
  name     = var.cluster_name
  version  = var.cluster_version
  role_arn = aws_iam_role.cluster.arn

  vpc_config {
    subnet_ids = var.subnet_ids
  }

  tags = var.tags

  depends_on = [aws_iam_role_policy_attachment.cluster_policy]
}

resource "aws_eks_node_group" "main" {
  for_each = var.eks_managed_node_groups

  cluster_name    = aws_eks_cluster.main.name
  node_group_name = each.key
  node_role_arn   = aws_iam_role.nodes.arn
  subnet_ids      = var.subnet_ids

  instance_types = each.value.instance_types
  scaling_config {
    desired_size = each.value.desired_size
    max_size     = each.value.max_size
    min_size     = each.value.min_size
  }

  tags = merge(var.tags, {
    Name = "${var.cluster_name}-node-group-${each.key}"
  })

  depends_on = [
    aws_iam_role_policy_attachment.nodes_AmazonEKSWorkerNodePolicy,
    aws_iam_role_policy_attachment.nodes_AmazonEKS_CNI_Policy,
    aws_iam_role_policy_attachment.nodes_AmazonEC2ContainerRegistryReadOnly,
  ]
}