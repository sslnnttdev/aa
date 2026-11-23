

CREATE DATABASE DEPARTAMENTOS;
USE DEPARTAMENTOS;
SET FOREIGN_KEY_CHECKS=0;

-- ----------------------------
-- Table structure for departamentos
-- ----------------------------
DROP TABLE IF EXISTS  departamentos ;
CREATE TABLE  departamentos  (
   NumeroDepartamento  int(11) NOT NULL AUTO_INCREMENT,
   Nombre  varchar(50) DEFAULT NULL,
   Presupuesto  decimal(10,2) DEFAULT NULL,
  PRIMARY KEY ( NumeroDepartamento )
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=latin1;

-- ----------------------------
-- Records of departamentos
-- ----------------------------
INSERT INTO  departamentos  VALUES ('1', 'Nóminas', '12000.00');
INSERT INTO  departamentos  VALUES ('2', 'Personal', '10000.00');
INSERT INTO  departamentos  VALUES ('3', 'Informática', '24000.00');
INSERT INTO  departamentos  VALUES ('4', 'Administración', '2999.00');

-- ----------------------------
-- Table structure for empleados
-- ----------------------------
DROP TABLE IF EXISTS  empleados ;
CREATE TABLE  empleados  (
   NumeroEmpleado  int(11) NOT NULL AUTO_INCREMENT,
   Nombre  varchar(50) DEFAULT NULL,
   Salario  decimal(8,2) DEFAULT NULL,
   Comision  decimal(8,2) DEFAULT NULL,
   Departamento  int(11) DEFAULT NULL,
   Email  varchar(50) DEFAULT NULL,
   Telefono  varchar(12) DEFAULT NULL,
  PRIMARY KEY ( NumeroEmpleado ),
  KEY  FK_DEP  ( Departamento ),
  CONSTRAINT  FK_DEP  FOREIGN KEY ( Departamento ) REFERENCES  departamentos  ( NumeroDepartamento )
) ENGINE=InnoDB AUTO_INCREMENT=8 DEFAULT CHARSET=latin1;

-- ----------------------------
-- Records of empleados
-- ----------------------------
INSERT INTO  empleados  VALUES ('1', 'Luis Salas', '1000.00', '501.00', '1', 'luis@gmail.com', '33333');
INSERT INTO  empleados  VALUES ('2', 'Carlos Sainz', '2000.00', '200.00', '2', 'carlos@gmail.com', '44444');
INSERT INTO  empleados  VALUES ('3', 'Eva Hache', '1000.00', '100.00', '2', 'eva@gmail.com', '333332');
INSERT INTO  empleados  VALUES ('4', 'Faemino Cansado', '2100.00', '550.00', '3', 'faemino@gmail.com', '23423');
INSERT INTO  empleados  VALUES ('5', 'Goyo Jiménez', '3000.00', '200.00', '4', 'goyo@gmail.com', '2342343');
INSERT INTO  empleados  VALUES ('6', 'Dani Rovira', null, null, null, 'rovira@gmail.com', '383838');
INSERT INTO  empleados  VALUES ('7', 'Enrique Saenz', null, null, null, null, null);
