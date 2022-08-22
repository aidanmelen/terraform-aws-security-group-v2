
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
  region = "us-west-2"

  default_tags {
    tags = {
      Example    = "complete"
      GithubRepo = "terraform-aws-security-group"
      GithubOrg  = "aidanmelen"
    }
  }
}