resource "aws_msk_cluster" "basic_msk" {
  cluster_name           = var.cluster_name
  kafka_version          = local.kafka_version
  number_of_broker_nodes = var.number_of_broker_nodes

  broker_node_group_info {
    instance_type   = var.instance_type
    client_subnets  = var.private_subnets_cidr_blocks
    security_groups = [var.security_group_id]
    storage_info {
      ebs_storage_info {
        volume_size = local.volume_size
      }
    }
  }

  encryption_info {
    encryption_at_rest_kms_key_arn = aws_kms_key.kms.arn
  }

  logging_info {
    broker_logs {
      cloudwatch_logs {
        enabled   = true
        log_group = aws_cloudwatch_log_group.msk_log_group.name
      }
    }
  }
}

resource "aws_kms_key" "kms" {
  description = "KMS key for MSK"
}

resource "aws_cloudwatch_log_group" "msk_log_group" {
  name              = "/aws/msk/ex-terraform"
  retention_in_days = 7
}
