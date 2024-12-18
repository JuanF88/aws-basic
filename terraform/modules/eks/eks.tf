#EKS Cluster
resource "aws_eks_cluster" "eks_cluster" {
  name     = var.cluster_name
  role_arn = var.eks_cluster_role_arn
  access_config {
    authentication_mode = "API_AND_CONFIG_MAP"
  }
  vpc_config {
    subnet_ids         = var.public_subnet_ids
    security_group_ids = [var.security_group_id]
  }

  tags = {
    Environment = var.environment
    Name        = var.cluster_name
  }
}

#EKS Node Group
resource "aws_eks_node_group" "eks_node_group" {
  cluster_name    = aws_eks_cluster.eks_cluster.name
  node_group_name = "${var.cluster_name}-node-group"
  node_role_arn   = var.eks_node_role_arn
  subnet_ids      = var.public_subnet_ids # Use public subnets

  scaling_config {
    desired_size = 1
    max_size     = 1
    min_size     = 1
  }

  instance_types = ["t3.small"]

  # remote_access {
  #   ec2_ssh_key               = var.ec2_ssh_key_name
  #   source_security_group_ids = [aws_security_group.eks_worker_sg.id]
  # }

  tags = {
    Environment = var.environment
    Name        = "${var.cluster_name}-node-group"
  }
}