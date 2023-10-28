terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

# Configure the AWS Provider

provider "aws" {
  region = "ap-south-1"
  access_key = "AKIAVGJZJJFL3B3YEDEU"
  secret_key = "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"

}
