include "root" {
  path = find_in_parent_folders()
}

# Dependemos del clúster EKS para obtener la información del proveedor OIDC.
dependency "eks" {
  config_path = "../../eks/environments/dev"
}

# Usamos nuestro módulo genérico para crear roles de IAM para Service Accounts.
terraform {
  source = "../../../modules/iam-irsa"
}

# La política de permisos que necesita el AWS Load Balancer Controller.
# Esta política está definida por AWS y permite al controller gestionar ALBs,
# Target Groups, Security Groups, etc.
locals {
  policy = file("${get_terragrunt_dir()}/../../iam-policy.json")
}

inputs = {
  role_name                  = "aws-lb-controller-role-dev"
  oidc_provider_arn          = dependency.eks.outputs.oidc_provider_arn
  oidc_provider_url          = dependency.eks.outputs.oidc_provider_url
  k8s_namespace              = "kube-system" # El controller se instala en kube-system
  k8s_service_account_name   = "aws-load-balancer-controller" # Nombre del SA que usará el controller
  policy_json                = local.policy
  tags = {
    Environment = "dev"
    Project     = "HelloBirthday"
  }
}