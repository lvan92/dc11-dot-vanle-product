terraform {
  backend "s3" {
    encrypt        = true
    key            = "product/terraform.tfstate"
    bucket         = "dc11-dot-van-le-networking"
    profile        = "default"
    region         = "us-east-1"
    dynamodb_table = "terraform-state-dynamodb-table-lock"
  }
}

provider "aws" {
  region = "us-east-1"
  profile = "default"
}