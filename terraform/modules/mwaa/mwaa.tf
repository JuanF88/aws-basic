###################
# MWAA Environment
###################

resource "aws_mwaa_environment" "mwaa" {
  count             = var.create_mwaa_env ? 1 : 0
  name              = "${var.project_name}-${var.infra_component_name}-${var.env}"
  airflow_version   = var.airflow_version
  environment_class = var.environment_class
  min_workers       = var.min_workers
  max_workers       = var.max_workers
  kms_key           = var.kms_key
  dag_s3_path       = var.dag_s3_path

  #plugins_s3_object_version        = var.plugins_s3_object_version
  #plugins_s3_path                  = var.plugins_s3_path
  requirements_s3_path             = var.requirements_s3_path
  requirements_s3_object_version   = var.requirements_s3_object_version
  startup_script_s3_path           = var.startup_script_s3_path
  startup_script_s3_object_version = var.startup_script_s3_object_version
  schedulers                       = var.schedulers
  execution_role_arn               = local.execution_role_arn
  airflow_configuration_options    = local.airflow_configuration_options
  source_bucket_arn                = local.source_bucket_arn
  webserver_access_mode            = var.webserver_access_mode
  weekly_maintenance_window_start  = var.weekly_maintenance_window_start
  tags                             = var.tags

  network_configuration {
    security_group_ids = var.security_group_ids
    subnet_ids         = var.subnet_ids
  }

  logging_configuration {
    dag_processing_logs {
      enabled   = try(var.logging_configuration.dag_processing_logs.enabled, true)
      log_level = try(var.logging_configuration.dag_processing_logs.log_level, "DEBUG")
    }
    scheduler_logs {
      enabled   = try(var.logging_configuration.scheduler_logs.enabled, true)
      log_level = try(var.logging_configuration.scheduler_logs.log_level, "INFO")
    }
    task_logs {
      enabled   = try(var.logging_configuration.task_logs.enabled, true)
      log_level = try(var.logging_configuration.task_logs.log_level, "INFO")
    }
    webserver_logs {
      enabled   = try(var.logging_configuration.webserver_logs.enabled, true)
      log_level = try(var.logging_configuration.webserver_logs.log_level, "ERROR")
    }
    worker_logs {
      enabled   = try(var.logging_configuration.worker_logs.enabled, true)
      log_level = try(var.logging_configuration.worker_logs.log_level, "CRITICAL")
    }
  }

  lifecycle {
    ignore_changes = [
      plugins_s3_object_version, requirements_s3_object_version, startup_script_s3_object_version
    ]
  }
}

###################
# IAM Role
###################
resource "aws_iam_role" "mwaa" {
  count = var.create_iam_role ? 1 : 0

  name                  = "${var.project_name}-executor-${var.env}"
  name_prefix           = null
  description           = "MWAA IAM Role"
  assume_role_policy    = data.aws_iam_policy_document.mwaa_assume.json
  force_detach_policies = var.force_detach_policies
  path                  = var.iam_role_path
  permissions_boundary  = var.iam_role_permissions_boundary

  tags = var.tags
}

resource "aws_iam_role_policy" "mwaa" {
  count = var.create_iam_role ? 1 : 0

  name        = "${var.project_name}-${var.infra_component_name}-policy-${var.env}"
  role        = aws_iam_role.mwaa[0].id
  policy      = data.aws_iam_policy_document.mwaa.json
}

resource "aws_iam_role_policy_attachment" "mwaa" {
  for_each   = local.iam_role_additional_policies
  policy_arn = each.value
  role       = aws_iam_role.mwaa[0].id
}

resource "aws_s3_bucket" "mwaa" {
  count = var.create_s3_bucket ? 1 : 0

  bucket = "${var.project_name}-${var.infra_component_name}-configs-${var.env}"

  tags = var.tags
}

#tfsec:ignore:aws-s3-encryption-customer-key
resource "aws_s3_bucket_server_side_encryption_configuration" "mwaa" {
  count = var.create_s3_bucket ? 1 : 0

  bucket = aws_s3_bucket.mwaa[0].id

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}

resource "aws_s3_bucket_versioning" "mwaa" {
  count = var.create_s3_bucket ? 1 : 0

  bucket = aws_s3_bucket.mwaa[0].id

  versioning_configuration {
    status = "Enabled"
  }
}

resource "aws_s3_bucket_public_access_block" "mwaa" {
  count = var.create_s3_bucket ? 1 : 0

  bucket = aws_s3_bucket.mwaa[0].id

  block_public_acls       = true
  block_public_policy     = true
  restrict_public_buckets = true
  ignore_public_acls      = true
}

###################
# Security Group
###################

# resource "aws_security_group" "mwaa_sg" {
#   count       = var.create_security_group && var.create_mwaa_env ? 1 : 0
#   name        = "${var.project_name}-${var.infra_component_name}-sg-${var.env}"
#   description = "${var.project_name}-${var.infra_component_name}-${var.env}-Security Group"
#   vpc_id      = local.vpc_id
#   tags        = merge(var.tags, { Name = "${var.project_name}-${var.infra_component_name}-sg-${var.env}" })
# }

# resource "aws_security_group_rule" "mwaa_sg_rule" {
#   for_each          = var.create_security_group && var.create_mwaa_env ? { for idx, rule in var.sg_rules : idx => rule } : {}
#   type              = each.value.type
#   protocol          = each.value.protocol
#   from_port         = each.value.from_port
#   to_port           = each.value.to_port
#   cidr_blocks       = each.value.cidr_blocks
#   security_group_id = length(aws_security_group.mwaa_sg) > 0 ? aws_security_group.mwaa_sg[0].id : null
# }


