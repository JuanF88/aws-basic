variable "instance_type" {
  description = "Type of the EC2 instance"
  type        = string
  default     = "t3.micro"

  validation {
    condition     = contains(["t2.micro", "t3.micro", "m5.large", "c5.large"], var.instance_type)
    error_message = "The instance type must be one of the supported EC2 types: t2.micro, t3.micro, m5.large, c5.large."
  }
}

variable "user_data" {
  description = "User data script to initialize the instance"
  type        = string
  default     = ""
}

variable "instance_name" {
  description = "Name tag for the EC2 instance"
  type        = string
}

variable "additional_tags" {
  description = "Additional tags to add to the instance"
  type        = map(string)
  default     = {}
}
