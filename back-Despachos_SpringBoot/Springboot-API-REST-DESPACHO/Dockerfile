# ==========================================
# Etapa 1: Compilación de la aplicación con Maven
# ==========================================
FROM maven:3.9.6-eclipse-temurin-17-alpine AS build

# Establecer directorio de trabajo
WORKDIR /app

# Copiar el archivo pom.xml primero para descargar dependencias y optimizar la caché
COPY pom.xml .

# Descargar las dependencias en modo offline para no repetir el proceso si el pom.xml no cambia
RUN mvn dependency:go-offline -B || true

# Copiar el código fuente de la aplicación
COPY src ./src

# Compilar y generar el archivo JAR empaquetado (omitiendo tests para acelerar la construcción de la imagen)
RUN mvn clean package -DskipTests

# ==========================================
# Etapa 2: Entorno de ejecución JRE (Seguro / No-Root)
# ==========================================
FROM eclipse-temurin:17-jre-alpine

# Crear un grupo de sistema y un usuario no-root 'spring' para seguridad
RUN addgroup -S spring && adduser -S spring -G spring

# Establecer directorio de trabajo
WORKDIR /app

# Copiar el JAR generado desde la etapa de compilación
COPY --from=build /app/target/*.jar app.jar

# Cambiar los permisos para que pertenezcan al usuario no privilegiado
RUN chown -R spring:spring /app

# Indicar que el contenedor se ejecute con el usuario spring en lugar de root
USER spring:spring

# Exponer el puerto configurado en application.properties para este microservicio (8081)
EXPOSE 8081

# Definir el comando de arranque del microservicio
ENTRYPOINT ["java", "-jar", "app.jar"]
