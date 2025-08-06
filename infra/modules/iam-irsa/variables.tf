variable "role_name" {
  description = "Nombre del rol de IAM."
  type        = string
}

variable "policy_json" {
  description = "La política de permisos en formato JSON."
  type        = string
}

variable "oidc_provider_arn" {
  description = "ARN del proveedor OIDC del clúster EKS."
  type        = string
}

variable "oidc_provider_url" {
  description = "URL del proveedor OIDC del clúster EKS."
  type        = string
}

variable "k8s_namespace" {
  description = "Namespace de Kubernetes donde reside el Service Account."
  type        = string
}

variable "k8s_service_account_name" {
  description = "Nombre del Service Account de Kubernetes."
  type        = string
}

variable "tags" {
  description = "Etiquetas comunes."
  type        = map(string)
  default     = {}
}