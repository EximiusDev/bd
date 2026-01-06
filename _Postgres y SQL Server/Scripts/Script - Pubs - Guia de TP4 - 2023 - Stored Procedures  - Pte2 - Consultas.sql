-- USANDO DataBase pubs:

USE pubs;

------------------------------------------------------------------------

/*
 ============================================
SQL: Guía de Trabajo Nro. 4  
Stored Procedures: Consultas 
 ============================================
 */

------¿Como utilizo las consultas SQL en el contexto de un programa?-----
-------------------------------------------------------------------------
/*
Como hemos estado viendo hasta aquí los procedures T-SQL y las funciones PL/pgSQL son 
programas bastante parecidos a los de otros lenguajes de programación. Su poder sin 
embargo radica en su vínculo tan estrecho con SQL y las posibilidades que brinda la 
interacción entre ambos. 

Veremos cómo se lleva a cabo esta interacción. 
 */
/*
-------------------------------------------------------------------------
1. Queries de los que no almacenamos su resultado
-------------------------------------------------------------------------
*/

/*
 La primer categoría que analizaremos es la de consultas de las cuales no necesitamos 
almacenar su resultado. 

Estas consultas se utilizan mucho en estructuras condicionales. 

Ejemplo 1
 
 Ver “2.1. Subqueries que producen valores escalares” en la “Guía de trabajo 
Nro. 3 - Parte 2” 
 
 Podemos utilizar SQL en una estructura condicional de la siguiente forma:


 IF 1 <= (SELECT COUNT(*)  
FROM titles  
WHERE pub_id = '1389') 
PRINT 'Posee más de una publicación' 
... --END IF
 */

-- SQL Server: 
IF 1 <= (SELECT COUNT(*)  
FROM titles  
WHERE pub_id = '1389')
	begin
		PRINT 'Posee más de una publicación' 
	end
ELSE
	begin
		PRINT 'AAAAAAAAAAAAn'
	end; -- END if

-- PostgreSQL (NeCESITA UN Batch con DO):

 DO
 $$
 BEGIN
	IF 1 <= (SELECT COUNT(*)  
		FROM titles  
		WHERE pub_id = '1389') THEN 
		RAISE NOTICE 'Posee más de una publicación'; 
	ELSE
		RAISE NOTICE 'AAAAAAAAAAAAn';
	END IF;
END;
$$


Ejemplo 2 

Ver “2.2. Condiciones que involucran relaciones” en la “Guía de trabajo Nro. 3 - 
Parte 2” 

Podemos utilizar SQL en una estructura condicional de la siguiente forma: 

IF 'D4482' IN (SELECT ord_num  
                  FROM Sales) 
   PRINT 'Existe la factura' 
   ... 
 --END IF 
*/	

--SQL Server:
IF 'D4482' IN (SELECT ord_num  
                  FROM Sales) 
   begin
		PRINT 'Posee más de una publicación' 
	end
ELSE
	begin
		PRINT 'AAAAAAAAAAAAn'
	end; --END IF 


/*
Ejemplo 3

Ver “2.2.6. El cuantificador EXISTS” en la “Guía de trabajo Nro. 3 - Parte 2”

Podemos utilizar SQL en una estructura condicional de la siguiente forma: 

IF NOT EXISTS (SELECT *  
                  FROM titles  
                  WHERE pub_id = '3389') 
   PRINT 'No existe' 
   ... 
 --END IF
 */
--SQL Server:
IF NOT EXISTS (SELECT *  
                  FROM titles  
                  WHERE pub_id = '3389') 
   begin
		PRINT 'No existe' 
	end
ELSE
	begin
		PRINT 'existe'
	end; --END IF 



-- Tanto T-SQL como PL/pgSQL soportan queries en condiciones. 

 DO
 $$
 BEGIN
	IF NOT EXISTS (SELECT *  
                  FROM titles  
                  WHERE pub_id = '3389') 
             THEN 
		RAISE NOTICE 'No existe'; 
	ELSE
		RAISE NOTICE 'existe';
	END IF;
END;
$$

/*
-------------------------------------------------------------------------
2. Queries de los que almacenamos su resultado 
-------------------------------------------------------------------------
*/

-------------- 2.1. Queries que retornan un valor escalar ----------------

/*
Ver “2.1. Subqueries que producen valores escalares” en la “Guía de trabajo 
Nro. 3 - Parte 2” 	
 */
/*
Los queries que retornan un valor escalar se pueden usar al lado derecho de las sentencias de 
asignación, encerrados entre paréntesis.
 */

-- SQL Server:
 /*
SET @price = (SELECT price  
FROM titles  
WHERE title_id = @title_id);
 */

--BEGIN -- Se puede o no poner
	DECLARE @PRICE float,				-- declaracion de variables
	 		@title_id  varchar(6)
	SET @title_id = 'BU1032'
	SET	@price = (SELECT price  	
			FROM titles  
			WHERE title_id = @title_id)		
	SELECT @price;
--END


-- PostgreSQL:
/*
price1 := (SELECT price  
FROM titles  
WHERE title_id = title_id1);
 */
 DO
 $$

DECLARE price1 titles.price %TYPE;   -- scalar anchoring
BEGIN
	price1 := (SELECT price  
		FROM titles  
		WHERE title_id = 'PC1035');

	RAISE NOTICE 'price1: %', price1;
END
$$
/*
	Más allá de la asignación a una variable, todo valor retornado por una consulta de este tipo 
puede en realidad ser considerado como un valor más en nuestro programa, que como tal 
puede ser usado en el contexto de cualquier expresión.
 */




/*
Las variables para almacenar un valor escalar deben ser declaradas por supuesto, con su tipo 
de dato correspondiente. 
En el caso de PL/pgSQL tenemos la alternativa de utilizar lo que se denomina anchored 
declarations. 
 */

-- PostgreSQL:
/*
 Anchored declarations 
 
Las Anchored Declarations son declaraciones de variables especiales en las 
que se “asocia” la declaración de la variable a un objeto de la base de 
datos. 
 
Cuando asociamos de esta manera un tipo de dato estamos indicando que 
queremos establecer como tipo de dato de nuestra variable al tipo de dato 
de una estructura de datos previamente definida, que puede ser una 
tabla de la base de datos, una columna de una tabla, o un TYPE predefinido.
 */

-- SQL Server:
 --T-SQL no soporta anchored declarations.


-- PostgreSQL:
/*
 Scalar anchoring
  
Un scalar anchoring define una variable en base a una columna de una 
tabla.  
 
Se especifican a través del atributo %TYPE.
 */


--Ejemplo 4

DO
$$
DECLARE 
      price1 titles.price%TYPE;   -- scalar anchoring
 
   BEGIN 
      price1 := (SELECT price  
                    FROM titles  
                    WHERE title_id = 'TC7777'); 
 
      RAISE NOTICE 'El precio es %', price1; 
 
      --...     
   END   
   $$

/*
DECLARE 
      precio titles.price%TYPE; 
 
   BEGIN 
      precio := (SELECT price  
                    FROM titles  
                    WHERE title_id = prmTitle_id); 
 
      RAISE NOTICE 'La publicación % vale $%', prmTitle_id, precio; 
   END 
*/

------------------- 2.2. Sentencias SELECT Single-row --------------------

/*
 Sentencias SQL single row
 
 En el documento “Relations y SQL”  vimos  
las sentencias SQL single row.  
 
Ahora veremos como se recuperan los valores que retornan estas sentencias 
desde el código T-SQL y PL/pgSQL.  
 */

-- SQL Server:
/*
 En T-SQL recuperamos los valores de una sentencia SELECT single-row 
anteponiendo una variable y un signo “=” a la columna o expresión:  

DECLARE  
   @price FLOAT, 
   @type CHAR(12)  
SELECT @price = price, @type = type  
   FROM titles  
   WHERE title_id = 'TC7777'; --  WHERE title_id =  @title_id; 
 */
BEGIN
   
DECLARE  
   @title_id 	CHAR(6) = 'TC7777',
   @price 		FLOAT, 				-- Variables
   @type 		CHAR(12)  
SELECT @price = price, @type = type  -- variables de salida del SELECT
   FROM titles  
   WHERE title_id = @title_id; 
	PRINT'title_id: ' + @title_id + ' @price: ' + CONVERT(varchar(20),@price) + ' @type: ' + CONVERT(varchar(20), @type);
END

-- PostgreSQL:
/*
	En PL/pgSQL recuperamos los valores de una sentencia SELECT single-row con 
una cláusula INTO que especifica las variables donde deben ser ubicados los 
componentes de esa única tupla. Estas variables pueden ser tipos anclados: 
*/
DO
$$
 DECLARE 
    price1 titles.price%TYPE;  -- scalar anchoring
    type1 titles.type%TYPE;  
 
 BEGIN 
    SELECT price, type INTO price1, type1   -- variables de salida del SELECT
       FROM titles  
       WHERE title_id = 'TC7777'; 
          
    RAISE NOTICE 'El precio es %', price1; 
    -- ... 
 END    
 $$
 /*
Si la sentencia SELECT no recuperara ninguna tupla, las variables asumirían el valor 
NULL.

Ej
 */
CREATE OR REPLACE FUNCTION Ejemplo25 
   ( 
    IN prmTitle_id VARCHAR(6) 
   ) 
   RETURNS void  			-- return value (NO devuelvo nada)
   AS  
   $$ 
   DECLARE 
      price1 titles.price%TYPE; -- scalar anchoring
      type1 titles.type%TYPE; 
   BEGIN 
      SELECT price, type INTO price1, type1 	-- variables de salida
         FROM titles  
         WHERE title_id = prmTitle_id; 
 
      RAISE NOTICE 'La publicación % es de tipo % y vale $%', prmTitle_id,  
                    trim(both from type1), price1; 
      RETURN;    
   END; 
   $$  
   LANGUAGE plpgsql 
  
   
  SELECT Ejemplo25 ('TC7777');

/*
En cualquier caso los tipos de datos entre los atributos recuperados y las variables deben ser 
compatibles, de otra forma los datos pueden perder precisión o resultar truncados. 	
 */

  
  
-- PostgreSQL:
/*
	La variable FOUND 
	
PostgreSQL proporciona una variable especial llamada FOUND que nos 
indica si un sentencia SQL encontró o no tuplas como resultado de su 
ejecución.
 Por ejemplo: 

SELECT price 
INTO vPrice 
FROM titles 
WHERE title_id = 'PC6565'; 

IF NOT FOUND THEN 
RAISE NOTICE 'Publicación no encontrada'; 
END IF;   

Ej:
*/
  CREATE OR REPLACE FUNCTION Ejemplo26 ( 
    IN prmTitle_id VARCHAR(6) 
   ) 
   RETURNS void  
   AS  
   $$ 
   DECLARE 
      price1 titles.price%TYPE; 
   type1 titles.type%TYPE; 
   BEGIN 
      SELECT price, type INTO price1, type1   -- variables de salida del SELECT
         FROM titles  
         WHERE title_id = prmTitle_id; 
      IF NOT FOUND THEN  					-- Si no se encutan la publicacion
         RAISE NOTICE 'Publicación no encontrada'; 
	  ELSE
		 RAISE NOTICE 'Publicación encontrada'; 
      END IF; 
      RETURN;    
   END; 
   $$  
   LANGUAGE plpgsql 
  
   
  SELECT Ejemplo26 ('PC6565');
  SELECT Ejemplo26 ('PC8888');
  
-- SQL Server:
  /*
   Se puede usar la variable @@row_count para saber si alguna fila fue modificada
   Ej:
   */
  begin
	  DECLARE
			@price FLOAT,
			@type char(12),
			@Title_id varchar(6);
	  SET @Title_id = 'XXXXXX' -- 'BU1111'
	  -- SET @Title_id = 'BU1111'
	  SELECT @price = price, @type = type  -- variables de salida del SELECT
         FROM titles  
         WHERE title_id = @Title_id 
      IF @@rowcount = 0   					-- Si no se encutan la publicacion
         print 'Publicación no encontrada' 
	  ELSE
		 print 'Publicación encontrada' 
      --END IF; 
end


---- 2.3. Sentencias SELECT Single-row que retornan una tupla completa----

/*
Sentencias SQL single row que retornan una tupla completa 
Ver “3.1. Sentencias SQL single row que retornan una tupla completa” en el 
documento “Relations y SQL”
 */

 -- PostgreSQL:
/*
	Record anchoring   
	 Table-based record 

Un record anchoring define una variable –que poseerá una estructura de 
record- en base al schema de una tupla completa
 de una tabla.  
Cada campo corresponde a –y tiene el mismo nombre que- una columna en 
la tabla.

Se especifican anexando al nombre de la tabla el atributo %ROWTYPE. Por 
ejemplo: 

DECLARE 
titleRec titles%ROWTYPE;

Luego de recuperados los datos, podemos acceder a cada uno de los 
componentes de la estructura de record usando una sintaxis de punto. Por 
ejemplo: 

titleRec.price 
*/

	
--Ejemplo 5 
  /*
DECLARE 
titleRec titles%ROWTYPE; 
BEGIN 
SELECT * INTO titleRec 
FROM titles  
WHERE title_id = prmTitle_id; 
RAISE NOTICE 'La publicación % es de tipo % y vale $%', prmTitle_id, 
trim(both from titleRec.type), titleRec.price; 
... 
END 
   */
DO
$$
DECLARE 
	titleRec titles%ROWTYPE;		--Record anchoring (toma forma de tabla)
BEGIN 
	SELECT *  
		INTO titleRec 			-- Lo ingresa en el Record anchoring  (con forma de tabla)
		FROM titles  
		WHERE title_id = 'BU1032'; 
	 
	RAISE NOTICE 'El precio es %', titleRec.price; 	-- los atributos del record-tabla se acceden mediante "."
	--...
END  
$$
 
 /*
 	Cuando la variable es un record asociado a una tupla completa, en la sentencia SELECT solo 
podemos recuperar la totalidad de las columnas de la tupla. No podemos recuperar una 
projection de tuplas. 
  */
 
  
----------- 2.4. Sentencias SELECT Single-row que retornan una Projection de una tupla ----------
 
/*
	Ver “3.2. Sentencias SQL single row que retornan una Projection de una tupla” 
en el documento “Relations y SQL” 
 */
 /*
 	En este caso, y solamente para PL/pgSQL, tenemos una alternativa más usando declaraciones 
ancladas. 

Tenemos que hacer un paso adicional: tenemos que definir una estructura de record que 
pueda recibir de la tupla sólo los atributos que necesitamos. 

PostgreSQL llama a esto un composite-type.  

Se crean con la sentencia CREATE TYPE. Luego de la cláusula AS, definimos la estructura del 
type de manera similar a como hacemos con la definición de una tabla: 
  */
   -- PostgreSQL:
  
 CREATE TYPE publisherCT  -- definicion de Composite-type
	AS ( 
		pub_id CHAR(4),  
		totalPrice numeric 
		); 
 
/*
	Este TYPE se define a nivel schema, fuera de la función PL/pgSQL.
	 
Una vez creado el type, podemos “anclar” variables al mismo, como si se tratase 
prácticamente de una tabla.


 El siguiente ejemplo ilustra este caso:
 
 Ejemplo 6
 
  -- PostgreSQL:
 */
CREATE TYPE titleCT  -- definicion de Composite-type
	AS ( 
		title_id char(6),  
		price numeric 		
		);
-- ... 
-- ...  
DO 		-- BATCH 
$$
 DECLARE 
	titleRec titleCT %ROWTYPE;  -- Declaro titleRec como un Composite-type
 
BEGIN 
	SELECT title_id, price INTO titleRec -- pongo la salida del select en el Composite-type
		FROM titles  
		WHERE title_id = 'BU1032'; 
	RAISE NOTICE 'El precio es %', titleRec.price;
	-- ... 
 END 
$$
/*
 DECLARE 
	titleRec titleCT%ROWTYPE; 
BEGIN 
	SELECT type, price INTO titleRec 
		FROM titles  
		WHERE title_id = prmTitle_id; 
	RAISE NOTICE 'La publicación % es de tipo % y vale $%',  
		prmTitle_id, trim(both from titleRec.type), titleRec.price; 
	RETURN;    
END; 
 */
 
--------------------------- 2.5. Records  -------------------------------- 

/*
	Sin embargo la solución más práctica es usar un tipo de dato RECORD datatype:
	 
El tipo de dato RECORD no adhiere a un formato de relación determinado. Adopta la forma en el 
momento de la asignación.
 
El siguiente ejemplo ilustra su uso para una Projection de una tupla: 


Ejemplo 7
 */

CREATE OR REPLACE FUNCTION test10B()  
	RETURNS VOID 				-- El valor de salida es VOID para RECORD
	LANGUAGE plpgsql 
	AS 
	$$ 
	DECLARE 
		titleRec RECORD; 		-- declaro el RECORD (variable, depende del Select)

	BEGIN 
		SELECT title_id, price INTO titleRec  -- meto las variables dentro del RECORD
			FROM titles  
			WHERE title_id = 'BU1032';

		RAISE NOTICE 'El precio es %', titleRec.price;
	
	END
	$$;


SELECT test10B ();

--- Otro Ejemplo: ------
CREATE OR REPLACE FUNCTION Ejemplo29 ( 
		IN prmTitle_id VARCHAR(6) 
	) 
	RETURNS void  	-- El valor de salida es VOID para RECORD
	AS  
	$$ 
	DECLARE 
		titleRec RECORD;  		-- declaro el RECORD (variable, depende del Select)
	BEGIN 
		SELECT type, price INTO titleRec  -- meto las variables dentro del RECORD 	
			FROM titles  
			WHERE title_id = prmTitle_id; 
		RAISE NOTICE 'La publicación % es de tipo % y vale $%',  
			prmTitle_id, trim(both from titleRec.type),  
			titleRec.price; 
		RETURN;    
	END; 
	$$  
	LANGUAGE plpgsql 


SELECT Ejemplo29 ('BU1032');

/*
-------------------------------------------------------------------------
3. SELECT sobre expresiones 
-------------------------------------------------------------------------
*/

-- SQL Server:
/*
	En T-SQL podemos consultar el valor de cualquier variable o expresión usando 
directamente la sentencia SELECT:  

SELECT @<nombre-variable> 
*/
begin
	DECLARE
		 @variable1 VARCHAR(10),
		 @variable2 VARCHAR(10)
	SET @variable1 = 'hola'
	SELECT @variable2 = 'buen dia'
	SELECT @variable1				-- SELECT @<nombre-variable> 
	SELECT @variable2				-- SELECT @<nombre-variable> 
end
/*

Esto es muy útil cuando estamos programando batches.   

También, como veremos más adelante, T-SQL permite que la salida de un stored 
procedure sea una sentencia SELECT, así que tenemos la posibilidad de retornar 
cualquier valor que querramos disparando directamente un SELECT de este tipo.
 */



----------------------------- SQL dinámico  ------------------------------
--------------------------------------------------------------------------

/*
Muchos motores de bases de datos permiten definir sentencias SQL a partir de una cadena de 
caracteres construida a partir de elementos variables.
 */

-- SQL Server:	
/*
Ejecutamos una cadena de caracteres como una sentencia SQL a través 
del comando EXEC (o EXECUTE): 
 
EXEC (@Nombre-de-variable) 
 
 
En el siguiente ejemplo disparamos un SELECT sobre una tabla y columna 
de salida cuyos nombres conocemos en tiempo de ejecución: 
 */
 
DECLARE @Cad Varchar(100) 
DECLARE @nomTabla Varchar(30) = 'titles' 
DECLARE @nomColumna VARCHAR(30) = 'title_id' 
 
SET @Cad = '        SELECT ' + @nomColumna; 
SET @Cad = @Cad + '    FROM ' + @nomTabla;  
EXEC (@Cad) 
 

 -- PostgreSQL:
/*
Ejecutamos la cadena de caracteres como una sentencia SQL a través del 
comando EXECUTE: 
 
EXECUTE Nombre-de-variable 
 
 
El siguiente es el mismo ejemplo de SQL dinámico en una función PL/pgSQL: 
 
   ... 
  DECLARE 
      cad Varchar(100); 
      nomTabla Varchar(30) := 'titles'; 
      nomColumna VARCHAR(30) := 'title_id'; 
   BEGIN 
 
      cad := 'SELECT ' || nomColumna; 
      cad = cad || ' FROM ' || nomTabla;  
 
      RETURN QUERY EXECUTE cad; 
   END 
   ...   
*/
CREATE OR REPLACE FUNCTION SQL_DINAMICO_1()
RETURNS Setof Varchar						-- se necesita un setof del tipo de "texto" para la ejecucion
LANGUAGE plpgsql  
AS
$$
DECLARE 
      cad Varchar(100); 				--Se declara variables para definir dinamicamente en momento de ejecucion
      nomTabla Varchar(30) := 'titles'; 		
      nomColumna VARCHAR(30) := 'title_id'; 
   BEGIN 
 
      cad := 'SELECT ' || nomColumna; 	-- se crea la secuencia de ejecucion en el momento (para c/caso)
      cad = cad || ' FROM ' || nomTabla;  
 
      RETURN QUERY EXECUTE cad; 		-- se usa RETURN QUERY, acompañado de EXECUTE y la sentencia
   END 
$$

SELECT * FROM SQL_DINAMICO_1()



----------------------------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------------------------


/*
-------------------------------------------------------------------------
8. Demarcación de transacciones en SQL 
-------------------------------------------------------------------------
*/
/*
Recordemos que una transacción es un grupo de sentencias que deben ejecutarse de manera 
exitosa como una unidad o fracasar también de manera completa. 

En SQL podemos demarcar un conjunto de sentencias para indicar al DBMS que las mismas 
deben ejecutarse como una unidad.
 
Iniciamos una transacción usando la sentencia BEGIN TRANSACTION 

Hay dos maneras de finalizar una transacción: 

A. La sentencia SQL COMMIT TRANSACTION provoca que la transacción finalice de manera 
satisfactoria. Cualquier cambio a la base de datos provocado por la o las sentencias SQL desde 
el inicio de la transacción es “hecho permanente” en la base de datos. Antes de que la 
sentencia COMMIT sea ejecutada, los cambios son tentativos y pueden o no ser visibles a 
otras transacciones. 

B. La sentencia SQL ROLLBACK TRANSACTION provoca que la transacción sea abortada o 
terminada de manera no satisfactoria. Cualquier cambio llevado a cabo por las sentencias SQL 
involucradas en la transacción es deshecho y no se verá como permanente en la base de 
datos. 

----------------- 8.1. Implicancias de las transacciones ----------------------- 

Toda sentencia SQL aislada disparada contra el DBMS desde una aplicación cliente 
representa en sí lo que se denomina una transacción implícita. Es decir, el inicio 
(BEGIN) y confirmación (COMMIT) de la transacción están implícitamente definidos en 
toda sentencia SQL. 

La solicitud de deshacer (ROLLBACK) o confirmar (COMMIT) una transacción no 
interfiere en absoluto con el flujo de control del batch o procedimiento. Por ejemplo, 
después de una sentencia ROLLBACK el procesamiento continúa normalmente con la 
próxima sentencia del batch o procedimiento. 

Las transacciones persisten abiertas hasta que son confirmadas o deshechas. 
Debemos tener en cuenta que, cuando una transacción está pendiente de 
confirmación, las páginas de datos correspondientes a las filas afectadas por la 
transacción resultan bloqueadas, impidiendo a otras conexiones acceder a esos datos. 
Es por ello que las transacciones deben agrupar solo las sentencias relacionadas 
lógicamente y –como regla general- deben involucrar la menor cantidad posible 
de operaciones. Debemos tener siempre presente que nuestra transacción, desde 
principio a fin, debe durar activa el menor tiempo posible. 
*/



----------------------------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------------------------





------------------ ¿Que retorna un procedure o función? ------------------ 
-------------------------------------------------------------------------- 
/*
El procedure o función va a llevar a cabo una tarea y retornar algo. 
A continuación analizaremos las opciones de retorno que tenemos.
*/

/*
-------------------------------------------------------------------------
4. Salida de un stored procedure en T-SQL
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
*/
ALTER PROCEDURE obtenerCantidadVendida 
	( 
	@pub_id CHAR(4), 
	@cantidad INTEGER OUTPUT 			-- Parametro de salida
	)  
	AS 
		SELECT @cantidad = SUM(qty)  		--pongo la salida del select en el parametro de salida
			FROM sales S INNER JOIN titles T 
					ON S.title_id = T.title_id 
			WHERE T.pub_id = @pub_id 
		RETURN 0   							-- tomo un valor de retorno 0

		
DECLARE @cantidad2 INTEGER               				  	-- declaro una variable         
EXECUTE  obtenerCantidadVendida '1389', @cantidad2 OUTPUT 	-- asigno la variable como Parametro d salida del Procedure 
SELECT  CONVERT(VARCHAR, @cantidad2)						-- muestro el parametro de salida

-------- 4.3. La salida de una sentencia SQL cualquiera sea la forma de la relación ------- 

-- SQL Server:
/*
T-SQL permite retornar directamente la salida de una sentencia SELECT. 
 
 
 
Ejemplo 9 
 */
CREATE PROCEDURE ListarTitles 
AS 
   SELECT * FROM titles;

EXECUTE ListarTitles 




/*
-------------------------------------------------------------------------
5. Salida de una function PL/pgSQL
-------------------------------------------------------------------------
*/

-- PostgreSQL:

/*
	Lo primero que debemos destacar es que una función PL/pgSQL NO PERMITE el OUTPUT 
directo  de una sentencia select-from-where como vimos recién en 4.3. 
  
Tenemos la alternativa de usar OUTPUT PARAMETERS.  

Para retornar conjuntos de datos, la función PL/pgSQL proporciona su valor de retorno, que se 
adapta a las diferentes necesidades como veremos a continuación. 
 */

----------------- 5.1. Retornar una relación unaria ---------------------- 

/*
	Relación unaria 
Ver “2. Relación unaria”  en el documento  
“Relations y SQL”.  
 */

-- PostgreSQL:

/*
	PL/pgSQL permite definir el valor de retorno de una función como Setof <Tipo-De-Dato>. 
Esto permite que una función retorne una especie de “lista” de valores.
 
Por un lado definimos el tipo de retorno de la función. Por ejemplo: 

RETURNS setof FLOAT 

Y en el cuerpo del procedimiento debemos utilizar una cláusula RETURN especial: RETURN 
QUERY. Por ejemplo: 
 */



