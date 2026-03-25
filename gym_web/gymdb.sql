-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Servidor: 127.0.0.1
-- Tiempo de generación: 14-03-2026 a las 20:43:24
-- Versión del servidor: 10.4.32-MariaDB
-- Versión de PHP: 8.2.12

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Base de datos: `gymdb`
--

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `auditoria`
--

CREATE TABLE `auditoria` (
  `id_log` int(11) NOT NULL,
  `fecha` datetime DEFAULT current_timestamp(),
  `tipo` varchar(30) NOT NULL,
  `actor_id` int(11) DEFAULT NULL,
  `actor_nombre` varchar(100) DEFAULT NULL,
  `actor_rol` varchar(20) DEFAULT NULL,
  `afectado_id` int(11) DEFAULT NULL,
  `afectado_nombre` varchar(100) DEFAULT NULL,
  `detalle` varchar(255) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Volcado de datos para la tabla `auditoria`
--

INSERT INTO `auditoria` (`id_log`, `fecha`, `tipo`, `actor_id`, `actor_nombre`, `actor_rol`, `afectado_id`, `afectado_nombre`, `detalle`) VALUES
(1, '2026-03-08 20:19:16', 'login', 15, 'Mariño', 'admin', NULL, NULL, 'Inició sesión'),
(2, '2026-03-08 20:19:31', 'rol', 15, 'Mariño', 'admin', 17, 'manuel lopezx', 'Asignó como Empleado'),
(3, '2026-03-08 20:19:36', 'desactivar', 15, 'Mariño', 'admin', 17, 'manuel lopezx', 'Desactivó la cuenta'),
(4, '2026-03-08 20:19:47', 'rol', 15, 'Mariño', 'admin', 17, 'manuel lopezx', 'Quitó rol Empleado → Usuario'),
(5, '2026-03-08 20:19:48', 'activacion', 15, 'Mariño', 'admin', 17, 'manuel lopezx', 'Reactivó la cuenta'),
(6, '2026-03-08 20:19:50', 'rol', 15, 'Mariño', 'admin', 16, 'santii pérez', 'Asignó como Empleado'),
(7, '2026-03-08 20:20:36', 'login', 15, 'Mariño', 'admin', NULL, NULL, 'Cerró sesión'),
(8, '2026-03-08 20:25:04', 'login', 15, 'Mariño', 'admin', NULL, NULL, 'Inició sesión'),
(9, '2026-03-08 20:25:35', 'login', 15, 'Mariño', 'admin', NULL, NULL, 'Cerró sesión'),
(10, '2026-03-09 10:05:23', 'login', 15, 'Mariño', 'admin', NULL, NULL, 'Inició sesión'),
(11, '2026-03-09 10:06:12', 'login', 15, 'Mariño', 'admin', NULL, NULL, 'Cerró sesión'),
(12, '2026-03-09 10:27:34', 'login', 15, 'Mariño', 'admin', NULL, NULL, 'Inició sesión'),
(13, '2026-03-09 11:58:38', 'login', 15, 'Mariño', 'admin', NULL, NULL, 'Inició sesión'),
(14, '2026-03-09 12:01:26', 'login', 15, 'Mariño', 'admin', NULL, NULL, 'Cerró sesión'),
(15, '2026-03-09 12:02:44', 'login', 18, 'Clinton', 'user', NULL, NULL, 'Inició sesión'),
(16, '2026-03-09 12:03:09', 'perfil', 18, 'Clinton', 'user', NULL, NULL, 'Completó perfil — Objetivo: Bajar de peso'),
(17, '2026-03-09 12:08:50', 'login', 18, 'Clinton', 'user', NULL, NULL, 'Cerró sesión'),
(18, '2026-03-09 12:08:58', 'login', 15, 'Mariño', 'admin', NULL, NULL, 'Inició sesión'),
(19, '2026-03-09 12:09:09', 'login', 15, 'Mariño', 'admin', NULL, NULL, 'Cerró sesión'),
(20, '2026-03-09 12:10:14', 'login', 19, 'jesus', 'user', NULL, NULL, 'Inició sesión'),
(21, '2026-03-09 12:10:58', 'perfil', 19, 'jesus', 'user', NULL, NULL, 'Completó perfil — Objetivo: Ganar músculo'),
(22, '2026-03-09 12:11:05', 'login', 19, 'jesus', 'user', NULL, NULL, 'Cerró sesión'),
(23, '2026-03-09 12:11:14', 'login', 15, 'Mariño', 'admin', NULL, NULL, 'Inició sesión'),
(24, '2026-03-09 12:11:17', 'rol', 15, 'Mariño', 'admin', 19, 'jesus fuentes', 'Asignó como Empleado'),
(25, '2026-03-09 12:11:20', 'login', 15, 'Mariño', 'admin', NULL, NULL, 'Cerró sesión'),
(26, '2026-03-09 12:11:42', 'login', 19, 'jesus', 'empleado', NULL, NULL, 'Inició sesión'),
(27, '2026-03-09 16:32:53', 'login', 15, 'Mariño', 'admin', NULL, NULL, 'Inició sesión'),
(28, '2026-03-09 16:34:10', 'desactivar', 15, 'Mariño', 'admin', 18, 'Clinton Pineda', 'Desactivó la cuenta'),
(29, '2026-03-09 16:34:48', 'activacion', 15, 'Mariño', 'admin', 18, 'Clinton Pineda', 'Reactivó la cuenta'),
(30, '2026-03-09 16:34:55', 'desactivar', 15, 'Mariño', 'admin', 18, 'Clinton Pineda', 'Desactivó la cuenta'),
(31, '2026-03-09 16:35:55', 'login', 15, 'Mariño', 'admin', NULL, NULL, 'Cerró sesión'),
(32, '2026-03-09 16:37:06', 'login', 20, 'Cristina', 'user', NULL, NULL, 'Inició sesión'),
(33, '2026-03-09 16:37:32', 'perfil', 20, 'Cristina', 'user', NULL, NULL, 'Completó perfil — Objetivo: Mantenimiento'),
(34, '2026-03-09 16:37:42', 'login', 20, 'Cristina', 'user', NULL, NULL, 'Cerró sesión'),
(35, '2026-03-09 16:37:50', 'login', 15, 'Mariño', 'admin', NULL, NULL, 'Inició sesión'),
(36, '2026-03-09 16:37:56', 'desactivar', 15, 'Mariño', 'admin', 20, 'Cristina Sente', 'Desactivó la cuenta'),
(37, '2026-03-09 16:37:58', 'login', 15, 'Mariño', 'admin', NULL, NULL, 'Cerró sesión'),
(38, '2026-03-09 16:39:09', 'login', 15, 'Mariño', 'admin', NULL, NULL, 'Inició sesión'),
(39, '2026-03-09 16:39:11', 'activacion', 15, 'Mariño', 'admin', 20, 'Cristina Sente', 'Reactivó la cuenta'),
(40, '2026-03-09 16:39:18', 'login', 15, 'Mariño', 'admin', NULL, NULL, 'Cerró sesión'),
(41, '2026-03-09 16:39:29', 'login', 20, 'Cristina', 'user', NULL, NULL, 'Inició sesión'),
(42, '2026-03-09 16:39:56', 'perfil', 20, 'Cristina', 'user', NULL, NULL, 'Actualizó entrenamiento — Crossfit / Noche'),
(43, '2026-03-09 16:42:00', 'login', 20, 'Cristina', 'user', NULL, NULL, 'Cerró sesión'),
(44, '2026-03-09 16:42:06', 'login', 15, 'Mariño', 'admin', NULL, NULL, 'Inició sesión'),
(45, '2026-03-09 16:42:47', 'login', 15, 'Mariño', 'admin', NULL, NULL, 'Cerró sesión'),
(46, '2026-03-09 16:43:13', 'login', 15, 'Mariño', 'admin', NULL, NULL, 'Inició sesión'),
(47, '2026-03-09 16:43:27', 'rol', 15, 'Mariño', 'admin', 20, 'Cristina Sente', 'Asignó como Empleado'),
(48, '2026-03-09 16:43:54', 'login', 15, 'Mariño', 'admin', NULL, NULL, 'Cerró sesión'),
(49, '2026-03-09 16:44:07', 'login', 20, 'Cristina', 'empleado', NULL, NULL, 'Inició sesión'),
(50, '2026-03-09 16:44:45', 'pago', 20, 'Cristina', 'empleado', 17, 'manuel lopezx', 'Registró pago de 1 mes(es) — Q225.00'),
(51, '2026-03-09 16:45:07', 'pago', 20, 'Cristina', 'empleado', 17, 'manuel lopezx', 'Registró pago de 3 mes(es) — Q675.00'),
(52, '2026-03-09 19:03:23', 'login', 15, 'Mariño', 'admin', NULL, NULL, 'Inició sesión'),
(53, '2026-03-09 19:03:48', 'activacion', 15, 'Mariño', 'admin', 18, 'Clinton Pineda', 'Reactivó la cuenta'),
(54, '2026-03-09 19:34:08', 'login', 16, 'santii', 'empleado', NULL, NULL, 'Inició sesión'),
(55, '2026-03-09 19:34:16', 'login', 16, 'santii', 'empleado', NULL, NULL, 'Cerró sesión'),
(56, '2026-03-09 20:07:21', 'login', 16, 'santii', 'empleado', NULL, NULL, 'Inició sesión'),
(57, '2026-03-09 20:07:32', 'login', 16, 'santii', 'empleado', NULL, NULL, 'Cerró sesión'),
(58, '2026-03-09 20:07:52', 'login', 15, 'Mariño', 'admin', NULL, NULL, 'Inició sesión'),
(59, '2026-03-09 20:07:59', 'rol', 15, 'Mariño', 'admin', 16, 'santii pérez', 'Quitó rol Empleado → Usuario'),
(60, '2026-03-09 20:08:02', 'login', 15, 'Mariño', 'admin', NULL, NULL, 'Cerró sesión'),
(61, '2026-03-09 20:08:07', 'login', 16, 'santii', 'user', NULL, NULL, 'Inició sesión'),
(62, '2026-03-09 20:08:26', 'perfil', 16, 'santii', 'user', NULL, NULL, 'Actualizó entrenamiento — Pesas / Mañana'),
(63, '2026-03-09 20:08:36', 'login', 16, 'santii', 'user', NULL, NULL, 'Cerró sesión'),
(64, '2026-03-09 20:08:48', 'login', 15, 'Mariño', 'admin', NULL, NULL, 'Inició sesión'),
(65, '2026-03-09 20:09:17', 'pago', 15, 'Mariño', 'admin', 18, 'Clinton Pineda', 'Registró pago de 1 mes(es) — Q225.00'),
(66, '2026-03-09 20:28:59', 'login', 15, 'Mariño', 'admin', NULL, NULL, 'Inició sesión'),
(67, '2026-03-09 20:46:55', 'pago', 15, 'Mariño', 'admin', 16, 'santii pérez', 'Registró pago de 2 mes(es) — Q450.00'),
(68, '2026-03-09 20:47:17', 'pago', 15, 'Mariño', 'admin', 18, 'Clinton Pineda', 'Registró pago de 2 mes(es) — Q450.00');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `pagos`
--

CREATE TABLE `pagos` (
  `id_pago` int(11) NOT NULL,
  `id_usuario` int(11) NOT NULL,
  `fecha_pago` date NOT NULL,
  `fecha_vencimiento` date NOT NULL,
  `monto` decimal(10,2) NOT NULL,
  `mes_pagado` varchar(60) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Volcado de datos para la tabla `pagos`
--

INSERT INTO `pagos` (`id_pago`, `id_usuario`, `fecha_pago`, `fecha_vencimiento`, `monto`, `mes_pagado`) VALUES
(3, 16, '2026-03-01', '2026-03-31', 225.00, NULL),
(11, 16, '2026-03-01', '2027-07-24', 2250.00, NULL),
(12, 17, '2026-03-01', '2026-03-31', 225.00, NULL),
(13, 15, '2026-03-02', '2026-08-29', 1350.00, NULL),
(14, 17, '2026-03-02', '2026-08-28', 1125.00, NULL),
(15, 16, '2026-03-02', '2027-12-21', 1125.00, NULL),
(16, 17, '2026-03-03', '2026-11-26', 675.00, NULL),
(17, 17, '2026-03-03', '2027-02-24', 675.00, NULL),
(18, 17, '2026-03-03', '2027-04-25', 450.00, NULL),
(19, 17, '2026-03-03', '2027-05-25', 225.00, NULL),
(20, 16, '2026-03-07', '2028-03-20', 675.00, NULL),
(21, 16, '2026-03-07', '2028-04-19', 225.00, NULL),
(22, 17, '2026-03-09', '2027-06-24', 225.00, NULL),
(23, 17, '2026-03-09', '2027-09-22', 675.00, NULL),
(24, 18, '2026-03-09', '2026-04-08', 225.00, 'Marzo 2026'),
(25, 16, '2026-03-09', '2028-06-18', 450.00, 'Octubre y Noviembre 2026'),
(26, 18, '2026-03-09', '2026-06-07', 450.00, 'Febrero y Marzo 2026');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `recuperar_contra`
--

CREATE TABLE `recuperar_contra` (
  `id` int(11) NOT NULL,
  `id_usuario` int(11) NOT NULL,
  `token` varchar(100) NOT NULL,
  `expira` datetime NOT NULL,
  `usado` tinyint(1) DEFAULT 0
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Volcado de datos para la tabla `recuperar_contra`
--

INSERT INTO `recuperar_contra` (`id`, `id_usuario`, `token`, `expira`, `usado`) VALUES
(1, 15, 'U66hH7zzvvIBko0NsVYTZUdiT3OtMI-zhY4GQryQlKKsXqUl-y6UaXCbBIRDsx_a', '2026-03-08 21:20:42', 1),
(2, 16, '0sDMAYshFLD0iflK2xeXIZadmQHovPOwkVL8sTdTX_9G_GKMIDJIsRRKHAbW3esz', '2026-03-08 21:20:51', 1),
(3, 15, 'IrWaMoXS00cshwRD4vq-Z0qddSdM4gZ9joGllbEzVFNajWUUvNxmx6U7rUmfmT6D', '2026-03-08 21:25:40', 1),
(4, 15, 'ncySWTu2AZjz_3DWMO7bDIh-meZzPrmMfOpW93I3a4D5vlZszrHjeKdo7Swwl7ZJ', '2026-03-08 21:28:01', 1),
(5, 15, 'PpOD_8Zyz98LmFkoOkQU9CrmhNKoh67muO_ZnShQTIyY-cJMNgxRzPIZixRtNimv', '2026-03-08 21:28:39', 1),
(6, 15, '8N3-kVsZsJC5sm4_dud6t0Bjk3v_H4fi_PW4ErYfpSadGdvVT5FX-7AyiBuiPPmY', '2026-03-08 21:33:23', 1),
(7, 15, '-h1iunFyKum1ipy_xWfjqLAfkn52eYSyeEh8U555jtz7Sz5-BK5SseraViqlIs7Y', '2026-03-08 22:02:58', 1),
(8, 16, 'qEXjy4eyjhIbZma86IRh8JvdN04LYAeQqSOsmIrElNbRpXbIr9u7uq9sXSkfuGxJ', '2026-03-08 22:03:05', 0),
(9, 15, '-El4wHmII4ckOIfGDRqq91Q5RgVQkbB4RFzNoNUyPOxaN70qUzISZqdQ-xQk-0I2', '2026-03-09 11:06:20', 1),
(10, 15, '9XfJ30ZCjbr2WUdLb7NUDng6Nkzrrlj1_6WdX25CCRI0gCHQaK1wuTYUe0rQIhvl', '2026-03-09 11:22:49', 1),
(11, 15, '7u76NdqMmdExmbaYzW6Nq7W7BpGaG1Ts7v5SROvtv_34DVw0_Uh5U-AV5NjSHLL9', '2026-03-09 11:26:56', 0);

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `usuarios`
--

CREATE TABLE `usuarios` (
  `id_usuario` int(11) NOT NULL,
  `nombre` varchar(100) NOT NULL,
  `apellido` varchar(100) NOT NULL,
  `fecha_registro` datetime DEFAULT current_timestamp(),
  `estado` enum('activo','inactivo') DEFAULT 'activo',
  `email` varchar(100) DEFAULT NULL,
  `password` varchar(255) DEFAULT NULL,
  `rol` varchar(20) DEFAULT 'user',
  `edad` int(11) DEFAULT NULL,
  `peso` decimal(5,2) DEFAULT NULL,
  `altura` decimal(5,2) DEFAULT NULL,
  `objetivo` varchar(100) DEFAULT NULL,
  `clase` varchar(50) DEFAULT NULL,
  `horario` varchar(50) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Volcado de datos para la tabla `usuarios`
--

INSERT INTO `usuarios` (`id_usuario`, `nombre`, `apellido`, `fecha_registro`, `estado`, `email`, `password`, `rol`, `edad`, `peso`, `altura`, `objetivo`, `clase`, `horario`) VALUES
(15, 'Mariño', 'ke', '2026-02-26 18:09:11', 'activo', 'kevinmperez29@gmail.com', 'scrypt:32768:8:1$D84jTLIrRvJioGSf$e9c685d847642b42acdf8ef1302f7ebfcdba2790885cd65ca7ace826b7ee1a16438c2a97cbf8e88b667fef5571dac874da11fe5ff0c456cff1211613841580d2', 'admin', 14, 14.00, 12.50, 'aa', NULL, NULL),
(16, 'santii', 'pérez', '2026-02-28 11:55:18', 'activo', 'santiagoandreperez08@gmail.com', 'scrypt:32768:8:1$l1avAaor7Xq4tiMN$4fd21d8923022bcf87b9ddf18992976bdba9685e6deb238cd66c72d09ac381968a8dc099eeda89f11425de12741c854c9943ca9392ec637ef4b0c09721fad5a6', 'user', 17, 15.00, 1.27, 'Pponerse fuertisimo', 'Pesas', 'Mañana'),
(17, 'manuel', 'lopezx', '2026-03-01 16:14:50', 'activo', 'asasa@gmail.com', 'scrypt:32768:8:1$cC73iuSqp9d48MV7$f37ec9673eeac84be16e272dacea17294ae69cdb198baacca7f876e42dace60238199096cd14af06d6334bd74fe68161ed290c37470fa0b9f2e155939f625686', 'user', 14, 12.00, 1.24, 'volear como fratta', NULL, NULL),
(18, 'Clinton', 'Pineda', '2026-03-09 12:02:27', 'activo', 'clintonpineda@itc.edu.gt', 'scrypt:32768:8:1$jfAtPwABKaojNjSq$80beadbad3de1ef295bab6c77ff3be235f5eeee855ff6b80f82820e558fe8fe4e45b1761e7833891b3ce2696624df82c79ecc32dbf8461677d976d2cf2fdb4c1', 'user', 75, 220.00, 1.80, 'Bajar de peso', NULL, NULL),
(19, 'jesus', 'fuentes', '2026-03-09 12:09:44', 'activo', 'fue2025051@itc.edu.gt', 'scrypt:32768:8:1$ypqTke3hqxOkguM0$18e6547b163543352b8db17315491c297aa3bd9062053ff212a82eeaedbcbb416c23466efbfcb90367a9d839f82158b2d79d03a2319d1ee02a86e49a825910a4', 'empleado', 20, 130.00, 1.85, 'Ganar músculo', NULL, NULL),
(20, 'Cristina', 'Sente', '2026-03-09 16:36:34', 'activo', 'cristina@gmail.com', 'scrypt:32768:8:1$8fgGIXAHs8ZKfu1l$dd86ae6f9a04ea74c4f9039a8fd34276fb31bfd43d2c16e7161eac7496d445ed76affed4521fed90d938e3a11e109af22733b7e91adf990a8ac24ca491944226', 'empleado', 30, 160.00, 1.60, 'Mantenimiento', 'Crossfit', 'Noche');

-- --------------------------------------------------------

--
-- Índices para tablas volcadas
--

--
-- Indices de la tabla `auditoria`
--
ALTER TABLE `auditoria`
  ADD PRIMARY KEY (`id_log`);

--
-- Indices de la tabla `pagos`
--
ALTER TABLE `pagos`
  ADD PRIMARY KEY (`id_pago`),
  ADD KEY `id_usuario` (`id_usuario`);

--
-- Indices de la tabla `recuperar_contra`
--
ALTER TABLE `recuperar_contra`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `token` (`token`),
  ADD KEY `id_usuario` (`id_usuario`);

--
-- Indices de la tabla `usuarios`
--
ALTER TABLE `usuarios`
  ADD PRIMARY KEY (`id_usuario`),
  ADD UNIQUE KEY `email` (`email`);

--
-- AUTO_INCREMENT de las tablas volcadas
--

--
-- AUTO_INCREMENT de la tabla `auditoria`
--
ALTER TABLE `auditoria`
  MODIFY `id_log` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=69;

--
-- AUTO_INCREMENT de la tabla `pagos`
--
ALTER TABLE `pagos`
  MODIFY `id_pago` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=27;

--
-- AUTO_INCREMENT de la tabla `recuperar_contra`
--
ALTER TABLE `recuperar_contra`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=12;

--
-- AUTO_INCREMENT de la tabla `usuarios`
--
ALTER TABLE `usuarios`
  MODIFY `id_usuario` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=21;

--
-- Filtros para la tabla `pagos`
--
ALTER TABLE `pagos`
  ADD CONSTRAINT `pagos_ibfk_1` FOREIGN KEY (`id_usuario`) REFERENCES `usuarios` (`id_usuario`);

--
-- Filtros para la tabla `recuperar_contra`
--
ALTER TABLE `recuperar_contra`
  ADD CONSTRAINT `recuperar_contra_ibfk_1` FOREIGN KEY (`id_usuario`) REFERENCES `usuarios` (`id_usuario`);

--
-- Filtros para la tabla `asistencia`
--
ALTER TABLE `asistencia`
  ADD CONSTRAINT `asistencia_ibfk_1` FOREIGN KEY (`usuario_id`) REFERENCES `usuarios` (`id_usuario`);

--
-- Filtros para la tabla `metas`
--
ALTER TABLE `metas`
  ADD CONSTRAINT `metas_ibfk_1` FOREIGN KEY (`usuario_id`) REFERENCES `usuarios` (`id_usuario`);
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
