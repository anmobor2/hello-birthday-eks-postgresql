output "prometheus_workspace_id" {
  value = aws_prometheus_workspace.amp.id
}

output "prometheus_endpoint" {
  value = aws_prometheus_workspace.amp.prometheus_endpoint
}

output "grafana_workspace_id" {
  value = aws_grafana_workspace.amg.id
}

output "grafana_endpoint" {
  value = aws_grafana_workspace.amg.endpoint
}