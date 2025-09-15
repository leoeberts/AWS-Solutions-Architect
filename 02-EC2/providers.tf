terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~>6.0"
    }
  }
}


provider "aws" {
  region  = "eu-central-1"
  profile = "terraform-study"
  default_tags {
    tags = {
      ManagedBy = "Terraform"
      Origin    = "Solutions Architect Lab: 02-EC2"
    }
  }
}
