# --- Amazon Managed Service for Prometheus (AMP) ---
resource "aws_prometheus_workspace" "amp" {
  alias = "${var.name_prefix}-amp-ws"
  tags  = var.tags
}

# --- Amazon Managed Grafana (AMG) ---
resource "aws_grafana_workspace" "amg" {
  account_access_type      = "CURRENT_ACCOUNT"
  authentication_providers = ["AWS_SSO"]
  permission_type          = "SERVICE_MANAGED"

  name                     = "${var.name_prefix}-amg-ws"
  role_arn                 = aws_iam_role.grafana_workspace.arn

  vpc_configuration {
    security_group_ids = var.grafana_security_group_ids
    subnet_ids         = var.grafana_subnet_ids
  }

  tags = var.tags
}

# --- IAM Role para que Grafana pueda acceder a los datos ---
resource "aws_iam_role" "grafana_workspace" {
  name = "${var.name_prefix}-amg-role"
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Action = "sts:AssumeRole"
      Effect = "Allow"
      Principal = {
        Service = "grafana.amazonaws.com"
      }
    }]
  })
}

# --- Política para que Grafana pueda leer de Prometheus y X-Ray ---
resource "aws_iam_role_policy" "grafana_read_policy" {
  name = "${var.name_prefix}-amg-read-policy"
  role = aws_iam_role.grafana_workspace.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect   = "Allow"
        Action   = [
          "aps:ListWorkspaces",
          "aps:DescribeWorkspace",
          "aps:QueryMetrics",
          "aps:GetLabels",
          "aps:GetSeries",
          "aps:GetMetricMetadata"
        ]
        Resource = "*"
      },
      {
        Effect   = "Allow"
        Action   = [
          "xray:GetServiceGraph",
          "xray:GetTraceSummaries",
          "xray:BatchGetTraces"
        ]
        Resource = "*"
      }
    ]
  })
}