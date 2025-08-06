include "root" {
  path = find_in_parent_folders()
}

terraform {
  source = "../../../modules/ecr"
}

inputs = {
  repository_name = "hello-birthday-dev"

  tags = {
    Environment = "development"
    Project     = "HelloBirthday"
  }
}