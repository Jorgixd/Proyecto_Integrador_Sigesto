-- ==============================================================================
-- SCRIPT DDL: Creación del Esquema Inicial de Base de Datos desde Cero
-- Proyecto: SIGESTO (Sistema Integrado de Gestión de Servicios Técnicos)
-- Archivo: create_tables.sql
-- ==============================================================================

-- 1. CREACIÓN Y SELECCIÓN DE LA BASE DE DATOS
CREATE DATABASE IF NOT EXISTS sigesto;
USE sigesto;

-- ==============================================================================
-- 2. TABLAS INDEPENDIENTES (Maestras y Catálogos)
-- ==============================================================================

-- Tabla 1: roles
-- Almacena los perfiles de acceso (ej. ADMINISTRADOR, TECNICO, CLIENTE)
CREATE TABLE roles (
    id_rol BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
    nombre VARCHAR(50) NOT NULL UNIQUE,
    PRIMARY KEY (id_rol)
);

-- Tabla 2: tipos_trabajo
-- Registra los tipos de servicios o mantenimientos que ofrece la empresa
CREATE TABLE tipos_trabajo (
    id BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
    nombre VARCHAR(100) NOT NULL,
    descripcion TEXT DEFAULT NULL,
    activo TINYINT(1) NOT NULL DEFAULT 1,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY (id)
);

-- Tabla 3: items_catalogo
-- Registra todos los materiales y servicios disponibles en el inventario
CREATE TABLE items_catalogo (
    id_item BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
    sku_codigo VARCHAR(50) DEFAULT NULL UNIQUE,
    tipo_item ENUM('MATERIAL', 'SERVICIO') NOT NULL,
    nombre VARCHAR(150) NOT NULL,
    descripcion TEXT DEFAULT NULL,
    unidad_medida VARCHAR(20) DEFAULT NULL,
    precio_ref DECIMAL(10,2) NOT NULL,
    activo TINYINT(1) NOT NULL DEFAULT 1,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY (id_item)
);

-- ==============================================================================
-- 3. TABLAS DEPENDIENTES (Con Claves Foráneas y Restricciones de Negocio)
-- ==============================================================================

-- Tabla 4: usuarios
-- Cuenta central de acceso al sistema (se relaciona con la tabla roles)
CREATE TABLE usuarios (
    id_usuario BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
    id_rol BIGINT UNSIGNED NOT NULL,
    email VARCHAR(150) NOT NULL,
    password_hash VARCHAR(255) NOT NULL,
    nombres VARCHAR(100) NOT NULL,
    apellidos VARCHAR(100) NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    deleted_at TIMESTAMP NULL DEFAULT NULL,
    PRIMARY KEY (id_usuario),
    -- Restricción UNIQUE para evitar duplicidad de correos
    CONSTRAINT uq_usuarios_email UNIQUE (email),
    -- Clave Foránea con restricción RESTRICT
    CONSTRAINT fk_usuarios_roles FOREIGN KEY (id_rol) 
        REFERENCES roles(id_rol) ON DELETE RESTRICT
);

-- Tabla 5: perfiles_clientes
-- Guarda los datos de facturación de los clientes (Relación 1 a 1 con usuarios)
CREATE TABLE perfiles_clientes (
    id_cliente BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
    id_usuario BIGINT UNSIGNED NOT NULL,
    dni_ruc VARCHAR(20) NOT NULL,
    telefono VARCHAR(20) NOT NULL,
    direccion VARCHAR(255) DEFAULT NULL,
    deleted_at TIMESTAMP NULL DEFAULT NULL,
    PRIMARY KEY (id_cliente),
    -- Restricciones UNIQUE
    CONSTRAINT uq_clientes_dni_ruc UNIQUE (dni_ruc),
    CONSTRAINT uq_clientes_usuario UNIQUE (id_usuario),
    -- Clave Foránea con eliminación en CASCADE
    CONSTRAINT fk_clientes_usuarios FOREIGN KEY (id_usuario) 
        REFERENCES usuarios(id_usuario) ON DELETE CASCADE
);

-- Tabla 6: cotizaciones
-- Registra los presupuestos generados para las atenciones
CREATE TABLE cotizaciones (
    id_cotizacion BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
    estado ENUM('BORRADOR', 'ENVIADA', 'APROBADA', 'RECHAZADA', 'LIQUIDADA') NOT NULL DEFAULT 'BORRADOR',
    tasa_igv DECIMAL(5,2) NOT NULL DEFAULT 18.00,
    subtotal DECIMAL(12,2) NOT NULL DEFAULT 0.00,
    igv DECIMAL(12,2) NOT NULL DEFAULT 0.00,
    total DECIMAL(12,2) NOT NULL DEFAULT 0.00,
    id_usuario_creador BIGINT UNSIGNED NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    deleted_at TIMESTAMP NULL DEFAULT NULL,
    PRIMARY KEY (id_cotizacion),
    -- Clave Foránea con el usuario creador
    CONSTRAINT fk_cotizaciones_usuario FOREIGN KEY (id_usuario_creador) 
        REFERENCES usuarios(id_usuario) ON DELETE RESTRICT,
    -- Restricción CHECK: impide valores negativos en el total
    CONSTRAINT chk_cotizacion_total CHECK (total >= 0)
);