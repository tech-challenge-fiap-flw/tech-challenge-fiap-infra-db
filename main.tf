resource "aws_security_group" "docdb_sg" {
  name        = "docdb-security-group-${var.environment}"
  description = "Permite acesso ao DocumentDB (${var.environment})"
  vpc_id      = var.vpc_id

  ingress {
    from_port   = 27017
    to_port     = 27017
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

resource "aws_docdb_subnet_group" "default" {
  name        = "docdb-subnet-group-${var.environment}"
  subnet_ids  = var.private_subnet_ids
  description = "Subnet group for DocumentDB"
}

resource "aws_docdb_cluster" "default" {
  skip_final_snapshot    = true
  cluster_identifier     = "docdb-cluster-${var.environment}"
  engine                 = "docdb"
  master_username        = var.docdb_username
  master_password        = var.docdb_password
  db_subnet_group_name   = aws_docdb_subnet_group.default.name
  vpc_security_group_ids = [aws_security_group.docdb_sg.id]
}

resource "aws_docdb_cluster_instance" "default" {
  count              = 1
  identifier         = "docdb-instance-${var.environment}-${count.index}"
  cluster_identifier = aws_docdb_cluster.default.id
  instance_class     = "db.t3.medium"
  engine             = "docdb"
}
terraform {
  backend "s3" {
    bucket         = "tech-challenge-fiap-tf-state"
    key            = "tech-challenge-fiap-infra-db/terraform.tfstate"
    region         = "us-east-1"
    dynamodb_table = "tech-challenge-fiap-terraform-locks"
    encrypt        = true
  }
}
resource "aws_security_group" "rds_sg" {
  name        = "rds-security-group-${var.environment}"
  description = "Permite acesso ao MySQL (${var.environment})"
  vpc_id      = var.vpc_id

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
  skip_final_snapshot = true
  identifier          = "tech-challenge-db-${var.environment}"
  allocated_storage   = 20
  storage_type        = "gp2"
  engine              = "mysql"
  engine_version      = "8.0"
  instance_class      = "db.t3.micro"

  username = var.db_username
  password = var.db_password

  parameter_group_name   = "default.mysql8.0"
  publicly_accessible    = true
  vpc_security_group_ids = [aws_security_group.rds_sg.id]

  tags = {
    Environment = var.environment
    Project     = "Tech Challenge"
    Name        = "rds-security-group-${var.environment}"
  }
}

resource "mysql_database" "microservice" {
  for_each = toset(var.microservices)
  name     = "${each.value}_${var.environment}"
}