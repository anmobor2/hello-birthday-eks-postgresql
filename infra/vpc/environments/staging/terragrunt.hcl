include "root" {
  path = find_in_parent_folders()
}

terraform {
  source = "../../../modules/vpc"
}

inputs = {
  vpc_name             = "vpc-staging-birthday"
  vpc_cidr_block       = "10.1.0.0/16"
  public_subnets_cidr  = ["10.1.1.0/24", "10.1.2.0/24"]
  private_subnets_cidr = ["10.1.101.0/24", "10.1.102.0/24"]

  tags = {
    Environment = "staging"
    Project     = "HelloBirthday"
  }
}