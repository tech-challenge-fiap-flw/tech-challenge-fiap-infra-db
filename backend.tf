terraform {
  backend "s3" {
    bucket = "tech-challenge-terraform-state"
    key    = "terraform.tfstate"
    region = "us-east-1"
  }
}