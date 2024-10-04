resource "null_resource" "push_to_dockerhub_backend" {
  provisioner "local-exec" {
    command = <<-EOT
      docker login -u ${var.dockerhub_username} -p ${var.dockerhub_password} && docker push ${var.dockerhub_username}/${var.dockerhub_project_name_backend}:latest
    EOT
  }

  depends_on = [docker_image.ticketea_backend_image]
}

resource "docker_image" "ticketea_backend_image" {
  name = "${var.dockerhub_username}/${var.dockerhub_project_name_backend}:latest"

  build {
    context  = "../ticketea-backend/"
    platform = "linux/amd64"
  }

  //depends_on = [null_resource.update_backend_env_file]
}

/*resource "null_resource" "update_backend_env_file" {
  provisioner "local-exec" {
    command = <<EOT
      echo "" >> ../ticketea-backend/.env
      echo "AWS_S3_BUCKET_NAME=${aws_s3_bucket.ticketea_bucket.bucket}" >> ../ticketea-backend/.env
      echo "AWS_ACCESS_KEY=${aws_iam_access_key.ticketea_bucket_user_access_key.id}" >> ../ticketea-backend/.env
      echo "AWS_ACCESS_SECRET=${aws_iam_access_key.ticketea_bucket_user_access_key.secret}" >> ../ticketea-backend/.env
      echo "AWS_S3_REGION=${local.aws_region}" >> ../ticketea-backend/.env
    EOT
  }

  depends_on = [
    aws_s3_bucket.ticketea_bucket,
    aws_iam_access_key.ticketea_bucket_user_access_key
  ]
}*/