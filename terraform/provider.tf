terraform {
  # 1. Versão do Terraform e dos Providers (Evita que o código quebre no futuro)
  required_version = ">= 1.5.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0" 
    }
  }

  # 2. Configuração do Backend Remoto (Onde o tfstate ficará guardado)
  backend "s3" {
    bucket         = "zenon-cfg-files" 
    key            = "infra/terraform.tfstate" 
    region         = "us-east-1"
    encrypt        = true
    dynamodb_table = "terraform-lock" 
  }
}

# 3. Configuração do Provedor AWS
provider "aws" {
  region = "us-east-1"

}