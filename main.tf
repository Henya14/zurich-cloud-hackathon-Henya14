terraform {
  required_version = ">=1.4.0"
  required_providers {
    aws = {
        version = ">= 5.5.0"
        source = "hashicorp/aws"
    }
  }

 /* backend "s3" {
    bucket = "terraform-backend-states"
    encrypt = true
    key = "user_data_process.tfstate"
    region = "us-east-1"
  }*/
}

provider "aws" {
  region = "us-east-1"
}





