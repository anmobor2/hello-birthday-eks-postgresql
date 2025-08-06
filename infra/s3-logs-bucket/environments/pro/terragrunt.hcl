include "root" {
  path = find_in_parent_folders()
}

terraform {
  source = "../../../modules/s3-logs-bucket"
}

inputs = {
  bucket_name = "hello-birthday-logs-pro"
  tags = {
    Environment = "production"
    Project     = "HelloBirthday"
  }
}