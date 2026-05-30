# ==========================================
# Etapa 1: Compilación de la aplicación React
# ==========================================
FROM node:20-alpine AS build

# Establecer directorio de trabajo
WORKDIR /app

# Copiar package.json y package-lock.json para aprovechar la caché de capas de Docker
COPY package*.json ./

# Instalar dependencias del proyecto
RUN npm ci

# Copiar el resto del código fuente del frontend
COPY . .

# Construir la aplicación para producción (genera la carpeta dist/)
RUN npm run build

# ==========================================
# Etapa 2: Servidor Nginx de Producción (Seguro / No-Root)
# ==========================================
FROM nginxinc/nginx-unprivileged:stable-alpine

# Copiar la configuración personalizada de Nginx que actúa como proxy inverso
COPY nginx.conf /etc/nginx/conf.d/default.conf

# Copiar los artefactos estáticos compilados desde la etapa 1
COPY --from=build /app/dist /usr/share/nginx/html

# Exponer el puerto no privilegiado en el que escucha Nginx
EXPOSE 8080

# No es necesario definir CMD ya que la imagen base de nginx ya lo tiene configurado
