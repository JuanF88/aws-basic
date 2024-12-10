module "EC2" {
  source        = "./modules/ec2"
  instance_type = "t3.micro"
  instance_name = "Demo EC2"
  user_data     = file("${path.module}/app1-install.sh")
  additional_tags = {
    "Environment" = "Development"
  }
}
