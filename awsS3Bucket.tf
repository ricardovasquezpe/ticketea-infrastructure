resource "aws_s3_bucket" "ticketea_bucket" {
  bucket = var.s3_bucket_name
}

resource "aws_s3_bucket_acl" "ticketea_bucket_acl" {
  bucket     = aws_s3_bucket.ticketea_bucket.id
  acl        = "public-read"
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
        Sid       = "PublicReadGetObject"
        Principal = "*"
        Action = [
          "s3:GetObject"
        ]
        Effect = "Allow"
        Resource = [
          "arn:aws:s3:::${var.s3_bucket_name}/public/*"
        ]
      },
    ]
  })

  depends_on = [aws_s3_bucket_public_access_block.ticketea_bucket_allow_public_access]
}

resource "aws_iam_user" "ticketea_bucket_user" {
  name = "${var.s3_bucket_name}-user"
}

resource "aws_iam_user_policy" "ticketea_bucket_user_policy" {
  name = "${var.s3_bucket_name}-user-policy"
  user = aws_iam_user.ticketea_bucket_user.name
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action   = ["s3:*"]
        Effect   = "Allow"
        Resource = "*"
      },
    ]
  })
}

resource "aws_iam_access_key" "ticketea_bucket_user_access_key" {
  user = aws_iam_user.ticketea_bucket_user.name
}