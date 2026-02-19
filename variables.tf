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

variable "private_subnet_ids" {
  description = "Lista de subnets privadas para o DocumentDB"
  type        = list(string)
  default     = ["subnet-008a8a1b03054cbca", "subnet-074e7ffb9ef9650bb"]
}

variable "vpc_id" {
  description = "ID da VPC onde os recursos serão criados"
  type        = string
  default     = "vpc-001ded259b3d2d65a"
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
  default     = "tech_challenge_fiap"
}

variable "environment" {
  description = "Ambiente de deploy (dev, staging, prod)"
  type        = string
  default     = "staging"
}

variable "microservices" {
  description = "Lista de microsserviços que terão banco de dados próprio"
  type        = list(string)
  default     = ["os_service", "billing_service", "execution_service"]
}