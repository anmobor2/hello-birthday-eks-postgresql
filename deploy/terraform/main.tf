# Main Terraform configuration file - Calls all modules

# Networking module - Creates VPC, subnets, and security groups
module "networking" {
  source = "./modules/networking"

  project_name        = var.project_name
  environment         = var.environment
  vpc_cidr            = var.vpc_cidr
  availability_zones  = ["${var.aws_region}a", "${var.aws_region}b"]
  private_subnet_cidrs = var.private_subnet_cidrs
  public_subnet_cidrs  = var.public_subnet_cidrs

  enable_nat_gateway  = var.enable_nat_gateway
  single_nat_gateway  = var.single_nat_gateway
  enable_https        = var.enable_https
  container_port      = var.container_port

  common_tags         = var.common_tags
}

# IAM module - Creates roles and policies
module "iam" {
  source = "./modules/iam"

  project_name       = var.project_name
  environment        = var.environment
  aws_region         = var.aws_region

  enable_secretsmanager = var.enable_secretsmanager
  secretsmanager_resource_pattern = "arn:aws:secretsmanager:${var.aws_region}:*:secret:${var.project_name}-*"

  common_tags        = var.common_tags
}

module "eks" {
  source      = "../modules/eks"
  region      = var.aws_region
  cluster_name = "happybirthday-cluster"
  subnet_ids  = module.networking.private_subnets
}

# Monitoring module - Creates CloudWatch alarms, dashboard, and SNS topics
module "monitoring" {
  source = "./modules/monitoring"

  project_name        = var.project_name
  environment         = var.environment
  aws_region          = var.aws_region

  ecs_cluster_name    = module.eks.eks_cluster_name


  cpu_threshold       = var.cpu_alarm_threshold
  memory_threshold    = var.memory_alarm_threshold
  error_threshold     = var.error_alarm_threshold

  # Alerting
  create_sns_topic    = var.create_alarm_topic
  alarm_email         = var.alarm_email
  enable_enhanced_monitoring = var.enable_enhanced_monitoring

  # Grafana
  enable_grafana      = true
  grafana_admin_user_arns = var.grafana_admin_user_arns

  enable_alb_alarm    = true

  common_tags         = var.common_tags

  depends_on = [module.eks]
}

module "cicd" {
  source = "./modules/cicd"
  count  = var.enable_cicd ? 1 : 0

  project_name              = var.project_name
  environment               = var.environment
  aws_region                = var.aws_region
  github_repository         = var.github_repository
  github_branch             = "main"
  ecr_repository_uri        = var.ecr_repository_url
  task_execution_role_arn   = module.iam.task_execution_role_arn
  task_role_arn             = module.iam.task_role_arn

  common_tags = var.common_tags
}