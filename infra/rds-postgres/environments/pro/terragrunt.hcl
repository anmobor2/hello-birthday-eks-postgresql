include "root" {
  path = find_in_parent_folders()
}

dependency "vpc" {
  config_path = "../../vpc/environments/pro"
}

terraform {
  source = "../../../modules/rds-postgres" # <-- CAMBIO: Apunta a un módulo local
}

inputs = {
  identifier = "rds-pro-birthday"

  engine               = "postgres"
  engine_version       = "15.3"
  family               = "postgres15"
  major_engine_version = "15"
  instance_class       = "db.m5.large"
  allocated_storage    = 100

  db_name  = "birthdaydb"
  username = "dbadmin"

  db_subnet_group_name = dependency.vpc.outputs.database_subnet_group_name
  vpc_security_group_ids = [dependency.vpc.outputs.default_security_group_id]

  multi_az               = true # Imprescindible para producción
  backup_retention_period = 30
  deletion_protection    = true

  tags = {
    Environment = "production"
    Project     = "HelloBirthday"
  }
}