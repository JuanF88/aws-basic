##########################
# General for ALL resources
##########################
variable "aws_account_id" {
  type        = string
  description = <<EOT
The ID of the AWS account used for deploying resources.
This ensures the resources are tied to the correct account.
EOT
}

variable "cloud_provider" {
  description = <<EOT
The cloud provider used in resource naming conventions.
This variable is part of the naming convention and will be included in the format <project_name>-<resource_name>-<environment>.
EOT
  type        = string
}

variable "region" {
  type        = string
  description = <<EOT
The AWS region where the resources and underlying MWAA resources will be created.
This determines the geographic location of the deployment.
EOT
}

variable "project_name" {
  type        = string
  description = <<EOT
The name of the project. This value is used as a prefix in resource names to help with identification
and organization across AWS infrastructure.
EOT
}

variable "env" {
  type        = string
  description = <<EOT
The environment to deploy resources to. Common values include "dev", "stage", and "prod".
This helps to separate resources by deployment environment.
EOT
}

variable "infra_component_name" {
  type        = string
  description = <<EOT
The name of the infrastructure component, applied to all resources created as part of this module.
This is used for easier identification and resource grouping.
EOT
}

###################
# MWAA environment
###################

variable "create_mwaa_env" {
  type        = bool
  description = <<EOT
A boolean flag indicating whether to create a Managed Workflows for Apache Airflow (MWAA) environment.
Set to true to create the environment.
EOT
}

variable "airflow_configuration_options" {
  type        = any
  default     = null
  description = <<EOT
 Specifies Apache Airflow override configuration options.
For example, you can customize worker memory or execution timeout.
Refer to AWS documentation for supported options:
https://docs.aws.amazon.com/mwaa/latest/userguide/configuring-env-variables.html#configuring-env-variables-reference.
EOT
}


variable "airflow_version" {
  type        = string
  description = <<EOT
 The version of Apache Airflow to deploy in the MWAA environment.
Defaults to the latest version supported by MWAA.
EOT
}

variable "source_bucket_arn" {
  type        = string
  default     = null
  description = <<EOT
 The Amazon Resource Name (ARN) of the S3 bucket where MWAA resources (e.g., DAGs, plugins) are stored.
Example: arn:aws:s3:::airflow-mybucketname
EOT
}

variable "dag_s3_path" {
  type        = string
  description = <<EOT
 The relative path to the DAG folder on your Amazon S3 storage bucket.
Example: dags.
EOT
}

variable "environment_class" {
  type        = string
  description = <<EOT
 The environment class for the MWAA cluster. Possible options: mw1.small, mw1.medium, mw1.large, mw1.xlarge, mw1.2xlarge.
Defaults to mw1.small. Refer to the AWS Pricing page for cost details.
EOT
  validation {
    condition     = contains(["mw1.small", "mw1.medium", "mw1.large", "mw1.xlarge", "mw1.2xlarge"], var.environment_class)
    error_message = "Invalid input. Accepted values: mw1.small, mw1.medium, mw1.large, mw1.xlarge, mw1.2xlarge."
  }
}

variable "kms_key" {
  type        = string
  default     = null
  description = <<EOT
 The ARN of the KMS key to use for encryption of MWAA resources.
If not specified, AWS-managed KMS key (aws/airflow) will be used.
EOT
}

variable "logging_configuration" {
  type        = any
  default     = null
  description = <<EOT
 Configures Apache Airflow logs to be sent to Amazon CloudWatch Logs for monitoring and troubleshooting.
EOT
}

variable "max_workers" {
  type        = number
  description = <<EOT
 The maximum number of workers that can be automatically scaled up in the MWAA environment.
The value must be between 1 and 25. Defaults to 10.
EOT
  validation {
    condition     = var.max_workers > 0 && var.max_workers < 26
    error_message = "Error: Value must be between 1 and 25."
  }
}

variable "min_workers" {
  type        = number
  description = <<EOT
 The minimum number of workers for the MWAA environment.
Defaults to 1.
EOT
}

variable "plugins_s3_object_version" {
  description = <<EOT
 Specifies the version ID of the `plugins.zip` file stored in your Amazon S3 bucket.
This version ID is automatically assigned by Amazon S3 whenever the file is updated.
Use this variable to ensure that the specific version of the `plugins.zip` file is used for your Apache Airflow environment.

If no value is provided, the latest version of the file will be used by default (set to null).
EOT
  type        = string
  default     = null
}


variable "plugins_s3_path" {
  type        = string
  default     = null
  description = <<EOT
 The relative path to the plugins.zip file on your S3 bucket.
Example: plugins.zip. If specified, plugins_s3_object_version must also be provided.
EOT
}

variable "requirements_s3_object_version" {
  description = " The requirements.txt file version you want to use."
  type        = string
  default     = null
}

variable "requirements_s3_path" {
  type        = string
  default     = null
  description = <<EOT
 The relative path to the requirements.txt file on your S3 bucket.
Example: requirements.txt. If specified, requirements_s3_object_version must also be provided.
EOT
}

variable "startup_script_s3_object_version" {
  description = <<EOT
 Specifies the version ID of the startup shell script stored in your Amazon S3 bucket.
The version ID is automatically assigned by Amazon S3 every time you update the script.
This script is executed as your Apache Airflow environment starts, allowing you to perform custom actions
such as installing dependencies, modifying configuration options, or setting environment variables.

If no value is provided, the latest version of the script will be used by default (set to null).
EOT
  type        = string
  default     = null
}

variable "startup_script_s3_path" {
  description = <<EOT
 Specifies the relative path to the startup shell script in your Amazon S3 bucket.
This script runs during the startup of the Apache Airflow environment, before the Airflow process begins.
It can be used to install additional dependencies, adjust environment configurations, or set custom environment variables.

For example, you can use `scripts/startup.sh` as the path if the script is located in an S3 folder called `scripts`.
If no value is provided, no startup script will be executed (set to null).
EOT
  type        = string
  default     = null
}


variable "schedulers" {
  type        = number
  description = <<EOT
 The number of schedulers to run in the MWAA environment.
For Airflow versions >= 2.0.2, the valid range is 2–5. Defaults to 2.
EOT
}

variable "webserver_access_mode" {
  type        = string
  description = <<EOT
 Specifies whether the webserver should be accessible over the internet or via your VPC.
Accepted values: PRIVATE_ONLY (default), PUBLIC_ONLY.
EOT
  validation {
    condition     = contains(["PRIVATE_ONLY", "PUBLIC_ONLY"], var.webserver_access_mode)
    error_message = "Invalid input. Accepted values: PRIVATE_ONLY, PUBLIC_ONLY."
  }
}

variable "weekly_maintenance_window_start" {
  description = <<EOT
 Specifies the start date and time for the weekly maintenance window for your environment.
The maintenance window is a designated time when updates and maintenance activities are performed on your environment.

The format is "ddd:hh:mm", where:
  - `ddd` is the day of the week (e.g., Mon, Tue, Wed, etc.).
  - `hh:mm` is the hour and minute in UTC time.

For example: "Mon:23:30" sets the maintenance window to start on Monday at 11:30 PM UTC.
If no value is provided, the system will automatically determine a maintenance window (set to null).
EOT
  type        = string
  default     = null
}

variable "tags" {
  description = <<EOT
 A map of key-value pairs to associate with resources created by this module.
Tags provide metadata for organizing and identifying resources, making them easier to manage.

For example:
  {
    "Environment" = "dev",
    "Project"     = "my-project",
    "Owner"       = "team-name"
  }

Default is an empty map, meaning no tags will be applied to the resources unless specified.
EOT
  type        = map(string)
  default     = {}
}


###################
# MWAA IAM Role
###################

variable "create_iam_role" {
  type        = bool
  default     = true
  description = <<EOT
Indicates whether to create a new IAM role for the MWAA environment.
Defaults to true.
EOT
}

variable "additional_principal_arns" {
  description = <<EOT
A list of additional AWS principal ARNs to be added to the IAM role's trust policy.
Each ARN represents an AWS principal (e.g., users, roles, or services) that can assume the IAM role.
EOT
  type        = list(string)
  default     = []
}

variable "iam_role_permissions_boundary" {
  description = <<EOT
 The ARN of the IAM permissions boundary policy to attach to the IAM role.
This restricts the maximum permissions the IAM role can have, even if other policies grant additional permissions.
EOT
  type        = string
  default     = null
}

variable "force_detach_policies" {
  description = <<EOT
 Specifies whether to forcefully detach any existing policies attached to the IAM role before applying new ones.
Set to true to ensure no existing policies interfere with the new configuration.
EOT
  type        = bool
  default     = false
}

variable "iam_role_additional_policies" {
  description = <<EOT
A map of additional IAM policies to attach to the IAM role.
The keys represent the policy names, and the values represent the policy ARNs to be attached to the role.
EOT
  type        = map(string)
  default     = {}
}

variable "iam_role_path" {
  description = <<EOT
 The path for the IAM role.
The path is used to group related IAM roles logically. The default path is "/".
EOT
  type        = string
  default     = "/"
}


variable "execution_role_arn" {
  type        = string
  default     = null
  description = <<EOT
The ARN of the IAM role that MWAA can assume to execute tasks.
Mandatory if `create_iam_role=false`.
EOT
}

###################
# MWAA Network
###################

# variable "create_security_group" {
#   description = <<EOT
# Specifies whether to create a new security group for MWAA.
# Set this to true to create a new security group. If set to false, you must provide existing security group IDs using the `security_group_ids` variable.
# EOT
#   type        = bool
#   default     = true
# }

variable "security_group_ids" {
  description = <<EOT
A list of security group IDs for MWAA.
This is required if `create_security_group` is set to false. Each ID should correspond to an existing security group in your AWS environment.
EOT
  type        = list(string)
  default     = []
}

# variable "sg_rules" {
#   description = <<EOT
# Defines custom security group rules as a list of objects.
# Each rule includes the following fields:
# - type: The type of rule (e.g., "ingress" or "egress").
# - protocol: The protocol for the rule (e.g., "tcp").
# - from_port: The starting port range for the rule.
# - to_port: The ending port range for the rule.
# - cidr_blocks: A list of CIDR blocks that are allowed or denied access.
# EOT
#   type = list(object({
#     type        = string
#     protocol    = string
#     from_port   = number
#     to_port     = number
#     cidr_blocks = list(string)
#   }))
# }

variable "create_s3_bucket" {
  description = <<EOT
Specifies whether to create a new S3 bucket for MWAA.
Provide a string value to name the new bucket or leave it empty if not creating a bucket.
EOT
  type        = string
}

variable "iam_role_name" {
  description = <<EOT
The name of the IAM role to be created for MWAA.
If `execution_role_arn` is specified, this variable is ignored. Use this to define a custom IAM role name for the MWAA environment.
EOT
  type        = string
  default     = null
}

variable "subnet_ids" {
  description = <<EOT
A list of security group IDs for MWAA.
This is required if `create_security_group` is set to false. Each ID should correspond to an existing security group in your AWS environment.
EOT
  type        = list(string)
  default     = []
}