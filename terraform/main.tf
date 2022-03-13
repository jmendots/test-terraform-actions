terraform {
  backend "s3" {
    bucket         = "jmmendoza-tfstate"
    key            = "test-terraform-actions/aws-instance/terraform.tfstate"
    region         = "eu-west-3"
    dynamodb_table = "terraform-state-locking"
    encrypt        = true
  }

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.0"
    }
  }
}

provider "aws" {
  region = "eu-west-3"
}

resource "aws_s3_bucket" "terraform_state" {
  bucket        = "jmmendoza-tfstate" # REPLACE WITH YOUR BUCKET NAME
  force_destroy = true
  versioning {
    enabled = true
  }

  server_side_encryption_configuration {
    rule {
      apply_server_side_encryption_by_default {
        sse_algorithm = "AES256"
      }
    }
  }
}

resource "aws_dynamodb_table" "terraform_locks" {
  name         = "terraform-state-locking"
  billing_mode = "PAY_PER_REQUEST"
  hash_key     = "LockID"
  attribute {
    name = "LockID"
    type = "S"
  }
}

resource "aws_instance" "example" {
  ami           = "ami-06ad2ef8cd7012912"
  instance_type = "t2.micro"
}