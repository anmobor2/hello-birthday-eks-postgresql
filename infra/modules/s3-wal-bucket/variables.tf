variable "bucket_name" {
  description = "Nombre del bucket S3 para los WAL."
  type        = string
}

variable "tags" {
  description = "Etiquetas comunes."
  type        = map(string)
  default     = {}
}