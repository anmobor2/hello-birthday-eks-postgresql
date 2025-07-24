output "eks_cluster_id" {
  description = "The ID of the EkS cluster"
  value       = aws_eks_cluster.this.id
}

output "eks_cluster_name" {
  description = "The name of the EkS cluster"
  value       = aws_eks_cluster.this.name
}

output "cloudwatch_log_group_name" {
  description = "The name of the CloudWatch log group"
  value       = aws_cloudwatch_log_group.this.name
}