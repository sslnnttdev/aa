CREATE TABLE Ejemplo_Modificadores (
    -- AUTO_INCREMENT (MySQL) / SERIAL (PostgreSQL)
    id INT AUTO_INCREMENT PRIMARY KEY,           -- Genera IDs automáticamente
    
    -- NOT NULL (campo obligatorio)
    nombre VARCHAR(100) NOT NULL,                -- No puede ser NULL
    email VARCHAR(100) NOT NULL,
    
    -- UNIQUE (valor único en toda la tabla)
    email_unico VARCHAR(100) UNIQUE,             -- No duplicados
    dni CHAR(9) UNIQUE NOT NULL,                 -- Único Y obligatorio
    
    -- DEFAULT (valor por defecto si no se especifica)
    fecha_registro DATE DEFAULT (CURRENT_DATE),  -- Fecha actual
    activo BOOLEAN DEFAULT TRUE,                 -- TRUE si no se especifica
    contador INT DEFAULT 0,                      -- Empieza en 0
    pais VARCHAR(50) DEFAULT 'España',          -- Valor fijo
    
    -- CHECK (validación personalizada)
    edad INT CHECK (edad >= 18 AND edad <= 100), -- Entre 18 y 100
    precio DECIMAL(10,2) CHECK (precio > 0),     -- Debe ser positivo
    email_check VARCHAR(100) CHECK (email_check LIKE '%@%'),
    
    -- COMMENT (documentación inline)
    codigo_interno VARCHAR(20) COMMENT 'Código de uso interno, no mostrar a clientes',
    
    -- UNSIGNED (solo positivos)
    stock INT UNSIGNED DEFAULT 0,                -- No puede ser negativo
    
    -- Combinaciones comunes
    usuario_id INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    email_profesional VARCHAR(100) NOT NULL UNIQUE DEFAULT 'noreply@empresa.com'
);

-- ═══════════════════════════════════════════════════════════════
--                    VALORES GENERADOS (COMPUTED COLUMNS)
-- ═══════════════════════════════════════════════════════════════

-- MySQL 5.7+: Columnas calculadas
CREATE TABLE Rectangulo (
    base DECIMAL(8,2) NOT NULL,
    altura DECIMAL(8,2) NOT NULL,
    area DECIMAL(10,2) AS (base * altura) STORED,        -- Almacenada físicamente
    perimetro DECIMAL(10,2) AS (2 * (base + altura)) VIRTUAL  -- Calculada al consultar
);

-- PostgreSQL: Columnas generadas (desde v12)
CREATE TABLE Factura (
    subtotal DECIMAL(10,2) NOT NULL,
    iva_porcentaje DECIMAL(5,2) DEFAULT 21,
    iva_importe DECIMAL(10,2) GENERATED ALWAYS AS (subtotal * iva_porcentaje / 100) STORED,
    total DECIMAL(10,2) GENERATED ALWAYS AS (subtotal + iva_importe) STORED
);

-- Diferencia STORED vs VIRTUAL:
-- STORED: Se calcula al INSERT/UPDATE y se guarda físicamente (ocupa espacio, más rápido en SELECT)
-- VIRTUAL: Se calcula cada vez que se consulta (no ocupa espacio, más lento en SELECT)