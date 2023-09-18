terraform {
  backend "s3" {
    encrypt        = true
    key            = "product/terraform.tfstate"
    bucket         = "devops-vanle-terraform-state-s3"
    profile        = "default"
    region         = "us-east-1"
    dynamodb_table = "terraform-state-dynamodb-table-lock"
  }
}

provider "aws" {
  region = "us-east-1"
  profile = "default"
}