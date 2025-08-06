include "root" {
  path = find_in_parent_folders()
}

terraform {
  source = "../../../modules/vpc"
}

inputs = {
  vpc_name             = "vpc-pro-birthday"
  vpc_cidr_block       = "10.0.0.0/16"
  public_subnets_cidr  = ["10.0.1.0/24", "10.0.2.0/24"]
  private_subnets_cidr = ["10.0.101.0/24", "10.0.102.0/24"]

  tags = {
    Environment = "production"
    Project     = "HelloBirthday"
  }
}