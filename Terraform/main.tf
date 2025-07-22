resource "aws_instance" "name" {
  ami = var.ami_id

  instance_type = var.instance_type

  key_name = var.key_name

  subnet_id              = var.subnet_id
  vpc_security_group_ids = [aws_security_group.web_sg.id]

  tags = {
    "Name" = "techeazy-${var.env}"
    "env"  = var.env
  }

  user_data = file(var.script_path)

  iam_instance_profile = aws_iam_instance_profile.test.name

}


resource "aws_security_group" "web_sg" {
  name        = "techeazy-sg-${var.env}"
  description = "Allow HTTP for ${var.env}"
  vpc_id      = var.vpc_id

  ingress {
    description = "Allow HTTP"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "Allow SSH"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_iam_role" "ec2_role" {
  name = "webapp-role-${var.env}"

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

resource "aws_iam_policy" "ec2_policy" {
  name        = "ec2-policy-${var.env}"
  description = "Policy for EC2 instance in ${var.env} environment"
  policy      = file(var.policy_path)

}

resource "aws_iam_role_policy_attachment" "ec2_policy_attachment" {
  role       = aws_iam_role.ec2_role.name
  policy_arn = aws_iam_policy.ec2_policy.arn
}

resource "aws_iam_instance_profile" "test" {
  name = "webapp-profile-${var.env}"
  role = aws_iam_role.ec2_role.name

}