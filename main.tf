provider "aws" {
region = "us-east-1"
}

# Security group for the instance.
resource "aws_security_group" "instance" {
 name		= "terraform-example-instance"
 description	= "Allow HTTP on port 8080"


ingress {
  from_port	= var.server_port
  to_port	= var.server_port
  protocol	= "tcp"
  cidr_blocks	= ["0.0.0.0/0"]

}

egress {
  from_port 	= 0
  to_port	= 0
  protocol	= "-1"
  cidr_blocks	= ["0.0.0.0/0"]

  }
}

#EC2 instance

resource "aws_instance" "example" {
  ami                      = "ami-0080e4c5bc078760e"
  instance_type            = "t2.micro"
  vpc_security_group_ids   = [aws_security_group.instance.id]	
 
  user_data = <<-EOF
	      #!/bin/bash
	      echo "Hello, World" > index.html
	      nohup busybox httpd -f -p ${var.server_port} &
       	      EOF
  
  tags = {
   Name = "terraform-example"
  }
}


variable "object_example_with_error" {
description = "An example of a structural type in Terraform with an error"
type        = object ({
name        = string
age         = number
tags        = list (string)
enabled     = bool
})

default = {
name    = "value1"
age     = 42
tags    = ["a", "b", "c"]
enabled = "false"
}
}

variable "server_port" {
description = "The port the server will use for HTTP requests"
type        = number
default     = 8080		
}

output "public_ip" {
value	    = aws_instance.example.public_ip
description = "The public IP address of the webserver"
}


