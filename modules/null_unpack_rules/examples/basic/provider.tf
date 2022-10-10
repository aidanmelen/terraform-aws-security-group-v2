terraform {
  required_version = ">= 0.13.1"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 3.29"
    }
  }
}

provider "aws" {
  region = var.aws_region

  default_tags {
    tags = {
      Example    = local.name
      GithubRepo = "terraform-aws-security-group"
      GithubOrg  = "aidanmelen"
    }
  }
}
