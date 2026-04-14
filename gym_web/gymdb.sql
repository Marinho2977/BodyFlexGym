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
  `rol`            VARCHAR(20) DEFAULT 'user',
  `edad`           INT(11) DEFAULT NULL,
  `peso`           DECIMAL(5,2) DEFAULT NULL,
  `altura`         DECIMAL(5,2) DEFAULT NULL,
  `objetivo`       VARCHAR(100) DEFAULT NULL,
  `clase`          VARCHAR(50) DEFAULT NULL,
  `horario`        VARCHAR(50) DEFAULT NULL,
  PRIMARY KEY (`cui`),
  UNIQUE KEY `email` (`email`),
  KEY `id_usuario` (`id_usuario`)
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
CREATE TABLE `anuncios` (
  `id`           INT(11) NOT NULL AUTO_INCREMENT,
  `titulo`       VARCHAR(150) NOT NULL,
  `contenido`    TEXT NOT NULL,
  `tipo`         ENUM('info','promo','aviso') NOT NULL DEFAULT 'info',
  `fecha_inicio` DATE NOT NULL,
  `fecha_fin`    DATE NOT NULL,
  `activo`       TINYINT(1) NOT NULL DEFAULT 1,
  `creado_por`   BIGINT UNSIGNED NOT NULL,
  `created_at`   DATETIME DEFAULT CURRENT_TIMESTAMP(),
  PRIMARY KEY (`id`),
  KEY `idx_anuncios_activo` (`activo`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- ============================================================
-- TABLA: asistencia
-- ============================================================
CREATE TABLE `asistencia` (
  `id`           INT(11) NOT NULL AUTO_INCREMENT,
  `cui_usuario`  BIGINT UNSIGNED NOT NULL,
  `fecha`        DATE NOT NULL,
  `hora_entrada` TIME DEFAULT NULL,
  `hora_salida`  TIME DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `cui_usuario` (`cui_usuario`),
  CONSTRAINT `asistencia_ibfk_1` FOREIGN KEY (`cui_usuario`) REFERENCES `usuarios` (`cui`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- ============================================================
-- TABLA: metas
-- ============================================================
CREATE TABLE `metas` (
  `id`           INT(11) NOT NULL AUTO_INCREMENT,
  `cui_usuario`  BIGINT UNSIGNED NOT NULL,
  `descripcion`  VARCHAR(255) NOT NULL,
  `completada`   TINYINT(1) DEFAULT 0,
  `created_at`   DATETIME DEFAULT CURRENT_TIMESTAMP(),
  PRIMARY KEY (`id`),
  KEY `cui_usuario` (`cui_usuario`),
  CONSTRAINT `metas_ibfk_1` FOREIGN KEY (`cui_usuario`) REFERENCES `usuarios` (`cui`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

COMMIT;

-- ============================================================
-- SCRIPT DE MIGRACION (ejecutar si ya tienes datos en Railway)
-- Copia estas lineas, quita los comentarios (--) y ejecutalas
-- en orden en phpMyAdmin de Railway.
-- Si la DB esta vacia, el schema de arriba es suficiente.
-- ============================================================
--
-- PASO 1: Quitar FK
-- ALTER TABLE pagos DROP FOREIGN KEY pagos_ibfk_1;
-- ALTER TABLE recuperar_contra DROP FOREIGN KEY recuperar_contra_ibfk_1;
-- ALTER TABLE asistencia DROP FOREIGN KEY asistencia_ibfk_1;
-- ALTER TABLE metas DROP FOREIGN KEY metas_ibfk_1;
--
-- PASO 2: Agregar cui y tipo_doc
-- ALTER TABLE usuarios ADD COLUMN `cui` BIGINT UNSIGNED NOT NULL DEFAULT 0 FIRST;
-- ALTER TABLE usuarios ADD COLUMN `tipo_doc` ENUM('CUI','DPI') NOT NULL DEFAULT 'CUI' AFTER `cui`;
-- ALTER TABLE usuarios ADD UNIQUE KEY `cui_unique` (`cui`);
--
-- PASO 3: Asignar CUI/DPI reales a usuarios existentes
-- UPDATE usuarios SET cui=TU_CUI_REAL, tipo_doc='DPI' WHERE id_usuario=15;
-- UPDATE usuarios SET cui=TU_CUI_REAL, tipo_doc='DPI' WHERE id_usuario=16;
-- (repetir para cada usuario)
--
-- PASO 4: Cambiar PK de id_usuario a cui
-- ALTER TABLE usuarios DROP PRIMARY KEY;
-- ALTER TABLE usuarios MODIFY `id_usuario` INT(11) NOT NULL;
-- ALTER TABLE usuarios ADD PRIMARY KEY (`cui`);
--
-- PASO 5: Migrar tablas hijas
-- ALTER TABLE pagos ADD COLUMN `cui_usuario` BIGINT UNSIGNED NOT NULL DEFAULT 0 AFTER `id_pago`;
-- UPDATE pagos p JOIN usuarios u ON u.id_usuario=p.id_usuario SET p.cui_usuario=u.cui;
-- ALTER TABLE pagos DROP COLUMN `id_usuario`;
--
-- ALTER TABLE recuperar_contra ADD COLUMN `cui_usuario` BIGINT UNSIGNED NOT NULL DEFAULT 0 AFTER `id`;
-- UPDATE recuperar_contra r JOIN usuarios u ON u.id_usuario=r.id_usuario SET r.cui_usuario=u.cui;
-- ALTER TABLE recuperar_contra DROP COLUMN `id_usuario`;
--
-- ALTER TABLE auditoria MODIFY `actor_id` BIGINT UNSIGNED DEFAULT NULL;
-- ALTER TABLE auditoria MODIFY `afectado_id` BIGINT UNSIGNED DEFAULT NULL;
--
-- ALTER TABLE asistencia ADD COLUMN `cui_usuario` BIGINT UNSIGNED NOT NULL DEFAULT 0;
-- UPDATE asistencia a JOIN usuarios u ON u.id_usuario=a.usuario_id SET a.cui_usuario=u.cui;
-- ALTER TABLE asistencia DROP COLUMN `usuario_id`;
--
-- ALTER TABLE metas ADD COLUMN `cui_usuario` BIGINT UNSIGNED NOT NULL DEFAULT 0;
-- UPDATE metas m JOIN usuarios u ON u.id_usuario=m.usuario_id SET m.cui_usuario=u.cui;
-- ALTER TABLE metas DROP COLUMN `usuario_id`;
--
-- PASO 6: Restaurar FK
-- ALTER TABLE pagos ADD CONSTRAINT `pagos_ibfk_1` FOREIGN KEY (`cui_usuario`) REFERENCES `usuarios`(`cui`);
-- ALTER TABLE recuperar_contra ADD CONSTRAINT `recuperar_contra_ibfk_1` FOREIGN KEY (`cui_usuario`) REFERENCES `usuarios`(`cui`);
-- ALTER TABLE asistencia ADD CONSTRAINT `asistencia_ibfk_1` FOREIGN KEY (`cui_usuario`) REFERENCES `usuarios`(`cui`);
-- ALTER TABLE metas ADD CONSTRAINT `metas_ibfk_1` FOREIGN KEY (`cui_usuario`) REFERENCES `usuarios`(`cui`);
