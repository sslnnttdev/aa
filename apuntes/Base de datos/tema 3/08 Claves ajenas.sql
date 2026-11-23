-- ═══════════════════════════════════════════════════════════════
--                    SINTAXIS BÁSICA
-- ═══════════════════════════════════════════════════════════════

-- Tabla padre
CREATE TABLE Departamentos (
    departamento_id INT AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(100) NOT NULL UNIQUE
);

-- Tabla hija con FK inline
CREATE TABLE Empleados (
    empleado_id INT AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(100) NOT NULL,
    departamento_id INT,
    FOREIGN KEY (departamento_id) REFERENCES Departamentos(departamento_id)
);

-- Con nombre de constraint (mejor para debugging)
CREATE TABLE Empleados (
    empleado_id INT AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(100) NOT NULL,
    departamento_id INT,
    CONSTRAINT fk_empleados_departamento
        FOREIGN KEY (departamento_id)
        REFERENCES Departamentos(departamento_id)
);

-- ═══════════════════════════════════════════════════════════════
--                    ACCIONES REFERENCIALES
-- ═══════════════════════════════════════════════════════════════

CREATE TABLE Pedidos (
    pedido_id INT AUTO_INCREMENT PRIMARY KEY,
    cliente_id INT NOT NULL,
    fecha DATE NOT NULL,
    total DECIMAL(10,2),
    
    FOREIGN KEY (cliente_id) REFERENCES Clientes(cliente_id)
        ON DELETE RESTRICT   -- No permitir borrar cliente con pedidos
        ON UPDATE CASCADE    -- Si cambio cliente_id, actualizar en Pedidos
);

-- Todas las opciones de acciones referenciales
CREATE TABLE Comentarios (
    comentario_id INT AUTO_INCREMENT PRIMARY KEY,
    articulo_id INT,
    usuario_id INT,
    texto TEXT NOT NULL,
    
    -- CASCADE: Borrar comentarios al borrar artículo
    FOREIGN KEY (articulo_id) REFERENCES Articulos(articulo_id)
        ON DELETE CASCADE
        ON UPDATE CASCADE,
    
    -- SET NULL: Poner NULL si se borra usuario (comentario anónimo)
    FOREIGN KEY (usuario_id) REFERENCES Usuarios(usuario_id)
        ON DELETE SET NULL
        ON UPDATE CASCADE
);

-- SET DEFAULT (MySQL no soporta, PostgreSQL sí)
-- PostgreSQL:
CREATE TABLE Productos (
    producto_id SERIAL PRIMARY KEY,
    categoria_id INT DEFAULT 1,  -- Categoría "sin clasificar"
    nombre VARCHAR(100) NOT NULL,
    
    FOREIGN KEY (categoria_id) REFERENCES Categorias(categoria_id)
        ON DELETE SET DEFAULT  -- Si borro categoría, usar categoría 1
);

-- ═══════════════════════════════════════════════════════════════
--                    CLAVES AJENAS COMPUESTAS
-- ═══════════════════════════════════════════════════════════════

-- Referencia a clave primaria compuesta
CREATE TABLE Inscripciones (
    inscripcion_id INT AUTO_INCREMENT PRIMARY KEY,
    estudiante_id INT,
    asignatura_id INT,
    fecha DATE NOT NULL,
    
    FOREIGN KEY (estudiante_id, asignatura_id)
        REFERENCES Matriculas(estudiante_id, asignatura_id)
        ON DELETE CASCADE
);

-- ═══════════════════════════════════════════════════════════════
--                    CLAVES AJENAS AUTO-REFERENCIALES
-- ═══════════════════════════════════════════════════════════════

-- Jerarquía de empleados (cada empleado tiene un supervisor)
CREATE TABLE Empleados (
    empleado_id INT AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(100) NOT NULL,
    supervisor_id INT,
    
    FOREIGN KEY (supervisor_id) REFERENCES Empleados(empleado_id)
        ON DELETE SET NULL  -- Si borro supervisor, empleado queda sin supervisor
);

-- Categorías anidadas (padre-hijo)
CREATE TABLE Categorias (
    categoria_id INT AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(100) NOT NULL,
    categoria_padre_id INT,
    
    FOREIGN KEY (categoria_padre_id) REFERENCES Categorias(categoria_id)
        ON DELETE CASCADE  -- Borrar subcategorías al borrar categoría padre
);

-- ═══════════════════════════════════════════════════════════════
--                    VERIFICACIÓN Y DEBUGGING
-- ═══════════════════════════════════════════════════════════════

-- MySQL: Ver claves foráneas de una tabla
SHOW CREATE TABLE Empleados;

-- Información detallada desde information_schema
SELECT
    CONSTRAINT_NAME,
    TABLE_NAME,
    COLUMN_NAME,
    REFERENCED_TABLE_NAME,
    REFERENCED_COLUMN_NAME
FROM information_schema.KEY_COLUMN_USAGE
WHERE TABLE_SCHEMA = 'mi_bd'
  AND TABLE_NAME = 'Empleados'
  AND REFERENCED_TABLE_NAME IS NOT NULL;

-- PostgreSQL: Ver FKs
\d+ empleados  -- En psql

SELECT
    tc.constraint_name,
    tc.table_name,
    kcu.column_name,
    ccu.table_name AS foreign_table_name,
    ccu.column_name AS foreign_column_name,
    rc.update_rule,
    rc.delete_rule
FROM information_schema.table_constraints AS tc
JOIN information_schema.key_column_usage AS kcu
    ON tc.constraint_name = kcu.constraint_name
JOIN information_schema.constraint_column_usage AS ccu
    ON ccu.constraint_name = tc.constraint_name
JOIN information_schema.referential_constraints AS rc
    ON rc.constraint_name = tc.constraint_name
WHERE tc.constraint_type = 'FOREIGN KEY'
  AND tc.table_name = 'empleados';