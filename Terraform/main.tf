resource "aws_instance" "name" {
  ami = var.ami_id

  instance_type = var.instance_type
  
  key_name = var.key_name
  
  subnet_id = var.subnet_id
  vpc_security_group_ids = [aws_security_group.web_sg.id]

  tags = {
    "Name" = "techeazy-${var.env}"
    "env" = var.env
    }

  user_data = file(var.script_path)

}


resource "aws_security_group" "web_sg" {
  name        = "sg-techeazy-${var.env}"
  description = "Allow HTTP for ${var.env}"
  vpc_id      = var.vpc_id

  ingress {
    description = "Allow HTTP"
    from_port   = 80
    to_port     = 80
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