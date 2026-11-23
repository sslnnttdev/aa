-- ═══════════════════════════════════════════════════════════════
--                    SINTAXIS BÁSICA
-- ═══════════════════════════════════════════════════════════════

-- Estructura general
CREATE TABLE nombre_tabla (
    columna1 tipo_dato [restricciones],
    columna2 tipo_dato [restricciones],
    ...
    [restricciones_de_tabla]
) [opciones_motor];

-- Ejemplo mínimo
CREATE TABLE Clientes (
    cliente_id INT,
    nombre VARCHAR(100),
    email VARCHAR(100)
);

-- Con IF NOT EXISTS (evita error si ya existe)
CREATE TABLE IF NOT EXISTS Productos (
    producto_id INT,
    nombre VARCHAR(100),
    precio DECIMAL(10,2)
);

-- ═══════════════════════════════════════════════════════════════
--                    EJEMPLO COMPLETO PROFESIONAL
-- ═══════════════════════════════════════════════════════════════

CREATE TABLE IF NOT EXISTS Empleados (
    -- Columnas con restricciones inline
    empleado_id INT AUTO_INCREMENT,                    -- PK autogenerada
    nombre VARCHAR(50) NOT NULL,                       -- Obligatorio
    apellido VARCHAR(50) NOT NULL,                     -- Obligatorio
    email VARCHAR(100) NOT NULL UNIQUE,                -- Único y obligatorio
    telefono VARCHAR(20),                              -- Opcional
    fecha_nacimiento DATE,
    fecha_ingreso DATE NOT NULL DEFAULT (CURRENT_DATE),
    salario DECIMAL(10,2) CHECK (salario > 0),        -- Debe ser positivo
    departamento_id INT,
    activo BOOLEAN DEFAULT TRUE,
    
    -- Restricciones a nivel de tabla
    PRIMARY KEY (empleado_id),                         -- Clave primaria
    UNIQUE KEY uk_email (email),                       -- Índice único con nombre
    FOREIGN KEY (departamento_id) 
        REFERENCES Departamentos(departamento_id)
        ON DELETE SET NULL
        ON UPDATE CASCADE,
    CHECK (fecha_ingreso >= fecha_nacimiento),         -- Validación lógica
    
    -- Índices
    INDEX idx_apellido (apellido),
    INDEX idx_departamento (departamento_id)
    
) ENGINE=InnoDB                                        -- Motor MySQL
  DEFAULT CHARSET=utf8mb4
  COLLATE=utf8mb4_unicode_ci
  COMMENT='Tabla de empleados de la empresa';