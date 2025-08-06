include "root" {
  path = find_in_parent_folders()
}

terraform {
  source = "../../../modules/iam"
}

locals {
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect   = "Allow",
        Action   = "*",
        Resource = "*"
      }
    ]
  })
}

inputs = {
  role_name        = "github-actions-role-pro"
  github_repo      = "mi-usuario/hello-birthday-eks-postgresql"
  role_policy_json = local.policy

  tags = {
    Environment = "production"
    Project     = "HelloBirthday"
  }
}