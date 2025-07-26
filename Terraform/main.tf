resource "aws_instance" "name" {
  ami                    = var.ami_id
  instance_type          = var.instance_type
  key_name               = var.key_name
  subnet_id              = var.subnet_id
  vpc_security_group_ids = [aws_security_group.web_sg.id]

  tags = {
    "Name" = "techeazy-${var.env}"
    "env"  = var.env
  }

  user_data             = file(var.script_path)
  iam_instance_profile  = aws_iam_instance_profile.test.name
}

resource "aws_security_group" "web_sg" {
  name        = "techeazy-sg-${var.env}"
  description = "Allow HTTP and SSH for ${var.env}"
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
