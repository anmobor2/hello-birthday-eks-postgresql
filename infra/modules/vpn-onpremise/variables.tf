variable "environment" {
  description = "El entorno (dev, pro) para nombrar recursos."
  type        = string
}

variable "onpremise_gateway_ip" {
  description = "La dirección IP pública del router de la oficina/empresa."
  type        = string
}

variable "onpremise_network_cidr" {
  description = "El rango de red de la oficina/empresa."
  type        = string
}

variable "vpc_id" {
  description = "ID de la VPC en AWS a la que nos conectamos."
  type        = string
}

variable "vpc_route_table_id" {
  description = "ID de la tabla de rutas de la VPC para añadir la ruta a on-premise."
  type        = string
}

variable "tags" {
  description = "Etiquetas comunes."
  type        = map(string)
  default     = {}
}