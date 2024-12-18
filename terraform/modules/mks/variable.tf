variable "security_group_id" {
  description = "The ID of the security group to associate with the MSK cluster brokers."
  type        = string
  validation {
    condition     = length(var.security_group_id) > 0 && substr(var.security_group_id, 0, 3) == "sg-"
    error_message = "The security group ID must start with 'sg-' and cannot be empty."
  }
}


variable "private_subnets_cidr_blocks" {
  description = "List of private subnet CIDR blocks where the MSK brokers will be deployed."
  type        = list(string)
  validation {
    condition     = length(var.private_subnets_cidr_blocks) >= 2
    error_message = "At least two private subnet CIDR blocks are required for high availability."
  }
}

variable "instance_type" {
  description = "The EC2 instance type for the Kafka brokers in the MSK cluster."
  type        = string
  validation {
    condition = contains(
      [
        "kafka.t3.small",
        "kafka.m5.large",
        "kafka.m5.xlarge",
        "kafka.m5.2xlarge",
        "kafka.m5.4xlarge",
        "kafka.m5.8xlarge",
        "kafka.m5.12xlarge",
        "kafka.m5.16xlarge",
        "kafka.m5.24xlarge"
      ], var.instance_type
    )
    error_message = "The instance type must be one of: kafka.t3.small, kafka.m5.large, kafka.m5.xlarge, kafka.m5.2xlarge, kafka.m5.4xlarge, kafka.m5.8xlarge, kafka.m5.12xlarge, kafka.m5.16xlarge, kafka.m5.24xlarge."
  }
}


variable "cluster_name" {
  description = "The name of the MSK cluster."
  type        = string
  validation {
    condition     = length(var.cluster_name) >= 3 && length(var.cluster_name) <= 50
    error_message = "The cluster name must be between 3 and 50 characters long."
  }
}


variable "number_of_broker_nodes" {
  description = "The number of broker nodes in the MSK cluster."
  type        = number
  validation {
    condition     = var.number_of_broker_nodes >= 2
    error_message = "The number of broker nodes must be at least 2 for high availability."
  }
}
