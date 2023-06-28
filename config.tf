terraform {
  required_version = ">=1.4.0"
  required_providers {
    aws = {
        version = ">= 5.5.0"
        source = "hashicorp/aws"
    }
  }
}

provider "aws" {
  region = "us-east-1"
}





