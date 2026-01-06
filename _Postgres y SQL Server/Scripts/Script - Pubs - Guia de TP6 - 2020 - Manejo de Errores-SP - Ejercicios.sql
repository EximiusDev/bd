-- USANDO DataBase pubs:

USE pubs;

------------------------------------------------------------------------

/*
 ============================================
SQL: Guía de Trabajo Nro. 4  
Stored Procedures y functions: Ejercicios
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
SELECT * FROM Titles

-- SQL Server:
 ALTER PROCEDURE obtenerPrecio( 			-- usando pub_id
 		@p_pub_id char(4)--,
 		--@P_precio float		OUTPUT	
 	)
 	AS
 	DECLARE @precio float
 		SELECT @precio = T.price FROM Titles T WHERE T. pub_id = @p_pub_id
 		--SELECT TOP 1 @precio = T.price FROM Titles T WHERE T. pub_id = @p_pub_id
 		PRINT 'Precio = $' + CONVERT(VARCHAR, @Precio) + ' de la publicacion: '  + @p_pub_id
 	RETURN @precio;			-- Salida de precio (como int, no es correcto mejor usar Output param)


DECLARE @precio float
EXECUTE  obtenerPrecio 'PS1372', @precio OUTPUT; -- 0736

EXECUTE  obtenerPrecio '0736';

DECLARE @precio float
EXECUTE @precio = obtenerPrecio '0736'
SELECT @Precio;

SELECT T.price FROM Titles T WHERE T. pub_id = '0736'; 
SELECT T.price FROM Titles T WHERE T. title_id = 'PS1372';

-- O sino

 alter PROCEDURE obtenerPrecio0( 			-- usando pub_id
 		@p_pub_id char(4),
 		@P_precio float		OUTPUT			-- tengo la salida como Output param
 	)
 	AS
 	/*
Declare @price money, 
        @priceMaximo FLOAT; (?) 
        */
 	--DECLARE @precio float
 		SELECT @P_precio = T.price FROM Titles T WHERE T. pub_id = @p_pub_id		-- pongo la salida del SELECT en el Output param
 		--SELECT TOP 1 @P_precio = T.price FROM Titles T WHERE T. pub_id = @p_pub_id
		PRINT 'Precio = $' + CONVERT(VARCHAR, @P_precio) + ' de la publicacion: '  + @p_pub_id	
		
 	RETURN 0;


DECLARE @precio float
EXECUTE  obtenerPrecio0 1389, @precio OUTPUT;

DECLARE @precio float
EXECUTE obtenerPrecio0 '0736', @precio OUTPUT
SELECT @Precio;


-- Para title_id (en vez de pub_id):
 alter PROCEDURE obtenerPrecio_title(			-- usando title_id
 		@p_title_id 	varchar(6),
 		@P_precio 		float		OUTPUT		-- Param de salida
 	)
 	AS
 		SELECT @P_precio = T.price FROM Titles T WHERE T. title_id = @p_title_id
 		PRINT 'Precio = $' + CAST(@P_precio AS VARCHAR) + ' del titulo: '  + @p_title_id -- CAST(@P_precio AS VARCHAR(10))
 		PRINT'Anda'; -- CONVERT(VARCHAR, @P_precio)
 	RETURN 0;


DECLARE @precio float
EXECUTE  obtenerPrecio_title 'PS1372', @precio OUTPUT; -- 0736


SELECT T.price FROM Titles T WHERE T. pub_id = '0736'; 
SELECT T.price FROM Titles T WHERE T. title_id = 'PS1372';

PRINT'Hola';

--PostgreSQL:

CREATE TYPE type_precio1 		-- defino antes un composited-type "type_precio1"
   AS ( 
       precio1 numeric 
      ); 


CREATE OR REPLACE FUNCTION obtenerPrecio3(
		IN p_pub_id char(4)
	)
	RETURNS setof type_precio1		-- digo que voy a retornar un SETOF ("lista") del composited-type "type_precio1"
	AS
	$$
	DECLARE 
		--tipo_p type_precio%rowtype;
	begin
		RETURN QUERY			-- RETURN QUERY sirve para obtener una "lista" de valores
		SELECT T.price
			AS precio1
			 FROM Titles T WHERE T. pub_id = p_pub_id;
		RAISE NOTICE 'Precio de la publicacion: % es:'  , p_pub_id; --, type_precio1.precio1; -- NO SE PUEDE PORQUE ES UNA "LISTA" y no un unico valor
	--RETURN					-- no puedo usar un return porque es una "lista" y no un valor, variable o estructura
	end
	$$
	LANGUAGE plpgsql;
	
	SELECT  *  
   FROM obtenerPrecio3('PS1372'); --0736
   SELECT  *  
   FROM obtenerPrecio3('0736');
	


   -- Recordemos que una función PL/pgSQL NO PERMITE el OUTPUT directo  de una sentencia SELECT.  
   
--DROP FUNCTION obtenerPrecio3(char(4));

-- O SINO:

 CREATE OR REPLACE FUNCTION obtenerPrecio1(		-- SOLO TOMA EL 1ER VALOR DE LA "LISTA" COMO SALIDA (el resto los ignora)
		IN p_pub_id char(4),
 		OUT P_precio NUMERIC			-- parametro de salida
	)
	RETURNS Titles. price %TYPE -- (Anchored declarations) -- RETURNS numeric 
	AS
	$$
	DECLARE 
		--precio
	begin
		SELECT T.price
			INTO P_precio
			 FROM Titles T WHERE T. pub_id = p_pub_id;
		RAISE NOTICE 'Precio = $ % de la publicacion: %'  , P_precio , p_pub_id;
	--RETURN
	end
	$$
	LANGUAGE plpgsql;
	
	
	SELECT  *  
   FROM obtenerPrecio1('0736');		-- SOLO TOMA EL 1ER VALOR DE LA "LISTA" COMO SALIDA (el resto los ignora)
 
	

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
WHERE St.stor_id = '7067' AND Sa.ord_num = 'P2121'  ;
	
ALTER PROCEDURE Fecha_venta_store(
	@Proc_stor_id	char(4),
	@Proc_ord_num	varchar(20),
	@Proc_ord_date	datetime	output				-- Param de salida
	)
	AS
		SET @Proc_ord_date = (SELECT DISTINCT  Sa. ord_date 		-- Igual el Param de salida al resultado del Selct
								FROM sales Sa INNER JOIN Stores St 
									ON Sa.stor_id = St. stor_id
								WHERE St.stor_id = @Proc_stor_id 
								AND Sa.ord_num = @Proc_ord_num  )
		PRINT 'La fecha de venta es: ' + CAST(@Proc_ord_date AS VARCHAR) + ' de la orden: ' + @Proc_ord_num 
	--DECLARE @fecha datetime 		-- no necesario
 	RETURN 0;
	

DECLARE @fecha datetime
EXECUTE  Fecha_venta_store 7067, 'P2121', @fecha OUTPUT;

DECLARE @fecha datetime
EXECUTE  Fecha_venta_store 7067, 'P2121', @fecha OUTPUT
SELECT @fecha;

PRINT'HOLA';

-- PostgreSQL:

CREATE OR REPLACE FUNCTION Fecha_venta_store(
		IN 		Proc_stor_id		char(4),
		IN 		Proc_ord_num		varchar(20),
	 	OUT 	Proc_ord_date		date			-- Param de Salida
	)
	RETURNS	date 						-- returns Sales. ord_date
	AS
	$$
	DECLARE
		 --Salida_ord_date date;		-- No es necesario pq ya usamos el Output Parameter
	begin
		--RETURN QUERY					-- No se usa como tenemos Output Parameter al no ser una "lista" ni usar SETOF o necesitar un Composited type
		SELECT DISTINCT Sa. ord_date INTO Proc_ord_date 		-- meto el resultado del Select en el Param de Salida
			FROM sales Sa INNER JOIN Stores St 
				ON Sa.stor_id = St. stor_id
			WHERE St.stor_id = Proc_stor_id 
			AND Sa.ord_num = Proc_ord_num ;
		RAISE NOTICE 'La fecha de venta es: % de la orden: %' , Proc_ord_date, Proc_ord_num;
		--RETURN Salida_ord_date;		-- Al usar Output Parameter no necesito una salida aparte
	end
	$$
	LANGUAGE plpgsql;

 
SELECT  *  
   FROM Fecha_venta_store('7067', 'P2121'); -- Fecha_venta_store 7067, 'P2121', @fecha OUTPUT;

--- O SINO----------------------------

CREATE OR REPLACE FUNCTION Fecha_venta_store1(
		IN 		Proc_stor_id	char(4),
		IN 		Proc_ord_num	varchar(20)
	 	--OUT 	Proc_ord_date 	date	
	)
	RETURNS	date							-- Especifico que va a devolver el Return
	AS
	$$
	DECLARE
		 Salida_ord_date date;				-- declaro una Variable
	begin
		--RETURN QUERY						-- No se usa por no tener una "lista" de valores
		Salida_ord_date := (SELECT DISTINCT Sa. ord_date  
							  FROM sales Sa INNER JOIN Stores St 
								ON Sa.stor_id = St. stor_id
							  WHERE St.stor_id = Proc_stor_id 
							  AND Sa.ord_num = Proc_ord_num );
		RAISE NOTICE 'La fecha de venta es: % de la orden: %' , Salida_ord_date, Proc_ord_num;
		RETURN Salida_ord_date;				-- Necesito especificar un Return al no tener Output Parameter
	end
	$$
	LANGUAGE plpgsql;

Declare Salida_ord_date date;
SELECT  *  
   FROM Fecha_venta_store1('7067', 'P2121'); -- Fecha_venta_store 7067, 'P2121', @fecha OUTPUT;


DO
$$
	Declare Salida_ord_date date;
begin
	Salida_ord_date := (SELECT  *  
   							FROM Fecha_venta_store1('7067', 'P2121') 
						);
/* O SINO:
	SELECT  *  INTO Salida_ord_date
   		FROM Fecha_venta_store1('7067', 'P2121');
*/  
end
$$


-------------------------------------------------------------------------- 
----------------------- E j e r c i c i o   3 ---------------------------- 
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
   codProv  	int  			IDENTITY(1,1),   -- sql Server
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
   codProv  	SERIAL, 						-- PostgreSQL
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


INSERT INTO Productos VALUES (10, 'Articulo 1', 50, 20);
INSERT INTO Productos VALUES (20, 'Articulo 2', 70, 40);

-------------------------------------------------------------------------- 
----------------------- E j e r c i c i o   3 ---------------------------- 
-------------------------------------------------------------------------.
/*
Ejercicio 3.   

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


-- SQL Server:

SELECT Pr.precUnit FROM Productos Pr WHERE Pr. codProd = 10;

ALTER PROCEDURE buscarPrecio1(
	@Proc_codProd 		int,
	@Proc_precUnit		float output		-- Param de salida
	)
	AS
		SELECT @Proc_precUnit = Pr.precUnit  FROM Productos Pr WHERE @Proc_codProd = Pr. codProd
		PRINT 'El codigo es: ' + CONVERT(VARCHAR, @Proc_codProd) + ' y su precio x unidad: ' + CONVERT(VARCHAR, @Proc_precUnit) 
	--DECLARE @Proc_precUnit float
	RETURN 0;
	--RETURN; -- O sino:
	
	DECLARE @Proc_precUnit float
	EXECUTE buscarPrecio1 20, @Proc_precUnit OUTPUT
	SELECT 'El Precio Unitario es ' + CONVERT(VARCHAR, @Proc_precUnit);
	
	-----------------
	
ALTER PROCEDURE insertarDetalle1 (
		 @Proc_codDetalle	int,
		 @Proc_numPed		int,
		 @Proc_codProd 		int,
		 @Proc_cant			int,
		 @Proc_precioTot	float		OUTPUT		-- Param de salida
		)
		AS
			DECLARE 
				@Proc_precUnit		float
			EXECUTE buscarPrecio1 @Proc_codProd, @Proc_precUnit OUTPUT;		-- Ejecuto la Funcion "buscar precio" para obtner el precio unitario
			INSERT INTO DETALLE												-- inserto en Detalle los valores
				VALUES (@Proc_codDetalle, @Proc_numPed, @Proc_codProd, @Proc_cant, @Proc_cant * @Proc_precUnit);
			
			IF @@RowCount = 1		-- Si se modifico una fila o tupla
				begin
					PRINT 'codProd: ' + CONVERT(VARCHAR, @Proc_codProd) + ', codDetalle: ' + CONVERT(VARCHAR, @Proc_codDetalle) + ', precUnit: '+ CONVERT(VARCHAR, @Proc_precUnit);
					PRINT'Se inserto una fila'
				end
			Else
				PRINT'NO se inserto una fila'
			RETURN; -- end IF
		--
		--RETURN 0;
	-- CAST(price AS varchar) 	
	
	DECLARE @Proc_precioTot float
	EXECUTE insertarDetalle1 3, 3, 10, 3, @Proc_precioTot OUTPUT;
	
	DECLARE @Proc_precioTot float
	EXECUTE insertarDetalle1 3, 3, 3, 3, @Proc_precioTot OUTPUT;
	
	--insertarDetalle 3, 3, 3, 3;
	
	SELECT * FROM Detalle;
	
	delete FROM detalle where codDetalle = 3;
	
	
	INSERT INTO DETALLE VALUES (4, 4, 4, 4, 4);
	
	--------------------------------------------------------------------
	-- Ejercicio 3
	------------------------------------
	-- RESUELTO POR EL PROFESOR:
	------------------------------------
	delete  from Productos;
	
	SELECT * FROM Productos
	DELETE productos;
	
	INSERT INTO Productos Values (10, 'Articulo 1', 50, 20);
	INSERT INTO Productos Values (20, 'Articulo 2', 70, 40);
	INSERT INTO Productos Values (20, 'Articulo 2', 70, 40);
	INSERT INTO Productos Values (30, 'Articulo 3', NULL, 40);
	
	---------
	
	DROP PROCEDURE buscarPrecio
	
	CREATE PROCEDURE buscarPrecio(
	@codProd 		int,
	@PrecUnit 		float		OUTPUT		-- Param de salida
	)
	AS
		SELECT @PrecUnit = precUnit		-- Igualo el Param de salida al resultado del Select
		FROM Productos
		WHERE CodProd = @CodProd
		RETURN;
	
	----------
	
	-- DELETE Productos
	DECLARE @PrecioObtenido FLOAT
	EXECUTE buscarPrecio 20, @PrecioObtenido OUTPUT
	SELECT 'El Precio obtenido es ' + CONVERT(VARCHAR, @PrecioObtenido)
	
	----------
	-- DROP PROCEDURE insertarDetalle
	
	CREATE PROCEDURE insertarDetalle(
	@CodDetalle			int,		-- IN
	@NumPed				int,		-- IN
	@CodProd			int,		-- IN
	@Cant				int			-- IN
	)
	AS
		---- Identifica la invocacion que hicimos desde el batch ----
		DECLARE @PrecioObtenido FLOAT	--Parametro OUT del inner procedure
		EXECUTE buscarPrecio @CodProd, @PrecioObtenido 	OUTPUT
		
		---- Aca ya tenemos el precio del producto ----
		
		INSERT Detalle Values(@CodDetalle, @NumPed, @CodProd, @Cant, 
		@Cant * @PrecioObtenido)
		
		IF @@RowCount = 1
				PRINT'Se inserto una fila'
		RETURN
	
	--- 4. Insertar el Procedure principal (insertarDetalle)
	
	SELECT * FROM Detalle
	
	insertarDetalle 1540, 120, 10, 2
	
---------------------------------------------------------------------------------------------
-- Ejercicio 3
-- PostgreSQL:		-- buscarPrecio:
---------------------------------------------------------------------------------------------
	
SELECT Pr.precUnit FROM Productos Pr WHERE Pr. codProd = 10;

CREATE or REPLACE FUNCTION buscarPrecio100(
		IN param_codProd			int
		--, OUT param_precioUnit		float		-- No uso Output Parameter
	)
	RETURNS float			   -- Uso el valor de retorno por medio de una Variable
	language plpgsql 
	AS
	$$
	DECLARE
		var_precioUnit	float; -- var_precioUnit Productos.precUnit % TYPE;
	BEGIN
		SELECT Pr.precUnit INTO var_precioUnit			-- pongo la salida del Select en la variable
			FROM Productos Pr
			WHERE param_codProd = Pr.codProd;
		RAISE NOTICE 'El precio Unitario del producto ( % ) es: %',param_codProd, var_precioUnit;
		RETURN var_precioUnit;							-- Devuelvo la variable
	END;
	$$
	
SELECT  buscarPrecio100(10);

--------------- O SINO

CREATE or REPLACE FUNCTION buscarPrecio101(
		IN param_codProd			int,
		OUT param_precioUnit		float		-- No uso Output Parameter
	)
	RETURNS float			   			-- Uso el valor de retorno por medio del Output parameter							
	language plpgsql 
	AS
	$$
	DECLARE
		--var_precioUnit	float; -- var_precioUnit Productos.precUnit % TYPE;
	BEGIN
		SELECT Pr.precUnit INTO param_precioUnit			-- pongo la salida del Select en el Output parameter
			FROM Productos Pr
			WHERE param_codProd = Pr.codProd;
		RAISE NOTICE 'El precio Unitario del producto ( % ) es: %',param_codProd, param_precioUnit;
		--RETURN -- param_precioUnit;
	END;
	$$
	
SELECT  buscarPrecio101(10);

-------------------------------
	
CREATE or REPLACE FUNCTION insertarDetalle100(
		IN par_CodDetalle		int,
		IN par_NumPed			int,		
		IN par_CodProd			int,		
		IN par_Cant				int
	)
	RETURNS VOID
	language plpgsql
	as
	$$
	DECLARE
		V_precioUnit	float;			-- Declaro la variable para la salida del Select (la otra funcion)
		v_precioTot		float;			-- Declaro la variable para un valor calculado (no es necesario)
		vCantFilas		int;			-- Declaro la variable para la cant de filas afectadas por una operacion (para ver si se realizo o no)
	begin
		SELECT * INTO	V_precioUnit				-- tengo la salida de la funcion en la variable
			 FROM buscarPrecio100(10);
		v_precioTot := par_Cant * V_precioUnit;		-- defino el valor calculado
		RAISE NOTICE'El precio total es: %', v_precioTot;
		--
		INSERT INTO Detalle VALUES (par_CodDetalle, par_NumPed, par_CodProd, par_Cant, V_precioUnit);
		--
		GET DIAGNOSTICS vCantFilas = ROW_COUNT; 	-- Confirmo si se realizo la insercion (si se modificaron o recuperaron filas)
		IF vCantFilas > 0 THEN
			RAISE NOTICE'Se inserto una tupla';
		END IF;
		RETURN;
	end	-- END FUNCTION
	$$
	
	
	SELECT  insertarDetalle100(3, 3, 10, 3);
	SELECT  insertarDetalle100(3, 3, 3, 3);
	
	SELECT * FROM  Detalle;
	/*
		EXECUTE insertarDetalle1 3, 3, 10, 3, @Proc_precioTot OUTPUT;
	
	DECLARE @Proc_precioTot float
	EXECUTE insertarDetalle1 3, 3, 3, 3, @Proc_precioTot OUTPUT;
	*/

----------------------------------------------------------------------------------------------------------------------------------------------------------------
	
----------------------------------------------------------------------------------------------------------------------------------------------------------------
	
-------------------------------------------------------------------------- 
----------------------- E j e r c i c i o   4 ---------------------------- 
-------------------------------------------------------------------------.
/*
Ejercicio 4 
 
Queremos mejorar el procedure insertarDetalle 
 
Si sucediese que el código de producto (codProd) que recibe el procedure no exista en la 
tabla de productos, queremos que esta situación sea indicada en un mensaje y que la 
sentencia INSERT no se ejecute. 
 
De manera análoga, si sucediese que el producto no tuviese definido precio (en este caso 
eso no sería posible ya que la columna es NOT NULL), queremos que esta situación sea 
indicada en un mensaje y que la sentencia INSERT tampoco se ejecute.	
*/
	-- ALTER TABLE  nombre_de_la_tabla		 ALTER COLUMN nombre_de_la_columna 		TYPE tipo_de_datos    nueva_anchura;
	
ALTER TABLE productos ALTER COLUMN precUnit 	float  		NULL; 		-- SQL Server:
ALTER TABLE productos ALTER COLUMN precUnit 	DROP  		NOT NULL;	-- PostgreSQL:

INSERT INTO Productos Values (30, 'Articulo 3', NULL, 40);
	
ALTER PROCEDURE	insertarDetalle100(		-- insertarDetalle (Uso IF para Error)
	@CodDetalle			int,	-- IN
	@NumPed				int,	-- IN
	@CodProd			int,	-- IN
	@Cant				int		-- IN
)
AS	
	IF @CodProd NOT IN (SELECT CodProd FROM Productos WHERE CodProd = @CodProd)	-- Hago una confirmacion del Parametro [IN] codigo de producto
		BEGIN
			PRINT 'El codigo de Producto no es valido (no se encuentra producto)'
		END
	ELSE	
		BEGIN		-- Si el cod Product es valido (puedo insertar en detalle sobre ese prod):
			
			DECLARE @PrecioObtenido FLOAT						-- Var para Parametro OUT del inner procedure (buscarPrecio)
			EXECUTE buscarPrecio @CodProd, @PrecioObtenido 	OUTPUT		-- Ejecuto el inner procedure (buscarPrecio)
		
			---- Aca ya tenemos el precio del producto ----
			
			IF @PrecioObtenido IS NOT NULL 						-- Si el precio es NULL puedo insertar igual (?), con valor NULL
				PRINT'El producto posee precio'
				
			INSERT Detalle Values(@CodDetalle, @NumPed, @CodProd, @Cant, 
			@Cant * @PrecioObtenido)
		
			IF @@RowCount = 1
				PRINT'Se inserto una fila'
			
		END
	RETURN	
	
	--buscarPrecio1
	DECLARE @PrecioObtenido 	FLOAT
Execute buscarPrecio100 50, @PrecioObtenido OUTPUT; -- con un producto inexistente
	
	DECLARE @PrecioObtenido 	FLOAT
Execute buscarPrecio100 30, @PrecioObtenido OUTPUT; -- con un producto sin precio

	insertarDetalle10 1540, 120, 70, 2; -- PRODUCTO INEXISTENTE
	insertarDetalle10 900, 120, 30, 2;	-- Producto sin precio
	insertarDetalle10 900, 120, 20, 2;	-- Producto Con precio
	
----------------------------------------------------
	--Hecho por el profe 1
ALTER PROCEDURE buscarPrecio11(		-- buscarPrecio (Uso RETURN Personalizado)
	@codProd 		int,
	@PrecUnit 		float		OUTPUT
)
	AS
		IF EXISTS(SELECT * FROM Productos WHERE CodProd = @CodProd)
		BEGIN
			PRINT'El producto existe'
			
			IF EXISTS (SELECT * FROM Productos WHERE CodProd = @CodProd
			AND precUnit IS NOT NULL)
				begin
					PRINT'El producto posee precio'
					
					SELECT @PrecUnit = PrecUnit 
					FROM Productos
					WHERE codProd = @codProd
					
					--RETURN 0; -- Antes de obtener la salida se verifico que no sea NULL
				end
			ELSE
				begin
					PRINT'El producto NO posee precio'
					RETURN 71 -- Va a indicar el SP invocante que el producto no tiene precio definido
				end
		END
		ELSE
			begin
				PRINT'El producto NO existe'
				RETURN 70 -- Va a indicar el SP invocante que el producto no existe
			end
		RETURN 0;
	
SELECT * FROM Productos
	
-- Testeos:
DECLARE @PrecioObtenido 	FLOAT
Execute buscarPrecio11 50, @PrecioObtenido OUTPUT; -- con un producto inexistente

DECLARE @PrecioObtenido 	FLOAT
Execute buscarPrecio11 30, @PrecioObtenido OUTPUT; -- con un producto sin precio

DECLARE @PrecioObtenido 	FLOAT
Execute buscarPrecio11 20, @PrecioObtenido OUTPUT; -- con un producto Con muchos precios
		
DECLARE @PrecioObtenido 	FLOAT
Execute buscarPrecio11 10, @PrecioObtenido OUTPUT; -- con un producto Con precio

buscarPrecio11 50; -- con un producto inexistente
	
	
------------------------------------
	--Hecho por el profe 2

ALTER PROCEDURE buscarPrecio12(	-- buscarPrecio (Uso RETURN Personalizado + simple)
	@codProd 		int,
	@PrecUnit 		float		OUTPUT
)
	AS
		SELECT @PrecUnit = PrecUnit 
			FROM Productos
			WHERE codProd = @codProd
			
		IF @@RowCount = 0
			RETURN 70		-- No se encontro el producto
		--END IF
		
		SELECT * FROM Productos WHERE codProd = @codProd
		IF @@RowCount > 1
			RETURN 69		-- Hay muchos productos (Hecho por mi)
		--END IF
		
		iF @PrecUnit  IS NULL
			RETURN 71		-- El producto existe pero su precio es NULL
		--END IF
			
		RETURN 0;			-- El producto existe y su precio NO es NULL
-- END procedure

DECLARE @PrecioObtenido FLOAT,
		@StatusRetorno INT
EXECUTE @StatusRetorno = buscarPrecio12 20, @PrecioObtenido OUTPUT
PRINT 'El Precio obtenido es ' + CONVERT(VARCHAR, @PrecioObtenido) + ', RETORNO: ' + CONVERT(VARCHAR, @StatusRetorno)
SELECT 'El Precio obtenido es ' + CONVERT(VARCHAR, @PrecioObtenido);


------------------------------------------
	--HECHO POR EL PROFE (a) 
ALTER PROCEDURE	insertarDetalle11(		-- insertarDetalle (Prueba con Status Retorno)
	@CodDetalle			int,	-- IN
	@NumPed				int,	-- IN
	@CodProd			int,	-- IN
	@Cant				int		-- IN
)
AS	
	----- Identifica la invocacion que haciamos desde el batch -----
	DECLARE @PrecioObtenido 	FLOAT 	-- Parametro OUT del inner procedure
	DECLARE @StatusRetorno 		INT		-- Status de retorno del inner procedure	
	
	EXECUTE @StatusRetorno = buscarPrecio12 @CodProd, @PrecioObtenido OUTPUT
	PRINT'El Status de retorno vale ' + CONVERT (VARCHAR, @StatusRetorno)
	PRINT'El Precio obtenido es ' + CONVERT (VARCHAR, @PrecioObtenido)
	
	RETURN
	
	
SELECT * FROM Detalle
	
EXECUTE	insertarDetalle11 1540, 120, 70, 2; -- PRODUCTO INEXISTENTE
EXECUTE	insertarDetalle11 900, 120, 30, 2;	-- Producto sin precio
EXECUTE	insertarDetalle11 900, 120, 10, 2;	-- Producto Con precio
	

------------------------------------------
		--HECHO POR EL PROFE (b) 
ALTER PROCEDURE	insertarDetalle12(		-- insertarDetalle (Manejo Errores con Status Retorno )
	@CodDetalle			int,	-- IN
	@NumPed				int,	-- IN
	@CodProd			int,	-- IN
	@Cant				int		-- IN
)
AS	
	----- Identifica la invocacion que haciamos desde el batch -----
	DECLARE @PrecioObtenido 	FLOAT 	-- Parametro OUT del inner procedure
	DECLARE @StatusRetorno 		INT		-- Status de retorno del inner procedure	
	
	EXECUTE @StatusRetorno = buscarPrecio12 @CodProd, @PrecioObtenido OUTPUT -- buscarPrecio10
	
	IF @StatusRetorno != 0
		 begin
		 	IF @StatusRetorno = 70
		 		BEGIN
		 			PRINT 'El producto no existe (Error)'
		 			RETURN 70;
		 		END -- END if
		 	ELSE
		 		IF @StatusRetorno = 71
		 			BEGIN
		 				PRINT 'El producto no posee precio (Advertencia)'
		 				-- Puedo insertar igualmente con un valor NULL
		 				--RETURN 71;
		 			END --END if
		 		IF @StatusRetorno = 69 -- Agregado por mi
		 			BEGIN
		 				PRINT 'El producto está Repetido [muchos Precios] (Error)'
		 				RETURN 69;
		 			END --END if
		 	--END ELSE
		 end --END IF
	--END IF
	ELSE	 
	INSERT Detalle Values(@CodDetalle, @NumPed, @CodProd, @Cant,
		@Cant * @PrecioObtenido)
	IF @@RowCount = 1
		PRINT'Se inserto en Detalles'
		-- Return 0;
	ELSE
		PRINT'No se inserto en Detalles'
		--RETURN 66;
	RETURN;
-- END Procedure
	
	
	
SELECT * FROM Detalle;
	
EXECUTE	insertarDetalle12 1540, 600, 40, 22; -- PRODUCTO INEXISTENTE
EXECUTE	insertarDetalle12 500, 500, 30, 30;	-- Producto sin precio
EXECUTE	insertarDetalle12 700, 200, 20, 20;	-- Producto con muchos precios
EXECUTE	insertarDetalle12 900, 100, 10, 10;	-- Producto Con precio
	
	
Delete FROM Detalle;
	
-----------------------------------------------------------------------
--HECHO POR MI (VERIFICAR si es correcto hacer una comparacion de NULL con un parametro de otro PROCEDURE)

ALTER PROCEDURE	insertarDetalle20(-- insertarDetalle (Manejo Errores con IF)
	@CodDetalle			int,	-- IN
	@NumPed				int,	-- IN
	@CodProd			int,	-- IN
	@Cant				int		-- IN
)
AS	
	IF @CodProd NOT IN (SELECT CodProd FROM Productos WHERE CodProd = @CodProd)
		BEGIN
			PRINT 'El codigo de Producto no es valido (No Existe producto) (Error)'
			RAISERROR ('No Existe el Producto) (Error)', 16, 1) -- RAISERROR ('Mensaje', [0 a 18],[normalmente 1])
			PRINT 'Sigue el codigo' -- No se ejecuta (RAISERROR interrumpe el codigo)
		END
	ELSE	
		BEGIN
			
			DECLARE @PrecioObtenido FLOAT	--Parametro OUT del inner procedure
			EXECUTE buscarPrecio @CodProd, @PrecioObtenido 	output
			
			/*
			IF @@RowCount <> 1
				BEGIN
					PRINT 'El Producto tiene varios precios (Error)'
					
					RETURN
				END --end if
			*/
		
			IF @PrecioObtenido IS NULL 
				PRINT 'El producto no tiene precio asignado (Error)'
				-- Se puede insertar con valor NULL
				--INSERT Detalle Values(@CodDetalle, @NumPed, @CodProd, @Cant, 
				--	NULL)
			ELSE
				BEGIN
		
					---- Aca ya tenemos el precio del producto ----
		
					INSERT Detalle Values(@CodDetalle, @NumPed, @CodProd, @Cant, 
					@Cant * @PrecioObtenido)
		
				END -- end else
				
				IF @@RowCount = 1
					PRINT'Se inserto una fila'
					-- Return 0;
				ELSE
					PRINT'No se inserto una fila'
					--RETURN 66;
		  END
	RETURN 	
	-- END PROCEDURE
	
	
SELECT * FROM Productos;
SELECT * FROM Detalle;
	
EXECUTE insertarDetalle20 1540, 120, 70, 2; -- PRODUCTO INEXISTENTE
EXECUTE insertarDetalle20 900, 120, 30, 2;	-- Producto sin precio
EXECUTE insertarDetalle20 900, 120, 20, 2;	-- Producto Con Varios precios
EXECUTE insertarDetalle20 900, 120, 10, 2;	-- Producto Con precio
	
-------------------------------------------------------------------------------------
---------------------- Usando Status d Retorno y @@ERROR ----------------------------

ALTER PROCEDURE	insertarDetalle13(		-- insertarDetalle (Manejo Errores con Status Retorno )
	@CodDetalle			int,	-- IN
	@NumPed				int,	-- IN
	@CodProd			int,	-- IN
	@Cant				int		-- IN
)
AS	
	----- Identifica la invocacion que haciamos desde el batch -----
	DECLARE @PrecioObtenido 	FLOAT 	-- Parametro OUT del inner procedure
	DECLARE @StatusRetorno 		INT,		-- Status de retorno del inner procedure	
			@Error 				INTEGER
			
	EXECUTE @StatusRetorno = buscarPrecio12 @CodProd, @PrecioObtenido OUTPUT -- buscarPrecio10
	
	SET @Error = 0
	
	IF @StatusRetorno != 0
		 BEGIN
		 	IF @StatusRetorno = 70
		 		BEGIN
		 			PRINT 'El producto no existe (Error)'
		 			--RETURN 70;
		 			RAISERROR( 'El producto no existe (Error)', 12, 1)
		 			SET @Error = @@ERROR			-- Variable Global de Error de SQL Server (Necesita RAISERROR)
		 		END -- END if
		 	
		 	IF @StatusRetorno = 71
		 		BEGIN
		 			PRINT 'El producto no posee precio (Advertencia)'
		 			-- Puedo insertar igualmente con un valor NULL
		 			--RETURN 71;
		 			--RAISERROR( 'El producto no posee precio (Advertencia)', 13, 1)
		 			SET @Error = @@ERROR			-- Variable Global de Error de SQL Server (Necesita RAISERROR)
		 		END --END if
		 	IF @StatusRetorno = 69 -- Agregado por mi
		 		BEGIN
		 			PRINT 'El producto está Repetido [muchos Precios] (Error)'
		 			--RETURN 69;
		 			RAISERROR( 'El producto está Repetido [muchos Precios] (Error)', 14, 1)
		 			SET @Error = @@ERROR			-- Variable Global de Error de SQL Server (Necesita RAISERROR)
		 		END --END if
		 	--END ELSE
		 END --END IF (IF @StatusRetorno != 0)
	
	IF @Error = 0
		BEGIN
			INSERT Detalle Values(@CodDetalle, @NumPed, @CodProd, @Cant,
				@Cant * @PrecioObtenido)
				
			IF @@RowCount = 1
				begin
					PRINT'Se inserto una fila'
					RETURN 0;
				end
			ELSE
				begin
					PRINT'No se inserto una fila'
					RETURN 66;
				end
		end -- END IF @Error = 0
-- END Procedure
	
	
	
SELECT * FROM Detalle;
		
Delete FROM Detalle;

EXECUTE	insertarDetalle13 1540, 120, 40, 2; -- PRODUCTO INEXISTENTE
EXECUTE	insertarDetalle13 900, 300, 30, 2;	-- Producto sin precio 				(No lo ve como Error)
EXECUTE	insertarDetalle13 600, 200, 20, 2;	-- Producto con muchos precios 		(No lo ve como Error)
EXECUTE	insertarDetalle13 500, 100, 10, 2;	-- Producto Con precio


-------------------------------------------------------------------------------------
------------------ Usando TRY/CATCH, Status d Retorno y @@ERROR -----------------------

ALTER PROCEDURE	insertarDetalle14(		-- insertarDetalle (Manejo Errores con Status Retorno )
	@CodDetalle			int,	-- IN
	@NumPed				int,	-- IN
	@CodProd			int,	-- IN
	@Cant				int		-- IN
)
AS	
	----- Identifica la invocacion que haciamos desde el batch -----
	DECLARE @PrecioObtenido 	FLOAT 	-- Parametro OUT del inner procedure
	DECLARE @StatusRetorno 		INT,		-- Status de retorno del inner procedure	
			@Error 				INTEGER
			
	EXECUTE @StatusRetorno = buscarPrecio12 @CodProd, @PrecioObtenido OUTPUT -- buscarPrecio10
	
	SET @Error = 0
	
	IF @StatusRetorno != 0
		 BEGIN
		 	IF @StatusRetorno = 70
		 		BEGIN
		 			PRINT 'El producto no existe (Error)'
		 			--RETURN 70;
		 			RAISERROR( 'El producto no existe (Error)', 12, 1)
		 			SET @Error = @@ERROR			-- Variable Global de Error de SQL Server (Necesita RAISERROR)
		 		END -- END if
		 	
		 	IF @StatusRetorno = 71
		 		BEGIN
		 			PRINT 'El producto no posee precio (Advertencia)'
		 			-- Puedo insertar igualmente con un valor NULL
		 			--RETURN 71;
		 			--RAISERROR( 'El producto no posee precio (Advertencia)', 13, 1)
		 			SET @Error = @@ERROR			-- Variable Global de Error de SQL Server (Necesita RAISERROR)
		 		END --END if
		 	IF @StatusRetorno = 69 -- Agregado por mi
		 		BEGIN
		 			PRINT 'El producto está Repetido [muchos Precios] (Error)'
		 			--RETURN 69;
		 			RAISERROR( 'El producto está Repetido [muchos Precios] (Error)', 14, 1)
		 			SET @Error = @@ERROR			-- Variable Global de Error de SQL Server (Necesita RAISERROR)
		 		END --END if
		 	--END ELSE
		 END --END IF (IF @StatusRetorno != 0)
	
		 
		 
	IF (@Error = 0)
		begin
					
			BEGIN TRANSACTION		-- Empiezo la Transaccion (Porque hago operaciones peligrosas)
			
			----------------------------- Try/catch I --------------------------- 
			BEGIN TRY			-- BEGIN [Operacion Peligrosa]
				INSERT Detalle Values(@CodDetalle, @NumPed, @CodProd, @Cant,
					@Cant * @PrecioObtenido)
					
				PRINT'Se inserto una fila'
				
				COMMIT TRANSACTION		-- Termino la Transaccion (La operacion peligrosa se realizo sin problemas)
				RETURN 0;
				
			END TRY				-- END [Operacion Peligrosa]
			
			BEGIN CATCH			-- BEGIN [Manejo de Errores]
					PRINT'No se inserto una fila'
					
					EXECUTE usp_GetErrorInfo
					ROLLBACK TRANSACTION		-- Revierto la Transaccion (La operacion peligrosa NO se realizo sin problemas)
					RETURN 66;
			END CATCH			-- END [Manejo de Errores]
			
		END -- END IF @Error = 0
-- END Procedure
	
	
	
SELECT * FROM Detalle;
	
Delete FROM Detalle;

EXECUTE	insertarDetalle14 1540, 120, 40, 2; -- PRODUCTO INEXISTENTE
EXECUTE	insertarDetalle14 900, 300, 30, 2;	-- Producto sin precio 				(No lo ve como Error)
EXECUTE	insertarDetalle14 600, 200, 20, 2;	-- Producto con muchos precios 		(No lo ve como Error)
EXECUTE	insertarDetalle14 500, 100, 10, 2;	-- Producto Con precio
	
	
	/*
	 SQL Server:
	 
	 Se pueden hacer varias cosas en BuscarPrecio:
		- volver un valor de RETORNO personalizado para indicar errores o escepciones
	 	- devolver la salida normal y resolverlo con un IF IS NULL y IF @@RowCount
	 	- Hacer RAISERROR ('Mensaje Error', severity [0 a 18], state [normalmente 1]) (NO RECOMENDADO PARA Funcio o Procedure Interno)
	 		--  RAISERROR (NO RECOMENDADO PARA Funcion o Procedure Interno, porque interrumpe codigo)
	 	- Devolver un mensaje (No afecta en nada)
	 		
	 Para insertarDetalle, debera manejar la salida del Procedure interno (sea cual sea, es decir es especifico)
	  A partir de eso insertarDetallese puede:
	 	- Hacer un RAISERROR 
	 	- Hacer RAISERROR y @Error = @@ERROR (Variable global de Error por defecto, ver si @Error <> 0)
		- Hacer un mensaje (con IF y IF @@RowCount)
		- Hacer un TRY/ CATCH 		(Manejo Error  y Salida ERROR Personalizada)
		
		
	(RECORDAR CANCELAR LAS OPERACIONES PELIGROSAS AL HACERLAS [antes tiene que haber un BEGIN TRANSACTION])
	*/
	
-------------------------------------------------------------------------- 
----------------------- E j e r c i c i o   4 ---------------------------- 
-------------------------------------------------------------------------.
/*
 Manejo de errores
 */
-- Postgress:
	
	/*
CREATE TYPE recProd					-- ?????????????????????
AS (
	codProd		int,
	PrecUnit	float
);

-- DROP TYPE recProd;
-- DROP FUNCTION buscarPrecio11;
	*/
	

 CREATE OR REPLACE FUNCTION buscarPrecio11(
	 	IN		func_codProd 		int
		--,  OUT		func_PrecUnit 		float
	 )  
   RETURNS float
   LANGUAGE plpgsql 
   AS 
   $$
   DECLARE 
      recProd RECORD; -- ???
	  vCantFilas int;
 
   BEGIN 
      SELECT  PrecUnit INTO recProd 			-- uso STRICT para considerar las excepciones (salta el mensaje de error)
         FROM Productos  							-- si sacamos STRICT no salta los errores
         WHERE codProd = func_codProd; 

	  IF func_codProd NOT IN (SELECT  codProd  		-- verifico si existe el producto buscado
         				FROM Productos )
		 THEN	
				RAISE NOTICE 'El Producto (%) NO Existe', func_codProd;
				RETURN recProd.PrecUnit;								-- devuelvo un dato del RECORD (float)
	  END IF;

	  -- func_PrecUnit := recProd.PrecUnit;
	  
      --		NO SE MUESTRA PORQUE SALTA EL ERROR
      IF recProd.PrecUnit IS NULL THEN    				-- Manejo de error [No hay datos/ NULL]
         RAISE NOTICE 'El Producto no tiene precio'; 
		 RETURN recProd.PrecUnit;
      END IF;   
      -- 
	
	  PERFORM * FROM Productos WHERE codProd = func_codProd; 
	  GET DIAGNOSTICS vCantFilas = ROW_COUNT;					-- obtengo la cantidad de filas
	  
	  IF 1 < (vCantFilas) THEN
			RAISE NOTICE 'El Producto tiene varios precios (Muestro el 1ero)'; 
		 	RETURN recProd.PrecUnit;
	  END IF;   
	  
      RAISE NOTICE 'El precio de [%] es %', func_codProd, recProd.PrecUnit;
   
	  
	  RETURN recProd.PrecUnit;
   END   -- END FUNCTION
   $$
   
    
SELECT  *  
   FROM buscarPrecio11( 20); -- 10, 20, 30, 40;
   

----------------------------------------------------------------------------
-- Pruebas de manejos de Errores y Excepciones
----------------------------------------------------------------------------

 CREATE OR REPLACE FUNCTION buscarPrecio111(	-- Funcion anterior con manejo de strict (Manejo de errores)
	 	IN		func_codProd 		int,
		OUT		func_PrecUnit 		float		-- Param de Salida
	 )  
   RETURNS float -- RETURNS setof float 
   LANGUAGE plpgsql 
   AS 
   $$
   DECLARE 
      recProd RECORD; 				-- Uso un Record
 	  vCantFilas int;
   BEGIN 
      SELECT  PrecUnit INTO STRICT recProd 			-- uso STRICT para considerar las excepciones (salta el mensaje de error)
         FROM Productos  							-- si sacamos STRICT no salta los errores
         WHERE codProd = func_codProd; 
	  

	  IF func_codProd NOT IN (SELECT  codProd  		-- verifico si existe el producto buscado
         				FROM Productos )
		 THEN	
				RAISE NOTICE 'El Producto (%) NO Existe', func_codProd;
				RETURN;
	  END IF;

	  func_PrecUnit := recProd.PrecUnit;		-- defino el Param de Salida
	  
      --		NO SE MUESTRA PORQUE SALTA EL ERROR
      IF recProd.PrecUnit IS NULL THEN    				-- Manejo de error [No hay datos/ NULL]
         RAISE NOTICE 'El Producto no tiene precio';
		 RETURN; 
      END IF;   
      -- 

	  PERFORM * FROM Productos WHERE codProd = func_codProd; 
	  GET DIAGNOSTICS vCantFilas = ROW_COUNT;
	  
	  IF 1 < (vCantFilas) THEN
			RAISE NOTICE 'El Producto tiene varios precios (Muestro el 1ero)'; 
		 	RETURN;
	  END IF;   
	  
      RAISE NOTICE 'El precio de [%] es %', func_codProd, recProd.PrecUnit;
   
	  
	  --RETURN recProd.PrecUnit;
   END  -- END FUNCTION
   $$
   
    
SELECT  *  
   FROM buscarPrecio111( 30); -- 10, 20, 30, 40;

-- Ver que (30) 	No tira ERROR ->
-- EN (30) -> Ya que el codigo buscado Existe pero el valor asociado es NULL (Salida Null)


-------------------------------------------------------
	
CREATE OR REPLACE FUNCTION test_strict()  -- devolver una lista de valores en una unica salida
   RETURNS VOID 
   LANGUAGE plpgsql 
   AS 
   $$
   DECLARE 
      recTitles RECORD; 
 
   BEGIN 
      SELECT price, type INTO STRICT recTitles 		-- uso STRICT para considerar las excepciones (salta el mensaje de error)
         FROM titles;  								-- No tengo WHERE (hay lista de valores)
 													-- si sacamos STRICT no salta los errores (de lista de valores)
      RAISE NOTICE 'El precio es %', recTitles.price; 
  
   END   
   $$



SELECT  *  
   FROM test_strict( ); 


 
CREATE OR REPLACE FUNCTION test_exception(
	in	 prm_title_id		Varchar(6)
	)  
   RETURNS VOID 
   LANGUAGE plpgsql 
   AS 
   $$
   DECLARE 
      recTitles RECORD; 
       
   BEGIN 							-- Begin del la funcion
 
      NULL; 						-- Operaciones de la funcion
      --- Otras operaciones--- 
 
      ----------------------------- Try/catch I --------------------------- 
 
      BEGIN  				-- Begin del "try" (Operaciones peligrosas)		[BEGIN = BEGIN TRANSACTION]
         SELECT price, type INTO STRICT recTitles 		-- Se usa el STRICT para hacer manejo de excepciones (NO_DATA_FOUND, TOO_MANY_ROWS, OTHERS)
            FROM titles
			WHERE title_id LIKE prm_title_id;  
 
         RAISE NOTICE 'El precio es %', recTitles.price; 
 
          
	     EXCEPTION -- Try I (empieza el "Catch", termina el "try", hago el Manejo de Errores)
	 
	         WHEN NO_DATA_FOUND THEN 					-- [No hay datos]: Situacion de Error/ Excepcion comun (se maneja aparte) 
	            RAISE NOTICE 'No se encontraron datos (Error)'; 	-- NULL
				-- ROLLBACK:  -- [ROLLBACK TRANSACTION]
	            RETURN; 
	             
	         WHEN TOO_MANY_ROWS THEN 					-- [muchas tuplas]: Situacion de Error/ Excepcion comun (se maneja aparte)
	            RAISE NOTICE 'La sentencia SELECT retornó más de una fila (Error)';  
				-- ROLLBACK:  -- [ROLLBACK TRANSACTION]
	            RETURN; 
	             
	         WHEN OTHERS THEN 							-- [Otros]: Situacion de Error/ Excepcion maneja todo lo demas
	            RAISE NOTICE 'ERROR Others';  
				-- ROLLBACK:  -- [ROLLBACK TRANSACTION]
	            RETURN;    
	 
	     END;  -- Try I  (Termina el "Catch")
 
      RETURN; 
  
   END  -- END FUNCTION
   $$



SELECT  *  
   FROM test_exception('PC%'); 		-- Muchas tuplas o filas (Hay muchas Tuplas para el valor buscado)

SELECT  *  
   FROM test_exception('HOLA'); 	-- NULL (NO hay datos, El valor buscado NO Existe)
  
SELECT  *  						-- No tira ERROR
   FROM test_exception('PC9999');	-- No hay precio [NULL] (El valor buscado Existe y es Unico) 
   
SELECT  *  
   FROM test_exception('PC1035');	-- Unico dato recuperado (Hay precio)

   
SELECT  *  
   from TITLES;

/*
 Viendo esta forma de manejo de Errores/ Excepciones,
 usando STRICT y Begin-EXCEPTION-End
 Podemos hacer un mejor manejo de buscar lo anterior
 */

---------------------------------------------------------------


 CREATE OR REPLACE FUNCTION buscarPrecio1111(	-- Funcion anterior con manejo de strict (Manejo de errores)
	 	IN		func_codProd 		int
		--, OUT		func_PrecUnit 		float
	 )  
   RETURNS setof float 		-- RETURNS float --  RETURNS SETOF recProd (RECORD)
   LANGUAGE plpgsql 
   AS 
   $$
   DECLARE 
       recProd	 RECORD; 				-- Uso un RECORD para la salida ?
	  --vPrecio		 float;
 	  vCantFilas	 int;
   BEGIN 
	  RETURN QUERY						-- puedo devolver una "lista" de valores
      SELECT  PrecUnit -- INTO recProd 			-- uso STRICT para considerar las excepciones (salta el mensaje de error)
		STRICT
		FROM Productos  							-- si sacamos STRICT no salta los errores
        WHERE codProd = func_codProd; 
	  

	  IF func_codProd NOT IN (SELECT  codProd  		-- verifico si existe el producto buscado
         				FROM Productos )
		 THEN	
				RAISE NOTICE 'El Producto (%) NO Existe', func_codProd;
				RETURN;
	  END IF;

	  --func_PrecUnit := recProd.PrecUnit;
	   
	  SELECT   PrecUnit INTO recProd 			
		FROM Productos  		
        WHERE codProd = func_codProd;
 
      --		NO SE MUESTRA PORQUE SALTA EL ERROR
      IF recProd.PrecUnit IS NULL THEN    				-- Manejo de error [No hay datos/ NULL]
         RAISE NOTICE 'El Producto no tiene precio';
		 RETURN;
      END IF;   
    -- 

	  PERFORM * FROM Productos WHERE codProd = func_codProd; 
	  GET DIAGNOSTICS vCantFilas = ROW_COUNT;
	  
	  IF 1 < (vCantFilas) THEN
			RAISE NOTICE 'El Producto tiene varios precios (Muestro el 1ero)'; 
		 	RETURN;
	  END IF;   
	  
      --RAISE NOTICE 'El precio de [%] es %', func_codProd, recProd.PrecUnit;
   
	  
	  --RETURN recProd.PrecUnit;
   END -- END FUNCTION  
   $$
   
    
SELECT  *  
   FROM buscarPrecio1111( 10); -- 10, 20, 30, 40; -- No da Error (El manejo de Error lo puede hacer la funcion que llame)

-- DROP FUNCTION buscarPrecio1111;

----------------------------------------
   

 CREATE OR REPLACE FUNCTION buscarPrecio1112(	-- Funcion anterior con manejo de strict (Manejo de errores)
	 	IN		func_codProd 		int,
		OUT		func_PrecUnit 		float
	 )  
   RETURNS float -- RETURNS setof float 
   LANGUAGE plpgsql 
   AS 
   $$
   DECLARE 
 	  vCantFilas int;
   BEGIN 							-- Begin del la funcion
 
      NULL; 						-- Operaciones de la funcion
      --- Otras operaciones--- 
 
      ----------------------------- Try/catch I --------------------------- 
 
      BEGIN  					-- Begin del "try" (Operaciones peligrosas)		 [BEGIN = BEGIN TRANSACTION]
	      SELECT  PrecUnit INTO STRICT func_PrecUnit 	-- uso STRICT para considerar las excepciones (salta el mensaje de error)
	         FROM Productos  							-- si sacamos STRICT no salta los errores
	         WHERE codProd = func_codProd; 
		  
	
	      IF func_PrecUnit IS NULL THEN    				-- Manejo de error [No hay datos/ NULL]
	         RAISE NOTICE 'Advertencia: El Producto no tiene precio';
			 --RAISE EXCEPTION 'El Producto no tiene precio (Advertencia)';
			 RETURN; 
	      END IF;   
		  
		  EXCEPTION -- Try I (empieza el "Catch", termina el "try", hago el Manejo de Errores)
			
	         WHEN NO_DATA_FOUND THEN 					-- [No hay datos]: Situacion de Error/ Excepcion comun (se maneja aparte) 
	            RAISE NOTICE 'Error: No se encontraron datos'; 	-- NULL
				RAISE EXCEPTION 'No se encontraron datos (Error)';
				RAISE NOTICE 'Sigue el codigo'; -- No se ejecuta (RAISE EXCEPTION interrumpe el codigo)
				-- ROLLBACK:  -- [ROLLBACK TRANSACTION]
	            RETURN; 
	             
	         WHEN TOO_MANY_ROWS THEN 					-- [muchas tuplas]: Situacion de Error/ Excepcion comun (se maneja aparte)
	            RAISE NOTICE 'Error: La sentencia SELECT retornó más de una fila';  
				RAISE EXCEPTION 'La sentencia SELECT retornó más de una fila (Error)'; 
				RAISE NOTICE 'Sigue el codigo'; -- No se ejecuta (RAISE EXCEPTION interrumpe el codigo)
				-- ROLLBACK:  -- [ROLLBACK TRANSACTION]
	            RETURN; 
	             
	         WHEN OTHERS THEN 							-- [Otros]: Situacion de Error/ Excepcion maneja todo lo demas
	            RAISE NOTICE 'ERROR: Others';  
				RAISE EXCEPTION 'Others (Error)'; 
				-- ROLLBACK:  -- [ROLLBACK TRANSACTION]
	            RETURN;    
	 
	      END;  -- Try I  (Termina el "Catch")		
      -- 
/*
--		NO SE MUESTRA PORQUE SALTA EL ERROR

		-- Los IF para MUCHAS FILAS y NO SE ENCUENTRA TUPLA
		-- no son necesarios porque ya se encarga el STRICT 
		-- con su respectivo EXCEPTION (para hacer ante el Error)
*/
      RAISE NOTICE 'El precio de [%] es %', func_codProd, func_PrecUnit;
   
	  --RETURN;
   END -- END FUNCTION
   $$
   
    
SELECT  *  
   FROM buscarPrecio1112( 40); -- 10, 20, 30, 40;

/*
 Ahora falta la Funcion Principal
  donde se hace el manejo de Errores
   y Operaciones Peligrosas 
   (la funcion buscarPrecio1112, en si misma no es peligrosa
   por lo que no necesitaria el uso de STRICT
    y un bloque  EXCEPTION)
 */

---------------------------------------------------------------------------------------
---------------------- Funcion INSERTAR DETALLE ---------------------------------------

--------------------------- Usando IF y ROW_COUNT -------------------------------------
CREATE or Replace FUNCTION insertarDetalle1111(
		IN 	par_CodDetalle		int,
		IN 	par_NumPed			int,		
		IN 	par_CodProd			int,		
		IN 	par_Cant			int
	)
	RETURNS VOID  
	Language plpgsql 
	AS
	$$
	DECLARE
		var_precioUnit	float;		
		var_CantFilas	int;	
	BEGIN
		
		PERFORM * FROM buscarPrecio1111(par_CodProd); -- (sin manejo errores) -- buscarPrecio1112 (par_CodProd);
		GET DIAGNOSTICS var_CantFilas = ROW_COUNT;
		
		IF var_CantFilas <> 1 THEN		-- No se recupero 1 valor
			RAISE NOTICE'ERROR';
			--
			IF var_CantFilas = 0 THEN
				RAISE NOTICE'No Existe [No encontrado]';
			ELSE
				RAISE NOTICE'Muchas filas encontradas [Varios]';
			END IF;
			--
			RETURN; -- ERROR
		ELSE
			RAISE NOTICE'NORMAL';

			SELECT * INTO var_precioUnit
			 	FROM buscarPrecio1111(par_CodProd);
			--var_precioUnit := (SELECT * FROM buscarPrecio1111(par_CodProd));
			--
			IF var_precioUnit IS NULL THEN
				RAISE NOTICE'No tiene valor asociado [Valor NULL]';
				--
				RETURN;-- ADVERTENCIA
			ELSE
				RAISE NOTICE'El precio del producto [%] es: %',par_CodProd, var_precioUnit;
			END IF;
			
			-- RETURN;
		END IF; -- if CantFilas <> 1
		
		
		INSERT INTO Detalle VALUES (par_CodDetalle, par_NumPed, par_CodProd, par_Cant, var_precioUnit * par_Cant);
		GET DIAGNOSTICS var_CantFilas = ROW_COUNT;

		IF var_CantFilas > 0 THEN
			RAISE NOTICE'Se inserto una tupla';
		ELSE
			RAISE NOTICE'Error en la insercion';
		END IF;
		
		--RETURN	
	END -- END FUNCTION
	$$ 

	
select * FROM  insertarDetalle1111(3, 3, 3, 3);	
select * FROM  insertarDetalle1111(3, 3, 10, 3);

SELECT  insertarDetalle1111(10, 10, 10, 10);	-- El Producto Tiene Precio (Normal)
SELECT  insertarDetalle1111(20, 20, 20, 20);	-- Muchos productos (Error)
SELECT  insertarDetalle1111(30, 30, 30, 30);	-- El producto No tiene Precio (Advertencia)
SELECT  insertarDetalle1111(40, 40, 40, 40);	-- El producto No Existe (Error)


	
SELECT * FROM  Detalle;
DELETE FROM  Detalle;


--------------------------------------------------------------------------------
-- Forma alternativa (con manejo de errores en la funcion previa):



CREATE or Replace FUNCTION insertarDetalle1112(
		IN 	par_CodDetalle		int,
		IN 	par_NumPed			int,		
		IN 	par_CodProd			int,		
		IN 	par_Cant			int
	)
	RETURNS VOID  
	Language plpgsql 
	AS
	$$
	DECLARE
		var_precioUnit	float;		
		var_CantFilas	int;	
	BEGIN
		
		SELECT * INTO var_precioUnit 
			FROM buscarPrecio1112(par_CodProd); -- (sin manejo errores) -- buscarPrecio1112 (par_CodProd);
		--var_precioUnit := (SELECT * FROM buscarPrecio1111(par_CodProd));
		GET DIAGNOSTICS var_CantFilas = ROW_COUNT;

		-- Si llega aca signigica que no hay Errores

			RAISE NOTICE'NORMAL';	
			
			IF var_precioUnit IS NULL THEN
				RAISE NOTICE'No tiene valor asociado [Valor NULL]';
				--
				RETURN;-- ADVERTENCIA
			ELSE
				RAISE NOTICE'El precio del producto [%] es: %',par_CodProd, var_precioUnit;
			END IF;
		
		
		INSERT INTO Detalle VALUES (par_CodDetalle, par_NumPed, par_CodProd, par_Cant, var_precioUnit * par_Cant);
		----------------------------- Try/catch I --------------------------- 
 
      	BEGIN  		-- Inicio del TRY (Operacion(es) peligrosas)		 [BEGIN = BEGIN TRANSACTION]
			RAISE NOTICE'Se inserto una tupla';
			
			EXCEPTION		-- Inicio del Catch (Nunca se ejecutan los errores porque ya fueron previstos antes)

			WHEN NO_DATA_FOUND THEN 		-- [No hay datos]: Situacion de Error/ Excepcion comun (se maneja aparte) 
	            RAISE NOTICE 'No hay datos (Error)'; 	-- NULL
				-- ROLLBACK:  -- [ROLLBACK TRANSACTION]
	            RETURN; 

	         WHEN TOO_MANY_ROWS THEN 		-- [muchas tuplas]: Situacion de Error/ Excepcion comun (se maneja aparte)
	            RAISE NOTICE 'más de una fila (Error)'; 
				-- ROLLBACK:  -- [ROLLBACK TRANSACTION] 
	            RETURN; 

				WHEN OTHERS THEN
					RAISE NOTICE'Error en la insercion';
					-- ROLLBACK:  -- [ROLLBACK TRANSACTION]
					RETURN;
					
		END;		-- End TRY I
		
		--RETURN	
	END -- END FUNCTION
	$$ 

	
select * FROM  insertarDetalle1112(3, 3, 3, 3);	
select * FROM  insertarDetalle1112(3, 3, 10, 3);

SELECT  insertarDetalle1112(10, 10, 10, 10);	-- El Producto Tiene Precio (Normal)
SELECT  insertarDetalle1112(20, 20, 20, 20);	-- Muchos productos (Error)
SELECT  insertarDetalle1112(30, 30, 30, 30);	-- El producto No tiene Precio (Advertencia)
SELECT  insertarDetalle1112(40, 40, 40, 40);	-- El producto No Existe (Error)


	
SELECT * FROM  Detalle;
DELETE FROM  Detalle;


--------------------------------------------------------------------------------
-- Forma alternativa (con manejo de errores en la funcion Principal):

CREATE or Replace FUNCTION insertarDetalle1113(
		IN 	par_CodDetalle		int,
		IN 	par_NumPed			int,		
		IN 	par_CodProd			int,		
		IN 	par_Cant			int
	)
	RETURNS VOID  
	Language plpgsql 
	AS
	$$
	DECLARE
		var_precioUnit	float;		
		var_CantFilas	int;	
	BEGIN 							-- Begin del la funcion
 
      NULL; 						-- Operaciones de la funcion
      --- Otras operaciones--- 
 
      ----------------------------- Try/catch I --------------------------- 
 
      BEGIN  		-- Inicio del TRY (Operacion(es) peligrosas)  [BEGIN = BEGIN TRANSACTION]
		SELECT * INTO STRICT var_precioUnit
			 	FROM buscarPrecio1111(par_CodProd);
			--var_precioUnit := (SELECT * FROM buscarPrecio1111(par_CodProd));
		-- RAISE NOTICE 'Sigue el codigo';
      
		EXCEPTION	-- Begin Catch I
			
	         WHEN NO_DATA_FOUND THEN 					-- [No hay datos]: Situacion de Error/ Excepcion comun (se maneja aparte) 
	            RAISE NOTICE 'No se encontraron datos (Error)'; 	-- NULL
	             -- ROLLBACK:  -- [ROLLBACK TRANSACTION]
	            RETURN; 
	             
	         WHEN TOO_MANY_ROWS THEN 					-- [muchas tuplas]: Situacion de Error/ Excepcion comun (se maneja aparte)
	            RAISE NOTICE 'La sentencia SELECT retornó más de una fila (Error)';  
	            -- ROLLBACK:  -- [ROLLBACK TRANSACTION]
	            RETURN; 
	             
	         WHEN OTHERS THEN 							-- [Otros]: Situacion de Error/ Excepcion maneja todo lo demas
	            RAISE NOTICE 'ERROR Others';
				-- ROLLBACK:  -- [ROLLBACK TRANSACTION]
	            RETURN;    

      END;	-- End Try I	------------------------------

		IF var_precioUnit IS NOT NULL THEN
				-- Curso normal
				RAISE NOTICE'El precio del producto [%] es: %',par_CodProd, var_precioUnit;
				
			ELSE
				RAISE NOTICE'No tiene valor asociado [Valor NULL]';
				--
				RETURN;-- ADVERTENCIA
			END IF;

----------------------------- Try/catch II --------------------------- 
 
      BEGIN  		-- Inicio del TRY (Operacion(es) peligrosas)		 [BEGIN = BEGIN TRANSACTION]
		INSERT INTO Detalle VALUES (par_CodDetalle, par_NumPed, par_CodProd, par_Cant, var_precioUnit * par_Cant);
		RAISE NOTICE'Se inserto una tupla';
		

		EXCEPTION	-- Begin Catch II
			
	         WHEN NO_DATA_FOUND THEN 					-- [No hay datos]: Situacion de Error/ Excepcion comun (se maneja aparte) 
	            RAISE NOTICE 'No se pudo insertar (falta dato) (Error)'; 	-- NULL
				-- ROLLBACK:  -- [ROLLBACK TRANSACTION]
	            RETURN; 
	             
	         WHEN TOO_MANY_ROWS THEN 					-- [muchas tuplas]: Situacion de Error/ Excepcion comun (se maneja aparte)
	            RAISE NOTICE 'No se pudo insertar (más de una fila) (Error)';  
				-- ROLLBACK:  -- [ROLLBACK TRANSACTION]
	            RETURN; 
	             
	         WHEN OTHERS THEN 							-- [Otros]: Situacion de Error/ Excepcion maneja todo lo demas
	            RAISE NOTICE 'ERROR en la insercion (Others)';  
				-- ROLLBACK:  -- [ROLLBACK TRANSACTION]
	            RETURN;    
		
	  END;	-- End Try II
		--RETURN	
	END -- END FUNCTION
	$$ 

	
select * FROM  insertarDetalle1113(3, 3, 3, 3);	
select * FROM  insertarDetalle1113(3, 3, 10, 3);

SELECT  insertarDetalle1113(10, 10, 10, 10);	-- El Producto Tiene Precio (Normal)
SELECT  insertarDetalle1113(20, 20, 20, 20);	-- Muchos productos (Error)
SELECT  insertarDetalle1113(30, 30, 30, 30);	-- El producto No tiene Precio (Advertencia)
SELECT  insertarDetalle1113(40, 40, 40, 40);	-- El producto No Existe (Error)


BEGIN TRANSACTION; 
   SELECT  insertarDetalle1113(40, 40, 40, 40);	-- El producto No Existe (Error)
COMMIT TRANSACTION; 
	
SELECT * FROM  Detalle;
DELETE FROM  Detalle;

BEGIN TRANSACTION; 
   SELECT  insertarDetalle1113(10, 10, 10, 10);	-- El Producto Tiene Precio (Normal)
COMMIT TRANSACTION; 
/*
	 Se pueden hacer varias cosas en BuscarPrecio:
		- volver un valor de RETORNO (RETURN QUERY con Setof Tipo_dato) para obtener el Select sin alterar (ver multiples salidas)
	 	- devolver la salida normal y resolverlo con un IF IS NULL y GET DIAGNOSTICS vCantFilas = ROW_COUNT
	 	- Hacer RAISE EXCEPTION 'Mensaje Error Nro: %', var_Error;
	 		--  RAISE EXCEPTION  (NO RECOMENDADO PARA Funcion o Procedure Interno, porque interrumpe codigo)
	 	- Devolver un mensaje (No afecta en nada)
	 		
	 Para insertarDetalle, debera manejar la salida del Procedure interno (sea cual sea, es decir es especifico)
	  A partir de eso insertarDetallese puede:
	 	- Hacer un RAISE EXCEPTION 
		- Hacer un mensaje (con IF, GET DIAGNOSTICS vCantFilas = ROW_COUNT)
		- Hacer un STRICT (Salida ERROR)
		- Hacer un STRICT con Begin-EXCEPTION-End (Manejo Error  y Salida ERROR Personalizada)
		
	(RECORDAR CANCELAR LAS OPERACIONES PELIGROSAS AL HACERLAS [antes tiene que haber un BEGIN TRANSACTION])
	*/

----------------------------------------------------------------------------------------------------------------------------------------------------------------

----------------------------------------------------------------------------------------------------------------------------------------------------------------

	
-------------------------------------------------------------------------- 
----------------------- E j e r c i c i o   5 ---------------------------- 
-------------------------------------------------------------------------.
/*
 Seguimos trabajando con el esquema de tablas que creamos en la Guía de Trabajo Nro. 2 para 
realizar ejercicios de manipulación de datos. 

Trabajaremos nuevamente con las tablas Productos y Detalle, en T-SQL. 

	Vamos a insertar un nuevo producto: 
	
INSERT productos 
VALUES (100, 'Articulo 3', 30, 10) 


Queremos registrar el pedido de cinco unidades de este producto. 

Para ello debemos disminuir su stock en la tabla Productos e insertar inmediatamente los 
datos del pedido en la tabla Detalle  

Nuestro detalle a insertar sería entonces: 

CodDetalle  	1200 
NumPed  		1108
CodProd 		100 
Cant  			5 

Debemos considerar que estas dos operaciones deben tener éxito o fracasar juntas. 
No puede suceder que descontemos 5 unidades de stock y no registremos el pedido. 
Tampoco puede suceder que registremos el pedido y no descontemos las 5 unidades de stock. 

Escriba un batch T-SQL que lleve a cabo la operación transaccionada. 

A fin de facilitar la realización del ejercicio, especifique un valor NULL para la columna 
precioTot. 
*/
	
--	Vamos a insertar un nuevo producto (Prerequisito): 
INSERT INTO productos 
VALUES (100, 'Articulo 3', 30, 10) ;
	
Select * from productos;
Select * from Detalle;

-- Ahora a Resolver el ejercicio:

-- SQL Server:

BEGIN 	------------------------------ BATCH ------------------------------------------
	
	Declare
		@CodDetalle		int,
		@numPed			int,
		@codProd		int,
		@cant			int,
		@precUnit		float
	
	SET @CodDetalle	= '1200'
	SET @numPed		= '1108'
	SET @codProd	= '100'
	SET @cant		= '5'
	
	Select @precUnit = precUnit FROM Productos
		
	BEGIN TRANSACTION
	
	BEGIN TRY				-------------------- Begin Try ---------------------------
		
		UPDATE Productos 
			SET stock = stock - @cant
			WHERE codProd = @codProd
		
		INSERT INTO Detalle Values(@CodDetalle, @numPed	, @codProd, @cant, @cant * @precUnit) 
		
		COMMIT TRANSACTION
		--RETURN 0;
		
	END TRY				-------------------- End Try ---------------------------

	BEGIN CATCH			------------------- Begin Catch ------------------------
	
		EXECUTE usp_GetErrorInfo
		ROLLBACK TRANSACTION
		--RETURN 99;
		
	END CATCH			------------------- End Catch --------------------------
	
END -- end batch


Select * from productos;
Select * from Detalle;
	










