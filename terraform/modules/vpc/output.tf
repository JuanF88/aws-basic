output "vpc_id" {
  value = aws_vpc.vpcDemo.id
}

output "subnet_id" {
  description = "The ID of the Demo Subnet"
  value       = aws_subnet.subnetDemo.id
}
