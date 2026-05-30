variable "aws_region" {
  description = "Región de AWS donde se desplegará la infraestructura"
  type        = string
  default     = "us-east-1"
}

variable "instance_type" {
  description = "Tipo de instancia de EC2"
  type        = string
  default     = "t2.micro" # Elegible para la Capa Gratuita de AWS
}

variable "key_name" {
  description = "Nombre de la clave SSH existente en tu cuenta de AWS (Key Pair) para conectarse por SSH"
  type        = string
  default     = "isy1101-key" # Reemplaza con el nombre de tu Key Pair en la consola de AWS
}

variable "instance_name" {
  description = "Nombre de la etiqueta para identificar la instancia EC2"
  type        = string
  default     = "ep2-devops-server"
}
