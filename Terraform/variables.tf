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
  type    = string
  default = "dev"
  validation {
    condition     = contains(["dev", "prod"], var.env)
    error_message = "Environment must be 'dev' or 'prod'"
  }
}


variable "script_path" {
  description = "Path to the user data script"
  type        = string
  default     = "../Scripts/user_data.sh"

}

variable "policy_path" {
  description = "Path to the IAM policy JSON file"
  type        = string
  default     = "../policies/ec2_policy.json"

}

variable "s3_bucket_name" {
  type        = string
  description = "Name of the private S3 bucket for logs"

  validation {
    condition     = length(var.s3_bucket_name) > 0
    error_message = "Bucket name must be provided."
  }
}
