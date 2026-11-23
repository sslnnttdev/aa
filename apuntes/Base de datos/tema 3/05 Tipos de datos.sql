-- ═══════════════════════════════════════════════════════════════
--                    TIPOS NUMÉRICOS
-- ═══════════════════════════════════════════════════════════════

CREATE TABLE Ejemplo_Numeros (
    -- Enteros
    tiny TINYINT,              -- -128 a 127 (1 byte)
    small SMALLINT,            -- -32,768 a 32,767 (2 bytes)
    mediano INT,               -- -2.1B a 2.1B (4 bytes) - MÁS COMÚN
    grande BIGINT,             -- -9.2 quintillones (8 bytes)
    
    -- Sin signo (solo positivos, duplica rango)
    contador INT UNSIGNED,     -- 0 a 4.2 mil millones
    
    -- Decimales exactos (para dinero)
    precio DECIMAL(10,2),      -- 10 dígitos total, 2 decimales → 99999999.99
    saldo NUMERIC(15,2),       -- Sinónimo de DECIMAL
    
    -- Punto flotante (científicos, no dinero)
    temperatura FLOAT,         -- Precisión simple
    distancia DOUBLE,          -- Precisión doble
    
    -- Booleanos (MySQL usa TINYINT(1))
    activo BOOLEAN,            -- 0=FALSE, 1=TRUE
    verificado BOOL            -- Sinónimo
);

-- ═══════════════════════════════════════════════════════════════
--                    TIPOS DE TEXTO
-- ═══════════════════════════════════════════════════════════════

CREATE TABLE Ejemplo_Texto (
    -- Longitud fija (rellena con espacios)
    codigo_pais CHAR(2),       -- Siempre 2 caracteres: 'ES', 'US'
    codigo_postal CHAR(5),     -- '28001', '90210'
    
    -- Longitud variable (recomendado)
    nombre VARCHAR(50),        -- Hasta 50 caracteres
    email VARCHAR(100),        -- Hasta 100 caracteres
    url VARCHAR(500),          -- URLs largas
    
    -- Textos largos
    descripcion TEXT,          -- Hasta 65,535 caracteres (~64 KB)
    articulo MEDIUMTEXT,       -- Hasta 16 MB
    libro_completo LONGTEXT,   -- Hasta 4 GB
    
    -- Enumerados (solo valores predefinidos)
    estado ENUM('pendiente', 'procesado', 'enviado', 'entregado'),
    prioridad ENUM('baja', 'media', 'alta', 'urgente') DEFAULT 'media',
    
    -- Set (múltiples valores)
    permisos SET('lectura', 'escritura', 'ejecucion', 'admin')
);

-- ═══════════════════════════════════════════════════════════════
--                    TIPOS TEMPORALES
-- ═══════════════════════════════════════════════════════════════

CREATE TABLE Ejemplo_Fechas (
    -- Solo fecha
    fecha_nacimiento DATE,                -- 'YYYY-MM-DD': '2000-01-15'
    
    -- Solo hora
    hora_inicio TIME,                     -- 'HH:MM:SS': '14:30:00'
    duracion TIME,                        -- También para intervalos
    
    -- Fecha + hora
    creado_en DATETIME,                   -- 'YYYY-MM-DD HH:MM:SS'
    modificado_en DATETIME DEFAULT CURRENT_TIMESTAMP,
    
    -- Timestamp (auto-actualizable)
    registro TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    actualizado TIMESTAMP DEFAULT CURRENT_TIMESTAMP 
                         ON UPDATE CURRENT_TIMESTAMP,
    
    -- Solo año
    año_produccion YEAR                   -- 1901 a 2155
);

-- ═══════════════════════════════════════════════════════════════
--                    TIPOS ESPECIALES
-- ═══════════════════════════════════════════════════════════════

CREATE TABLE Ejemplo_Especiales (
    -- JSON (MySQL 5.7+, PostgreSQL 9.2+)
    metadatos JSON,                       -- Datos estructurados flexibles
    configuracion JSON,
    
    -- UUID (PostgreSQL nativo, MySQL como texto)
    sesion_id CHAR(36),                   -- '550e8400-e29b-41d4-a716-446655440000'
    
    -- Binarios
    imagen BLOB,                          -- Binary Large Object, hasta 65 KB
    documento MEDIUMBLOB,                 -- Hasta 16 MB
    video LONGBLOB,                       -- Hasta 4 GB
    
    -- Geoespacial (MySQL 5.7+, PostgreSQL con PostGIS)
    ubicacion POINT,                      -- Coordenadas (lat, lon)
    zona POLYGON,                         -- Área geográfica
    ruta LINESTRING                       -- Línea de puntos
);