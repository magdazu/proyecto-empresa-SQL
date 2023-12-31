USE empresa;

CREATE TABLE cliente (
DNI VARCHAR (11) PRIMARY KEY NOT NULL,
NOMBRE VARCHAR(100) NOT NULL,
DIRECCION VARCHAR(150),
BARRIO VARCHAR(50),
CIUDAD VARCHAR(50),
ESTADO VARCHAR(10),
CP VARCHAR(10),
FECHA_NAC DATE,
EDAD SMALLINT,
SEXO VARCHAR(1),
LIMITE_CRED FLOAT,
VOLUMEN_COMP FLOAT,
PRIMERA_COMP BIT
);

CREATE TABLE producto(
CODIGO VARCHAR(10) PRIMARY KEY NOT NULL,
DESCRIPCION VARCHAR (100),
SABOR VARCHAR (50),
TAMANO VARCHAR (50),
ENVASE VARCHAR (50),
PRECIO FLOAT 
);

CREATE TABLE factura(
NUMERO INT PRIMARY KEY NOT NULL,
FECHA DATE,
DNI VARCHAR (11) NOT NULL,
MATRICULA VARCHAR (5),
IMPUESTO FLOAT,
FOREIGN KEY (DNI) REFERENCES cliente(DNI),
FOREIGN KEY (MATRICULA) REFERENCES vendedor(MATRICULA)
);

CREATE TABLE item(
NUMERO  INT NOT NULL,
CODIGO VARCHAR (10) NOT NULL,
CANTIDAD INT,
PRECIO FLOAT,
PRIMARY KEY (NUMERO, CODIGO),
FOREIGN KEY (NUMERO) REFERENCES factura(NUMERO),
FOREIGN KEY (CODIGO) REFERENCES producto(CODIGO)
);

ALTER TABLE Productos RENAME producto;
ALTER TABLE Clientes RENAME cliente;
ALTER TABLE cliente CHANGE VOLUMNE_COMP VOLUMEN_COMP FLOAT;
SELECT * FROM cliente;

INSERT INTO factura
SELECT NUMERO, FECHA_VENTA AS FECHA, DNI, MATRICULA, IMPUESTO
FROM jugos_ventas.facturas;

INSERT INTO item
SELECT NUMERO, CODIGO_DEL_PRODUCTO AS CODIGO, CANTIDAD, PRECIO 
FROM jugos_ventas.items_facturas;  

INSERT INTO producto
SELECT CODIGO_DEL_PRODUCTO AS CODIGO, NOMBRE_DEL_PRODUCTO AS DESCRIPCION, SABOR, TAMANO, ENVASE, PRECIO_DE_LISTA AS PRECIO
FROM jugos_ventas.tabla_de_productos;

SELECT * FROM cliente;
SELECT * FROM vendedor;
SELECT * FROM factura;

SET GLOBAL log_bin_trust_function_creators = 1;

SELECT f_cliente_aleatorio() AS CLIENTE;

SELECT MAX(NUMERO) FROM factura;
SELECT COUNT(*) FROM factura;
CALL sp_venta('20210619', 5, 100);

CALL sp_venta('20210619', 20, 100);

DROP  TRIGGER TG_FACTURACION_INSERT;
DROP  TRIGGER TG_FACTURACION_DELETE;
DROP  TRIGGER TG_FACTURACION_UPDATE;

DELIMITER //
CREATE TRIGGER TG_FACTURACION_INSERT 
AFTER INSERT ON item
FOR EACH ROW BEGIN
  CALL sp_triggers;
END //

DELIMITER //
CREATE TRIGGER TG_FACTURACION_DELETE
AFTER DELETE ON item
FOR EACH ROW BEGIN
  CALL sp_triggers;
END //

DELIMITER //
CREATE TRIGGER TG_FACTURACION_UPDATE
AFTER UPDATE ON item
FOR EACH ROW BEGIN
  CALL sp_triggers;
END //



