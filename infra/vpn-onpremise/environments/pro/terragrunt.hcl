include "root" {
  path = find_in_parent_folders()
}

dependency "vpc" {
  config_path = "../../vpc/environments/pro"
}

terraform {
  source = "../../../modules/vpn-onpremise"
}

inputs = {
  environment            = "pro"
  onpremise_gateway_ip   = "203.0.113.42" # company router ip
  onpremise_network_cidr = "192.168.0.0/16" # company network CIDR
  vpc_id                 = dependency.vpc.outputs.vpc_id
  vpc_route_table_id     = dependency.vpc.outputs.public_route_table_id # O la tabla de rutas privada, según la arquitectura

  tags = {
    Environment = "production"
    Project     = "HelloBirthday"
  }
}