terraform {
  required_version = ">= 1.0.0, < 2.0.0"

  backend "s3" {
    bucket         = "susizhou-picture-storage-terraform-state-backend"
    key            = "1_application.tfstate"
    region         = "eu-west-2"
    dynamodb_table = "terraform_state"
    encrypt        = true
  }
}

provider "aws" {
  region = "eu-west-2"
}

data "aws_caller_identity" "current" {}

locals {
  account_id = data.aws_caller_identity.current.account_id
}
