provider "aws" {
  region = var.region
}

resource "aws_eks_cluster" "this" {
  name     = var.cluster_name
  role_arn = aws_iam_role.eks_cluster.arn

  vpc_config {
    subnet_ids = var.subnet_ids
  }
}

resource "aws_eks_node_group" "this" {
  cluster_name    = aws_eks_cluster.this.name
  node_group_name = "main-group"
  node_role_arn   = aws_iam_role.eks_nodes.arn
  subnet_ids      = var.subnet_ids

  scaling_config {
    desired_size = 3
    max_size     = 3
    min_size     = 3
  }

  labels = {
    role = "app1"
  }

  # Override labels per node (manual step if using self-managed nodes; for managed nodegroups, AWS does not support per-node labels directly,
  # so instead you create separate node groups for each label. For demo: let's do 3 node groups.)
}

resource "aws_eks_node_group" "app1" {
  cluster_name    = aws_eks_cluster.this.name
  node_group_name = "app1"
  node_role_arn   = aws_iam_role.eks_nodes.arn
  subnet_ids      = var.subnet_ids

  scaling_config {
    desired_size = 1
    max_size     = 1
    min_size     = 1
  }

  labels = {
    role = "app1"
  }
}

resource "aws_eks_node_group" "app2" {
  cluster_name    = aws_eks_cluster.this.name
  node_group_name = "app2"
  node_role_arn   = aws_iam_role.eks_nodes.arn
  subnet_ids      = var.subnet_ids

  scaling_config {
    desired_size = 1
    max_size     = 1
    min_size     = 1
  }

  labels = {
    role = "app2"
  }
}

resource "aws_eks_node_group" "app3" {
  cluster_name    = aws_eks_cluster.this.name
  node_group_name = "app3"
  node_role_arn   = aws_iam_role.eks_nodes.arn
  subnet_ids      = var.subnet_ids

  scaling_config {
    desired_size = 1
    max_size     = 1
    min_size     = 1
  }
}

resource "aws_eks_cluster" "this" {
  name     = var.cluster_name
  role_arn = aws_iam_role.eks_cluster.arn

  vpc_config {
    subnet_ids = var.subnet_ids
  }
}

resource "aws_eks_node_group" "this" {
  cluster_name    = aws_eks_cluster.this.name
  node_group_name = "main-group"
  node_role_arn   = aws_iam_role.eks_nodes.arn
  subnet_ids      = var.subnet_ids

  scaling_config {
    desired_size = 3
    max_size     = 3
    min_size     = 3
  }

  labels = {
    role = "app1"
  }

  # Override labels per node (manual step if using self-managed nodes; for managed nodegroups, AWS does not support per-node labels directly,
  # so instead you create separate node groups for each label. For demo: let's do 3 node groups.)
}

resource "aws_eks_node_group" "app1" {
  cluster_name    = aws_eks_cluster.this.name
  node_group_name = "app1"
  node_role_arn   = aws_iam_role.eks_nodes.arn
  subnet_ids      = var.subnet_ids

  scaling_config {
    desired_size = 1
    max_size     = 1
    min_size     = 1
  }

  labels = {
    role = "app1"
  }
}

resource "aws_eks_node_group" "app2" {
  cluster_name    = aws_eks_cluster.this.name
  node_group_name = "app2"
  node_role_arn   = aws_iam_role.eks_nodes.arn
  subnet_ids      = var.subnet_ids

  scaling_config {
    desired_size = 1
    max_size     = 1
    min_size     = 1
  }

  labels = {
    role = "app2"
  }
}

resource "aws_eks_node_group" "app3" {
  cluster_name    = aws_eks_cluster.this.name
  node_group_name = "app3"
  node_role_arn   = aws_iam_role.eks_nodes.arn
  subnet_ids      = var.subnet_ids

  scaling_config {
    desired_size = 1
    max_size     = 1
    min_size     = 1
  }

  labels = {
    role = "app3"
  }
}

resource "aws_cloudwatch_log_group" "this" {
        name = "/aws/eks/${aws_eks_cluster.this.name}/cluster"
        retention_in_days = 7
}