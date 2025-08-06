include "root" {
  path = find_in_parent_folders()
}

dependency "vpc" {
  config_path = "../../vpc/environments/staging"
}

terraform {
  source = "../../../modules/rds-postgres" # <-- CAMBIO: Apunta a un módulo local
}

inputs = {
  identifier = "rds-staging-birthday"

  engine               = "postgres"
  engine_version       = "15.3"
  family               = "postgres15"
  major_engine_version = "15"
  instance_class       = "db.t3.small"
  allocated_storage    = 50

  db_name  = "birthdaydb"
  username = "dbadmin"

  db_subnet_group_name = dependency.vpc.outputs.database_subnet_group_name
  vpc_security_group_ids = [dependency.vpc.outputs.default_security_group_id]

  multi_az               = true
  backup_retention_period = 14

  tags = {
    Environment = "staging"
    Project     = "HelloBirthday"
  }
}