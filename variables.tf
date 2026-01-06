variable "db_username" {
  description = "Usuário master do banco de dados"
  type        = string
  default     = "admin"
}

variable "db_password" {
  description = "Senha master do banco de dados"
  type        = string
  sensitive   = true
  default     = "Staging#1234!"
}

variable "db_name" {
  description = "Nome do database inicial"
  type        = string
  default     = "tech_challenge_fiap"
}

variable "environment" {
  description = "Ambiente de deploy (dev, staging, prod)"
  type        = string
  default     = "staging"
}