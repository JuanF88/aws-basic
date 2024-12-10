resource "aws_instance" "ec2" {
  ami           = local.ami
  instance_type = var.instance_type
  user_data     = var.user_data

  tags = merge(
    {
      "Name" = var.instance_name
    },
    var.additional_tags
  )
  vpc_security_group_ids = [aws_security_group.ec2_sg.id]
}

