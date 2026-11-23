-- ═══════════════════════════════════════════════════════════════
--                    SINTAXIS BÁSICA
-- ═══════════════════════════════════════════════════════════════

-- MySQL: Crear base de datos simple
CREATE DATABASE mi_aplicacion;

-- Crear solo si no existe (evita errores)
CREATE DATABASE IF NOT EXISTS mi_aplicacion;

-- PostgreSQL: Sintaxis idéntica
CREATE DATABASE mi_aplicacion;

-- ═══════════════════════════════════════════════════════════════
--                    OPCIONES DE CONFIGURACIÓN
-- ═══════════════════════════════════════════════════════════════

-- MySQL: Con codificación de caracteres y collation
CREATE DATABASE tienda_online
    CHARACTER SET utf8mb4           -- Codificación: UTF-8 completo (emojis, etc.)
    COLLATE utf8mb4_unicode_ci;     -- Comparación: case-insensitive, Unicode

-- Opciones de CHARACTER SET comunes:
-- - utf8mb4: Recomendado (soporta todos los caracteres Unicode, incluidos emojis)
-- - utf8: Antiguo, no soporta caracteres de 4 bytes (evitar)
-- - latin1: Solo caracteres latinos (inglés, español básico)
-- - ascii: Solo ASCII 7-bit (muy limitado)

-- Opciones de COLLATE (reglas de comparación):
-- - utf8mb4_unicode_ci: Case-insensitive, Unicode correcto (recomendado)
-- - utf8mb4_general_ci: Más rápido pero menos preciso en comparaciones
-- - utf8mb4_bin: Case-sensitive, comparación binaria

-- PostgreSQL: Con codificación y locale
CREATE DATABASE sistema_escolar
    WITH 
    ENCODING 'UTF8'                    -- Codificación UTF-8
    LC_COLLATE='es_ES.UTF-8'           -- Locale para comparación (español)
    LC_CTYPE='es_ES.UTF-8'             -- Locale para clasificación de caracteres
    TEMPLATE=template0;                -- Plantilla base limpia

-- PostgreSQL: Con propietario específico
CREATE DATABASE blog_personal
    WITH 
    OWNER = usuario_blog
    ENCODING = 'UTF8';

-- ═══════════════════════════════════════════════════════════════
--                    USO Y SELECCIÓN
-- ═══════════════════════════════════════════════════════════════

-- MySQL: Seleccionar BD para usar
USE mi_aplicacion;

-- PostgreSQL: Conectar a BD (desde psql o cliente)
\c mi_aplicacion

-- SQL Server: Similar a MySQL
USE mi_aplicacion;
GO

-- SQLite: La BD es un archivo, se especifica al conectar
-- sqlite3 mi_aplicacion.db