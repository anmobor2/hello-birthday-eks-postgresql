resource "aws_iam_role" "github_actions" {
  name = var.role_name

  # Política de confianza que permite a GitHub Actions asumir este rol.
  # Se filtrará por repositorio y, opcionalmente, por rama.
  assume_role_policy = data.aws_iam_policy_document.github_actions_assume_role.json

  tags = var.tags
}

# --- Política de Permisos ---
resource "aws_iam_policy" "github_actions" {
  name   = "${var.role_name}-policy"
  policy = var.role_policy_json
}

# --- Adjuntar la política al rol ---
resource "aws_iam_role_policy_attachment" "github_actions" {
  role       = aws_iam_role.github_actions.name
  policy_arn = aws_iam_policy.github_actions.arn
}