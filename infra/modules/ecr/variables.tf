variable "repository_name" {
  description = "Nombre del repositorio ECR."
  type        = string
}

variable "tags" {
  description = "Etiquetas comunes."
  type        = map(string)
  default     = {}
}