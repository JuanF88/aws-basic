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

# Reglas dinámicas de ingreso
resource "aws_security_group_rule" "ingress_rules" {
  for_each          = { for rule in var.ingress_rules : rule["name"] => rule }
  type              = "ingress"
  from_port         = each.value["from_port"]
  to_port           = each.value["to_port"]
  protocol          = each.value["protocol"]
  cidr_blocks       = each.value["cidr_blocks"]
  security_group_id = aws_security_group.ec2_sg.id
}

# Reglas dinámicas de salida
resource "aws_security_group_rule" "egress_rules" {
  for_each          = { for rule in var.egress_rules : rule["name"] => rule }
  type              = "egress"
  from_port         = each.value["from_port"]
  to_port           = each.value["to_port"]
  protocol          = each.value["protocol"]
  cidr_blocks       = each.value["cidr_blocks"]
  security_group_id = aws_security_group.ec2_sg.id
}
