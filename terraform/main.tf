terraform {
  required_version = ">= 1.2.0"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

provider "aws" {
  region = var.aws_region
}

# =========================================================================
# 1. Obtener la última AMI oficial de Ubuntu 22.04 LTS de forma dinámica
# =========================================================================
data "aws_ami" "ubuntu" {
  most_recent = true
  owners      = ["099720109477"] # ID oficial de Canonical (propietarios de Ubuntu)

  filter {
    name     = "name"
    values   = ["ubuntu/images/hvm-ssd/ubuntu-jammy-22.04-amd64-server-*"]
  }

  filter {
    name     = "virtualization-type"
    values   = ["hvm"]
  }
}

# =========================================================================
# 2. Grupo de Seguridad Declarativo (Security Group)
# =========================================================================
resource "aws_security_group" "web_sg" {
  name        = "ep2-devops-security-group"
  description = "Grupo de seguridad creado por Terraform para la Evaluacion Parcial 2"

  # Regla de entrada: SSH (Puerto 22) para permitir acceso SSH al pipeline y administradores
  ingress {
    description      = "Acceso SSH seguro"
    from_port        = 22
    to_port          = 22
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"] # En producción se recomienda limitar a tu IP específica
    ipv6_cidr_blocks = []
  }

  # Regla de entrada: HTTP (Puerto 80) público para el acceso de los clientes al Frontend Nginx
  ingress {
    description      = "Acceso HTTP publico para el Frontend"
    from_port        = 80
    to_port          = 80
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = []
  }

  # Regla de salida: Permitir todo el tráfico saliente (obligatorio para descargar dependencias y levantar contenedores)
  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1" # Todos los protocolos
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  tags = {
    Name = "ep2-security-group"
  }
}

# =========================================================================
# 3. Instancia de Cómputo AWS EC2
# =========================================================================
resource "aws_instance" "app_server" {
  ami           = data.aws_ami.ubuntu.id
  instance_type = var.instance_type
  key_name      = var.key_name

  # Asociar el grupo de seguridad declarativo
  vpc_security_group_ids = [aws_security_group.web_sg.id]

  # Inyectar el script de aprovisionamiento automatizado al arrancar por primera vez
  user_data = file("user_data.sh")

  # Optimizar almacenamiento (8 GB por defecto es suficiente para la capa gratuita)
  root_block_device {
    volume_size           = 8
    volume_type           = "gp3"
    delete_on_termination = true
  }

  tags = {
    Name = var.instance_name
  }
}
