module "vpc" {
  source               = "./modules/vpc"
  environment          = local.environment
  public_subnet_count  = 2
  private_subnet_count = 2
  eks_cluster_name     = local.eks_cluster_name
  mks_cluster_name     = local.mks_cluster_name
}

module "security_group_eks" {
  source = "./modules/securityGroup"
  #instance_name               = "Security_group"
  instance_name               = "ex-terraform-cluster"
  description                 = "Security group for EKS cluster control plane"
  vpc_id                      = module.vpc.vpc_id
  private_subnets_cidr_blocks = module.vpc.private_subnets_cidr_blocks
  ingress_rules               = local.eks_module.ingress_rules
  egress_rules                = local.eks_module.egress_rules

  depends_on = [module.vpc]
}

module "security_group_mks" {
  source                      = "./modules/securityGroup"
  instance_name               = "Security_group"
  description                 = "Security group for MKS cluster control plane"
  vpc_id                      = module.vpc.vpc_id
  private_subnets_cidr_blocks = module.vpc.private_subnets_cidr_blocks
  ingress_rules               = local.mks_module.ingress_rules
  egress_rules                = local.mks_module.egress_rules
  depends_on                  = [module.vpc]
}

module "security_group_worker" {
  source                      = "./modules/securityGroup"
  instance_name               = "ex-terraform-worker"
  description                 = "Security group for EKS worker nodes"
  vpc_id                      = module.vpc.vpc_id
  private_subnets_cidr_blocks = module.vpc.private_subnets_cidr_blocks
  ingress_rules               = local.eks_worker.ingress_rules
  egress_rules                = local.eks_worker.egress_rules
  depends_on                  = [module.vpc]
}

module "mks" {
  source                      = "./modules/mks"
  cluster_name                = local.mks_cluster_name
  number_of_broker_nodes      = 2
  instance_type               = "kafka.t3.small"
  private_subnets_cidr_blocks = module.vpc.private_subnet_ids
  security_group_id           = module.security_group_mks.security_group_id
  depends_on                  = [module.security_group_mks]
}

module "eks" {
  source             = "./modules/eks"
  cluster_name       = local.eks_cluster_name
  environment        = local.environment
  vpc_id             = module.vpc.vpc_id
  private_subnet_ids = module.vpc.private_subnet_ids
  public_subnet_ids  = module.vpc.public_subnet_ids
  #ec2_ssh_key_name   = "myLinux"
  security_group_id = module.security_group_eks.security_group_id
  eks_cluster_role_arn = module.iam_roles.eks_cluster_role_arn
  eks_node_role_arn = module.iam_roles.eks_node_role_arn
  depends_on        = [module.security_group_eks,module.iam_roles]
}

module "iam_roles" {
  source       = "./modules/iam-roles"
  cluster_name = local.eks_cluster_name
  environment  = local.environment
}

# module "EC2" {
#   source        = "./modules/ec2"
#   env           = "dev"
#   instance_name = "Demo EC2"
#   user_data     = file("${path.module}/app1-install.sh")
#   additional_tags = {
#     "Environment" = "Development"
#   }

#   security_group_id = module.security_group.security_group_id
#   #subnet_id = module.vpc.public_subnets[0]
#   depends_on = [module.security_group]

# }ec2_ssh_key_name

