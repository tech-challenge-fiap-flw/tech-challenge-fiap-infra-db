terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
    mysql = {
      source  = "petoju/mysql"
      version = "~> 3.0"
    }
  }
}

provider "aws" {
  region = "us-east-1"
}

provider "mysql" {
  endpoint = aws_db_instance.default.endpoint
  username = var.db_username
  password = var.db_password
}