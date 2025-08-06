include "root" {
  path = find_in_parent_folders()
}

# Declaramos una dependencia en la VPC de 'dev'. Terragrunt se asegurará de que
# la VPC se aplique primero y nos dará acceso a sus 'outputs'.
dependency "vpc" {
  config_path = "../../vpc/environments/dev"
}

terraform {
  source = "../../../modules/eks"
}

inputs = {
  cluster_name    = "eks-dev-birthday"
  cluster_version = "1.27"

  vpc_id     = dependency.vpc.outputs.vpc_id
  subnet_ids = dependency.vpc.outputs.private_subnets_ids

  eks_managed_node_groups = {
    general = {
      min_size     = 1
      max_size     = 2
      desired_size = 1
      instance_types = ["t3.medium"]
    }
  }

  tags = {
    Environment = "development"
    Project     = "HelloBirthday"
  }
}