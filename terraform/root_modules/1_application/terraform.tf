terraform {
  backend "s3" {
    bucket         = "susizhou-picture-storage-terraform-state-backend"
    key            = "1_application.tfstate"
    region         = "eu-west-2"
    dynamodb_table = "terraform_state"
    encrypt        = true
  }
}

terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.0"
    }
  }
  required_version = ">=1.4.4"
}

data "aws_caller_identity" "current" {}

locals {
  account_id = data.aws_caller_identity.current.account_id
}
