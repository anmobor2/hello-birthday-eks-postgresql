include "root" {
  path = find_in_parent_folders()
}

terraform {
  source = "../../../modules/s3-logs-bucket"
}

inputs = {
  bucket_name = "hello-birthday-logs-staging"
  tags = {
    Environment = "staging"
    Project     = "HelloBirthday"
  }
}