variable "cluster_name" {
  type        = string
  description = "Nombre del clúster EKS."
}

variable "cluster_version" {
  type        = string
  description = "Versión de Kubernetes para el clúster."
}

variable "vpc_id" {
  type        = string
  description = "ID de la VPC donde se desplegará el clúster."
}

variable "subnet_ids" {
  type        = list(string)
  description = "Lista de IDs de subredes para el clúster y los nodos."
}

variable "eks_managed_node_groups" {
  type        = any
  description = "Mapa de configuración para los grupos de nodos gestionados."
  default     = {}
}

variable "tags" {
  description = "Etiquetas comunes para aplicar a todos los recursos."
  type        = map(string)
  default     = {}
}