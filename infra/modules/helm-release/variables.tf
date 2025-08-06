variable "release_name" {
  description = "Nombre del release de Helm."
  type        = string
}

variable "chart_repository" {
  description = "URL del repositorio del Helm chart."
  type        = string
}

variable "chart_name" {
  description = "Nombre del chart a instalar."
  type        = string
}

variable "chart_version" {
  description = "Versión del chart a instalar."
  type        = string
}

variable "namespace" {
  description = "Namespace de Kubernetes donde instalar el chart."
  type        = string
}

variable "cluster_name" {
  description = "Nombre del clúster EKS (usado para configurar el provider de Helm)."
  type        = string
}

variable "values" {
  description = "Mapa de valores para pasar al Helm chart."
  type        = map(any)
  default     = {}
}