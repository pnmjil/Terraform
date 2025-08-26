provider "aws" {
region = "us-east-1"
}

# Security group for the instance.
resource "aws_security_group" "instance" {
 name		= "terraform-example-instance"
 description	= "Allow HTTP on port 8080"


ingress {
  from_port	= 8080
  to_port	= 8080
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
	      nohup busybox httpd -f -p 8080 &
       	      EOF
  
  tags = {
   Name = "terraform-example"
  }

}
