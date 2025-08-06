variable "name_prefix" {
  description = "Prefijo para los nombres de los recursos (ej. 'hello-birthday-pro')."
  type        = string
}

variable "grafana_security_group_ids" {
  description = "Security Groups para el workspace de Grafana."
  type        = list(string)
}

variable "grafana_subnet_ids" {
  description = "Subredes para el workspace de Grafana."
  type        = list(string)
}

variable "tags" {
  description = "Etiquetas comunes."
  type        = map(string)
  default     = {}
}