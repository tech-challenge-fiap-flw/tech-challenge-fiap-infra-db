output "docdb_endpoint" {
  description = "Endpoint do cluster DocumentDB"
  value       = aws_docdb_cluster.default.endpoint
}

output "docdb_username" {
  value = var.docdb_username
}

output "docdb_password" {
  value     = var.docdb_password
  sensitive = true
}

output "rds_endpoint" {
  description = "O endpoint para conectar no banco de dados"
  value       = aws_db_instance.default.endpoint
}

output "rds_username" {
  value = var.db_username
}