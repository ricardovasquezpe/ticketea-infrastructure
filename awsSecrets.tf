resource "aws_secretsmanager_secret" "ticketea_secrets" {
  name        = "ticketea-secrets"
  description = "Ticketea secrets"

  depends_on = [
    aws_eip.ticketea_elastic_ip,
    aws_s3_bucket.ticketea_bucket,
    aws_iam_access_key.ticketea_bucket_user_access_key
  ]
}

resource "aws_secretsmanager_secret_version" "ticketea_secrets_version" {
  secret_id = aws_secretsmanager_secret.ticketea_secrets.id
  secret_string = jsonencode({
    publicIp = aws_eip.ticketea_elastic_ip.public_ip,
    bucketName = aws_s3_bucket.ticketea_bucket.bucket,
    accessKey = aws_iam_access_key.ticketea_bucket_user_access_key.id,
    accessSecret = aws_iam_access_key.ticketea_bucket_user_access_key.secret,
    region = local.aws_region
  })
}