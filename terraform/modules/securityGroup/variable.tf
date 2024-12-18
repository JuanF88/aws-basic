variable "vpc_id" {
  description = "The ID of the VPC where the Security Group will be created"
  type        = string
}

variable "instance_name" {
  description = "Name of the security group"
  type        = string
}

variable "description" {
  description = "Description"
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

variable "ingress_rules" {
  description = "Lista de reglas de ingreso para el security group"
  type = list(object({
    name        = string
    from_port   = number
    to_port     = number
    protocol    = string
    cidr_blocks = list(string)
  }))
  default = []
}

variable "egress_rules" {
  description = "Lista de reglas de salida para el security group"
  type = list(object({
    name        = string
    from_port   = number
    to_port     = number
    protocol    = string
    cidr_blocks = list(string)
  }))
  default = []
}
