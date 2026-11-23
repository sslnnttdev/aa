-- Ejemplo completo mostrando todos los subconjuntos

-- ═══════════════════════════════════════════════════════════════
--                    DDL - Data Definition Language
-- ═══════════════════════════════════════════════════════════════

-- Crear base de datos
CREATE DATABASE mi_tienda;
USE mi_tienda;

-- Crear tabla
CREATE TABLE Productos (
    producto_id INT AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(100) NOT NULL,
    precio DECIMAL(10,2) CHECK (precio > 0),
    stock INT DEFAULT 0
);

-- Modificar estructura
ALTER TABLE Productos ADD COLUMN categoria VARCHAR(50);

-- ═══════════════════════════════════════════════════════════════
--                    DML - Data Manipulation Language
-- ═══════════════════════════════════════════════════════════════

-- Insertar datos
INSERT INTO Productos (nombre, precio, stock, categoria)
VALUES ('Laptop', 999.99, 10, 'Electrónica');

-- Actualizar datos
UPDATE Productos
SET stock = stock - 1
WHERE producto_id = 1;

-- Eliminar datos
DELETE FROM Productos
WHERE stock = 0;

-- ═══════════════════════════════════════════════════════════════
--                    DQL - Data Query Language
-- ═══════════════════════════════════════════════════════════════

-- Consultar datos
SELECT nombre, precio, stock
FROM Productos
WHERE categoria = 'Electrónica'
ORDER BY precio DESC;

-- ═══════════════════════════════════════════════════════════════
--                    DCL - Data Control Language
-- ═══════════════════════════════════════════════════════════════

-- Crear usuario
CREATE USER 'app_user'@'localhost' IDENTIFIED BY 'password123';

-- Otorgar permisos
GRANT SELECT, INSERT, UPDATE ON mi_tienda.Productos TO 'app_user'@'localhost';

-- Revocar permisos
REVOKE INSERT ON mi_tienda.Productos FROM 'app_user'@'localhost';

-- ═══════════════════════════════════════════════════════════════
--                    TCL - Transaction Control Language
-- ═══════════════════════════════════════════════════════════════

-- Iniciar transacción
START TRANSACTION;

-- Operaciones dentro de la transacción
UPDATE Productos SET stock = stock - 1 WHERE producto_id = 1;
INSERT INTO Ventas (producto_id, cantidad) VALUES (1, 1);

-- Si todo va bien: confirmar
COMMIT;

-- Si hay error: deshacer
-- ROLLBACK;