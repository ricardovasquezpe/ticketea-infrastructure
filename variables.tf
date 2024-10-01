variable "aws_access_key" {
  type      = string
  sensitive = true
}

variable "aws_secret_key" {
  type      = string
  sensitive = true
}

variable "dockerhub_username" {
  type      = string
  sensitive = true
}

variable "dockerhub_password" {
  type      = string
  sensitive = true
}

variable "dockerhub_project_name_backend" {
  type      = string
  sensitive = true
}

variable "s3_bucket_name" {
  type      = string
  sensitive = true
}

variable "dockerhub_project_name_frontend" {
  type      = string
  sensitive = true
}