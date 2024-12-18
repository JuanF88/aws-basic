variable "cluster_name" {
  description = "Name of the EKS cluster"
  type        = string
}

variable "environment" {
  description = "Environment name (e.g., dev, staging, prod)"
  type        = string
}

variable "vpc_id" {
  description = "ID of the VPC where EKS will be deployed"
  type        = string
}

variable "private_subnet_ids" {
  description = "List of private subnet IDs"
  type        = list(string)
}

variable "public_subnet_ids" {
  description = "List of public subnet IDs"
  type        = list(string)
}

variable "security_group_id" {
  description = "security group ID"
  type        = string
}


variable "eks_cluster_role_arn" {
  description = "eks_cluster_role"
  type        = string
}

variable "eks_node_role_arn" {
  description = "eks_node_role"
  type        = string
}

# variable "ec2_ssh_key_name" {
#   description = "Name of the EC2 Key Pair for SSH access to worker nodes"
#   type        = string
# }
