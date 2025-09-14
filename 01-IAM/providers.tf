terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 6.0"
    }
  }
}

provider "aws" {
  region  = var.region
  profile = var.profile
  default_tags {
    tags = {
      ManagedBy = "Terraform"
      Origin    = "Solutions Architect Lab: 01-IAM"
    }
  }
}
