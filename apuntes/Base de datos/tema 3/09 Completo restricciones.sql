-- ═══════════════════════════════════════════════════════════════
--                    TABLA CON TODAS LAS RESTRICCIONES
-- ═══════════════════════════════════════════════════════════════

CREATE TABLE Cuentas_Bancarias (
    -- Clave primaria
    cuenta_id INT AUTO_INCREMENT PRIMARY KEY,
    
    -- NOT NULL (obligatorios)
    titular VARCHAR(100) NOT NULL,
    iban CHAR(24) NOT NULL,
    fecha_apertura DATE NOT NULL DEFAULT (CURRENT_DATE),
    
    -- UNIQUE (únicos)
    iban_unico CHAR(24) UNIQUE NOT NULL,  -- inline
    
    -- CHECK (validaciones personalizadas)
    saldo DECIMAL(12,2) DEFAULT 0.00 
        CHECK (saldo >= -1000.00),  -- Descubierto máximo 1000€
    
    tipo_cuenta ENUM('corriente', 'ahorro', 'nomina') NOT NULL,
    
    fecha_cierre DATE,
    
    -- CHECK con múltiples columnas
    CONSTRAINT chk_fechas CHECK (
        fecha_cierre IS NULL OR fecha_cierre > fecha_apertura
    ),
    
    -- CHECK: cuenta ahorro no puede tener descubierto
    CONSTRAINT chk_ahorro_sin_descubierto CHECK (
        tipo_cuenta != 'ahorro' OR saldo >= 0
    ),
    
    -- UNIQUE con nombre (permite índice único multi-columna)
    CONSTRAINT uk_titular_iban UNIQUE (titular, iban),
    
    -- Índices para rendimiento
    INDEX idx_titular (titular),
    INDEX idx_tipo (tipo_cuenta),
    INDEX idx_saldo (saldo)
    
) ENGINE=InnoDB
  DEFAULT CHARSET=utf8mb4
  COLLATE=utf8mb4_unicode_ci;

-- ═══════════════════════════════════════════════════════════════
--                    RESTRICCIONES COMPLEJAS
-- ═══════════════════════════════════════════════════════════════

CREATE TABLE Reservas (
    reserva_id INT AUTO_INCREMENT PRIMARY KEY,
    usuario_id INT NOT NULL,
    recurso_id INT NOT NULL,
    fecha_inicio DATETIME NOT NULL,
    fecha_fin DATETIME NOT NULL,
    estado ENUM('pendiente', 'confirmada', 'cancelada') DEFAULT 'pendiente',
    
    -- CHECK: fin después de inicio
    CONSTRAINT chk_fechas_logicas CHECK (fecha_fin > fecha_inicio),
    
    -- CHECK: reserva máximo 30 días
    CONSTRAINT chk_duracion_maxima CHECK (
        DATEDIFF(fecha_fin, fecha_inicio) <= 30
    ),
    
    -- CHECK: no reservar en el pasado
    CONSTRAINT chk_no_pasado CHECK (fecha_inicio >= CURRENT_TIMESTAMP),
    
    -- UNIQUE: un usuario no puede tener dos reservas del mismo recurso
    -- que se solapen en fechas (NO soportado directamente, requiere trigger)
    CONSTRAINT uk_usuario_recurso UNIQUE (usuario_id, recurso_id, fecha_inicio),
    
    -- FKs
    FOREIGN KEY (usuario_id) REFERENCES Usuarios(usuario_id)
        ON DELETE CASCADE,
    FOREIGN KEY (recurso_id) REFERENCES Recursos(recurso_id)
        ON DELETE RESTRICT
);

-- ═══════════════════════════════════════════════════════════════
--                    GESTIÓN DE CONSTRAINTS
-- ═══════════════════════════════════════════════════════════════

-- Ver todas las restricciones de una tabla
-- MySQL:
SELECT CONSTRAINT_NAME, CONSTRAINT_TYPE
FROM information_schema.TABLE_CONSTRAINTS
WHERE TABLE_SCHEMA = 'mi_bd' AND TABLE_NAME = 'Cuentas_Bancarias';

-- Ver CHECKs específicos (MySQL 8.0.16+)
SELECT CONSTRAINT_NAME, CHECK_CLAUSE
FROM information_schema.CHECK_CONSTRAINTS
WHERE CONSTRAINT_SCHEMA = 'mi_bd';

-- PostgreSQL:
\d+ cuentas_bancarias  -- Muestra constraints

SELECT conname AS constraint_name,
       pg_get_constraintdef(oid) AS constraint_definition
FROM pg_constraint
WHERE conrelid = 'cuentas_bancarias'::regclass;