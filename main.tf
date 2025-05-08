provider "aws" {
  region = "us-east-1"
}

resource "aws_s3_bucket" "vulnerable_bucket" {
  bucket = "my-public-vulnerable-bucket-checkov"
  acl    = "public-read"  # ❌ Public ACL
}

resource "aws_s3_bucket_public_access_block" "example" {
  bucket = aws_s3_bucket.vulnerable_bucket.id

  block_public_acls       = false  # ❌ Should be true
  block_public_policy     = false  # ❌ Should be true
  ignore_public_acls      = false  # ❌ Should be true
  restrict_public_buckets = false  # ❌ Should be true
}

resource "aws_s3_bucket_policy" "public_policy" {
  bucket = aws_s3_bucket.vulnerable_bucket.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Sid       = "PublicRead"
        Effect    = "Allow"
        Principal = "*"
        Action    = "s3:GetObject"
        Resource  = "${aws_s3_bucket.vulnerable_bucket.arn}/*"
      }
    ]
  })
}
