# tech-challenge-fiap-infra-db

Infraestrutura de banco de dados na AWS para o Tech Challenge, provisionada com Terraform. Este projeto cria:

- Um cluster Amazon DocumentDB (compatível com MongoDB) com uma instância.
- Uma instância Amazon RDS MySQL 8.0 com grupo de segurança dedicado.
- Backend remoto do Terraform em S3 com lock em DynamoDB.

Veja os arquivos principais: [provider.tf](provider.tf), [main.tf](main.tf), [variables.tf](variables.tf) e [outputs.tf](outputs.tf).

**Aviso de segurança**
- DocumentDB (`27017`) e MySQL (`3306`) estão liberados para `0.0.0.0/0` por padrão e o RDS está `publicly_accessible = true`. Ajuste para sua rede ou VPN antes de aplicar em produção.
- Senhas possuem valores de exemplo em [variables.tf](variables.tf). Substitua via `terraform.tfvars` ou `-var` para evitar exposição.
- Recursos críticos têm `prevent_destroy = true`. Destruição exige remoção consciente dessa proteção.

**Arquitetura**
- DocumentDB: `aws_docdb_subnet_group`, `aws_security_group`, `aws_docdb_cluster`, `aws_docdb_cluster_instance`.
- RDS MySQL: `aws_security_group`, `aws_db_instance`.
- Estado Remoto: `terraform { backend "s3" }` configurado para bucket `tech-challenge-fiap-terraform-state`, chave `tech-challenge-fiap-infra-db/terraform.tfstate` e tabela DynamoDB `tech-challenge-fiap-terraform-locks` na região `us-east-1`.

## Pré-requisitos
- Terraform 1.5+ e AWS CLI configurados.
- Conta AWS com permissões para VPC, Subnets, Security Groups, DocumentDB, RDS, S3 e DynamoDB.
- Backend remoto existente: bucket S3 e tabela DynamoDB conforme [main.tf](main.tf).

## Credenciais AWS
Configure credenciais por perfil ou variáveis de ambiente:

```powershell
# Via variáveis de ambiente
$env:AWS_ACCESS_KEY_ID = "<sua_access_key>"
$env:AWS_SECRET_ACCESS_KEY = "<sua_secret_key>"
$env:AWS_DEFAULT_REGION = "us-east-1"

# Ou via perfil nomeado
aws configure --profile tech-challenge
# Depois, use o perfil com AWS_PROFILE=tech-challenge
```

## Variáveis de entrada
Defina via `terraform.tfvars`, `-var` ou `-var-file`. Principais variáveis (ver [variables.tf](variables.tf)):

- `environment`: ambiente de deploy. Padrão: `staging`.
- `vpc_id`: VPC onde os recursos serão criados. Padrão de exemplo.
- `private_subnet_ids`: subnets privadas para DocumentDB. Padrão de exemplo.
- `docdb_username`: usuário master do DocumentDB. Padrão: `docdbadmin`.
- `docdb_password` (sensível): senha master do DocumentDB. Substitua.
- `db_username`: usuário master do MySQL. Padrão: `admin`.
- `db_password` (sensível): senha master do MySQL. Substitua.
- `db_name`: nome do database inicial. Padrão: `tech_challenge_fiap`.

Exemplo `terraform.tfvars`:

```hcl
environment       = "dev"
vpc_id            = "vpc-xxxxxxxxxxxxxxxxx"
private_subnet_ids = ["subnet-aaa", "subnet-bbb"]
docdb_username    = "docdbadmin"
docdb_password    = "TroqueEstaSenhaSeguro!"
db_username       = "admin"
db_password       = "TroqueEstaSenhaSeguro!"
db_name           = "tech_challenge_fiap"
```

## Como usar

```powershell
# 1) Inicializar o backend e providers
terraform init

# 2) Visualizar o plano com seus valores
terraform plan -var-file=terraform.tfvars

# 3) Aplicar a infraestrutura
terraform apply -var-file=terraform.tfvars

# 4) Consultar os outputs após a criação
terraform output
```

## Outputs
Principais valores exportados (veja [outputs.tf](outputs.tf)):

- `docdb_endpoint`: endpoint do cluster DocumentDB.
- `docdb_username`: usuário configurado do DocumentDB.
- `docdb_password` (sensível): pode ser mascarado na saída.
- `rds_endpoint`: endpoint da instância MySQL.
- `rds_username`: usuário configurado do MySQL.

## Personalizações recomendadas
- Restringir `cidr_blocks` dos Security Groups a ranges confiáveis (VPC, VPN, IPs fixos).
- Tornar o RDS `publicly_accessible = false` e usar subnets privadas e bastion/VPN.
- Ajustar `instance_class` e `allocated_storage` conforme carga esperada.
- Alterar `region` em [provider.tf](provider.tf) se necessário.

## Destruir recursos
Há `prevent_destroy = true` em DocumentDB e RDS. Para destruir conscientemente:

```powershell
# Remova o bloco lifecycle ou ajuste prevent_destroy para false
# Em seguida:
terraform destroy -var-file=terraform.tfvars
```

## Estrutura do projeto
- [provider.tf](provider.tf): provider AWS e versão.
- [main.tf](main.tf): recursos DocumentDB, RDS, SGs e backend remoto.
- [variables.tf](variables.tf): variáveis de configuração.
- [outputs.tf](outputs.tf): endpoints e credenciais expostas.

## Custos e responsabilidade
DocumentDB e RDS geram cobrança contínua. Aplique apenas em contas de teste/produção com budget e alocação apropriados. Desalocar quando não for necessário.

## Solução de problemas
- Falha no backend S3/DynamoDB: crie bucket/tabela nas mesmas configurações e região.
- Acesso negado: verifique credenciais/role, região e permissões IAM.
- Sem acesso ao banco: ajuste Security Groups e verifique rotas/subnets.

