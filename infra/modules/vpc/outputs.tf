output "vpc_id" {
  value = aws_vpc.main.id
}

output "public_subnets_ids" {
  value = aws_subnet.public[*].id
}

output "private_subnets_ids" {
  value = aws_subnet.private[*].id
}

output "database_subnet_group_name" {
  value = aws_db_subnet_group.default.name
}

output "default_security_group_id" {
  value = aws_vpc.main.default_security_group_id
}