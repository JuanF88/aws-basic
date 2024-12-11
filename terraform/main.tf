module "vpc" {
  source = "./modules/vpc"
}

module "security_group" {
  source = "./modules/securityGroup"

  instance_name = "asda"
  vpc_id        = module.vpc.vpc_id
  depends_on    = [module.vpc]
}


module "EC2" {
  source        = "./modules/ec2"
  env           = "dev"
  instance_name = "Demo EC2"
  user_data     = file("${path.module}/app1-install.sh")
  additional_tags = {
    "Environment" = "Development"
  }

  security_group_id = module.security_group.security_group_id
  #subnet_id = module.vpc.public_subnets[0]
  depends_on = [module.security_group]

}


