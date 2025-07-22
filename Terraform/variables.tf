variable "region" {
  description = "AWS region to deploy resources"
  type        = string
  default     = "ap-south-2"
  
}

variable "ami_id" {
  description = "AMI ID for the instance"
  type        = string
  
}

variable "instance_type" {
  description = "Type of instance to create"
  type        = string
  
}

variable "key_name" {
  description = "Key pair name for SSH access"
  type        = string
  
}

variable "subnet_id" {
  description = "Subnet ID where the instance will be launched"
  type        = string
  
}

variable "vpc_id" {
  description = "VPC ID where the security group will be created"
  type        = string
  
}

variable "env" {
  description = "Environment tag for the instance"
  type        = string
  default     = "dev"
  
}

variable "script_path" {
  description = "Path to the user data script"
  type        = string
  default     = "${path.module}/../Scripts/user_data.sh"
  
}