aws_region = "eu-west-1"
project_name = "hello-api"
environment = "dev"

vpc_cidr = "10.0.0.0/16"
private_subnet_cidrs = ["10.0.1.0/24", "10.0.2.0/24"]
public_subnet_cidrs  = ["10.0.101.0/24", "10.0.102.0/24"]
enable_nat_gateway = true
single_nat_gateway = true

ecr_repository_url = "123456789012.dkr.ecr.eu-west-1.amazonaws.com/hello-api"
container_image_tag = "latest"
container_port = 8000
container_cpu = 256
container_memory = 512
desired_count = 1

enable_autoscaling = false
min_capacity = 1
max_capacity = 2
cpu_scaling_target = 70

health_check_path = "/health"
alb_internal = false
enable_deletion_protection = false
enable_https = false
ssl_certificate_arn = ""

domain_name = "hello-api.io"
route53_zone_id = "Z3HELLOAPI5XAMPLE"
create_dns_record = true

cpu_alarm_threshold = 80
memory_alarm_threshold = 80
error_alarm_threshold = 5
create_alarm_topic = true
alarm_email = "dev-team@hello-api.com"
enable_enhanced_monitoring = false

enable_secretsmanager = false
grafana_admin_user_arns = []
waf_web_acl_arn = ""

common_tags = {
  Project     = "hello-api"
  ManagedBy   = "terraform"
  Owner       = "development-team"
  CostCenter  = "dev-12345"
}