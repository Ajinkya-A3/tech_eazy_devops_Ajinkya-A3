
output "app_url" {
  value = "http://${aws_instance.name.public_ip}"
  
}