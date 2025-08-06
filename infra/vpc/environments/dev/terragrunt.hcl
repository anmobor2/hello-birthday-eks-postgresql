include "root" {
  path = find_in_parent_folders()
}

terraform {
  source = "../../../modules/vpc"
}

inputs = {
  vpc_name             = "vpc-dev-birthday"
  vpc_cidr_block       = "10.2.0.0/16"
  public_subnets_cidr  = ["10.2.1.0/24"]
  private_subnets_cidr = ["10.2.101.0/24"]

  tags = {
    Environment = "development"
    Project     = "HelloBirthday"
  }
}