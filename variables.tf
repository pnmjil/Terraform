variable "aws_region" {
  description = "The AWS region to deploy the infrastructure."
  type        = string
  default     = "us-east-1"
}

variable "instance_type" {
  description = "The EC2 instance type for the web server."
  type        = string
  default     = "t2.micro"
}

variable "key_name" {
  description = "The name of the existing AWS Key Pair to use for SSH access."
  type        = string
  # IMPORTANT: Replace "my-ssh-key" with the name of a Key Pair you have already created in the specified AWS region.
  default     = "my-ssh-key" 
}

