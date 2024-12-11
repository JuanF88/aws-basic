resource "aws_instance" "ec2" {
  for_each      = toset(local.availability_zones)
  ami           = local.ami
  instance_type = var.instance_type_map[var.env]
  user_data     = var.user_data
  tags = merge(
    {
      "Name" = "${var.instance_name}-${each.value}"
    },
    var.additional_tags
  )
  #subnet_id     = var.subnet_id
  availability_zone      = each.key
  vpc_security_group_ids = [var.security_group_id]
}

