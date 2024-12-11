output "instance_id" {
  description = "The ID of the EC2 instance"
  value       = [for instance in aws_instance.ec2 : instance.id]
}

output "public_ip" {
  description = "The public IP address of the EC2 instance"
  value       = [for instance in aws_instance.ec2 : instance.public_ip]
}

output "private_ip" {
  description = "The private IP address of the EC2 instance"
  value       = [for instance in aws_instance.ec2 : instance.private_ip]
}
