output "rds_endpoint" {
  description = "O endpoint para conectar no banco de dados"
  value       = aws_db_instance.default.endpoint
}

output "rds_username" {
  value = var.db_username
}