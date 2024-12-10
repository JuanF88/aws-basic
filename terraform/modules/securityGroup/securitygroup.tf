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
}

resource "aws_security_group_rule" "allow_http" {
  type              = "ingress"
  from_port         = 80
  to_port           = 80
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.ec2_sg.id
}

resource "aws_security_group_rule" "allow_outbound" {
  type              = "egress"
  from_port         = 0
  to_port           = 0
  protocol          = "-1"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.ec2_sg.id
}
