-- ============================================================
-- Bodyflex Gym — gymdb.sql
-- Esquema actualizado: CUI/DPI como llave primaria
-- tipo_doc: CUI para menores, DPI para mayores de edad
-- ============================================================

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";
SET NAMES utf8mb4;

-- ============================================================
-- TABLA: usuarios
-- ============================================================
CREATE TABLE `usuarios` (
  `cui`            BIGINT UNSIGNED NOT NULL,
  `tipo_doc`       ENUM('CUI','DPI') NOT NULL DEFAULT 'CUI',
  `id_usuario`     INT(11) NOT NULL AUTO_INCREMENT,
  `nombre`         VARCHAR(100) NOT NULL,
  `apellido`       VARCHAR(100) NOT NULL,
  `fecha_registro` DATETIME DEFAULT CURRENT_TIMESTAMP(),
  `estado`         ENUM('activo','inactivo') DEFAULT 'activo',
  `email`          VARCHAR(100) DEFAULT NULL,
  `password`       VARCHAR(255) DEFAULT NULL,
  `telefono`       VARCHAR(20) DEFAULT NULL,
  `rol`            VARCHAR(20) DEFAULT 'user',
  `id_rol`         INT(11) DEFAULT NULL,
  PRIMARY KEY (`cui`),
  UNIQUE KEY `email` (`email`),
  KEY `id_usuario` (`id_usuario`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- ============================================================
-- TABLA: perfiles
-- ============================================================
CREATE TABLE `perfiles` (
  `id_perfil`           INT(11) NOT NULL AUTO_INCREMENT,
  `cui_usuario`         BIGINT UNSIGNED NOT NULL,
  `edad`                INT(11) DEFAULT NULL,
  `peso`                DECIMAL(5,2) DEFAULT NULL,
  `altura`              DECIMAL(5,2) DEFAULT NULL,
  `objetivo`            VARCHAR(100) DEFAULT NULL,
  `fecha_actualizacion` DATETIME DEFAULT CURRENT_TIMESTAMP() ON UPDATE CURRENT_TIMESTAMP(),
  PRIMARY KEY (`id_perfil`),
  KEY `cui_usuario` (`cui_usuario`),
  CONSTRAINT `perfiles_ibfk_1` FOREIGN KEY (`cui_usuario`) REFERENCES `usuarios` (`cui`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- ============================================================
-- TABLA: pagos
-- ============================================================
CREATE TABLE `pagos` (
  `id_pago`           INT(11) NOT NULL AUTO_INCREMENT,
  `cui_usuario`       BIGINT UNSIGNED NOT NULL,
  `fecha_pago`        DATE NOT NULL,
  `fecha_vencimiento` DATE NOT NULL,
  `monto`             DECIMAL(10,2) NOT NULL,
  `mes_pagado`        VARCHAR(60) DEFAULT NULL,
  PRIMARY KEY (`id_pago`),
  KEY `cui_usuario` (`cui_usuario`),
  CONSTRAINT `pagos_ibfk_1` FOREIGN KEY (`cui_usuario`) REFERENCES `usuarios` (`cui`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- ============================================================
-- TABLA: recuperar_contra
-- ============================================================
CREATE TABLE `recuperar_contra` (
  `id`          INT(11) NOT NULL AUTO_INCREMENT,
  `cui_usuario` BIGINT UNSIGNED NOT NULL,
  `token`       VARCHAR(100) NOT NULL,
  `expira`      DATETIME NOT NULL,
  `usado`       TINYINT(1) DEFAULT 0,
  PRIMARY KEY (`id`),
  UNIQUE KEY `token` (`token`),
  KEY `cui_usuario` (`cui_usuario`),
  CONSTRAINT `recuperar_contra_ibfk_1` FOREIGN KEY (`cui_usuario`) REFERENCES `usuarios` (`cui`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- ============================================================
-- TABLA: auditoria
-- actor_id y afectado_id almacenan el CUI del usuario
-- ============================================================
CREATE TABLE `auditoria` (
  `id_log`          INT(11) NOT NULL AUTO_INCREMENT,
  `fecha`           DATETIME DEFAULT CURRENT_TIMESTAMP(),
  `tipo`            VARCHAR(30) NOT NULL,
  `actor_id`        BIGINT UNSIGNED DEFAULT NULL,
  `actor_nombre`    VARCHAR(100) DEFAULT NULL,
  `actor_rol`       VARCHAR(20) DEFAULT NULL,
  `afectado_id`     BIGINT UNSIGNED DEFAULT NULL,
  `afectado_nombre` VARCHAR(100) DEFAULT NULL,
  `detalle`         VARCHAR(255) DEFAULT NULL,
  PRIMARY KEY (`id_log`),
  KEY `idx_auditoria_fecha` (`fecha`),
  KEY `idx_auditoria_tipo`  (`tipo`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- ============================================================
-- TABLA: anuncios
-- creado_por almacena el CUI del admin/empleado
-- ============================================================


-- ============================================================
-- TABLA: productos (productos de venta y consumibles)
-- ============================================================
CREATE TABLE `productos` (
  `id_producto` INT(11) NOT NULL AUTO_INCREMENT,
  `nombre` VARCHAR(100) NOT NULL,
  `descripcion` VARCHAR(255) DEFAULT NULL,
  `cantidad` INT(11) NOT NULL DEFAULT 0,
  `precio_costo` DECIMAL(10,2) DEFAULT NULL,
  `precio_venta` DECIMAL(10,2) NOT NULL,
  `categoria` VARCHAR(50) DEFAULT 'General',
  `foto_url` VARCHAR(255) DEFAULT NULL,
  `fecha_agregado` DATETIME DEFAULT CURRENT_TIMESTAMP(),
  PRIMARY KEY (`id_producto`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- ============================================================
-- TABLA: maquinaria (equipos y máquinas del gimnasio)
-- ============================================================
CREATE TABLE `maquinaria` (
  `id_equipo` INT(11) NOT NULL AUTO_INCREMENT,
  `nombre` VARCHAR(100) NOT NULL,
  `descripcion` VARCHAR(255) DEFAULT NULL,
  `cantidad` INT(11) NOT NULL DEFAULT 1,
  `zona` VARCHAR(50) NOT NULL DEFAULT 'Cardio',
  `estado` VARCHAR(50) NOT NULL DEFAULT 'Excelente',
  `foto_url` VARCHAR(255) DEFAULT NULL,
  `fecha_registro` DATETIME DEFAULT CURRENT_TIMESTAMP(),
  PRIMARY KEY (`id_equipo`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- ============================================================
-- TABLA: cargos
-- ============================================================
CREATE TABLE `cargos` (
  `id_cargo`          BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
  `cui_usuario`       BIGINT UNSIGNED NOT NULL,
  `descripcion`       VARCHAR(255) NOT NULL,
  `monto`             DECIMAL(10,2) NOT NULL,
  `fecha_emision`     DATE NOT NULL,
  `estado`            VARCHAR(20) NOT NULL DEFAULT 'pendiente',
  `id_producto`       INT(11) DEFAULT NULL,
  PRIMARY KEY (`id_cargo`),
  KEY `cui_usuario` (`cui_usuario`),
  KEY `id_producto` (`id_producto`),
  CONSTRAINT `cargos_ibfk_1` FOREIGN KEY (`cui_usuario`) REFERENCES `usuarios` (`cui`),
  CONSTRAINT `fk_cargo_producto` FOREIGN KEY (`id_producto`) REFERENCES `productos` (`id_producto`) ON DELETE SET NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

COMMIT;

-- ============================================================
-- PASO 7: MIGRACIÓN EN RAILWAY (Ejecutar en Railway para separar productos y maquinaria)
-- ============================================================
-- ALTER TABLE `cargos` DROP FOREIGN KEY `fk_cargo_producto`;
-- RENAME TABLE `inventario` TO `productos`;
-- ALTER TABLE `cargos` ADD CONSTRAINT `fk_cargo_producto` FOREIGN KEY (`id_producto`) REFERENCES `productos` (`id_producto`) ON DELETE SET NULL;
-- CREATE TABLE IF NOT EXISTS `maquinaria` (
--   `id_equipo` INT(11) NOT NULL AUTO_INCREMENT,
--   `nombre` VARCHAR(100) NOT NULL,
--   `descripcion` VARCHAR(255) DEFAULT NULL,
--   `cantidad` INT(11) NOT NULL DEFAULT 1,
--   `zona` VARCHAR(50) NOT NULL DEFAULT 'Cardio',
--   `estado` VARCHAR(50) NOT NULL DEFAULT 'Excelente',
--   `foto_url` VARCHAR(255) DEFAULT NULL,
--   `fecha_registro` DATETIME DEFAULT CURRENT_TIMESTAMP(),
--   PRIMARY KEY (`id_equipo`)
-- ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;


