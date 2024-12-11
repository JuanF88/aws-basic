module "vpc_awsmodule" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "5.16.0"

  name = local.name
  cidr = local.vpc_cidr

  azs             = local.azs
  private_subnets = ["10.0.1.0/24"]
  public_subnets  = ["10.0.101.0/24"]

  create_database_subnet_group       = true
  create_database_subnet_route_table = true

  #database_subnets    = ["10.0.151.0/24", "10.0.152.0/24"]

  # create_private_nat_gateway_route = true
  # create_database_internet_gateway_route = true

  #   #NAT Gateways
  #   enable_nat_gateway = true
  #   single_nat_gateway = true

  #   #DNS
  #   enable_dns_hostnames = true
  #   enable_dns_support = true

  #   public_subnet_tags = {
  #     Name = "public-subnets"
  #   }
  #   database_subnet_tags = {
  #     Name = "database-subnets"
  #   }
  #   tags = {
  #     owner = "Jose"
  #     Environment = "dev"
  #   }
}