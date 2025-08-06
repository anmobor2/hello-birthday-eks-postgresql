dependency "eks" {
  config_path = "../../eks/environments/pro"
}

# we depend on the IAM role for the AWS Load Balancer Controller
dependency "iam_lb_controller" {
  config_path = "../../iam-aws-lb-controller/environments/pro"
}

terraform {
  source = "../../../modules/helm-release" # generic module for Helm releases
}

inputs = {
  chart_name        = "aws-load-balancer-controller"
  chart_repository  = "https://aws.github.io/eks-charts"
  chart_version     = "1.5.3"
  release_name      = "aws-load-balancer-controller"
  namespace         = "kube-system"
  cluster_name      = dependency.eks.outputs.cluster_name

  # Valores que se pasarán al Helm chart del controller.
  values = {
    clusterName = dependency.eks.outputs.cluster_name
    serviceAccount = {
      create = true
      name   = "aws-load-balancer-controller"
    }
    # ARN role of the IAM role created in the iam-aws-lb-controller module
    serviceAccount.annotations = {
      "eks.amazonaws.com/role-arn" = dependency.iam_lb_controller.outputs.role_arn
    }
  }
}