locals {
  name            = "ex-${basename(path.cwd)}"
  cluster_version = "1.31"
  region          = "us-east-2"

  vpc_cidr = "10.0.0.0/16"

  tags = {
    Test       = local.name
    GithubRepo = "terraform-aws-eks"
    GithubOrg  = "terraform-aws-modules"
  }
}
