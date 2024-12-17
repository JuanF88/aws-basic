resource "aws_security_group" "ec2_sg" {
  name        = "${var.instance_name}-sg"
  description = var.instance_name
  vpc_id      = var.vpc_id

  tags = merge(
    {
      "Name" = "${var.instance_name}-sg"
    },
    var.additional_tags
  )

  lifecycle {
    ignore_changes = [ingress, egress]
  }
}


# Reglas de ingreso para Kafka (TCP y TLS)
resource "aws_security_group_rule" "allow_kafka_tcp" {
  type              = "ingress"
  from_port         = 9092
  to_port           = 9092
  protocol          = "tcp"
  cidr_blocks       = var.private_subnets_cidr_blocks # Asegúrate de pasar este valor como variable
  security_group_id = aws_security_group.ec2_sg.id
  # tags = {
  #   Name = "${var.instance_name}-kafka-tcp"
  # }
}

resource "aws_security_group_rule" "allow_kafka_tls" {
  type              = "ingress"
  from_port         = 9094
  to_port           = 9094
  protocol          = "tcp"
  cidr_blocks       = var.private_subnets_cidr_blocks
  security_group_id = aws_security_group.ec2_sg.id
  # tags = {
  #   Name = "${var.instance_name}-kafka-tls"
  # }
}

# Reglas de salida (mantener regla genérica de salida)
resource "aws_security_group_rule" "allow_outbound" {
  type              = "egress"
  from_port         = 0
  to_port           = 0
  protocol          = "-1"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.ec2_sg.id
}

resource "aws_security_group_rule" "allow_worker_nodes" {
  type              = "ingress"
  from_port         = 443
  to_port           = 443
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.ec2_sg.id
  # tags = {
  #   Name = "${var.instance_name}-kafka-tls"
  # }
}
