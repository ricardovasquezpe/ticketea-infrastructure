/*resource "null_resource" "push_to_dockerhub_frontend" {
  provisioner "local-exec" {
    command = <<-EOT
      docker login -u ${var.dockerhub_username} -p ${var.dockerhub_password} && docker push ${var.dockerhub_username}/${var.dockerhub_project_name_frontend}:latest
    EOT
  }

  depends_on = [docker_image.ticketea_frontend_image]
}

resource "docker_image" "ticketea_frontend_image" {
  name = "${var.dockerhub_username}/${var.dockerhub_project_name_frontend}:latest"

  build {
    context  = "../ticketea-frontend/"
    platform = "linux/amd64"
  }

  depends_on = [null_resource.update_frontend_env_file]
}

resource "null_resource" "update_frontend_env_file" {
  provisioner "local-exec" {
    command = <<EOT
      echo "" >> ../ticketea-frontend/.env
      echo "VITE_API_URL=${aws_eip.ticketea_elastic_ip.public_ip}:3000" >> ../ticketea-frontend/.env
    EOT
  }

  depends_on = [
    aws_eip.ticketea_elastic_ip
  ]
}*/