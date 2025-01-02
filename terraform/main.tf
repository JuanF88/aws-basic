###################
# VPC
###################
module "vpc" {
  source               = "./modules/vpc"
  environment          = local.environment
  public_subnet_count  = 2
  private_subnet_count = 2
  eks_cluster_name     = local.eks_cluster_name
  mks_cluster_name     = local.mks_cluster_name
}

###################
# S3 Security Group
###################
module "security_group_mwaa" {
  source                      = "./modules/securityGroup"
  instance_name               = "mwaa-security-group"
  description                 = "Security group for MWAA"
  vpc_id                      = module.vpc.vpc_id
  private_subnets_cidr_blocks = module.vpc.private_subnets_cidr_blocks
  ingress_rules               = local.mwaa_module.ingress_rules
  egress_rules                = local.mwaa_module.egress_rules
  depends_on                  = [module.vpc]
}


###################
# S3 Bucket
###################
resource "aws_s3_bucket" "mwaa" {
  count = local.create_s3_bucket ? 1 : 0

  bucket = "test-mwaa-configs-dev"

  #tags = var.tags
}


#tfsec:ignore:aws-s3-encryption-customer-key
resource "aws_s3_bucket_server_side_encryption_configuration" "mwaa" {
  count = local.create_s3_bucket ? 1 : 0

  bucket = aws_s3_bucket.mwaa[0].id

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}

resource "aws_s3_bucket_versioning" "mwaa" {
  count = local.create_s3_bucket ? 1 : 0

  bucket = aws_s3_bucket.mwaa[0].id

  versioning_configuration {
    status = "Enabled"
  }
}

resource "aws_s3_bucket_public_access_block" "mwaa" {
  count = local.create_s3_bucket ? 1 : 0

  bucket = aws_s3_bucket.mwaa[0].id

  block_public_acls       = true
  block_public_policy     = true
  restrict_public_buckets = true
  ignore_public_acls      = true
}

module "mwaa"{
  source = "./modules/mwaa"

  security_group_ids = [module.security_group_mwaa.security_group_id]
  subnet_ids = module.vpc.private_subnet_ids

  aws_account_id = "677276109682"
  region = local.region
  env = local.environment
  project_name = "test"
  cloud_provider = "aws"
  infra_component_name  = "mwaa"
  create_mwaa_env       = true
  airflow_version       = "2.10.3"
  environment_class     = "mw1.small"
  webserver_access_mode = "PUBLIC_ONLY"
  min_workers           = 1
  max_workers           = 10
  create_s3_bucket      = true
  dag_s3_path           = "src/"
  source_bucket_arn = aws_s3_bucket.mwaa[0].arn
  #plugins_s3_path       = "plugins.zip"
  requirements_s3_path  = "requirements.txt"
  schedulers            = 2

  #NO INCLUIR ESTA CONFIGURACIÓN!!!! A MENOS QUE SE REQUIERA UN MAYOR PROCESAMIENTO DE LOGS (PUEDE DAR ERRORES DE CONFIGRUACIÓN.
  # logging_configuration = {
  #   dag_processing_logs = {
  #     enabled   = true
  #     log_level = "INFO"
  #   }
  #   scheduler_logs = {
  #     enabled   = true
  #     log_level = "ERROR"
  #   }
  #   task_logs = {
  #     enabled   = true
  #     log_level = "INFO"
  #   }
  #   webserver_logs = {
  #     enabled   = true
  #     log_level = "DEBUG"
  #   }
  #   worker_logs = {
  #     enabled   = true
  #     log_level = "CRITICAL"
  #   }
  # }
  # airflow_configuration_options = {
  #   "webserver.warn_deployment_exposure" = "False",
  #   "core.test_connection"               = "Enabled",
  # }
}

# module "security_group_eks" {
#   source = "./modules/securityGroup"
#   #instance_name               = "Security_group"
#   instance_name               = "ex-terraform-cluster"
#   description                 = "Security group for EKS cluster control plane"
#   vpc_id                      = module.vpc.vpc_id
#   private_subnets_cidr_blocks = module.vpc.private_subnets_cidr_blocks
#   ingress_rules               = local.eks_module.ingress_rules
#   egress_rules                = local.eks_module.egress_rules

#   depends_on = [module.vpc]
# }

# module "security_group_mks" {
#   source                      = "./modules/securityGroup"
#   instance_name               = "Security_group"
#   description                 = "Security group for MKS cluster control plane"
#   vpc_id                      = module.vpc.vpc_id
#   private_subnets_cidr_blocks = module.vpc.private_subnets_cidr_blocks
#   ingress_rules               = local.mks_module.ingress_rules
#   egress_rules                = local.mks_module.egress_rules
#   depends_on                  = [module.vpc]
# }

# module "security_group_worker" {
#   source                      = "./modules/securityGroup"
#   instance_name               = "ex-terraform-worker"
#   description                 = "Security group for EKS worker nodes"
#   vpc_id                      = module.vpc.vpc_id
#   private_subnets_cidr_blocks = module.vpc.private_subnets_cidr_blocks
#   ingress_rules               = local.eks_worker.ingress_rules
#   egress_rules                = local.eks_worker.egress_rules
#   depends_on                  = [module.vpc]
# }

# module "mks" {
#   source                      = "./modules/mks"
#   cluster_name                = local.mks_cluster_name
#   number_of_broker_nodes      = 2
#   instance_type               = "kafka.t3.small"
#   private_subnets_cidr_blocks = module.vpc.private_subnet_ids
#   security_group_id           = module.security_group_mks.security_group_id
#   depends_on                  = [module.security_group_mks]
# }

# module "eks" {
#   source             = "./modules/eks"
#   cluster_name       = local.eks_cluster_name
#   environment        = local.environment
#   vpc_id             = module.vpc.vpc_id
#   private_subnet_ids = module.vpc.private_subnet_ids
#   public_subnet_ids  = module.vpc.public_subnet_ids
#   #ec2_ssh_key_name   = "myLinux"
#   security_group_id = module.security_group_eks.security_group_id
#   eks_cluster_role_arn = module.iam_roles.eks_cluster_role_arn
#   eks_node_role_arn = module.iam_roles.eks_node_role_arn
#   depends_on        = [module.security_group_eks,module.iam_roles]
# }

# module "iam_roles" {
#   source       = "./modules/iam-roles"
#   cluster_name = local.eks_cluster_name
#   environment  = local.environment
# }

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

