################################################################################
# MSK Cluster - Default
################################################################################

module "msk_cluster" {
  source  = "terraform-aws-modules/msk-kafka-cluster/aws"
  version = "2.9.0"

  name                   = local.name
  kafka_version          = "3.5.1"
  number_of_broker_nodes = 3

  #broker_node_client_subnets  = module.vpc.private_subnets
  broker_node_client_subnets = var.private_subnets

  broker_node_instance_type   = "kafka.t3.small"
  broker_node_security_groups = [var.security_group_id]

  tags = local.tags
}

################################################################################
# MSK Cluster - Disabled
################################################################################

module "msk_cluster_disabled" {
  source  = "terraform-aws-modules/msk-kafka-cluster/aws"
  version = "2.9.0"

  create = false
}

#IAM principal access to Kubernetes 
resource "kubernetes_config_map" "aws_auth" {
  metadata {
    name      = "aws-auth"
    namespace = "kube-system"
  }

  data = {
    mapUsers = <<EOF
- userarn: arn:aws:iam::677276109682:root
  username: root
  groups:
    - system:masters
EOF
  }
}


resource "aws_iam_role" "eks_admin_role" {
  name = "eks-cluster-admin-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [{
      Action = "sts:AssumeRole",
      Effect = "Allow",
      Principal = {
        Service = "eks.amazonaws.com"
      }
    }]
  })
}

resource "aws_iam_role_policy_attachment" "eks_admin_policy_attachment" {
  role       = aws_iam_role.eks_admin_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSClusterAdminPolicy"
  depends_on = [aws_iam_role.eks_admin_role]
}
