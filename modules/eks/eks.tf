locals {
  cluster_name = var.cluster_name
}

# EKS Cluster
resource "aws_eks_cluster" "this" {
  name     = local.cluster_name
  role_arn = var.cluster_role_arn

  vpc_config {
    subnet_ids = var.subnet_ids
  }

  depends_on = [var.cluster_dependencies]
}

# Worker Node Group
resource "aws_eks_node_group" "node_group" {
  cluster_name    = aws_eks_cluster.this.name
  node_group_name = "${local.cluster_name}-nodes"
  node_role_arn   = var.node_role_arn
  subnet_ids      = var.subnet_ids

  scaling_config {
    desired_size = 2
    max_size     = 4
    min_size     = 2
  }

  instance_types = ["t3.small", "t3.micro", "t2.micro"]
}
