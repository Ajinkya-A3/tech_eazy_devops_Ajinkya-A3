# Instance profile for EC2 to upload logs to S3 (Write-only access)
resource "aws_iam_instance_profile" "upload_profile" {
  name = "upload-profile-${var.env}"
  role = aws_iam_role.s3_upload_only_role.name
}

# Instance profile for EC2 or external usage to read from S3 (Read-only access)
resource "aws_iam_instance_profile" "readonly_profile" {
  name = "readonly-profile-${var.env}"
  role = aws_iam_role.s3_readonly_role.name
}
