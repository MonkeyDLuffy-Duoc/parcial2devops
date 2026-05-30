#!/bin/bash
# =========================================================================
# Script de aprovisionamiento automático ejecutado al iniciar la instancia EC2
# =========================================================================

# Forzar salida en caso de error
set -e

# Actualizar el índice de paquetes del sistema
echo "Actualizando paquetes del sistema..."
apt-get update -y
apt-get upgrade -y

# Instalar herramientas básicas requeridas
apt-get install -y apt-transport-https ca-certificates curl software-properties-common gnupg lsb-release git

# Configurar el repositorio oficial de Docker
echo "Configurando repositorio de Docker..."
mkdir -p /etc/apt/keyrings
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | gpg --dearmor -o /etc/apt/keyrings/docker.gpg

echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu \
  $(lsb_release -cs) stable" | tee /etc/apt/sources.list.d/docker.list > /dev/null

# Instalar Docker Engine, Docker CLI y el plugin de Docker Compose
echo "Instalando Docker y Docker Compose..."
apt-get update -y
apt-get install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin

# Asegurar que el servicio de Docker esté corriendo y se inicie en cada arranque
systemctl start docker
systemctl enable docker

# IMPORTANTE: Agregar al usuario por defecto 'ubuntu' al grupo 'docker'
# Esto permite que el pipeline de GitHub Actions ejecute comandos de docker compose por SSH sin requerir 'sudo'
echo "Configurando permisos de Docker para el usuario 'ubuntu'..."
usermod -aG docker ubuntu

# Aplicar los cambios reiniciando el socket de docker
systemctl restart docker

# Crear y dar pertenencia a la carpeta de despliegue de la aplicación
echo "Creando carpeta de destino de despliegue en /home/ubuntu/app..."
mkdir -p /home/ubuntu/app
chown -R ubuntu:ubuntu /home/ubuntu/app

echo "Aprovisionamiento completado con éxito!"
