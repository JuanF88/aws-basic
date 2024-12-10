resource "aws_vpc" "vpcDemo" {
  cidr_block = "10.0.0.0/16"
  tags = {
    Name = "Demo VPC"
  }
}

resource "aws_subnet" "subnetDemo" {
  vpc_id            = aws_vpc.vpcDemo.id
  cidr_block        = "10.0.1.0/24" # Subdivisión del bloque CIDR de la VPC
  tags = {
    Name = "Demo Subnet"
  }
  map_public_ip_on_launch = true
}
