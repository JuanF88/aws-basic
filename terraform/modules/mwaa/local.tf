locals {
  #vpc_id             = data.terraform_remote_state.network.outputs.vpc_id
  #private_subnets    = data.terraform_remote_state.network.outputs.private_subnets
  execution_role_arn = var.create_iam_role ? aws_iam_role.mwaa[0].arn : var.execution_role_arn

  source_bucket_arn = var.create_s3_bucket ? aws_s3_bucket.mwaa[0].arn : var.source_bucket_arn


  default_airflow_configuration_options = {
    "logging.logging_level" = "INFO"
  }

  airflow_configuration_options = merge(local.default_airflow_configuration_options, var.airflow_configuration_options)

  iam_role_additional_policies = { for k, v in var.iam_role_additional_policies : k => v if var.create_iam_role }

}