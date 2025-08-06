
resource "helm_release" "main" {
  name       = var.release_name
  repository = var.chart_repository
  chart      = var.chart_name
  version    = var.chart_version
  namespace  = var.namespace

  dynamic "set" {
    for_each = var.values
    content {
      name  = set.key
      value = set.value
    }
  }
}