resource "aws_vpc" "main" {
  cidr_block = var.vpc_cidr_block
  enable_dns_support   = true
  enable_dns_hostnames = true

  tags = merge(var.tags, {
    Name = var.vpc_name
  })
}

resource "aws_internet_gateway" "main" {
  vpc_id = aws_vpc.main.id
  tags   = var.tags
}

resource "aws_subnet" "public" {
  count             = length(var.public_subnets_cidr)
  vpc_id            = aws_vpc.main.id
  cidr_block        = var.public_subnets_cidr[count.index]
  availability_zone = data.aws_availability_zones.available.names[count.index]
  map_public_ip_on_launch = true

  tags = merge(var.tags, {
    Name = "${var.vpc_name}-public-subnet-${count.index + 1}"
  })
}

resource "aws_subnet" "private" {
  count             = length(var.private_subnets_cidr)
  vpc_id            = aws_vpc.main.id
  cidr_block        = var.private_subnets_cidr[count.index]
  availability_zone = data.aws_availability_zones.available.names[count.index]

  tags = merge(var.tags, {
    Name = "${var.vpc_name}-private-subnet-${count.index + 1}"
  })
}

resource "aws_eip" "nat" {
  count = var.enable_nat_gateway ? 1 : 0
  domain = "vpc"
  tags   = var.tags
}

resource "aws_nat_gateway" "main" {
  count         = var.enable_nat_gateway ? 1 : 0
  allocation_id = aws_eip.nat[0].id
  subnet_id     = aws_subnet.public[0].id
  tags          = var.tags

  depends_on = [aws_internet_gateway.main]
}

# --- Rutas ---
resource "aws_route_table" "public" {
  vpc_id = aws_vpc.main.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.main.id
  }
  tags = merge(var.tags, { Name = "${var.vpc_name}-public-rt" })
}

resource "aws_route_table" "private" {
  count  = var.enable_nat_gateway ? 1 : 0
  vpc_id = aws_vpc.main.id
  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.main[0].id
  }
  tags = merge(var.tags, { Name = "${var.vpc_name}-private-rt" })
}

# --- Asociaciones de Rutas ---
resource "aws_route_table_association" "public" {
  count          = length(var.public_subnets_cidr)
  subnet_id      = aws_subnet.public[count.index].id
  route_table_id = aws_route_table.public.id
}

resource "aws_route_table_association" "private" {
  count          = var.enable_nat_gateway ? length(var.private_subnets_cidr) : 0
  subnet_id      = aws_subnet.private[count.index].id
  route_table_id = aws_route_table.private[0].id
}

# --- Grupos de Subredes para RDS/Databases ---
resource "aws_db_subnet_group" "default" {
  name       = "${var.vpc_name}-db-subnet-group"
  subnet_ids = aws_subnet.private[*].id
  tags       = var.tags
}

# --- Datos ---
data "aws_availability_zones" "available" {}