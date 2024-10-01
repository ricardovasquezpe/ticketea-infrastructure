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
}

provider "aws" {
  region     = "us-east-2"
  access_key = var.aws_access_key
  secret_key = var.aws_secret_key
}

provider "docker" {}

/*resource "aws_key_pair" "ticketea_key" {
  key_name   = "ticketea_key"
  public_key = file(local.public_key_path)
}

resource "aws_security_group" "ticketea_backend_security_group" {
  name        = "ticketea_backend_security_group"
  description = "Allow traffic"

  ingress {
    from_port   = 3000
    to_port     = 3000
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_instance" "ticketea_instance" {
  ami             = local.instance_ami
  security_groups = [aws_security_group.ticketea_backend_security_group.name]
  instance_type   = "t2.micro"
  key_name        = aws_key_pair.ticketea_key.key_name
  user_data       = file(local.userdata_path)

  depends_on = [null_resource.push_to_dockerhub,
                null_resource.update_backend_env_file]
}

resource "aws_eip" "ticketea_elastic_ip" {
  vpc = false
}

resource "aws_eip_association" "ticketea_elastic_ip_association" {
  instance_id   = aws_instance.ticketea_instance.id
  allocation_id = aws_eip.ticketea_elastic_ip.id
}

resource "docker_image" "ticketea_backend_image" {
  name = "${var.dockerhub_username}/${var.dockerhub_project_name_backend}:latest"

  build {
    context  = "../ticketea-backend/"
    platform = "linux/amd64"
  }
}

resource "null_resource" "push_to_dockerhub" {
  provisioner "local-exec" {
    command = <<-EOT
      docker login -u ${var.dockerhub_username} -p ${var.dockerhub_password} && docker push ${var.dockerhub_username}/${var.dockerhub_project_name_backend}:latest
    EOT
  }

  depends_on = [docker_image.ticketea_backend_image]
}*/

resource "aws_s3_bucket" "ticketea_bucket" {
  bucket = var.s3_bucket_name
}

resource "aws_s3_bucket_acl" "ticketea_bucket_acl" {
    bucket = aws_s3_bucket.ticketea_bucket.id
    acl    = "public-read"
    depends_on = [aws_s3_bucket_ownership_controls.ticketea_bucket_ownership]
}

resource "aws_s3_bucket_ownership_controls" "ticketea_bucket_ownership" {
  bucket = aws_s3_bucket.ticketea_bucket.id
  rule {
    object_ownership = "BucketOwnerPreferred"
  }
  depends_on = [aws_s3_bucket_public_access_block.ticketea_bucket_allow_public_access]
}

resource "aws_s3_bucket_public_access_block" "ticketea_bucket_allow_public_access" {
  bucket = aws_s3_bucket.ticketea_bucket.id

  block_public_acls       = false
  block_public_policy     = false
  ignore_public_acls      = false
  restrict_public_buckets = false
}

resource "aws_s3_bucket_policy" "ticketea_bucket_policy" {
    bucket = aws_s3_bucket.ticketea_bucket.id
    policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Sid = "PublicReadGetObject"
        Principal = "*"
        Action = [
          "s3:GetObject"
        ]
        Effect   = "Allow"
        Resource = [
          "arn:aws:s3:::${var.s3_bucket_name}/public/*"
        ]
      },
    ]
  })
  
  depends_on = [aws_s3_bucket_public_access_block.ticketea_bucket_allow_public_access]
}

/*resource "null_resource" "update_backend_env_file" {
  provisioner "local-exec" {
    command = <<EOT
      echo "\nS3_BUCKET_NAME=${aws_s3_bucket.ticketea_bucket.bucket}" >> ../ticketea-backend/.env
    EOT
  }

  depends_on = [
    aws_s3_bucket.ticketea_bucket
  ]
}*/