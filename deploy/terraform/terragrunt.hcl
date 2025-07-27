# Config remota compartida
remote_state {
  backend = "s3"
  config = {
    bucket         = "${get_env("TFSTATE_BUCKET", "default-bucket")}"  # changes by env
    key            = "${path_relative_to_include()}/terraform.tfstate"
    region         = "eu-west-1"
    encrypt        = true
    dynamodb_table = "tf-locks"
  }
}