terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~>6.0"
    }
  }
}

provider "aws" {
  profile = "terraform-study"
  region  = "eu-central-1"
  default_tags {
    tags = {
      ManagedBy = "Terraform"
      Origin    = "Solutions Architect Lab: 03-EBS"
    }
  }
}
