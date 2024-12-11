output "vpc_id" {
  description = "The ID of the VPC"
  value       = module.vpc_awsmodule.vpc_id
}

output "default_security_group_id" {
  description = "The ID of the security group created by default on VPC creation"
  value       = module.vpc_awsmodule.default_security_group_id
}

output "private_subnets" {
  description = "List of IDs of private subnets"
  value       = module.vpc_awsmodule.private_subnets
}

output "public_subnets" {
  description = "List of IDs of public subnets"
  value       = module.vpc_awsmodule.public_subnets
}

# output "subnet_id" {
#   description = "The ID of the Demo Subnet"
#   value       = aws_subnet.subnetDemo.id
# }
