resource "aws_s3_bucket" "logs_bucket" {
  bucket = var.s3_bucket_name
  force_destroy = true # optional: allows TF to destroy non-empty buckets during cleanup
}

resource "aws_s3_bucket_ownership_controls" "logs_bucket" {
  bucket = aws_s3_bucket.logs_bucket.id

  rule {
    object_ownership = "BucketOwnerEnforced"
  }
}

resource "aws_s3_bucket_acl" "logs_bucket" {
  depends_on = [aws_s3_bucket_ownership_controls.logs_bucket] # required
  bucket     = aws_s3_bucket.logs_bucket.id
  acl        = "private"
}

resource "aws_s3_bucket_lifecycle_configuration" "log_cleanup" {
  bucket = aws_s3_bucket.logs_bucket.id

  rule {
    id     = "log-expiry"
    status = "Enabled"

    filter {
      prefix = "logs/"
    }

    expiration {
      days = 7
    }
  }
}
