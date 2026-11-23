-- ═══════════════════════════════════════════════════════════════
--                    ELIMINACIÓN DE BASE DE DATOS
-- ═══════════════════════════════════════════════════════════════

-- MySQL: Eliminar base de datos
DROP DATABASE mi_aplicacion;

-- Con verificación (no error si no existe)
DROP DATABASE IF EXISTS mi_aplicacion;

-- PostgreSQL: Idéntico
DROP DATABASE IF EXISTS mi_aplicacion;

-- ⚠️ ERROR común: No puedes borrar la BD a la que estás conectado
-- MySQL:
USE mysql;                           -- Cambia a otra BD primero
DROP DATABASE mi_aplicacion;         -- Ahora sí

-- PostgreSQL:
\c postgres                          -- Cambia a BD postgres
DROP DATABASE mi_aplicacion;

-- ═══════════════════════════════════════════════════════════════
--                    PRECAUCIONES ANTES DE ELIMINAR
-- ═══════════════════════════════════════════════════════════════

-- 1. Verificar que es la BD correcta
SELECT DATABASE();                   -- MySQL: Muestra BD actual
SELECT current_database();           -- PostgreSQL

-- 2. Hacer backup ANTES de eliminar
-- MySQL:
mysqldump -u usuario -p mi_aplicacion > backup_mi_aplicacion_$(date +%Y%m%d).sql

-- PostgreSQL:
pg_dump -U usuario mi_aplicacion > backup_mi_aplicacion_$(date +%Y%m%d).sql

-- 3. Verificar conexiones activas (PostgreSQL)
SELECT * FROM pg_stat_activity WHERE datname = 'mi_aplicacion';

-- Terminar conexiones activas (PostgreSQL)
SELECT pg_terminate_backend(pid)
FROM pg_stat_activity
WHERE datname = 'mi_aplicacion' AND pid <> pg_backend_pid();

-- MySQL: Verificar procesos
SHOW PROCESSLIST;

-- ═══════════════════════════════════════════════════════════════
--                    RECREACIÓN DESDE BACKUP
-- ═══════════════════════════════════════════════════════════════

-- MySQL: Restaurar desde backup
CREATE DATABASE mi_aplicacion CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
mysql -u usuario -p mi_aplicacion < backup_mi_aplicacion_20240101.sql

-- PostgreSQL: Restaurar desde backup
CREATE DATABASE mi_aplicacion;
psql -U usuario mi_aplicacion < backup_mi_aplicacion_20240101.sql

-- ═══════════════════════════════════════════════════════════════
--                    ALTERNATIVAS MÁS SEGURAS
-- ═══════════════════════════════════════════════════════════════

-- En lugar de DROP DATABASE, considera:

-- 1. Renombrar la BD (mantener como backup)
-- MySQL:
RENAME DATABASE old_app TO old_app_backup_20240101;  -- Obsoleto, usar dump/restore

-- Mejor: mysqldump + CREATE con nuevo nombre
-- PostgreSQL:
ALTER DATABASE old_app RENAME TO old_app_backup_20240101;

-- 2. Exportar antes de eliminar (mysqldump ya mostrado)

-- 3. En entorno de desarrollo: usar contenedores Docker
-- Destruir y recrear contenedor en lugar de DROP DATABASE