output "vpc_id" {
  value = aws_vpc.main.id
}

output "public_subnet_ids" {
  value = aws_subnet.public[*].id
}

output "private_subnet_ids" {
  value = aws_subnet.private[*].id
}

output "private_subnets_cidr_blocks" {
  value       = [for subnet in aws_subnet.private : subnet.cidr_block]
  description = "CIDR blocks of private subnets"
}

output "public_subnets_cidr_blocks" {
  value       = [for subnet in aws_subnet.public : subnet.cidr_block]
  description = "CIDR blocks of public subnets"
}
