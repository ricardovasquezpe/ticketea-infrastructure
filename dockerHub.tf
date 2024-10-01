/*resource "docker_image" "ticketea_backend_image" {
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
}

resource "null_resource" "update_backend_env_file" {
  provisioner "local-exec" {
    command = <<EOT
      echo "\nS3_BUCKET_NAME=${aws_s3_bucket.ticketea_bucket.bucket}" >> ../ticketea-backend/.env
    EOT
  }

  depends_on = [
    aws_s3_bucket.ticketea_bucket
  ]
}*/