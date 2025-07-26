### S3 Upload-Only Role
resource "aws_iam_role" "s3_upload_only_role" {
  name = "s3-upload-only-role-${var.env}"

  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [{
      Effect = "Allow",
      Principal = {
        Service = "ec2.amazonaws.com"
      },
      Action = "sts:AssumeRole"
    }]
  })
}

# IAM Policy for S3 Upload-Only Role from a JSON file

resource "aws_iam_policy" "s3_upload_only_policy" {
  name = "s3-upload-policy-${var.env}"
  policy = templatefile("${var.policy_path}", {
    bucket_arn = aws_s3_bucket.logs_bucket.arn
  })
}

# Attach the policy to the upload-only role
resource "aws_iam_role_policy_attachment" "upload_policy_attach" {
  role       = aws_iam_role.s3_upload_only_role.name
  policy_arn = aws_iam_policy.s3_upload_only_policy.arn
}

### S3 Read-Only Role (Managed Policy)
resource "aws_iam_role" "s3_readonly_role" {
  name = "s3-readonly-role-${var.env}"

  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [{
      Effect = "Allow",
      Principal = {
        Service = "ec2.amazonaws.com"
      },
      Action = "sts:AssumeRole"
    }]
  })
}

# used the managed policy for read-only access
resource "aws_iam_role_policy_attachment" "readonly_attach" {
  role       = aws_iam_role.s3_readonly_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonS3ReadOnlyAccess"
}
