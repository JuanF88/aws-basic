locals {
  eks_cluster_name = "eks-ex-terraform"
  mks_cluster_name = "mks-ex-terraform"
  environment      = "dev"
  region           = "us-east-2"
  create_s3_bucket = true
  mks_module = {
    ingress_rules = [
      {
        name        = "kafka-tcp"
        from_port   = 9092
        to_port     = 9092
        protocol    = "tcp"
        cidr_blocks = ["10.0.0.0/16"]
      },
      {
        name        = "kafka-tls"
        from_port   = 9094
        to_port     = 9094
        protocol    = "tcp"
        cidr_blocks = ["10.0.0.0/16"]
      }
    ]

    egress_rules = [
      {
        name        = "all-outbound"
        from_port   = 0
        to_port     = 0
        protocol    = "-1"
        cidr_blocks = ["0.0.0.0/0"]
      }
    ]
  }

  # Security Group for EKS Cluster Communication
  eks_module = {
    ingress_rules = [
      {
        name        = "tcp-rule"
        from_port   = 443
        to_port     = 443
        protocol    = "tcp"
        cidr_blocks = ["0.0.0.0/0"] # You may restrict this further
      },
      {
        name        = "custom-tcp"
        from_port   = 31662
        to_port     = 31662
        protocol    = "tcp"
        cidr_blocks = ["0.0.0.0/0"] # You may restrict this further
      }
    ]

    egress_rules = [
      {
        name        = "Allow-all"
        from_port   = 0
        to_port     = 0
        protocol    = "-1"
        cidr_blocks = ["0.0.0.0/0"]
      }
    ]
  }

  # Security Group for Worker Nodes
  eks_worker = {
    ingress_rules = [
      {
        name        = "allow_nodes"
        from_port   = 0
        to_port     = 0
        protocol    = "-1"
        cidr_blocks = ["0.0.0.0/0"]
      },
      {
        name        = "Allow SSH access from your IP"
        from_port   = 22
        to_port     = 22
        protocol    = "tcp"
        cidr_blocks = ["186.82.168.205/32"] # Replace with your actual public IP
      },
      {
        name        = "Allow-workers-to-recieve"
        from_port   = 1025
        to_port     = 65535
        protocol    = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
      }
    ]
    egress_rules = [
      {
        name        = "Allow-all"
        from_port   = 0
        to_port     = 0
        protocol    = "-1"
        cidr_blocks = ["0.0.0.0/0"]
      },
      {
        name        = "Allow-cluster-to-worker"
        from_port   = 1025
        to_port     = 65535
        protocol    = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
      }
    ]
  }
  mwaa_module = {
    ingress_rules = [
      {
        name        = "Ingress tcp 433"
        from_port   = 433
        to_port     = 433
        protocol    = "tcp"
        cidr_blocks = ["0.0.0.0/0"] # Replace with your actual public IP
      },
      {
        name        = "Ingress tcp 5432"
        from_port   = 5432
        to_port     = 5432
        protocol    = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
      }
    ]
    egress_rules = [
      {
        name        = "Allow-all"
        from_port   = 0
        to_port     = 0
        protocol    = "-1"
        cidr_blocks = ["0.0.0.0/0"]
      }
    ]
  }
}