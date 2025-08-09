resource "aws_customer_gateway" "onpremise" {
  bgp_asn    = 65000 # ASN estándar para BGP, tu equipo de red te daría el real.
  ip_address = var.onpremise_gateway_ip
  type       = "ipsec.1"

  tags = merge(var.tags, {
    Name = "cgw-onpremise-${var.environment}"
  })
}

resource "aws_vpn_gateway" "aws" {
  vpc_id = var.vpc_id

  tags = merge(var.tags, {
    Name = "vgw-aws-${var.environment}"
  })
}

resource "aws_vpn_connection" "main" {
  vpn_gateway_id      = aws_vpn_gateway.aws.id
  customer_gateway_id = aws_customer_gateway.onpremise.id
  type                = "ipsec.1"
  static_routes_only  = true

  tags = merge(var.tags, {
    Name = "vpn-conn-aws-to-onprem-${var.environment}"
  })
}

resource "aws_vpn_connection_route" "onpremise_route" {
  destination_cidr_block = var.onpremise_network_cidr
  vpn_connection_id      = aws_vpn_connection.main.id
}

resource "aws_route" "to_onpremise" {
  route_table_id         = var.vpc_route_table_id
  destination_cidr_block = var.onpremise_network_cidr
  gateway_id             = aws_vpn_gateway.aws.id
}