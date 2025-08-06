remote_state {
  backend = "s3"
  config = {
    encrypt        = true
    bucket         = "hello-birthday-tfstate-bucket-12345"
    key            = "tf-states/${path_relative_to_include()}/terraform.tfstate"
    region         = "eu-west-1"
    dynamodb_table = "terraform-state-lock"
  }
  generate = {
    path      = "backend.tf"
    if_exists = "overwrite_terragrunt"
  }
}

generate "provider" {
  path      = "provider.tf"
  if_exists = "overwrite_terragrunt"
  contents  = <<EOF
  provider "aws" {
    region = "eu-west-1"
  }
EOF
}