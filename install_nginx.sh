#!/bin/bash
# Install Nginx and start the service on Amazon Linux 2/Rocky/RHEL
set -e

# Update the system packages
sudo yum update -y

# Install Nginx
sudo amazon-linux-extras install nginx1 -y

# Start the Nginx service
sudo systemctl start nginx

# Enable Nginx to start on boot
sudo systemctl enable nginx

# Create a simple index.html page
echo "<h1>Hello from Terraform and Nginx!</h1>" | sudo tee /usr/share/nginx/html/index.html

