include "root" {
  path = find_in_parent_folders()
}

dependency "vpc" {
  config_path = "../../vpc/environments/pro"
}

terraform {
  source = "../../../modules/observability"
}

inputs = {
  name_prefix = "hello-birthday-pro"

  grafana_subnet_ids = dependency.vpc.outputs.private_subnets_ids

  grafana_security_group_ids = [dependency.vpc.outputs.default_security_group_id]

  tags = {
    Environment = "production"
    Project     = "HelloBirthday"
  }
}