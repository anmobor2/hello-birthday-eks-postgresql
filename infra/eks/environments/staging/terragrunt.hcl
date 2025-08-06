include "root" {
  path = find_in_parent_folders()
}

dependency "vpc" {
  config_path = "../../vpc/environments/staging"
}

terraform {
  source = "../../../modules/eks"
}

inputs = {
  cluster_name    = "eks-staging-birthday"
  cluster_version = "1.27"

  vpc_id     = dependency.vpc.outputs.vpc_id
  subnet_ids = dependency.vpc.outputs.private_subnets_ids

  eks_managed_node_groups = {
    general = {
      min_size     = 2
      max_size     = 3
      desired_size = 2
      instance_types = ["t3.large"]
    }
  }

  tags = {
    Environment = "staging"
    Project     = "HelloBirthday"
  }
}