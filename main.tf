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

resource "aws_key_pair" "ticketea_key" {
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

  # depends_on = [null_resource.push_to_dockerhub]
}

resource "aws_eip" "ticketea_elastic_ip" {
  vpc = false
}

resource "aws_eip_association" "ticketea_elastic_ip_association" {
  instance_id   = aws_instance.ticketea_instance.id
  allocation_id = aws_eip.ticketea_elastic_ip.id
}

/*resource "docker_image" "ticketea_backend_image" {
  name = "${var.dockerhub_username}/${var.dockerhub_project_name_backend}:latest"

  build {
    context = "../ticketea-backend/"
    platform   = "linux/amd64"
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

/*resource "aws_s3_bucket" "ticketea_bucket" {
  bucket = "ticketeabucket"
  acl    = "private"
}*/