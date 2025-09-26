output "web_server_public_ip" {
  description = "The public IP address of the deployed web server."
  value       = aws_instance.web_server.public_ip
}

output "web_server_url" {
  description = "The URL to access the deployed web server."
  value       = "http://${aws_instance.web_server.public_dns}"
}

