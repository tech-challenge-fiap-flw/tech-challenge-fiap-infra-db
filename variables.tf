variable "docdb_username" {
  description = "Usuário master do DocumentDB"
  type        = string
  default     = "docdbadmin"
}

variable "docdb_password" {
  description = "Senha master do DocumentDB"
  type        = string
  sensitive   = true
  default     = "Docdb#1234!"
}

variable "docdb_database" {
  description = "Nome do database do DocumentDB"
  type        = string
  default     = "tech_challenge-${var.environment}"
}

variable "private_subnet_ids" {
  description = "Lista de subnets privadas para o DocumentDB"
  type        = list(string)
  default     = ["subnet-06505d8dbaaa297e9", "subnet-068174308c9776a7b"]
}
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
  default     = "tech_challenge_fiap-${var.environment}"
}

variable "environment" {
  description = "Ambiente de deploy (dev, staging, prod)"
  type        = string
  default     = "staging"
}