include "root" {
  path = find_in_parent_folders()
}

dependency "eks" {
  config_path = "../../eks/environments/staging"
}
dependency "observability" {
  config_path = "../../observability/environments/staging"
}
# --- AÑADIR ESTA DEPENDENCIA ---
dependency "logs_bucket" {
  config_path = "../../s3-logs-bucket/environments/staging"
}

data "aws_caller_identity" "current" {}

terraform {
  source = "../../../modules/iam-irsa"
}

locals {
  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect   = "Allow",
        Action   = "aps:RemoteWrite",
        Resource = "arn:aws:aps:${dependency.eks.outputs.cluster_region}:${data.aws_caller_identity.current.account_id}:workspace/${dependency.observability.outputs.prometheus_workspace_id}"
      },
      # --- AÑADIR ESTA DECLARACIÓN ---
      {
        Effect   = "Allow",
        Action   = "s3:PutObject",
        Resource = "${dependency.logs_bucket.outputs.bucket_arn}/*"
      }
    ]
  })
}

inputs = {
  role_name                  = "adot-collector-role-staging"
  oidc_provider_arn          = dependency.eks.outputs.oidc_provider_arn
  oidc_provider_url          = dependency.eks.outputs.oidc_provider_url
  k8s_namespace              = "default"
  k8s_service_account_name   = "adot-collector-sa"
  policy_json                = local.policy
  tags = {
    Environment = "staging"
    Project     = "HelloBirthday"
  }
}