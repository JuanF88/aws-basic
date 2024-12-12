locals {
  ami    = "ami-0c80e2b6ccb9ad6d1"
  azs    = ["us-east-2a"]
  name   = "ex-${basename(path.cwd)}"
  region = "us-east-2"
  vpc_cidr = "10.0.0.0/16"

  tags = {
    Example    = local.name
    GithubRepo = "terraform-aws-msk-kafka-cluster"
    GithubOrg  = "terraform-aws-modules"
  }
}
