variable "vpc_name" {
  description = "Nombre de la VPC."
  type        = string
}

variable "vpc_cidr_block" {
  description = "Bloque CIDR para la VPC."
  type        = string
}

variable "public_subnets_cidr" {
  description = "Lista de bloques CIDR para las subredes públicas."
  type        = list(string)
}

variable "private_subnets_cidr" {
  description = "Lista de bloques CIDR para las subredes privadas."
  type        = list(string)
}

variable "enable_nat_gateway" {
  description = "Habilitar NAT Gateway para las subredes privadas."
  type        = bool
  default     = true
}

variable "tags" {
  description = "Etiquetas comunes para aplicar a todos los recursos."
  type        = map(string)
  default     = {}
}