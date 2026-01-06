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

-- SQL Server (todo el capitulo):
/*
En T-SQL, tenemos tres posibilidades para obtener una salida de un stored procedure: 
*/

------------------------- 4.1. Return value ------------------------------ 

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
*/
Declare @retorno integer 
/*
Ejemplo: 
 
EXECUTE spBuscarPublicaciones '1389'
 
Declare @retorno integer 
EXECUTE @retorno =spBuscarPublicaciones ‘1389’
*/


---------------- 4.1.1. Return value personalizado ----------------------- 
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

---------------------- 4.2. Parámetros OUTPUT ---------------------------- 	

-- SQL Server:
/*
	T-SQL permite definir parámetros OUTPUT de cualquiera de los tipos de datos T-SQL. 
Si necesitamos retornar valores individuales, podemos usar este recurso.

Ejemplo 8 

ALTER PROCEDURE obtenerCantidadVendida 
	( 
	@pub_id CHAR(4), 
	@cantidad INTEGER OUTPUT 
	)  
	AS 
		SELECT @cantidad = SUM(qty)  
			FROM sales S INNER JOIN titles T 
					ON S.title_id = T.title_id 
			WHERE T.pub_id = @pub_id 
		RETURN 0   
*/

CREATE PROCEDURE obtenerCantidadVendida2 
   ( 
    @pub_id CHAR(4), 
    @cantidad INTEGER OUTPUT 
   )  
   AS 
      SET @cantidad = ( 
                       SELECT SUM(qty)  
                          FROM sales S INNER JOIN titles T 
                                          ON S.title_id = T.title_id  
                           WHERE T.pub_id = @pub_id 
                      )      
      RETURN 0  


DECLARE @cantidad2 INTEGER                          
EXECUTE  obtenerCantidadVendida2 '1389', @cantidad2 OUTPUT 
SELECT  CONVERT(VARCHAR, @cantidad2)


-------- 4.3. La salida de una sentencia SQL cualquiera sea la forma de la relación ------- 

-- SQL Server:
/*
T-SQL permite retornar directamente la salida de una sentencia SELECT. 
 
 
 
Ejemplo 9 
 */
CREATE PROCEDURE ListarTitles 
AS 
   SELECT * FROM titles;


EXECUTE ListarTitles;




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

----------------- 2.1. Retornar un valor escalar ---------------------- 

-------- 2.1.1. Usando un OUTPUT parameter

--Ejemplo  
CREATE FUNCTION Ejemplo31 
( 
IN prmPub_id VARCHAR(4), 
OUT prmCantidad INTEGER 
) 
RETURNS INTEGER  
AS  
$$ 
DECLARE 
BEGIN 
SELECT SUM(qty)  
INTO prmCantidad 
FROM sales S INNER JOIN titles T 
ON S.title_id = T.title_id 
WHERE T.pub_id = prmPub_id; 
END; 
$$  
LANGUAGE plpgsql 


SELECT Ejemplo31 ('1389'); 

/*
 Como vemos:
  - El tipo del parámetro OUT DEBE COINCIDIR con el tipo de retorno definido para la function.
  - No es necesario especificar sentencia RETURN. 
 */

/*
	Lo primero que debemos destacar es que una función PL/pgSQL NO PERMITE el OUTPUT 
directo  de una sentencia select-from-where como vimos recién en 4.3. 
  
Tenemos la alternativa de usar OUTPUT PARAMETERS.  

Para retornar conjuntos de datos, la función PL/pgSQL proporciona su valor de retorno, que se 
adapta a las diferentes necesidades como veremos a continuación. 
 */

---------------- 2.1.2. Salida directa sin parameter OUT -----------------

--Podemos retornar directamente un valor escalar:
CREATE FUNCTION Ejemplo31B 
( 
IN prmPub_id VARCHAR(4) 
) 
RETURNS INTEGER 
AS  
$$ 
DECLARE 
cantidad INTEGER; 
BEGIN 
cantidad := (SELECT SUM(qty) FROM sales S INNER JOIN titles T  
ON S.title_id = T.title_id WHERE T.pub_id = prmPub_id); 
RETURN cantidad; 
END; 
$$  
LANGUAGE plpgsql


SELECT Ejemplo31B ('1389'); 

/*
...o bien usar la misma estrategia que para una relación unaria (Ver 2.2), retornar setof del 
tipo de dato correspondiente. 
 */


-------------- 2.2. Functions con más de un OUTPUT parameter ------------- 

/*
 Cuando la function posee más de un OUTPUT parameter, debe retornar un RECORD.
 */
CREATE OR REPLACE FUNCTION getMaxMinPrecio 
	( 
	OUT minPrice public.Titles.price%TYPE, 
	OUT maxPrice public.Titles.price%TYPE 
	)  
	RETURNS RECORD 
	AS 
	$$ 
	DECLARE 
	BEGIN 
		minPrice := (SELECT MIN(price) FROM titles); 
		maxPrice := (SELECT MAX(price) FROM titles); 
	END    
	$$ 
	LANGUAGE plpgsql


SELECT  * FROM getMaxMinPrecio ();



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
	RETURNS setof date  
	AS  
	$$ 
	DECLARE 
	BEGIN 
		RETURN QUERY  
			SELECT ord_date FROM Sales; 
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
	RETURNS setof titles  
	AS  
	$$ 
	DECLARE 
	BEGIN 
		RETURN QUERY  
			SELECT * FROM titles; 
	END; 
	$$  
	LANGUAGE plpgsql 
 

SELECT *  
FROM Ejemplo32() 
WHERE pub_id = '1389' ; 


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
CREATE TYPE publisherCT 
	AS ( 
		pub_id CHAR(4),  
		totalPrice numeric 
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
CREATE FUNCTION Ejemplo33 () 
	RETURNS setof publisherCT  
	AS  
	$$ 
	DECLARE 
	BEGIN 
		RETURN QUERY  
			SELECT pub_id, SUM(price) AS totalPrice 
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
CREATE TYPE publisherCT 
	AS ( 
		pub_id CHAR(4),  
		totalPrice numeric 
);

-- Y luego:

CREATE FUNCTION Ejemplo34 () 
	RETURNS setof publisherCT  -- (A)
	AS  
	$$ 
	DECLARE 
		fila publisherCT%ROWTYPE;   -- (B)
	BEGIN 
		fila.pub_id := '0736'; 
		fila.totalPrice := 240.00; 
		
		RETURN NEXT fila;   -- (C)
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



------------------------- 8.1. CASE simple ------------------------------- 	

-------------------------------------------------------------------------- 
----------------------- E j e r c i c i o   1 ---------------------------- 
-------------------------------------------------------------------------.
