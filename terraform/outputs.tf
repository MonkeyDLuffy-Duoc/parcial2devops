output "ec2_public_ip" {
  description = "Dirección IP pública asignada a la instancia EC2 por AWS"
  value       = aws_instance.app_server.public_ip
}

output "ssh_connection_command" {
  description = "Comando de terminal sugerido para conectarse por SSH a la instancia"
  value       = "ssh -i <tu-clave.pem> ubuntu@${aws_instance.app_server.public_ip}"
}

output "app_url" {
  description = "Dirección URL para acceder a la aplicación en producción"
  value       = "http://${aws_instance.app_server.public_ip}"
}
