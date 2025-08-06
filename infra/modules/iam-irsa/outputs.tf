output "role_arn" {
  description = "ARN del rol de IAM creado."
  value       = aws_iam_role.irsa.arn
}