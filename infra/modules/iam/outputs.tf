output "role_arn" {
  description = "El ARN del rol de IAM creado para GitHub Actions."
  value       = aws_iam_role.github_actions.arn
}