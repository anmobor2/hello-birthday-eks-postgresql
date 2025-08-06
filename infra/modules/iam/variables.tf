variable "role_name" {
  description = "Nombre del rol de IAM para GitHub Actions."
  type        = string
}

variable "github_repo" {
  description = "El repositorio de GitHub en formato 'owner/repo' que puede asumir el rol."
  type        = string
}

variable "role_policy_json" {
  description = "La política de permisos en formato JSON para el rol."
  type        = string
}

variable "tags" {
  description = "Etiquetas comunes."
  type        = map(string)
  default     = {}
}