terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.0"
    }
    docker = {
      source  = "kreuzwerker/docker"
      version = "~> 2.0"
    }
  }
}

locals {
  instance_ami    = "ami-00eb69d236edcfaf8"
  public_key_path = "${path.module}/ticketea-key.pub"
  userdata_path   = "${path.module}/ticketea-userdata.sh"
  aws_region      = "us-east-2"
}

provider "aws" {
  region     = local.aws_region
  access_key = var.aws_access_key
  secret_key = var.aws_secret_key
}

provider "docker" {}