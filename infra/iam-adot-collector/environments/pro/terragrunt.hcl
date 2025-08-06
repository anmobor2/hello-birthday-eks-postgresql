include "root" {
  path = find_in_parent_folders()
}

# Dependencias para obtener datos de otros componentes
dependency "eks" {
  config_path = "../../eks/environments/pro"
}
dependency "observability" {
  config_path = "../../observability/environments/pro"
}

data "aws_caller_identity" "current" {}

terraform {
  source = "../../../modules/iam-irsa"
}

# Política que permite al colector escribir en el workspace de Prometheus
locals {
  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect   = "Allow",
        Action   = "aps:RemoteWrite",
        Resource = "arn:aws:aps:${dependency.eks.outputs.cluster_region}:${data.aws_caller_identity.current.account_id}:workspace/${dependency.observability.outputs.prometheus_workspace_id}"
      }
    ]
  })
}

inputs = {
  role_name                  = "adot-collector-role-pro"
  oidc_provider_arn          = dependency.eks.outputs.oidc_provider_arn
  oidc_provider_url          = dependency.eks.outputs.oidc_provider_url
  k8s_namespace              = "default" # El namespace donde desplegaremos el colector
  k8s_service_account_name   = "adot-collector-sa" # El nombre del service account que usará el colector
  policy_json                = local.policy
  tags = {
    Environment = "production"
    Project     = "HelloBirthday"
  }
}