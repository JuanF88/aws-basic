# variable "vpc_id" {
#   description = "ID of the VPC where EKS will be deployed"
#   type        = string
# }

# variable "private_subnet_ids" {
#   description = "List of private subnet IDs"
#   type        = list(string)
# }

# variable "public_subnet_ids" {
#   description = "List of public subnet IDs"
#   type        = list(string)
# }

variable "private_subnets_cidr_blocks" {
  description = "value"
  type        = list(string)
}

variable "private_subnets" {
  description = "value"
  type        = list(string)
}

variable "vpc_id" {
  description = "value"
  type        = string
}
variable "security_group_id" {
  description = "value"
  type        = string
}