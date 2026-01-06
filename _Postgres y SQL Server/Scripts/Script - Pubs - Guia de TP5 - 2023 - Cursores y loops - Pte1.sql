-- USANDO DataBase pubs:

USE pubs;

------------------------------------------------------------------------

/*
 ============================================
SQL: Guía de Trabajo Nro. 5  
Cursores y loops 
Parte 1  
 ============================================
 */

/*
-------------------------------------------------------------------------
-------------------------------------------------------------------------
 1. Cursores y loops 
-------------------------------------------------------------------------
-------------------------------------------------------------------------
*/
/* 
SQL fue diseñado como un lenguaje orientado a conjuntos. Puede suceder a veces que la 
operación a realizar sea tan compleja que no la podamos resolver a través de este enfoque de 
conjuntos y necesitemos recorrer los datos secuencialmente, fila a fila.  
 
Al permitirnos recorrer los datos fila a fila, podemos entonces detenernos en cada una, realizar 
tal vez varias operaciones, y luego movernos a la próxima. 
 
 
En esta Guía de Trabajo veremos qué enfoques nos proporcionan T-SQL y PL/pgSQL para 
resolver este tipo de problemas. 
 */

-------------------------------------------------------------------------- 
------------------------------ Ejemplo 1 --------------------------------- 
-------------------------------------------------------------------------.
/*
 Ejemplo 1
 
 Demostraremos el recorrido fila a fila con un ejemplo simple. Supongamos que necesitamos 
obtener el máximo valor de la columna price en la tabla titles (algo que podríamos 
obtener directamente con SELECT MAX(price) FROM titles, pero vale como ejemplo). 
 
Vamos a recorrer fila a fila la tabla titles e iremos actualizando una variable con el valor 
máximo obtenido. Al final del recorrido, tendremos el máximo: 
*/
-- Prueba: 
SELECT MAX(price) FROM titles;

-- Ahora con cursor:

-- SQL Server:

BEGIN					-- BATCH

	DECLARE cur_MaxPrecio CURSOR
		FOR 
			SELECT price 
				FROM titles
	
	
	DECLARE @max_price	float,
			@price		float;
	
	SET @max_price = 0;
	
	OPEN cur_MaxPrecio
	
	FETCH NEXT 		FROM cur_MaxPrecio
							INTO	@price
	
	
	WHILE @@FETCH_STATUS = 0
	Begin
		
		-- Acciones
		IF @price IS NOT NULL
			IF @max_price < @price
				SET @max_price = @price;
			-- END IF
		-- END IF
		
		
		FETCH NEXT 		FROM cur_MaxPrecio
							INTO	@price
		
	END -- END WHILE
   
   CLOSE cur_MaxPrecio
   DEALLOCATE cur_MaxPrecio			-- END CURSOR
   
   
   
   
   SELECT @max_price;		-- $22.95
   
END						-- END BATCH
   
   
-------------------------------------------------------------------------

-- PostgreSQL:

DO
$$
	DECLARE
		V_max_price		float;
		V_price			float;
	
	DECLARE cur_MaxPrecio CURSOR FOR
			SELECT price 
				FROM titles;
	

	BEGIN
		V_max_price := 0;		

		OPEN cur_MaxPrecio;
		
		LOOP
			--
			FETCH NEXT FROM cur_MaxPrecio
								 INTO V_price;
			EXIT WHEN NOT FOUND;

			IF V_price IS NOT NULL THEN
				--
				IF V_price > V_max_price THEN
					--
					V_max_price := V_price;
				END IF;
			END IF;
			
		END LOOP; -- end
		
		CLOSE cur_MaxPrecio; -- END CURSOR
		
		--RETURN V_max_price;	-- No se puede en un batch
		--SELECT V_max_price;	-- No anda
		RAISE NOTICE 'V_max_price: %', V_max_price;

	END;  -- END BATCH 
$$

/*
 ...
 
 ...
 
 
 También en la Guía de Trabajo Nro. 4 - vimos una construcción FOR con la 
siguiente sintaxis:  
 
suma:=0;  
FOR i IN 1..10 LOOP 
   suma := suma + i;               
END LOOP; 
 
Esta construcción FOR en realidad tiene un soporte más extendido, de la forma: 
 
FOR <target> IN <query> LOOP 
   -- procesar... 
END LOOP 
 
A esta forma de LOOP se le llama “cursor implícito”. El bucle finaliza 
automáticamente cuando no se encuentran más filas en <query>. 
 
 */

/*
 Cursor explícito 

 Generalmente los lenguajes de bases de datos llaman CURSOR EXPLÍCITO al 
cursor como el del Ejemplo 1: un cursor que se declara, posee una sentencia 
OPEN, posee varias sentencias FETCH y una sentencia CLOSE. 
 
Como contrapartida, un cursor que se crea con una sentencia FOR <target> IN
 <query> LOOP generalmente se denomina cursor implícito. 
 
Sin embargo, la interpretación de cursor implícito  varía entre fabricantes. Para 
Oracle, por ejemplo, toda sentencia SELECT...INTO crea un cursor implícito. 
 
 */
-- PostgreSQL:

-- Cursor Implicito 
CREATE OR REPLACE FUNCTION test_cursor700 
   () 
   RETURNS FLOAT  
   AS  
   $$ 
   DECLARE 
      vPrice FLOAT; 
      vPriceMaximo FLOAT; 
   BEGIN 
      vPriceMaximo := 0;  
 
      FOR vPrice IN Select price 
                       From Titles LOOP   		-- Uso el cursor Implicito
 
         IF vPrice IS NOT NULL THEN 
            IF vPrice > vPriceMaximo THEN 
               vPriceMaximo := vPrice;   
            END IF; 
         END IF;    
 
      END LOOP; 
 
      RETURN vPriceMaximo; 
   END; 
   $$  
   LANGUAGE plpgsql 
 
 
SELECT test_cursor700 (); 

/*
-------------------------------------------------------------------------
-------------------------------------------------------------------------
 2. Loops y estructuras de datos para sentencias 
 SELECT single-row  
-------------------------------------------------------------------------
-------------------------------------------------------------------------
*/
-------------------------------------------------------------------------
-------------- 2.1. Cursor que retorna una tupla completa ---------------

-- Record anchoring   
-- Table-based record 
/*
Si el cursor recupera una fila completa, podemos usar un Table-based record 
como el que vimos en la Sección Sentencias SELECT Single-row que retornan una 
tupla completa de la Guía de Trabajo Nro. 4: 
 
 
DECLARE 
   titleRec titles%ROWTYPE; 
 */

-------------------------------------------------------------------------
----------- 2.2. Cursor que retorna una Projection de una tupla ---------

-- Composite-type:
/*
Si el cursor recupera una Projections de una tupol, podemos definir un 
composite-type, como aprendimos en la Sección 2.4 Sentencias SELECT Single
row que retornan una Projection de una tupla de la Guía de Trabajo Nro. 4 - parte 
2, y luego declarar una variable anclada a ese composite type: 
 
 CREATE TYPE titleCT 
   AS ( 
       title_id char(6),  
       price numeric 
      ); 
 
DECLARE 
   titleRec titleCT%ROWTYPE; 
 
 */
/*
La siguiente es la solución del Ejemplo 1 usando una variable anclada a  un 
composite type: 
  */
 
CREATE TYPE titlesCT 			-- defino el Composite-type
   AS ( 
       title_id CHAR(6),  
       price numeric 
      ); 
 



CREATE FUNCTION test_cursor703()
   RETURNS FLOAT 
   LANGUAGE plpgsql 
   AS 
   $$ 
   DECLARE 
      tuplaTitlesCT titlesCT %rowtype; 		-- declaro el Composite-type
      vPriceMaximo FLOAT; 
   BEGIN 
    vPriceMaximo := 0;  
    FOR tuplaTitlesCT IN Select title_id, price 
                          From Titles LOOP 					-- Uso el cursor Implicito
       IF tuplaTitlesCT.price IS NOT NULL THEN 
          IF tuplaTitlesCT.price > vPriceMaximo THEN 
             vPriceMaximo := tuplaTitlesCT.price;    			-- uso el Composite-type
          END IF; 
       END IF;    
    END LOOP; 
    RETURN vPriceMaximo; 
   END    
   $$; 


SELECT test_cursor703 (); 

-------------------------------------------------------------------------
----------------------------- 2.3. Records ------------------------------

-- RECORD datatype 
/*
Sin embargo la solución más práctica es usar un tipo de dato RECORD 
datatype como el que aprendimos en la Sección 2.5 Records de la Guía de 
Trabajo Nro. 4 - parte 2. 
 
Recordemos que el tipo de dato RECORD no posee un formato de tupla 
determinado. Adopta la forma de la tupla en el momento de la asignación. 
  
En el caso del bucle FOR..IN..<query> la operación fetch implícita define la 
estructura del RECORD. 

La siguiente es la solución del Ejemplo 1 usando una variable de tipo RECORD:  
 */

CREATE FUNCTION test_cursor701()  
   RETURNS FLOAT 							-- Declaro salida
   LANGUAGE plpgsql 
   AS 
   $$ 
   DECLARE 
      recTupla RECORD; 						-- declaro un tipo RECORD
      vPriceMaximo FLOAT; 
   BEGIN 
    vPriceMaximo := 0;  
    FOR recTupla IN Select price 
                     From Titles LOOP			  	-- Uso el cursor Implicito
       IF recTupla.price IS NOT NULL THEN
          IF recTupla.price > vPriceMaximo THEN 			-- uso el RECORD
             vPriceMaximo := recTupla.price;   
          END IF; 
       END IF;    
    END LOOP; 
    RETURN vPriceMaximo; 
   END    
   $$; 


SELECT test_cursor701 ();

--  También podríamos haber podido usar un tipo de dato RECORD en el Ejemplo 1: 

CREATE FUNCTION test_cursor500()  
   RETURNS FLOAT 
   LANGUAGE plpgsql 
   AS 
   $$ 
   DECLARE 
      recTitles RECORD;  							-- declaro un tipo RECORD
      vPriceMaximo FLOAT; 
      cursorPrice CURSOR FOR Select price 			 -- Declaro el cursor Explicito
                                From Titles; 
   BEGIN 
      vPriceMaximo := 0;  
      OPEN cursorPrice; 
 
      LOOP 
         FETCH NEXT FROM cursorPrice INTO recTitles;  	-- Uso el cursor Explicito
         EXIT WHEN NOT FOUND;   
 
         IF recTitles IS NOT NULL THEN 
            IF recTitles.price > vPriceMaximo THEN 
               vPriceMaximo := recTitles.price;   
            END IF; 
         END IF;    
 
      END LOOP; 
      CLOSE cursorPrice; 
      RETURN vPriceMaximo; 
     
   END    
   $$; 
 
SELECT * from test_cursor500();




/*
-------------------------------------------------------------------------
-------------------------------------------------------------------------
3. Cursores for update
-------------------------------------------------------------------------
-------------------------------------------------------------------------
*/
/*
En general los cursores pueden ser utilizados para realizar modificaciones sobre las tablas.  Es 
decir, nos permiten realizar operaciones UPDATE o DELETE sobre tuplas recuperadas por la 
operación FETCH. 
Esto es posible ya que un cursor es una estructura compleja que mantiene todo el tiempo un 
enlace entre la tupla recuperada por una operación FETCH y los datos físicos subyacentes en la 
base de datos. 
De esta manera, las operaciones de modificación que realicemos sobre la tupla actualmente en 
FETCH puede ser trasladada a la tabla física subyacente. 
 */

-------------------------------------------------------------------------
--------------------- 3.1. La cláusula CURRENT OF -----------------------
/*
Para soportar la modificación o eliminación de filas en un cursor,  
tanto las sentencias UPDATE como DELETE  soportan una sintaxis especial de la cláusula WHERE 
que indica que el contexto del query se reduce a la fila correspondiente al último 
FETCH realizado. 
*/

-- SQL Server:

--Declaración de Cursores for update 
/*
 Declaramos un cursor for update con la siguiente sintaxis:
 
 DECLARE curPrecios CURSOR 
	FOR 
		SELECT Price 
			From Titles 
	FOR UPDATE 	

También podemos restringir las columnas que pueden soportar update: 

DECLARE curPrecios CURSOR 
	FOR 
		SELECT Price 
			From Titles 
	FOR UPDATE OF price 

En este caso, solo estamos permitiendo la modificación de la columna price (A)
 */

/*
Ejemplo 2 
 
Se necesita modificar el título de las publicaciones que poseen un título que comienza con 
la string 'The gourmet' por ese título concatenado con la string ' Second Edition'. 

La siguiente es la solución T-SQL del Ejemplo 2:	
 */

Select title 
       		From Titles
			WHERE title LIKE '%The gourmet%'; 

-- SQL Server:	

Begin 				-- begin batch ----------------------

SELECT title  
   FROM titles 
   WHERE title LIKE 'The gourmet%' -- The Gourmet Microwave 
 
 
Declare curTitles Cursor 
   For 
      Select title 
         From Titles  
   FOR UPDATE 								-- declaro Cursor Explicito por Update (en SQL Server siempre son explicitos) 
 
Declare @title VARCHAR(255) 
    
 
OPEN curTitles 							-- abro cursor

FETCH NEXT 
   FROM curTitles 
   		INTO @title 					
 
WHILE @@fetch_status = 0 				-- inicio el bucle del cursor
   BEGIN 
      IF @title LIKE 'The gourmet%' 
         UPDATE titles 									-- Update
            SET title = title + ' Second Edition' 
            WHERE CURRENT OF curTitles 					-- WHERE CURRENT OF nombre_cursor (dentro del Update) especifico la salida del cursor
      --END IF; 
    
      FETCH NEXT 
         FROM curTitles 
         	INTO @title 
     
   END -- END WHILE 
 
CLOSE curTitles 
DEALLOCATE curTitles

end 	-- end batch  ----------------------

Select title 
       		From Titles
			WHERE title LIKE '%The gourmet%'; 

--------------------------------------------------------------------------

-- La siguiente es la solución del Ejemplo 2 usando PL/pgSQL:  

-- PostgreSQL:
 
SELECT title  
   FROM titles2 
   WHERE title LIKE 'The Gourmet%' -- The Gourmet Microwave 
 
 
CREATE FUNCTION test()  
   RETURNS VOID 
   LANGUAGE plpgsql 
   AS 
   $$ 
   DECLARE 
      vTitle VARCHAR(255); 
      curTitles CURSOR FOR Select title 
                              From Titles2; 			-- Declaro Cursor Explicito
 
   BEGIN 
      OPEN curTitles; 									-- abro el cursor
 
      LOOP 
         FETCH NEXT FROM curTitles INTO vTitle; 
         EXIT WHEN NOT FOUND;   						-- condicion de salida
 
         IF vTitle LIKE 'The Gourmet%' THEN 
            UPDATE titles2 								-- update
               SET title = title || ' Second Edition' 
               WHERE CURRENT OF curTitles; 				-- WHERE CURRENT OF nombre_cursor (dentro del Update) especifico la salida del cursor

         END IF; 
 
      END LOOP; 
      CLOSE curTitles; 
      RETURN; 
     
   END    
   $$;


/*
-------------------------------------------------------------------------
-------------------------------------------------------------------------
4. SCROLL CURSORS 
-------------------------------------------------------------------------
-------------------------------------------------------------------------
*/ 
/*   
Los cursores que hemos visto hasta ahora son “forward only”. Solo hemos ejecutado FETCH 
NEXT para obtener la próxima tupla del conjunto resultado. 
T-SQL nos permite crear cursores que permiten hacer un “scroll” hacia adelante y hacia atrás.  
Estos cursores son mucho más costosos en recursos y deberían utilizase solo si no hay otra 
alternativa.
*/

   
--------------------------------------------------------------------------
------------------------ 4.1. Operaciones FETCH --------------------------
/*
Si el cursor es de tipo SCROLL, tenemos la posibilidad de realizar los siguientes FETCH 
adicionales: 
FETCH PRIOR (para ir a la tupla anterior a la actual), FETCH FIRST (0ara ir a la primera tupla), 
FETCH LAST (para ir a la última tupla).  
 */
   
-- SQL Server:
/*
Declaración de un scroll cursor
 
Declaramos un scroll cursor con la siguiente sintaxis:
*/
   
DECLARE curPrecios CURSOR 
	SCROLL 
	FOR 
		SELECT Price From Titles
 

-- PostgreSQL:
/*
 Declaración de un scroll
 
 Declaramos un scroll cursor con la sintaxis: 
 */
 
DECLARE curPrecios SCROLL 
	CURSOR 
	FOR 
SELECT Price From Titles 
 


-------------------------------------------------------------------------- 
----------------------- E j e r c i c i o   1 ----------------------------
-------------------------------------------------------------------------.

--------------------------- 1.1.  Producto cartesiano -------------------