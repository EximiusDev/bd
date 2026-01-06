-- USANDO DataBase pubs:

USE pubs;

------------------------------------------------------------------------

/*
 ============================================
SQL: Guía de Trabajo Nro. 4  
Stored Procedures y functions: Retorno 
 ============================================
 */

/*
-------------------------------------------------------------------------
-------------------------------------------------------------------------
Ejercicios 
-------------------------------------------------------------------------
-------------------------------------------------------------------------
*/

-------------------------------------------------------------------------- 
----------------------- E j e r c i c i o   1 ---------------------------- 
-------------------------------------------------------------------------.
/*
 	Ejercicio 1.  
Escriba un SP T-SQL (obtenerPrecio) que proporcione el precio de cualquier publicación para 
la cual se proporcione un código.  
Testee su funcionamiento con un código de publicación. Por ejemplo, PS1372.
 */

-- SQL Server:
 CREATE PROCEDURE obtenerPrecio(
 		@p_pub_id char(4),
 		@P_precio float		OUTPUT	
 	)
 	AS
 		SELECT T.price FROM Titles T WHERE T. pub_id = @p_pub_id
 		PRINT 'Precio = $' + @P_precio + 'de la publicacion: '  + @p_pub_id
 	RETURN 0;


DECLARE @precio float
EXECUTE  obtenerPrecio 'PS1372', @precio OUTPUT; -- 0736


SELECT T.price FROM Titles T WHERE T. pub_id = 'PS1372'; -- 0736

-- O sino

 CREATE PROCEDURE obtenerPrecio0(
 		@p_pub_id char(4),
 		@P_precio float		OUTPUT	
 	)
 	AS
 	/*
Declare @price money, 
        @priceMaximo FLOAT; (?) 
        */
 		SELECT T.price FROM Titles T WHERE T. pub_id = @p_pub_id
		PRINT 'Precio = $' + @P_precio + 'de la publicacion: '  + @p_pub_id
		DECLARE @precio float
 	RETURN 0;


DECLARE @precio float
EXECUTE  obtenerPrecio0 1389, @precio OUTPUT;



--PostgreSQL:

CREATE TYPE type_precio1 
   AS ( 
       precio1 numeric 
      ); 


CREATE OR REPLACE FUNCTION obtenerPrecio(
		IN p_pub_id char(4)
	)
	RETURNS setof type_precio1
	AS
	$$
	DECLARE 
		--tipo_p type_precio%rowtype;
	begin
		RETURN QUERY
		SELECT T.price
			AS precio1
			 FROM Titles T WHERE T. pub_id = p_pub_id;
		RAISE NOTICE 'Precio de la publicacion: %'  , p_pub_id;
	--RETURN
	end
	$$
	LANGUAGE plpgsql;
	
	SELECT  *  
   FROM obtenerPrecio('PS1372'); --0736

   -- Recordemos que una función PL/pgSQL NO PERMITE el OUTPUT directo  de una sentencia SELECT.  
   
--DROP FUNCTION obtenerPrecio(char(4)
   

	)
/*
 CREATE OR REPLACE FUNCTION obtenerPrecio(
		IN p_pub_id char(4),
 		OUT P_precio float			
	)
	RETURNS type_precio
	AS
	$$
	DECLARE 
		--precio
	begin
		SELECT T.price
			INTO P_precio
			 FROM Titles T WHERE T. pub_id = p_pub_id
		RAISE NOTICE 'Precio = $ % de la publicacion: %'  , P_precio , p_pub_id
	--RETURN
	end
	$$
	LANGUAGE plpgsql;
 */
	

-------------------------------------------------------------------------- 
----------------------- E j e r c i c i o   2 ---------------------------- 
-------------------------------------------------------------------------.
/*
	Ejercicio 2.  
 
Escriba una función PL/pgSQL que dado un código de almacén (stor_id) y un número de 
factura (ord_num), retorne la fecha de dicha venta. 
 
Ejecútela para los siguientes parámetros: código de almacén 7067, número de orden 
P2121. 
*/
	
--SQL Server:
	
SELECT Sa. ord_date FROM sales Sa, Stores St WHERE Sa.stor_id = St. stor_id;
SELECT DISTINCT Sa. ord_date FROM sales Sa INNER JOIN Stores St ON Sa.stor_id = St. stor_id
WHERE St.stor_id = 7067 AND Sa.ord_num = 'P2121'  ;
	
CREATE PROCEDURE Fecha_venta_store(
	@Proc_stor_id	char(4),
	@Proc_ord_num	varchar(20),
	@Proc_ord_date	datetime	OUTPUT
	)
	AS
		SELECT DISTINCT Sa. ord_date FROM sales Sa INNER JOIN Stores St ON Sa.stor_id = St. stor_id
		WHERE St.stor_id = @Proc_stor_id AND Sa.ord_num = @Proc_ord_num  
		PRINT 'La fecha de venta es = ' + @Proc_ord_date + 'de la orden: ' + @Proc_ord_num 
	DECLARE @fecha datetime
 	RETURN 0;
	

DECLARE @fecha datetime
EXECUTE  Fecha_venta_store 7067, 'P2121', @fecha OUTPUT;

-- PostgreSQL:

CREATE OR REPLACE FUNCTION Fecha_venta_store(
	IN Proc_stor_id	char(4),
	IN Proc_ord_num	varchar(20),
	 OUT Proc_ord_date date	
	)
	RETURNS	date
	AS
	$$
	DECLARE
		 --Salida_ord_date date;
	begin
		--RETURN QUERY
		SELECT DISTINCT Sa. ord_date INTO Proc_ord_date FROM sales Sa INNER JOIN Stores St ON Sa.stor_id = St. stor_id
		WHERE St.stor_id = Proc_stor_id AND Sa.ord_num = Proc_ord_num ;
		RAISE NOTICE 'La fecha de venta es = % de la orden: %' , Proc_ord_date, Proc_ord_num;
		--RETURN Salida_ord_date;
	end
	$$
	LANGUAGE plpgsql;

 
SELECT  *  
   FROM Fecha_venta_store('7067', 'P2121'); -- Fecha_venta_store 7067, 'P2121', @fecha OUTPUT;

--- O SINO----------------------------

CREATE OR REPLACE FUNCTION Fecha_venta_store(
	IN Proc_stor_id	char(4),
	IN Proc_ord_num	varchar(20)
	 --OUT Proc_ord_date date	
	)
	RETURNS	date
	AS
	$$
	DECLARE
		 Salida_ord_date date;
	begin
		--RETURN QUERY
		SELECT DISTINCT Sa. ord_date INTO Salida_ord_date FROM sales Sa INNER JOIN Stores St ON Sa.stor_id = St. stor_id
		WHERE St.stor_id = Proc_stor_id AND Sa.ord_num = Proc_ord_num ;
		RAISE NOTICE 'La fecha de venta es = % de la orden: %' , Salida_ord_date, Proc_ord_num;
		RETURN Salida_ord_date;
	end
	$$
	LANGUAGE plpgsql;

Declare Salida_ord_date date;
SELECT  *  
   FROM Fecha_venta_store('7067', 'P2121'); -- Fecha_venta_store 7067, 'P2121', @fecha OUTPUT;


-------------------------------------------------------------------------- 
----------------------- E j e r c i c i o   2 ---------------------------- 
-------------------------------------------------------------------------.
/*
Ejercicio 3.   
 
Recordemos el esquema de tablas que creamos en la Guía de Trabajo Nro. 2 para realizar 
ejercicios de manipulación de datos: 
*/

-- Sobre SQL Server: 
--SQL Server:

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

--Sobre PostgreSQL: 
--PostgreSQL:

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
   codProv  	SERIAL, 
   razonSoc  	varchar(30) 	NOT NULL, 
   dir  		varchar(30)  	NOT NULL 
  ); 
 
 
 
CREATE TABLE pedidos  
  ( 
   numPed  		int  	NOT NULL, 
   fechPed   	date    NOT NULL, 
   codCli 		int   	NOT NULL 
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
 Trabajaremos con las tablas Productos y Detalle, en T-SQL. 
 
 
 Cargue el siguiente lote de prueba en la tabla de Productos: 
 
(10, “Articulo 1”, 50, 20) 
(20, “Articulo 2”, 70, 40)


El valor que almacena en la columna precioTot de la tabla Detalle se calcula en función 
de la cantidad pedida de un producto (columna cant) y su precio unitario (columna 
precUnit en la tabla productos). 

Se desea crear un procedimiento almacenado (insertarDetalle) que reciba como 
parámetros código de detalle (codDetalle), número de Pedido (numPed), código de 
producto (codProd) y cantidad vendida (cant) e inserte una nueva fila en la tabla detalle. 

Para obtener el valor correspondiente a la columna precioTot,  el procedimiento principal 
debe invocar a un procedimiento auxiliar (buscarPrecio) que retorne el precio unitario 
correspondiente al producto recibido como parámetro en insertarDetalle.
*/



SELECT Pr.precUnit FROM Productos Pr WHERE Pr. codProd = 1;

CREATE PROCEDURE buscarPrecio1(
	@Proc_codProd 		int,
	@Proc_precUnit		float OUTPUT
	)
	AS
		SELECT Pr.precUnit FROM Productos Pr WHERE Pr. codProd = @Proc_codProd
		PRINT 'El codigo es = ' + @Proc_codProd + 'el precio por unidad: ' + @Proc_precUnit 
	--DECLARE @Proc_precUnit float
	RETURN 0;
	
	DECLARE @Proc_precUnit float
	EXECUTE buscarPrecio1 101, @Proc_precUnit OUTPUT;
	
	-----------------
	
ALTER PROCEDURE insertarDetalle (
		 @Proc_codDetalle	int,
		 @Proc_numPed		int,
		 @Proc_codProd 		int,
		 @Proc_cant			int,
		 @Proc_precioTot	float		OUTPUT
		)
		AS
			DECLARE 
				@Proc_precUnit		float
			EXECUTE buscarPrecio1 @Proc_codProd, @Proc_precUnit OUTPUT;
			INSERT INTO DETALLE VALUES (@Proc_codDetalle, @Proc_numPed, @Proc_codProd, @Proc_cant, @Proc_cant * @Proc_precUnit);
			PRINT 'codProd: ' + @Proc_codProd + 'codDetalle' + @Proc_codDetalle + 'precUnit'+ @Proc_precUnit;
			RETURN;
		--
		--RETURN 0;
	-- CAST(price AS varchar) 	
	
	DECLARE @Proc_precioTot float
	EXECUTE insertarDetalle 3, 3, 3, 3, @Proc_precioTot OUTPUT;
	
	SELECT * FROM Detalle;
	
	
	INSERT INTO DETALLE VALUES (4, 4, 4, 4, 4);
	
	
	
	--------------------------------
	
	
	
	