provider "aws" {
region = "us-east-1"
}

resource "aws_instance" "example" {
  ami           = "ami-0080e4c5bc078760e"
  instance_type = "t2.micro"
  
  tags = {
   Name = "terraform-example"
  }

}
