resource "aws_iam_instance_profile" "test" {
  name = "webapp-profile-${var.env}"
  role = aws_iam_role.ec2_role.name
}


