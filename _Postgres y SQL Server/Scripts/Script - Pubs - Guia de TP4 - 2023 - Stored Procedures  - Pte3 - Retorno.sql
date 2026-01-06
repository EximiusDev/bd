-- USANDO DataBase pubs:

USE pubs;

------------------------------------------------------------------------

/*
 ============================================
SQL: Guía de Trabajo Nro. 4  
Stored Procedures y functions: Retorno 
 ============================================
 */



------------------ ¿Que retorna un procedure o función? ------------------ 
-------------------------------------------------------------------------- 
/*
El procedure o función va a llevar a cabo una tarea y retornar algo. 
A continuación analizaremos las opciones de retorno que tenemos.
*/

/*
-------------------------------------------------------------------------
1. Salida de un stored procedure en T-SQL
-------------------------------------------------------------------------
*/

-- SQL Server :
/*
En T-SQL, tenemos tres posibilidades para obtener una salida de un stored procedure: 
*/

------------------------- 1.1. Return value ------------------------------ 

/*
	También llamado “status de retorno”. El return value es un valor entero, y está pensado para 
proporcionar un “código de status” al programa invocante.  

En un entorno cliente/servidor el return value sirve para indicar al programa invocante el 
motivo por el cual el procedimiento finalizó su ejecución. 

Bajo condiciones normales, un SP finaliza su ejecución cuando alcanza el final del código del 
mismo o cuando ejecuta una sentencia RETURN. 
 
Esta finalización normal (exitosa) retorna un status de 0. 
	
Microsoft reserva un bloque de números de -1 a -99 para identificar status de error. Solo los 
primeros 14 valores poseen significado: 

Valor 		Significado 
-1 			Falta objeto 
-2			Error de tipo de dato 
-3			El proceso fue elegido como víctima de deadlock. 
-4			Error de permisos 
-5			Error de sintaxis 
-6			Error de usuario de miscelánea 
-7			Error de recursos (sin espacio, por ejemplo) 
-8			Problema interno no fatal.  
-9			El sistema ha alcanzado su límite. 
-10			Inconsistencia interna fatal. 
-11			Inconsistencia interna fatal. 
-12			Tabla o índice corrupto.
-13			Base de datos corrupta. 
-14			Error de hardware	
 */
/*
El valor del status de retorno de un SP puede capturarse mediante la siguiente sintaxis:
 
EXECUTE <@Variable-local-de-tipo-Int> = <Nombre-SP> 
Valor-de-Parametro1, 
Valor-de-Parametro2, 
Valor-de-Parametro3 

Declare @retorno integer 

Ejemplo: 
 */
CREATE PROCEDURE spBuscarPublicaciones(
	@pub_id		char(4)
	)
	AS
		SELECT * FROM Titles
			WHERE pub_id = @pub_id
		IF @@rowcount <> 0
			begin
				PRINT'Existe'
				return 0
			end
		Else
			begin
				print'NO Existe'
				return 33;
			end --end if


EXECUTE spBuscarPublicaciones '0000';
 
Declare @retorno integer 
EXECUTE @retorno = spBuscarPublicaciones '1389'
print'@retorno: ' + cast(@retorno as varchar); 



---------------- 1.1.1. Return value personalizado ----------------------- 
/*
	Podemos valernos de esta característica para explotarla a nuestro favor.  
Si tenemos un programa principal que invoca a otro secundario, el secundario puede indicarle 
al principal cómo resultó la ejecución a través de su return value: 
 */


/*
	Si un SP interno -invocado por otro SP- genera una determinada condición que consideramos 
un error para nuestra aplicación (un no cumplimiento de  una regla de negocio, por ejemplo)  
el desarrollador puede notificar de esta situación al SP invocante retornando un valor de 
retorno “personalizado” que el SP invocante pueda interpretar.

En T-SQL, estos códigos de error pueden ser cualquier valor de tipo Int fuera de los 
reservados (-99 a -1) y se especifican a continuación de la(s) cláusula(s) RETURN en el SP 
invocado.
 */

---------------------- 1.2. Parámetros OUTPUT ---------------------------- 	

-- SQL Server:
/*
	T-SQL permite definir parámetros OUTPUT de cualquiera de los tipos de datos T-SQL. 
Si necesitamos retornar valores individuales, podemos usar este recurso.

Ejemplo 8 
*/
-- CREATE
ALTER PROCEDURE obtenerCantidadVendida2 
   ( 
    @pub_id CHAR(4), 
    @cantidad INTEGER OUTPUT  				-- Parametro de salida
   )  
   AS 
      SET @cantidad = (   					--pongo la salida del Select en el parametro de salida
                       SELECT SUM(qty)  
                          FROM sales S INNER JOIN titles T 
                                          ON S.title_id = T.title_id  
                           WHERE T.pub_id = @pub_id 
                      )      
      RETURN 0    							-- tomo un valor de retorno 0


DECLARE @cantidad2 INTEGER                				  		-- declaro una variable                                  
EXECUTE  obtenerCantidadVendida2 '1389', @cantidad2 OUTPUT 		-- asigno la variable como Parametro d salida del Procedure
SELECT  CONVERT(VARCHAR, @cantidad2)							-- muestro el parametro de salida


-- PostgreSQL:

create or Replace FUNCTION obtenerCantidadVendida2(
		IN 		prm_pub_id 		CHAR(4), 
    	OUT 	prm_cantidad 	INTEGER   				-- Parametro de salida
   )  
   RETURNS INTEGER							-- La salida tiene que ser igual que el PARAMETRO de Salida
   language plpgsql
   AS
   $$
   BEGIN
   		prm_cantidad := (   					--pongo la salida del Select en el parametro de salida
                       SELECT SUM(qty)  
                          FROM sales S INNER JOIN titles T 
                                          ON S.title_id = T.title_id  
                           WHERE T.pub_id = prm_pub_id 
                      );
   END
$$
   
select obtenerCantidadVendida2 ('1389');

do
$$
declare cantidad2	INTEGER;
	begin
		cantidad2 := (SELECT obtenerCantidadVendida2 ('1389'));
		--SELECT  'CANTIDAD: ' || CAST( cantidad2 AS varchar);
		RAISE NOTICE 'CANTIDAD: %', cantidad2;
	end
$$

-------- 1.3. La salida de una sentencia SQL cualquiera sea la forma de la relación ------- 

-- SQL Server:
/*
T-SQL permite retornar directamente la salida de una sentencia SELECT. 
 
 
 
Ejemplo 9 
 */
CREATE PROCEDURE ListarTitles 
AS 
   SELECT * FROM titles;


EXECUTE ListarTitles;		-- Que pasa aca? xq se ejecuta tantas veces?



/*
-------------------------------------------------------------------------
2. Salida de una function PL/pgSQL
-------------------------------------------------------------------------
*/

-- PostgreSQL:
/*
En una función PL/pgSQL podemos obtener la salida a través de OUTPUT PARAMETERS o con 
un query con una sintaxis especial- 
En un caso u otro, el resultado se debe ajustar al tipo de retorno de la function. 
 */

/* REVISAR:
	Lo primero que debemos destacar es que una función PL/pgSQL NO PERMITE el OUTPUT 
directo  de una sentencia select-from-where como vimos recién en 4.3. 
  
Tenemos la alternativa de usar OUTPUT PARAMETERS.  

Para retornar conjuntos de datos, la función PL/pgSQL proporciona su valor de retorno, que se 
adapta a las diferentes necesidades como veremos a continuación. 
 */

----------------- 2.1. Retornar un valor escalar ---------------------- 

-------- 2.1.1. Usando un OUTPUT parameter

--Ejemplo  

-- PostgreSQL:
CREATE or Replace FUNCTION Ejemplo31 
	( 
		IN prmPub_id VARCHAR(4), 
		OUT prmCantidad INTEGER 	-- defino el Output Parameter
	) 
	RETURNS INTEGER  				-- digo que voy a retornar una salida del mismo tipo que el Output Parameter
	AS  
	$$ 
	DECLARE 
	BEGIN 
		SELECT SUM(qty)  
			INTO prmCantidad 			-- pongo la salida del Select en el Output Parameter
			FROM sales S INNER JOIN titles T 
			ON S.title_id = T.title_id 
			WHERE T.pub_id = prmPub_id; 
		--RETURN 						-- No es necesario especificar una sentencia Return
	END; 
	$$  
	LANGUAGE plpgsql 


SELECT Ejemplo31 ('1389');		-- Ejecuto la Function con su INput parameter 

/*
 Como vemos:
  - El tipo del parámetro OUT DEBE COINCIDIR con el tipo de retorno definido para la function.
  - No es necesario especificar sentencia RETURN. 
 */

---------------- 2.1.2. Salida directa sin parameter OUT -----------------

--Podemos retornar directamente un valor escalar:
create or Replace FUNCTION Ejemplo31B 
	( 
		IN prmPub_id VARCHAR(4) 	-- NO hay Output Parameter 
	) 
	RETURNS INTEGER 				-- tenemos un Return de tipo INTEGER (digo que voy a retornar una salida del mismo tipo que una Variable que defini)
	AS  
	$$ 
	DECLARE 
		cantidad INTEGER; 			-- defino una Variable del mismo tipo que voy a retornar
	BEGIN 
		cantidad := (				-- igualo la Varible a la salida del Select
			SELECT SUM(qty) FROM sales S INNER JOIN titles T  
				ON S.title_id = T.title_id WHERE T.pub_id = prmPub_id); 
		RETURN cantidad; 			-- Retorno la variable que defini (sin Out Parameter es necesario)
	END; 
	$$  
	LANGUAGE plpgsql


SELECT Ejemplo31B ('1389'); 

/*
...o bien usar la misma estrategia que para una relación unaria (Ver 2.2), retornar setof del 
tipo de dato correspondiente. 


También tenemos la posibilidad de definir como tipo de retorno un tipo anclado:
 */
CREATE OR REPLACE FUNCTION Ejemplo31C 
   ( 
    IN prmPub_id VARCHAR(4) 
   ) 
   RETURNS Publishers.pub_name%TYPE  			-- digo que voy a retornar un tipo anclado de la tabla "Publishers" del atributo "pub_name"
   AS  
   $$ 
   DECLARE 
      pub_name1 Publishers.pub_name%TYPE;   	-- declaro una Variable d tipo anclado de la tabla "Publishers" del atributo "pub_name"
   BEGIN 
      pub_name1 := (							-- igualo la Varible anclada a la salida del Select
				SELECT pub_name FROM Publishers P  
                    WHERE P.pub_id = prmPub_id); 
      RETURN pub_name1; 
   END; 
   $$  
   LANGUAGE plpgsql 
 
 
SELECT Ejemplo31C('1389') 


-------------- 2.2. Functions con más de un OUTPUT parameter ------------- 

/*
 Cuando la function posee más de un OUTPUT parameter, debe retornar un RECORD.
 */
CREATE OR REPLACE FUNCTION getMaxMinPrecio 
	( 
	OUT minPrice public.Titles.price%TYPE, 		-- defino uno de los Output Parameter
	OUT maxPrice public.Titles.price%TYPE  		-- defino uno de los Output Parameter
	)  
	RETURNS RECORD 				-- digo que el valor de retorno va a ser un RECORD
	AS 
	$$ 
	DECLARE 
	BEGIN 
		minPrice := (SELECT MIN(price) FROM titles);	-- igualo la salida del Select a un Output Parameter
		maxPrice := (SELECT MAX(price) FROM titles); 	-- igualo la salida del Select a un Output Parameter
	END    
	$$ 
	LANGUAGE plpgsql


SELECT  * FROM getMaxMinPrecio ();
SELECT getMaxMinPrecio ();



-------------------- 2.3. Retornar una relación unaria ------------------- 

/*
 Ver “2. Relación unaria”  en el documento  
“Relations y SQL”.  
 */
-- PostgreSQL:
/*
PL/pgSQL permite definir el valor de retorno de una función como Setof <Tipo-De-Dato>. 
Esto permite que una función retorne una especie de “lista” de valores. 
 
Por un lado definimos el tipo de retorno de la función. Por ejemplo: 
 */
-- RETURNS setof FLOAT
 /*
Y en el cuerpo del procedimiento debemos utilizar una cláusula RETURN especial: RETURN 
QUERY. Por ejemplo:

  
Ejemplo  
 */

CREATE FUNCTION Ejemplo30 () 
	RETURNS setof date  					-- devuelvo una lista (Setof) de un atributo (tipo date)
	AS  
	$$ 
	DECLARE 
	BEGIN 
		RETURN QUERY  						-- uso RETURN QUERY para devolver la "lista" de valores (el atributo) del Select
			SELECT ord_date FROM Sales; 	-- tengo como salida del Select una lista de valores (de un unico atributo)
	END; 
	$$  
	LANGUAGE plpgsql 



SELECT Ejemplo30 (); 




----------------- 2.4. Retornar sets de tuplas completas ----------------- 

/*
Si especificamos un valor de retorno como setof <nombre-de-tabla>  la función podrá 
retornar cualquier conjunto de tuplas de la tabla especificada.  

Por un lado definimos el tipo de retorno de la función: 


RETURNS setof titles 

Y en el cuerpo del procedimiento utilizamos RETURN QUERY. 
Por ejemplo: 

Ejemplo 
*/
CREATE FUNCTION Ejemplo32 () 
	RETURNS setof titles   			-- devuelvo una lista (Setof) de una tabla completa (titles)
	AS  
	$$ 
	DECLARE 
	BEGIN 
		RETURN QUERY  				-- uso RETURN QUERY para devolver la lista de tuplas (las columnas enteras) del Select
			SELECT * FROM titles; 	 -- tengo como salida del Select una lista de tuplas (de columnas enteras)
	END; 
	$$  
	LANGUAGE plpgsql 
 

SELECT *  
	FROM Ejemplo32() 
	WHERE pub_id = '1389' ; 		-- para ejecutar una funcion se pueden especificar condiciones


SELECT * FROM titles
	WHERE pub_id = '1389' ; 


------------- 2.5. Retornar sets de projections de tuplas ----------------

/*
Conjunto de Projections de tuplas  
Ver “5. Conjunto de Projections de tuplas”  en el documento “Relations y SQL”.
 */

/*
	Si se necesita obtener una relación que posee un conjunto de Projections de 
tuplas podemos definir un composite-type con la estructura a retornar: 
Schema level
 */
CREATE TYPE publisherCT 			-- Defino un Composite-Type
	AS ( 
		pub_id CHAR(4),  			-- variable del Comp-Tipe
		totalPrice numeric 			-- variable del Comp-Tipe
	); 

/*
	Composite Types  
Ya vimos como crear y utilizar Composite types en  “2.4. Sentencias SELECT 
Single-row que retornan una Projection de una tupla”  en este mismo 
documento.  
 */


/*
 Luego nuestra function es definida para retornar este composite-type.  
En el cuerpo del procedimiento también utilizamos RETURN QUERY: 

Ejemplo 
 */
create or Replace FUNCTION Ejemplo33 () 
	RETURNS setof publisherCT  			-- digo que voy a devolver un Seof (lista de valores) de tipo publisherCT (Composite-Type)
	AS  
	$$ 
	DECLARE 
	BEGIN 
		RETURN QUERY    				-- uso RETURN QUERY para devolver la lista de projecciones de tuplas (parte de columnas ) del Select
			SELECT pub_id, SUM(price) AS totalPrice 		-- Devuelvo 2 columnas del Select
			FROM titles 
			WHERE price IS NOT NULL 
			GROUP BY pub_id; 
	END; 
	$$  
	LANGUAGE plpgsql 


	
	SELECT *  
FROM Ejemplo33();




------------------------- 2.6. Return Next -------------------------------

-- PostgreSQL:
/*
En PL/pgSQL también podemos retornar un record que asuma la forma de un Composite 
Type. 

Es una forma que debemos usar cuando lo que queremos retornar NO ES resultado de 
un query, sino que se trata de algo que estamos armando por nosotros mismos. 

Primero definimos un composite-type con la estructura deseada.  Por ejemplo: 


Ejemplo 14
*/
CREATE TYPE publisherCT  			-- Defino un Composite-Type
	AS ( 
		pub_id CHAR(4),  
		totalPrice numeric 
);

-- Y luego:

CREATE FUNCTION Ejemplo34 () 
	RETURNS setof publisherCT  -- (A)		-- digo que voy a devolver un Seof (lista de valores) de tipo publisherCT (Composite-Type)
	AS  
	$$ 
	DECLARE 
		fila publisherCT %ROWTYPE;   -- (B)	-- declaro fila como el Composite-Type (publisherCT) igual que con una tabla
	BEGIN 
		fila.pub_id := '0736'; 				-- defino yo mismo que es lo que voy a retornar en el Composite-Type
		fila.totalPrice := 240.00; 
		
		RETURN NEXT fila;   -- (C)			-- devuelvo NEXT (algo que no es resultado de un QUERY)
	END; 
	$$  
	LANGUAGE plpgsql 

/*
 Nuestra function es definida para retornar sets de este composite-type (A).  
 
Definimos una variable especial de tipo <composite-type>%rowtype (B). 

En el cuerpo del procedimiento utilizamos una cláusula RETURN NEXT <tupla-del
composite-type> (C).
 */
SELECT *  
FROM Ejemplo34(); 



--------------------------------------------------------------------------
-------------------------------------------------------------------------- 

----------------------- E j e r c i c i o   x ---------------------------- 
-------------------------------------------------------------------------.
