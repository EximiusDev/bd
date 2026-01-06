-- USANDO DataBase pubs:

USE pubs;
/*
 ============================================
Sobre SQL Server: 
 ============================================
 */
------------------------------------------------------------------------

/*
 ============================================
 SQL: Guía de Trabajo Nro. 2  
Data Manipulation Language 
 ============================================
 */

/*
-------------------------------------------------------------------------
-------------------------------------------------------------------------
1. Pre-requisitos 
-------------------------------------------------------------------------
-------------------------------------------------------------------------
*/


 ------------------------------------------------------------------------- 
 ---------------------- E j e r c i c i o   1 ---------------------------- 
 ------------------------------------------------------------------------.
/*
Ejercicio 1.  A continuación definiremos un pequeño esquema de tablas para realizar 
ejercicios de manipulación de datos. Sobre la base de datos pubs ejecute las siguientes 
sentencias SQL. No importa si observan cláusulas que no conocen. Las analizaremos a 
continuación: 
 */

/*
 ============================================
Sobre SQL Server: 
 ============================================
 */

CREATE TABLE cliente  
  ( 
   codCli  	int  			NOT NULL,  
   ape   	varchar(30) 	NOT NULL, 
   nom  	varchar(30)  	NOT NULL, 
   dir  	varchar(40) 	NOT NULL, 
   codPost 	char(9) 		NULL 		DEFAULT 3000 
  );


CREATE TABLE productos  
  ( 
   codProd  	int  			NOT NULL, 
   descr   		varchar(30) 	NOT NULL, 
   precUnit 	float  			NOT NULL, 
   stock 		smallint 		NOT NULL 
  );


CREATE TABLE proveed  
  ( 
   codProv  	int  			IDENTITY(1,1), 
   razonSoc  	varchar(30) 	NOT NULL,  
   dir  		varchar(30)  	NOT NULL 
  ); 

 
CREATE TABLE pedidos  
  ( 
   numPed  		int  		NOT NULL, 
   fechPed   	datetime 	NOT NULL, 
   codCli 		int   		NOT NULL 
  ); 
 
 
 
CREATE TABLE detalle  
  ( 
   codDetalle  	int  	NOT NULL, 
   numPed  		int  	NOT NULL, 
   codProd    	int  	NOT NULL, 
   cant  		int   	NOT NULL, 
   precioTot  	float  	NULL 
  ); 


/*
En SQL Server, las columnas con valores autoincrementales se definen 
especificando la cláusula IDENTITY: 

CREATE TABLE proveed  ( 
   codProv  	int  					IDENTITY( A, B), 
   razonSoc  	varchar(30) 	NOT NULL,  
   dir  		varchar(30)  	NOT NULL 
  ); 
  
  La cláusula posee dos parámetros opcionales: SEED (A) y STEP (B). 
SEED es el valor inicial que recibirá la primer fila insertada. Su valor por 
omisión es 1.  
STEP es el valor de incremento entre filas consecutivas. Su valor por omisión 
también es 1. 
  
 */


/*
Secuencia (sequence) 
Una secuencia es una característica soportada por algunos DBMSs para generar valores 
enteros secuenciales únicos y asignárselos a columnas numéricas.  
 
Internamente, una secuencia es generalmente una tabla con una columna numérica en la 
cual se almacena un valor que es consultado e incrementado por el sistema. 
 */

/*
Secuencias 
SQL Server permite crear SEQUENCE objects desde la versión 2012.  
Ver (https://msdn.microsoft.com/en-us/library/ff878058.aspx) 
 */


/*
-------------------------------------------------------------------------
-------------------------------------------------------------------------
2. Inserción de filas 
-------------------------------------------------------------------------
-------------------------------------------------------------------------
*/

/*
 Recordemos que insertamos filas en una tabla a través de la sentencia ANSI SQL 
INSERT. La sintaxis simplificada de INSERT es la siguiente: 

INSERT [INTO] <tabla> 
   [ (<columna1>, <columna2> [, <columnan> ...] ) ] 
   VALUES ( <dato1> [, <dato2>...] )
   
    En PostgreSQL la cláusula INTO es obligatoria. 	 
 */
INSERT  
  cliente 
   (codcli, ape, nom, dir, codPost) 
   VALUES (1, 'CONGRESO ', 'MARIANO', ' Nacional 3020', NULL);

/*
 Si vamos a proporcionar datos para todas las columnas podemos omitir la lista de las 
mismas: 
INSERT [INTO] <tabla> 
   VALUES ( <dato1> [, <dato2>...] ) 
 */
INSERT  INTO cliente  
   VALUES (3, 'Peres ', 'Juan', ' Primera Calle 1000', NULL);

/*
 Los datos de tipo char o varchar se especifican entre comillas simples. Los valores 
de tipo float se especifican con un punto decimal. (Por ejemplo: 243.2). El formato 
de las fechas varía según la configuración del DBMS. Un formato usual es 
aaaa/mm/dd. El mismo se especifica entre comillas simples (Por ejemplo: 
'2007/11/30'). 
 */
INSERT  INTO pedidos  
(numPed, fechPed, codCli) 
   VALUES (1, '2007/11/30', 111);

 
 ------------------------------------------------------------------------- 
 ---------------------- E j e r c i c i o   2 ---------------------------- 
 ------------------------------------------------------------------------.
/*
Ejercicio 2. Inserte en la tabla cliente una fila con los siguientes datos:  
1, 'LOPEZ', 'JOSE MARIA', 'Gral. Paz 3124'. Permita que el código 
postal asuma el valor por omisión previsto. Verifique los datos insertados. 
*/
INSERT INTO cliente
(codcli, ape, nom, dir, codPost) 
VALUES (1, 'LOPEZ', 'JOSE MARIA', 'Gral. Paz 3124', DEFAULT);


SELECT * FROM CLIENTE;
/*
DELETE FROM cliente
WHERE codcli = 3;
*/
 ------------------------------------------------------------------------- 
 ---------------------- E j e r c i c i o   3 ---------------------------- 
 ------------------------------------------------------------------------.
/*
Ejercicio 3. Inserte en la tabla cliente una fila con los siguientes datos:  2, 'GERVASOLI', 
'MAURO', 'San Luis 472'. ¿Podemos  evitar que la fila asuma el valor por omisión para el 
código postal?. Verifique los datos insertados. 
*/

INSERT INTO cliente
VALUES (2, 'GERVASOLI', 'MAURO', 'San Luis 472', null);

SELECT * FROM CLIENTE;


 ------------------------------------------------------------------------- 
 ---------------------- E j e r c i c i o   4 ---------------------------- 
 ------------------------------------------------------------------------.
/*
Ejercicio 4. Inserte en la tabla proveed dos proveedores:  'FLUKE 
INGENIERIA', 'RUTA 9 Km. 80' y 'PVD PATCHES', 'Pinar de Rocha 
1154'. Verifique los datos insertados. 
*/

INSERT INTO proveed
( razonSoc, dir)
VALUES ('FLUKE INGENIERIA', 'RUTA 9 Km. 80'),
('PVD PATCHES', 'Pinar de Rocha 1154');

-- O sino

INSERT INTO proveed
( razonSoc, dir)
VALUES ('FLUKE INGENIERIA', 'RUTA 9 Km. 80');

INSERT INTO proveed
( razonSoc, dir)
VALUES ('PVD PATCHES', 'Pinar de Rocha 1154');

SELECT * FROM proveed;
/*
INSERT INTO proveedores
( codProv, razonSoc, dir)
VALUES ('FLUKE INGENIERIA', 'RUTA 9 Km. 80');
*/
 

/*
-------------------------------------------------------------------------
-------------------------------------------------------------------------
Información del sistema 
-------------------------------------------------------------------------
-------------------------------------------------------------------------
*/	

------------------------- Usuario actual 
/*
En SQL Server, la función USER retorna el usuario actual de la base de datos
 como una cadena de caracteres.
 */
SELECT USER;



------------------------- Fecha y hora actuales 
/*
Tal como vimos en la Guía de Trabajo Nro. 1, en la Sección 4.1. Fechas,  en SQL Server 
podemos obtener la fecha actual con la función CURRENT_TIMESTAMP y en PostgreSQL 
obtenemos esta información con las funciones  CURRENT_TIMESTAMP y now(). 
*/
select CURRENT_TIMESTAMP;
select now();

 ------------------------------------------------------------------------- 
 ---------------------- E j e r c i c i o   5 ---------------------------- 
 ------------------------------------------------------------------------.
/*
Ejercicio 5.  
Defina una tabla de ventas (Ventas) que contenga: -Un código de venta de tipo entero (codVent) autoincremental. -La fecha de carga de la venta (fechaVent) no nulo con la fecha actual como valor por 
omisión. -El nombre del usuario de la base de datos que cargó la venta (usuarioDB) no nulo con el 
usuario actual de la base de datos como valor por omisión. -El monto vendido (monto) de tipo FLOAT que admita nulos.
*/

CREATE TABLE Ventas(
   codVent  	int  			IDENTITY(1,1), 
   fechaVent   	date    		NOT NULL		DEFAULT CURRENT_TIMESTAMP, 
   usuarioDB 	varchar(40)   	NOT NULL		DEFAULT USER,
   monto		float			NULL
  );
 
-- DROP TABLE Ventas;
 ------------------------------------------------------------------------- 
 ---------------------- E j e r c i c i o   6 ---------------------------- 
 ------------------------------------------------------------------------.
/*
Ejercicio 6. Inserte dos ventas de $100 y $200 respectivamente. No proporcione ninguna 
información adicional. Verifique los datos insertados. 
*/

INSERT INTO ventas
(MONTO)
VALUES (100);

INSERT INTO ventas
(MONTO)
VALUES (200);


/*
-------------------------------------------------------------------------
-------------------------------------------------------------------------
Variantes de INSERT
-------------------------------------------------------------------------
-------------------------------------------------------------------------
*/	
/*
 Podemos crear una nueva tabla e insertar a la vez filas de una existente usando la 
sentencia SELECT con la cláusula INTO: 

SELECT <lista de columnas> 
   INTO <tabla-nueva> 
   FROM <tabla-existente> 
   WHERE <condicion> 
*/

/*
 Una variante de la sentencia INSERT permite que insertemos en una tabla los datos 
de salida de una sentencia SELECT. La tabla sobre la que vamos a insertar debe 
existir previamente: 

INSERT INTO <tabla-destino> 
   SELECT * 
      FROM <tabla-origen> 
      WHERE <condicion>
*/


 ------------------------------------------------------------------------- 
 ---------------------- E j e r c i c i o   7 ---------------------------- 
 ------------------------------------------------------------------------.
/*
Ejercicio 7. Cree una tabla llamada clistafe a partir de los datos de la tabla cliente para 
el código postal 3000. Verifique los datos de la nueva tabla. 
*/
CREATE TABLE clistafe (
codCli  	int  			NOT NULL, 
   ape   	varchar(30) 	NOT NULL, 
   nom  	varchar(30)  	NOT NULL, 
   dir  	varchar(40) 	NOT NULL, 
   codPost 	char(9) 		NULL 		DEFAULT 3000  
);

INSERT INTO clistafe 
   SELECT * 
      FROM cliente 
      WHERE codPost = '3000';

select * from CLISTAFE;



 ------------------------------------------------------------------------- 
 ---------------------- E j e r c i c i o   8 ---------------------------- 
 ------------------------------------------------------------------------.
/*
Ejercicio 8. Inserte en la tabla clistafe la totalidad de las filas de la tabla cliente. 
Verifique los datos insertados. 
 */
DELETE from CLISTAFE;

INSERT INTO clistafe 
   SELECT * 
      FROM cliente;

SELECT * FROM clistafe;
SELECT * FROM cliente;


/*
-------------------------------------------------------------------------
-------------------------------------------------------------------------
3. Modificación de datos 
-------------------------------------------------------------------------
-------------------------------------------------------------------------
*/	
/*
Recordemos que modificamos los datos de una o varias filas a través de la sentencia 
ANSI SQL UPDATE. La sintaxis simplificada de UPDATE es la siguiente: 

UPDATE <tabla> 
SET <col> = <nuevo valor-o-expres> [,<col> = <nuevo-valor-o-expres>...] 
WHERE <condición> 

Si omitimos la cláusula WHERE, todas las filas de la tabla resultan modificadas.  
 */


 ------------------------------------------------------------------------- 
 ---------------------- E j e r c i c i o   9 ---------------------------- 
 ------------------------------------------------------------------------.
/*
Ejercicio 9. En la tabla cliente, modifique el dato de domicilio. Para todas las columnas 
que incluyan el texto  '1' reemplace el mismo por 'TCM 168'. 
*/


UPDATE cliente 
SET dir = 'TCM 168' 
WHERE dir like '%1%';

select * from cliente;


/*
-------------------------------------------------------------------------
-------------------------------------------------------------------------
4. Eliminación de filas
-------------------------------------------------------------------------
-------------------------------------------------------------------------
*/	
/*
 Recordemos que eliminamos una o varias filas usando sentencia ANSI SQL DELETE. 
Su sintaxis simplificada es la siguiente: 

DELETE [FROM] <tabla> 
WHERE <condicion> 

Si omitimos la cláusula WHERE, todas las filas de la tabla resultan eliminadas.  

En PostgreSQL la cláusula FROM es obligatoria. 

Ej:
 */
DELETE from CLISTAFE;




------------------------------------------------------------------------- 
---------------------- E j e r c i c i o  10 ---------------------------- 
------------------------------------------------------------------------.
/*
Ejercicio 10. Elimine todos las filas de la tabla cliStaFe cuyo código postal sea nulo. 
*/

DELETE from CLISTAFE 
WHERE codPost IS NULL;

select * from CLISTAFE;


/*
-------------------------------------------------------------------------
-------------------------------------------------------------------------
5. Eliminar tablas
-------------------------------------------------------------------------
-------------------------------------------------------------------------
*/	
/*
Recordemos que eliminamos una tabla a través del comando ANSI SQL DROP TABLE. Por 
ejemplo, para eliminar la tabla cliente: 
Ej:
*/
DROP TABLE cliente;
 

/*
-------------------------------------------------------------------------
-------------------------------------------------------------------------
6. Obtener una copia de una tabla	
-------------------------------------------------------------------------
-------------------------------------------------------------------------
*/	
-- PostgreSQL:
/*
PostgreSQL proporciona una sintaxis especial CREATE TABLE para crear una tabla con 
una estructura idéntica a otra existente. En el siguiente ejemplo creamos una copia 
(vacía por supuesto) de la tabla titles:

CREATE TABLE titles10  
(LIKE titles); 
*/ 
/*
De todas maneras existen alternativas para obtener el mismo resultado sin usar 
CREATE TABLE. A continuación dos ejemplos: 
*/

SELECT *  
INTO titles10 
FROM titles 
WHERE 1=0; 

/*
SELECT *  
INTO titles10 
FROM titles 
LIMIT 0;
*/

SELECT * FROM titles10;
DROP TABLE titles10;



























