# module "vpc" {
#   source = "./modules/vpc"
#   environment = "dev"
#   public_subnet_count = 2
#   private_subnet_count = 2
#   cluster_name = "ex-terraform"
# }

# module "eks" {
#   source = "./modules/eks"
#   cluster_name       = "ex-terraform"
#   environment        = "dev"
#   vpc_id             = module.vpc.vpc_id
#   private_subnet_ids = module.vpc.private_subnet_ids
#   public_subnet_ids  = module.vpc.public_subnet_ids
#   #ec2_ssh_key_name   = "myLinux"
# }

module "mks" {
  source             = "./modules/mks"
}

# module "security_group" {
#   source = "./modules/securityGroup"

#   instance_name = "asda"
#   vpc_id        = module.vpc.vpc_id
#   depends_on    = [module.vpc]
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

