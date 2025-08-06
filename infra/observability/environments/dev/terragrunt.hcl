include "root" {
  path = find_in_parent_folders()
}

# Dependemos de la VPC de 'dev' para obtener las subredes y los security groups
# donde se desplegará el endpoint de Grafana.
dependency "vpc" {
  config_path = "../../vpc/environments/dev"
}

terraform {
  source = "../../../modules/observability"
}

inputs = {
  name_prefix = "hello-birthday-dev"

  # Usamos las subredes privadas para el endpoint de Grafana.
  grafana_subnet_ids = dependency.vpc.outputs.private_subnets_ids

  # NOTA: Es una mejor práctica crear un Security Group específico para Grafana
  # que solo permita el acceso desde IPs de confianza. Por ahora, usamos el SG por defecto.
  grafana_security_group_ids = [dependency.vpc.outputs.default_security_group_id]

  tags = {
    Environment = "development"
    Project     = "HelloBirthday"
  }
}