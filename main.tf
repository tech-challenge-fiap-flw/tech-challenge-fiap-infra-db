terraform {
  backend "s3" {
    bucket         = "tech-challenge-fiap-terraform-state"
    key            = "tech-challenge-fiap-infra-db/terraform.tfstate"
    region         = "us-east-1"
    dynamodb_table = "tech-challenge-fiap-terraform-locks"
    encrypt        = true
  }
}
resource "aws_security_group" "rds_sg" {
  name        = "rds-security-group-${var.environment}"
  description = "Permite acesso ao MySQL (${var.environment})"

  
  ingress {
    from_port   = 3306
    to_port     = 3306
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"] 
  }

  
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}


resource "aws_db_instance" "default" {
  identifier           = "tech-challenge-db-${var.environment}"
  allocated_storage    = 20 
  storage_type         = "gp2"
  engine               = "mysql"
  engine_version       = "8.0" 
  instance_class       = "db.t3.micro"
  
  db_name              = var.db_name
  username             = var.db_username
  password             = var.db_password
  
  parameter_group_name = "default.mysql8.0"
  skip_final_snapshot  = true 
  publicly_accessible  = true 
  vpc_security_group_ids = [aws_security_group.rds_sg.id]

  tags = {
    Environment = var.environment
    Project     = "Tech Challenge"
    Name        = "rds-security-group-${var.environment}"
  }
}