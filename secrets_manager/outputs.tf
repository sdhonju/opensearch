output "secret_key" {
  description = "Secrets Manager id for db master username"
  value       = aws_secretsmanager_secret.secret_key.id
}

output "secret_key_arn" {
  description = "Secrets Manager ARN"
  value       = aws_secretsmanager_secret.secret_key.arn
}

output "secret_key_name" {
  description = "Secrets Manager name for db master username"
  value       = aws_secretsmanager_secret.secret_key.name
}