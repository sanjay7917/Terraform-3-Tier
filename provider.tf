#Download AWS plugins for Terraform
terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "4.65.0"
    }
  }
}
# Connect AWS account to Terraform
provider "aws" {
  region  = var.region
  profile = var.profile
}