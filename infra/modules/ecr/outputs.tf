output "repository_url" {
  description = "La URL del repositorio ECR."
  value       = aws_ecr_repository.main.repository_url
}

output "repository_arn" {
  description = "El ARN del repositorio ECR."
  value       = aws_ecr_repository.main.arn
}