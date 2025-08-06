include "root" {
  path = find_in_parent_folders()
}

dependency "vpc" {
  config_path = "../../vpc/environments/dev"
}

terraform {
  source = "../../../modules/rds-postgres"
}

inputs = {
  identifier = "rds-dev-birthday"

  engine               = "postgres"
  engine_version       = "15.3"
  family               = "postgres15"
  major_engine_version = "15"
  instance_class       = "db.t3.micro"
  allocated_storage    = 20

  db_name  = "birthdaydb"
  username = "dbadmin"

  db_subnet_group_name = dependency.vpc.outputs.database_subnet_group_name
  vpc_security_group_ids = [dependency.vpc.outputs.default_security_group_id]

  multi_az               = false # No es necesario para dev
  backup_retention_period = 7

  tags = {
    Environment = "development"
    Project     = "HelloBirthday"
  }
}