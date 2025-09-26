# Define the AWS Provider
terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 6.7.0"
    }
  }
}

provider "aws" {
  region = var.aws_region
}

# --- Data Lookups (Find Default VPC and Subnets) ---

# 1. Look up the default VPC
data "aws_vpc" "default" {
  default = true
}

# 2. Look up subnets within the default VPC
data "aws_subnets" "default" {
  filter {
    name   = "vpc-id"
    values = [data.aws_vpc.default.id]
  }
}

# --- Security Group (Firewall) ---

# 3. Create a Security Group to allow HTTP (80) and SSH (22) traffic
resource "aws_security_group" "web_sg" {
  name        = "web_server_sg"
  description = "Allow HTTP and SSH inbound traffic"
  vpc_id      = data.aws_vpc.default.id

  # Inbound rule for HTTP (Port 80)
  ingress {
    description = "HTTP from anywhere"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # Inbound rule for SSH (Port 22) - WARNING: Adjust for production use
  ingress {
    description = "SSH from anywhere (0.0.0.0/0 is insecure for production)"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"] 
  }

  # Outbound rule (Allow all traffic out)
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "Web_Server_SG"
  }
}

# --- EC2 Instance (Web Server) ---

# 4. Find the latest Amazon Linux 2 AMI ID for the selected region
data "aws_ami" "amazon_linux" {
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "name"
    # Matches Amazon Linux 2 or 2023 base AMIs
    values = ["al2023-ami-*-x86_64", "amzn2-ami-hvm-*-x86_64-gp2"] 
  }

  filter {
    name   = "state"
    values = ["available"]
  }
}


# 5. Launch the EC2 Instance
resource "aws_instance" "web_server" {
  ami           = data.aws_ami.amazon_linux.id
  instance_type = var.instance_type
  key_name      = var.key_name
  
  # Assign to a random public subnet in the default VPC
  subnet_id     = element(data.aws_subnets.default.ids, 0)

  # Attach the Security Group
  security_groups = [aws_security_group.web_sg.id]

  # Automatically assign a public IP address
  associate_public_ip_address = true

  # User data script to install Nginx
  user_data = file("install_nginx.sh")

  tags = {
    Name        = "ConfigurableWebServer"
    Environment = "Dev"
  }
}

