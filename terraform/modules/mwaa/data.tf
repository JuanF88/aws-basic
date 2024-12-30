data "aws_partition" "current" {}

data "aws_region" "current" {}

data "aws_caller_identity" "current" {}

# ---------------------------------------------------------------------------------------------------------------------
# MWAA Role
# ---------------------------------------------------------------------------------------------------------------------
data "aws_iam_policy_document" "mwaa_assume" {
  statement {
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["airflow.amazonaws.com"]
    }

    principals {
      type        = "Service"
      identifiers = ["airflow-env.amazonaws.com"]
    }

    principals {
      type        = "Service"
      identifiers = ["batch.amazonaws.com"]
    }

    principals {
      type        = "Service"
      identifiers = ["ssm.amazonaws.com"]
    }
    principals {
      type        = "Service"
      identifiers = ["lambda.amazonaws.com"]
    }
    principals {
      type        = "Service"
      identifiers = ["s3.amazonaws.com"]
    }
    dynamic "principals" {
      for_each = var.additional_principal_arns
      content {
        type        = "AWS"
        identifiers = [principals.value]
      }
    }
  }
}
#tfsec:ignore:AWS099
data "aws_iam_policy_document" "mwaa" {
  statement {
    effect = "Allow"
    actions = [
      "airflow:PublishMetrics",
      "airflow:CreateWebLoginToken"
    ]
    resources = [
      "arn:${data.aws_partition.current.id}:airflow:${var.region}:${var.aws_account_id}:environment/${var.project_name}-${var.infra_component_name}-${var.env}"
    ]
  }
  statement {
    effect = "Allow"
    actions = [
      "s3:GetObject*",
      "s3:GetBucket*",
      "s3:List*"
    ]
    resources = [
      var.source_bucket_arn,
      "${var.source_bucket_arn}/*",
      "arn:aws:s3:::${var.project_name}-*-landing-zone-${var.env}",
      "arn:aws:s3:::${var.project_name}-forecast-engine-${var.env}",
      "arn:aws:s3:::xpr-forecast-poc1", # Temporary Hardcoded since it is POC temporary buckets
      "arn:aws:s3:::xpr-forecast-poc1/*",

    ]
  }

  statement {
    effect = "Allow"
    actions = [
      "logs:CreateLogStream",
      "logs:CreateLogGroup",
      "logs:PutLogEvents",
      "logs:GetLogEvents",
      "logs:GetLogRecord",
      "logs:GetLogGroupFields",
      "logs:GetQueryResults"
    ]
    resources = [
      "arn:${data.aws_partition.current.id}:logs:${var.region}:${var.aws_account_id}:log-group:airflow-*"
    ]
  }

  statement {
    effect = "Allow"
    actions = [
      "logs:DescribeLogGroups",
      "cloudwatch:PutMetricData",
      "s3:GetAccountPublicAccessBlock",
      "eks:DescribeCluster"
    ]
    resources = [
      "*"
    ]
  }

  statement {
    effect = "Allow"
    actions = [
      "sqs:ChangeMessageVisibility",
      "sqs:DeleteMessage",
      "sqs:GetQueueAttributes",
      "sqs:GetQueueUrl",
      "sqs:ReceiveMessage",
      "sqs:SendMessage"
    ]
    resources = [
      "arn:${data.aws_partition.current.id}:sqs:${var.region}:*:airflow-celery-*"
    ]
  }

  # See note in https://docs.aws.amazon.com/mwaa/latest/userguide/mwaa-create-role.html
  # if MWAA is using a AWS managed KMS key, we have to give permission to the key in ?? account
  # We don't know what account AWS puts their key in so we use not_resources to grant access to all
  # accounts except for ours
  dynamic "statement" {
    for_each = var.kms_key != null ? [] : [1]
    content {
      effect = "Allow"
      actions = [
        "kms:Decrypt",
        "kms:DescribeKey",
        "kms:GenerateDataKey*",
        "kms:Encrypt"
      ]
      not_resources = [
        "arn:${data.aws_partition.current.id}:kms:*:${var.aws_account_id}:key/*"
      ]
      condition {
        test     = "StringLike"
        variable = "kms:ViaService"

        values = [
          "sqs.${var.region}.amazonaws.com"
        ]
      }
    }
  }

  dynamic "statement" {
    for_each = var.kms_key != null ? [1] : []
    content {
      effect = "Allow"
      actions = [
        "kms:Decrypt",
        "kms:DescribeKey",
        "kms:GenerateDataKey*",
        "kms:Encrypt"
      ]
      resources = [
        var.kms_key
      ]
      condition {
        test     = "StringLike"
        variable = "kms:ViaService"

        values = [
          "sqs.${var.region}.amazonaws.com"
        ]
      }
    }
  }

  statement {
    effect = "Allow"
    actions = [
      "batch:*",
    ]
    resources = [
      "arn:${data.aws_partition.current.id}:batch:*:${var.aws_account_id}:*"
    ]
  }

  statement {
    effect = "Allow"
    actions = [
      "ssm:*"
    ]
    resources = [
      "arn:${data.aws_partition.current.id}:ssm:${var.region}:${var.aws_account_id}:parameter/*"
    ]
  }

  statement {
    effect = "Allow"
    actions = [
      "logs:*"
    ]
    resources = ["arn:${data.aws_partition.current.id}:logs:${var.region}:${var.aws_account_id}:log-group:/aws/lambda/*"]
  }

  statement {
    effect    = "Allow"
    actions   = ["cloudwatch:*"]
    resources = ["arn:${data.aws_partition.current.id}:logs:${var.region}:${var.aws_account_id}:log-group:/aws/lambda/*"]
  }
}