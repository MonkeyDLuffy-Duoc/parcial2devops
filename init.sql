-- Crear las bases de datos independientes para cada microservicio
CREATE DATABASE IF NOT EXISTS ventas_db CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
CREATE DATABASE IF NOT EXISTS despachos_db CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

-- Garantizar que se puedan realizar operaciones
GRANT ALL PRIVILEGES ON ventas_db.* TO 'citt_user'@'%';
GRANT ALL PRIVILEGES ON despachos_db.* TO 'citt_user'@'%';
FLUSH PRIVILEGES;

-- ==========================================
-- Inicialización de datos semilla para Ventas
-- ==========================================
USE ventas_db;

-- Crear tabla venta si no existe para que el insert funcione inmediatamente
CREATE TABLE IF NOT EXISTS `venta` (
  `id_venta` bigint NOT NULL,
  `despacho_generado` bit(1) NOT NULL,
  `direccion_compra` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `fecha_compra` date NOT NULL,
  `valor_compra` int NOT NULL,
  PRIMARY KEY (`id_venta`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Crear tabla de secuencia de venta si no existe
CREATE TABLE IF NOT EXISTS `venta_seq` (
  `next_val` bigint DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Insertar datos semilla de Ventas (extraídos del db.json original del frontend)
INSERT INTO `venta` (`id_venta`, `despacho_generado`, `direccion_compra`, `fecha_compra`, `valor_compra`) 
VALUES 
(1, 0, 'P Sherman Calle Wallabi 42 Sydney', '2024-02-02', 22990),
(2, 0, 'Avenida siempre viva 69', '2024-03-05', 12590),
(3, 0, 'Avenida Por atrás 1313', '2024-04-20', 13990),
(4, 0, 'Calle presidente kirby 8528', '2024-04-15', 9990)
ON DUPLICATE KEY UPDATE `id_venta` = `id_venta`;

-- Inicializar la secuencia de IDs de venta en 5 para evitar colisiones en futuras inserciones
INSERT INTO `venta_seq` (`next_val`) 
SELECT 5 WHERE NOT EXISTS (SELECT 1 FROM `venta_seq`);

-- ==========================================
-- Inicialización de datos para Despachos
-- ==========================================
USE despachos_db;

-- Crear tabla de secuencia de despacho si no existe
CREATE TABLE IF NOT EXISTS `despacho_seq` (
  `next_val` bigint DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Inicializar la secuencia de IDs de despachos en 1
INSERT INTO `despacho_seq` (`next_val`) 
SELECT 1 WHERE NOT EXISTS (SELECT 1 FROM `despacho_seq`);
