-- USANDO DataBase pubs:

USE pubs;

------------------------------------------------------------------------

/*
 ============================================
SQL: Guía de Trabajo Nro. 5  
Cursores y loops 
Parte 2: Ejercicios
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
 
 
Implemente un batch T-SQL que actualice los precios de las publicaciones de la editorial 
'0736'. 
Por cada publicación de esta editorial, se desea incrementar en un 25% el precio de las 
publicaciones que cuestan $10 o menos y decrementar también en un 25% las publicaciones 
que cuestan más de $10.
 */

/*
 -- buscar las publicaciones de la editorial '0736' (meterlas dentro del cursor) -- 
 -- por cada publicacion, ver cuanto cuesta (para actualizar precio)
 -- si la publicacion cuesta <= $10 incrementar el 25% el precio (actualizar precio)
 -- si la publicacion cuesta > $10 decrementar el 25% el precio (actualizar precio)
 */
SELECT * FROM Titles WHERE pub_id = '0736';

-- SQL Server:

BEGIN			-- Begin BATCH
	-- 
	DECLARE cur_Upd_prec CURSOR 
		FOR
			SELECT price, pub_id  FROM Titles
		FOR UPDATE 
				--WHERE pub_id = '0736'				-- No soporta WHERE
				
	DECLARE @price 			float,
			@pub_id			char(4),
			@porcen_precio	float
				
	OPEN cur_Upd_prec
	
	FETCH NEXT
			FROM cur_Upd_prec
							INTO @price, @pub_id
	
	BEGIN TRANSACTION 			-- Recordar la operacion peligrosa (Update) 
	
	WHILE @@FETCH_STATUS = 0
		BEGIN
			
			IF @pub_id = '0736'
			BEGIN
				IF @price IS NOT NULL
				begin
					
					SET @porcen_precio = @price * 0.25
					
					IF (@price > 10)
						SET @price = @price - @porcen_precio
					ELSE
						SET @price = @price + @porcen_precio
						
						-- aca iria un BEGIN TRY
						
					UPDATE 	Titles								-- Update
						SET price = @price
						WHERE CURRENT OF cur_Upd_prec			-- uso el WHERE CURRENT OF (del cursor)
						
						-- aca iria un END TRY
						-- aca iria un BEGIN CATCH
						
				end -- END IF (@price IS NOT NULL)
			END	-- IF @pub_id = '0736'
			
			FETCH NEXT
			FROM cur_Upd_prec
							INTO @price, @pub_id
		END		-- end while
	
	CLOSE cur_Upd_prec
	DEALLOCATE cur_Upd_prec
	
	SELECT * FROM Titles WHERE pub_id = '0736';
	
	ROLLBACK TRANSACTION
	-- COMMIT TRANSACTION (ACA iria el COMMIT, porque la insercion fue exitosa), pero no quiero guardar los cambios
	
END			-- End BATCH


-------------------------------------------------------------------------

-- PostgreSQL:

create or REPLACE FUNCTION fun_cur_Upd_prec()
	RETURNS VOID
	language plpgsql
	AS
	$$
	DECLARE publi_id	char(4);
	 precio		float;
	 porc_prec	float;
	DECLARE cur_Upd_prec CURSOR
		FOR
			SELECT price, pub_id
				From Titles
		FOR UPDATE;-- OF Price;
	
	BEGIN
		OPEN cur_Upd_prec;
		
		LOOP
			FETCH NEXT FROM cur_Upd_prec
									 	INTO precio, publi_id;
			EXIT WHEN NOT FOUND;
			
			--
			IF (publi_id = '0736') THEN
				
				IF (precio IS NOT NULL) THEN
				
					porc_prec := precio * 0.25;
					
					IF (precio > 10) THEN
						precio := precio - porc_prec;
					ELSE
						precio := precio + porc_prec;
					END IF;

				UPDATE Titles								-- Update
					SET price = precio
					WHERE CURRENT OF cur_Upd_prec;
					
				END IF; -- PRECIO NULL
			END IF; -- publi_id = '0736'
			
		END LOOP;
		CLOSE cur_Upd_prec;
		
		
		--SELECT * FROM Titles WHERE pub_id = '0736'; 
		RETURN;

	END;		-- END FUNCTION
$$

BEGIN transaction;
SELECT fun_cur_Upd_prec();
SELECT * FROM Titles WHERE pub_id = '0736'; 
ROLLBACK TRANSACTION;
-- COMMIT TRANSACTION; (ACA iria el COMMIT, porque la insercion fue exitosa), pero no quiero guardar los cambios


SELECT * FROM Titles WHERE pub_id = '0736';




-------------------------------------------------------------------------- 
----------------------- E j e r c i c i o   2 ----------------------------
-------------------------------------------------------------------------.
/*
Ejercicio 2. 

Resuelva el Ejercicio 1 utilizando la estructura FOR <target> IN <query> LOOP. 
*/

create or REPLACE FUNCTION fun_cur_Upd_prec2()
	RETURNS VOID
	language plpgsql
	AS
	$$
	DECLARE	publi_id	char(4);
			precio		float;
			porc_prec float;
			recTupla RECORD; 	
	BEGIN
		
		FOR recTupla IN SELECT price, pub_id, title_id
										FROM Titles
			LOOP
		
			--
			IF (recTupla.pub_id = '0736') THEN
				
				IF (recTupla.price IS NOT NULL) THEN
						
					precio := recTupla. price;
					porc_prec := precio * 0.25;
					
					IF (recTupla.price > 10) THEN
						precio := precio - porc_prec;
					ELSE
						precio := precio + porc_prec;
					END IF;

					UPDATE Titles								-- Update
						SET price = precio
						WHERE title_id = recTupla.title_id;
					
				END IF; -- PRECIO NULL
			END IF; -- publi_id = '0736'
			
			END LOOP;
			--CLOSE CURSOR;
			
			
			--SELECT * FROM Titles WHERE pub_id = '0736'; 
			RETURN;
	END	-- END FUNCTION
$$



BEGIN transaction;
SELECT fun_cur_Upd_prec2();
SELECT * FROM Titles WHERE pub_id = '0736'; 
ROLLBACK TRANSACTION;





-------------------------------------------------------------------------- 
----------------------- E j e r c i c i o   3 ----------------------------
-------------------------------------------------------------------------.
/*
Ejercicio 3 
 
En T-SQL, Obtenga un listado con las tres publicaciones más caras de cada tipo (columna type). 
 
Publicaciones más caras de tipo business     
 --------------------- 
2,99 
11,95 
19,99 
 
Publicaciones más caras de tipo mod_cook     
 --------------------- 
NULL 
2,99 
19,99 
 
Publicaciones más caras de tipo popular_comp 
 --------------------- 
NULL 
20,00 
22,95 
 
Publicaciones más caras de tipo psychology   
 --------------------- 
10,95 
19,99 
21,59 
 
Publicaciones más caras de tipo trad_cook    
 --------------------- 
11,95 
14,99 
20,95 
 
Publicaciones más caras de tipo UNDECIDED    
 --------------------- 
NULL 
 */

SELECT  title_id, price, type
FROM Titles;

SELECT ti1.title_id, ti1. price, ti1. type
from titles ti1
Where title_id IN (
	SELECT TOP 3 ti2. title_id
		FROM Titles ti2
		WHERE ti2. type =  ti1. type
		ORDER BY ti2.type, ti2.Price desc
)
ORDER BY type;

/*
 Necesito las 3 publicaciones mas caras (3 public de > price)
 de cada tipo
 hacer un cursor que recorra por tipo de publicacion 
 hacer dentro de eso un select para el mayor valor
 comparar el mayor valor con el valor actual
 si es mayor buscar el sig mayor (x 3 veces)
 */

-- SQL Server:

BEGIN		-- BEGIN BATCH
	
	DECLARE @type		char(12)
	DECLARE cur_tip_prec CURSOR
		FOR 
			SELECT DISTINCT type --, title_id, price
				FROM Titles
	
	OPEN cur_tip_prec
	
	FETCH NEXT FROM cur_tip_prec
								INTO @type
	
	WHILE @@FETCH_STATUS = 0
		BEGIN
			--
			/*
			SELECT top 3 title_id, price, type
				FROM Titles
				WHERE type = @type
				ORDER BY Price desc
			*/
			-------------------------------------- Cursor interno
			DECLARE cur_prec_interno CURSOR
				FOR 
					SELECT title_id, price, type
						FROM Titles
						ORDER BY Price desc
						
			DECLARE @title_id	varchar(6),
					@price		float,
					@type2		char(12), 
					@cont		int
			
			PRINT'Las 3 publicaciones mas caras del tipo [' + @type + '] son:'
			SET @cont = 0
					
			OPEN cur_prec_interno
			
			FETCH NEXT FROM cur_prec_interno
								INTO @title_id, @price, @type2
			
			WHILE @@FETCH_STATUS = 0 AND @cont < 3
			BEGIN
				
					IF @type = @type2
					BEGIN
						IF @price IS NOT NULL
							PRINT'Publicacion ' + @title_id + ' de precio: ' + CAST(@price AS VARCHAR)
						ELSE
							PRINT'Publicacion ' + @title_id + ' de precio: NULL'
						
						SET @cont = @cont + 1
					END -- IF
			
				FETCH NEXT FROM cur_prec_interno
								INTO @title_id, @price, @type2
			END	-- END WHILE
			
			CLOSE cur_prec_interno
			DEALLOCATE cur_prec_interno
			
			------------------------------------- Cursor interno
			
			FETCH NEXT FROM cur_tip_prec
								INTO @type
		END		-- WHILE
	
	CLOSE cur_tip_prec
	DEALLOCATE cur_tip_prec
								
END			-- END BATCH

----------------------------------------------------------

PRINT'HOLA'

-- FORMA ALTERNATIVA:

------------------------------------------------------------

BEGIN		-- BEGIN BATCH
	
	DECLARE @title_id	varchar(6),
			@price		float,
			@type		char(12), 
			@cont		int,
			@type3		char(12)
			
	DECLARE cur_tip_prec CURSOR
		FOR 
			SELECT type, title_id, price
				FROM Titles
				ORDER BY type, price desc
				
	SET @cont = 0
	SET @type3 = 'business    '
	PRINT'Las 3 publicaciones mas caras de cada tipo son:'
	
	
	OPEN cur_tip_prec
	
	FETCH NEXT FROM cur_tip_prec
								INTO @type, @title_id, @price
	
	WHILE @@FETCH_STATUS = 0
		BEGIN
			--
			/*
			SELECT top 3 title_id, price, type
				FROM Titles
				WHERE type = @type
				ORDER BY Price desc
			*/
			
			IF @cont < 3
			BEGIN
				--PRINT'Tipo: ' + @type + ' Publicacion: ' + @title_id + '  con precio: ' + CAST(@price AS VARCHAR)
				
				IF @price IS NOT NULL
					PRINT'Tipo: ' + @type + ' Publicacion: ' + @title_id + '  con precio: ' + CAST(@price AS VARCHAR)
				ELSE
					PRINT'Tipo: ' + @type + ' Publicacion: ' + @title_id + '  con precio: NULL' 
			
			END	-- IF @cont > 3
			
			IF @type3 = @type
				SET @cont = @cont + 1
			ELSE
				SET @cont = 0
					
			SET @type3 = @type
			
			FETCH NEXT FROM cur_tip_prec
								INTO @type, @title_id, @price
		END		-- WHILE
	
	CLOSE cur_tip_prec
	DEALLOCATE cur_tip_prec
								
END			-- END BATCH





SELECT TYPE
FROM TITLES



-------------------------------------------------------------------------- 
----------------------- E j e r c i c i o   4 ----------------------------
-------------------------------------------------------------------------.
/*
Ejercicio 4 
 
 
Usando PL/pgSQL, obtenga un listado como el siguiente para los autores que viven en 
ciudades donde se ubican las editoriales que publican sus libros. 
 
 
El autor: Carson reside en la misma ciudad que la editorial que lo edita 
El autor: Bennet reside en la misma ciudad que la editorial que lo edita 
 
 
Nota: existen soluciones sin loops/cursores para este problema. Resuelva el ejercicio 
usando loops/cursores. 
 */

--au_lname
SELECT *
FROM Authors A INNER JOIN TitleAuthor TA
	ON A. au_id = TA. au_id	
	INNER JOIN Titles T
	ON TA.title_id = T. title_id
	INNER JOIN Publishers P
	ON T.pub_id  = P.pub_id 
WHERE A. city = P.city

---------------------------------

create or Replace FUNCTION fun_cur_Aut_city()
	RETURNS VOID
	language pLpGsql
	AS
	$$
	DECLARE au_id1	 	varchar(11);
			au_lname1	varchar(40);
			city1		 varchar(20);
	
	DECLARE cur_Aut1 CURSOR
		FOR 
			SELECT au_id, au_lname, city
				FROM Authors;
	DECLARE au_id2	 	varchar(11);
			title_id2	varchar(6);
			pub_id2		char(4);
	DECLARE cur_Tit2 CURSOR
		FOR 
			SELECT au_id, title_id
				FROM TitleAuthor;
				--where au_id = 'bbb%';		-- anda
	DECLARE cur_Pub3 CURSOR
		FOR 
			SELECT pub_id, city
				FROM Publishers;
			recTupla RECORD; 
			encontrado bool;
				
	BEGIN
		
		OPEN cur_Aut1;
		
		LOOP
			
			FETCH NEXT FROM cur_Aut1
									INTO au_id1, au_lname1, city1;
			EXIT WHEN NOT FOUND;
			
			--
			encontrado := false;

			IF encontrado = FALSE THEN

			---------------------------------------- Cursor2 ------------
			
			OPEN cur_Tit2;
			
			LOOP
				
				FETCH NEXT FROM cur_Tit2
										INTO au_id2, title_id2;
				EXIT WHEN NOT FOUND;

				--
				IF encontrado = FALSE THEN

				SELECT pub_id INTO pub_id2
				FROM Titles
				WHERE title_id = title_id2;

				--RAISE NOTICE'title_id: %, pub_id: %', title_id2, pub_id2;
								
				------------------------------------------- Cursor3 ----------
				FOR recTupla IN Select pub_id, city 
                     From Publishers LOOP	
					
					--
					IF recTupla. pub_id = pub_id2 THEN
						IF recTupla. city = city1 THEN
							--
							encontrado := TRUE;
							RAISE NOTICE'El autor: % reside en la misma ciudad que la editorial que lo edita ', au_lname1;
							CONTINUE;
						END IF;
					END IF;
					
				END LOOP;	-- CURSOR3
				------------------------------------------- Cursor3 ----------
				
				END IF; -- encontrado = FALSE
				
				IF encontrado = TRUE THEN
					CONTINUE;
				END IF;	-- encontrado = TRUE
			
			END LOOP;	-- CURSOR2
			CLOSE cur_Tit2;
			
			---------------------------------------- Cursor2 ------------
			
			RAISE NOTICE'title_id: %, pub_id: %', title_id2, pub_id2;
			END IF; -- encontrado = FALSE

		END LOOP;	-- CURSOR1
		CLOSE cur_Aut1;
		
	END	-- END FUnction
	
$$

---------------------------

SELECT fun_cur_Aut_city();




-------------------------------------------------------------------------- 
----------------------- E j e r c i c i o   5 ----------------------------
-------------------------------------------------------------------------.

/*
 Ejercicio 5 
En la tabla Employee hay varios empleados que son editores (columna job_id con valor 
5): 

Select * from employee where job_id = 5 

--PXH22250M de 0877
--CFH28514M de 9999 
--JYL26161F de 9901 
--LAL21447M de 0736
--RBM23061F de 1622 
--SKO22412M de 1389 
--MJP25939M de 1756 

Se deben analizar los empleados con job_id 5 y, de los que pertenezcan a las dos 
editoriales que menos han facturado (en dinero) a lo largo del tiempo, se debe seleccionar 
el más antiguo (columna hire_date). 
Este empleado debe pasar a formar parte de la editorial que más ha facturado (en dinero) 
a lo largo del tiempo. 

Por ejemplo, la editorial que más ha vendido es la '1389'. 
Las dos que menos han vendido son las '0736' y '0877' 
Terminan siendo evaluados dos empleados: 
-- PXH22250M de editorial 0877 contratado el 1993-08-19 00:00:00.000 
-- LAL21447M de editorial 0736 contratado el 1990-06-03 00:00:00.000 
El más antiguo es el empleado LAL21447M, contratado en 1990. Este empleado debe 
pasara  trabajar en la editorial '1389'. 

Resuélva el ejercicio utilizando T-SQL 
 */

--Busqueda de empleados con job_id = 5
Select * from employee where job_id = 5;

----------
-- La editorial por ventas (facturacion):
SELECT tit. pub_id, SUM(sal.qty * tit. price) ventas
FROM Titles tit INNER JOIN Sales sal ON sal. title_id = tit. title_id
GROUP BY tit. pub_id
ORDER BY ventas desc;

-- La editorial que mas vendió es: (la pub_id: 1389)
SELECT top 1 tit. pub_id, SUM(sal.qty * tit. price) ventas
FROM Titles tit INNER JOIN Sales sal ON sal. title_id = tit. title_id
GROUP BY tit. pub_id
ORDER BY ventas desc;

---------
-- Las 2 editoriales que vendieron menos son: ( pub_id [<]: 0736, 0877)
SELECT top 2 tit. pub_id, SUM(sal.qty * tit. price) ventas
FROM Titles tit INNER JOIN Sales sal ON sal. title_id = tit. title_id
GROUP BY tit. pub_id
ORDER BY ventas;

------------------------
-- Empleados que cumple con la condicion (de pubs de menos ventas):
SELECT emp_id, hire_date
FROM Employee
WHERE job_id = '5'
AND pub_id IN ('0736', '0877')
ORDER BY hire_date;

-- Empleado a cambiar de editorial:
SELECT top 1 emp_id, hire_date
FROM Employee
WHERE job_id = '5'
AND pub_id IN ('0736', '0877')
ORDER BY hire_date
--LIMIT 1; 			-- En PostgreSQL

/*
 FORMA ALTERNATIVA:
 
SELECT top 1 emp_id, hire_date
FROM Employee
WHERE job_id = '5'
AND pub_id IN (SELECT top 2 tit. pub_id ventas --, SUM(sal.qty * tit. price) 					-- Subquery con 2 editoriales con menos ventas
				FROM Titles tit INNER JOIN Sales sal ON sal. title_id = tit. title_id
				GROUP BY tit. pub_id
				--ORDER BY SUM(sal.qty * tit. price)  
				)
ORDER BY hire_date
*/

-------------------------------------------------------------------------

-- Hago un Batch para realizar todas las operaciones de una:
---------------------------- INICIO -----------------------------------------------------

DECLARE
	@pub_id_MayorVenta VARCHAR(4)

SELECT TOP 1 @pub_id_MayorVenta = tit. pub_id --, SUM(sal.qty * tit. price) ventas
FROM Titles tit INNER JOIN Sales sal ON sal. title_id = tit. title_id
GROUP BY tit. pub_id
ORDER BY SUM(sal.qty * tit. price) desc

PRINT'La editorial de mayor venta es ' + @pub_id_MayorVenta;

---------------------------------- FIN -----------------------------------------------------


-- Ahora con CURSOR:
---------------------------- INICIO --------------------------------------------------------

DECLARE
	@pub_id_MayorVenta 	VARCHAR(4),
	@emp_id				CHAR(9),
	@pub_id				VARCHAR(4),
	@hire_date			DATETIME
	

SELECT TOP 1 @pub_id_MayorVenta = tit. pub_id --, SUM(sal.qty * tit. price) ventas
FROM Titles tit INNER JOIN Sales sal ON sal. title_id = tit. title_id
GROUP BY tit. pub_id
ORDER BY SUM(sal.qty * tit. price) desc

PRINT'La editorial de mayor venta es ' + @pub_id_MayorVenta;



DECLARE curEmployee CURSOR
	FOR
		SELECT TOP 1 emp_id, pub_id, hire_date		-- empleado 
			FROM Employee
			WHERE job_id = '5'
			AND pub_id IN (
				SELECT top 2 tit. pub_id ventas --, SUM(sal.qty * tit. price) 				-- de las 2 editoriales
				FROM Titles tit INNER JOIN Sales sal ON sal. title_id = tit. title_id
				GROUP BY tit. pub_id
				--ORDER BY SUM(sal.qty * tit. price)  
				)
	
	OPEN curEmployee
	
	FETCH NEXT FROM curEmployee INTO @emp_id, @pub_id, @hire_date
	
	WHILE @@FETCH_STATUS = 0 -- 
		BEGIN
			PRINT'Procesando Empleado: ' + @emp_id + ' de editorial ' + @pub_id
			
			FETCH NEXT FROM curEmployee INTO @emp_id, @pub_id, @hire_date
		END -- END WHILE
		
	CLOSE curEmployee
	DEALLOCATE curEmployee
		
---------------------------------- FIN -----------------------------------------------------


-- Ahora con CURSOR:
---------------------------- INICIO --------------------------------------------------------

DECLARE
	@pub_id_MayorVenta 	VARCHAR(4),
	@emp_id				CHAR(9),
	@pub_id				VARCHAR(4),
	@hire_date			DATETIME,
	@min_Hire_date		DATETIME,
	@min_emp_id			CHAR(9)
	

SELECT TOP 1 @pub_id_MayorVenta = tit. pub_id --, SUM(sal.qty * tit. price) ventas
FROM Titles tit INNER JOIN Sales sal ON sal. title_id = tit. title_id
GROUP BY tit. pub_id
ORDER BY SUM(sal.qty * tit. price) desc

PRINT'La editorial de mayor venta es ' + @pub_id_MayorVenta;

SET @min_Hire_date = CURRENT_TIMESTAMP;

DECLARE curEmployee CURSOR
	FOR
		SELECT emp_id, pub_id, hire_date
			FROM Employee
			WHERE job_id = '5'
			AND pub_id IN (
				SELECT top 2 tit. pub_id ventas --, SUM(sal.qty * tit. price) 
				FROM Titles tit INNER JOIN Sales sal ON sal. title_id = tit. title_id
				GROUP BY tit. pub_id
				--ORDER BY SUM(sal.qty * tit. price)  
				)
	
	OPEN curEmployee
	
	FETCH NEXT FROM curEmployee INTO @emp_id, @pub_id, @hire_date
	
	WHILE @@FETCH_STATUS = 0 -- 
		BEGIN
			PRINT'Procesando Empleado: ' + @emp_id + ' de editorial ' + @pub_id
			
			
			IF @hire_date < @min_Hire_date --
				--BEGIN
					SET @min_Hire_date = @hire_date;
					SET @min_emp_id = @emp_id;
			--END 	-- END IF
			
			
			FETCH NEXT FROM curEmployee INTO @emp_id, @pub_id, @hire_date
		END -- END WHILE
		
		PRINT'El empleado que cambia de editorial es el: ' +  @min_emp_id;
		PRINT'La fecha de contratacion mas antigua es: ' + CONVERT(VARCHAR, @min_Hire_date, 3) -- CONVERT(VARCHAR, @min_Hire_date)
		
		PRINT'Termino el procedimiento. El empleado a modificar es: ' +  @min_emp_id + ' que pasa a la editorial: ' + @pub_id_MayorVenta
		
		--BEGIN TRANSACTION
			UPDATE Employee
 				SET	pub_id = @pub_id_MayorVenta -- la editorial de mayor ventas
 				WHERE emp_id = @min_emp_id
		
		--COMMIT TRANSACTION
		
	CLOSE curEmployee
	DEALLOCATE curEmployee
		
---------------------------------- FIN -----------------------------------------------------

/*
 UPDATE Employee
 	SET	pub_id = 1389 -- la editorial de mayor ventas
 	WHERE emp_id = 'LAL21447M' -- empleado con job_id = 5 y de editoriales de menor ventas y contratacion mas antigua
 */

SELECT * FROM employee 
WHERE emp_id = 'LAL21447M'; --pub_id: 0736

/*
UPDATE Employee
 	SET	pub_id = 0736 -- la editorial original
 	WHERE emp_id = 'LAL21447M' 
*/





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



-------------------------------------------------------------------------- 
----------------------- E j e r c i c i o   1 ----------------------------
-------------------------------------------------------------------------.

--------------------------- 1.1.  Producto cartesiano -------------------