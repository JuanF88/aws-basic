variable "vpc_id" {
  description = "The ID of the VPC where the Security Group will be created"
  type        = string
}

variable "instance_name" {
  description = "Name of the security group"
  type        = string
}


variable "additional_tags" {
  description = "Additional tags to add to the instance"
  type        = map(string)
  default     = {}
}

variable "private_subnets_cidr_blocks" {
  description = "value"
  type        = list(string)
}