-- ═══════════════════════════════════════════════════════════════
--                    CLAVE PRIMARIA SIMPLE
-- ═══════════════════════════════════════════════════════════════

-- Forma 1: Inline (en la definición de columna)
CREATE TABLE Clientes (
    cliente_id INT AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(100) NOT NULL
);

-- Forma 2: Al final de la tabla (más explícito)
CREATE TABLE Productos (
    producto_id INT AUTO_INCREMENT,
    nombre VARCHAR(100) NOT NULL,
    precio DECIMAL(10,2),
    PRIMARY KEY (producto_id)
);

-- Forma 3: Con nombre de constraint (recomendado, facilita debugging)
CREATE TABLE Pedidos (
    pedido_id INT AUTO_INCREMENT,
    fecha DATE NOT NULL,
    total DECIMAL(10,2),
    CONSTRAINT pk_pedidos PRIMARY KEY (pedido_id)
);

-- ═══════════════════════════════════════════════════════════════
--                    CLAVE PRIMARIA COMPUESTA
-- ═══════════════════════════════════════════════════════════════

-- Tabla de relación muchos-a-muchos
CREATE TABLE Matriculas (
    estudiante_id INT,
    asignatura_id INT,
    fecha_matricula DATE NOT NULL,
    nota DECIMAL(4,2),
    PRIMARY KEY (estudiante_id, asignatura_id)
    -- Ambas columnas juntas forman la PK
);

-- Tabla de detalles de pedido
CREATE TABLE DetallePedido (
    pedido_id INT,
    linea_numero INT,
    producto_id INT NOT NULL,
    cantidad INT NOT NULL CHECK (cantidad > 0),
    precio_unitario DECIMAL(10,2) NOT NULL,
    PRIMARY KEY (pedido_id, linea_numero)
    -- Cada línea de un pedido es única
);

-- Con constraint nombrado
CREATE TABLE AsistenciaClases (
    estudiante_id INT,
    clase_id INT,
    fecha DATE,
    presente BOOLEAN DEFAULT FALSE,
    CONSTRAINT pk_asistencia PRIMARY KEY (estudiante_id, clase_id, fecha)
    -- Tres columnas en la PK
);

-- ═══════════════════════════════════════════════════════════════
--                    CLAVES PRIMARIAS ESPECIALES
-- ═══════════════════════════════════════════════════════════════

-- UUID como clave primaria (mejor para sistemas distribuidos)
CREATE TABLE Sesiones (
    sesion_id CHAR(36) PRIMARY KEY DEFAULT (UUID()),  -- MySQL 8.0+
    usuario_id INT NOT NULL,
    fecha_inicio DATETIME DEFAULT CURRENT_TIMESTAMP,
    activa BOOLEAN DEFAULT TRUE
);

-- PostgreSQL con UUID nativo
CREATE EXTENSION IF NOT EXISTS "uuid-ossp";
CREATE TABLE Sesiones (
    sesion_id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    usuario_id INT NOT NULL,
    fecha_inicio TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Natural key (clave natural del dominio)
CREATE TABLE Paises (
    codigo_iso CHAR(2) PRIMARY KEY,  -- 'ES', 'US', 'FR' (clave natural)
    nombre VARCHAR(100) NOT NULL,
    poblacion BIGINT
);

-- ═══════════════════════════════════════════════════════════════
--                    BUENAS PRÁCTICAS
-- ═══════════════════════════════════════════════════════════════

-- ✓ RECOMENDADO: Clave subrogada (surrogate key) + índice único en natural key
CREATE TABLE Usuarios (
    usuario_id INT AUTO_INCREMENT PRIMARY KEY,  -- Surrogate key
    email VARCHAR(100) NOT NULL UNIQUE,         -- Natural key con índice único
    nombre VARCHAR(100) NOT NULL
);
-- Ventajas: PK nunca cambia (email puede cambiar), PK corta (4 bytes vs 100 bytes),
--           FK rápidos, pero mantienes unicidad del email

-- ✗ EVITAR: Claves primarias muy largas
CREATE TABLE Logs (
    timestamp DATETIME,
    servidor VARCHAR(100),
    aplicacion VARCHAR(100),
    mensaje TEXT,
    PRIMARY KEY (timestamp, servidor, aplicacion)  -- PK de 216+ bytes!
);
-- Problema: FK gigantes, joins lentos, índices enormes
-- Mejor: id INT AUTO_INCREMENT PRIMARY KEY + índice compuesto en los tres campos