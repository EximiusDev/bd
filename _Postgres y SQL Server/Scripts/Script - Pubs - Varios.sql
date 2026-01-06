-- USANDO DataBase pubs:

USE pubs;


/*
 ============================================
 SQL: Guía de Trabajo Nro. 4  
Cursores y loops 
Parte 2: Ejercicios
 ============================================
 */
 ------------------------------------------------------------------------- 
 ---------------------- E j e r c i c i o   5 ---------------------------- 
 ------------------------------------------------------------------------.
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








---------------------------------------------------------------------------------------------------------------

---------------------------------------------------------------------------------------------------------------

---------------------------------------------------------------------------------------------------------------
 ============================================
SQL: Guía de Trabajo Nro. 4  
Stored Procedures y functions: Retorno 
 ============================================
 */

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

		--HECHO POR EL PROFE (b) 
ALTER PROCEDURE	insertarDetalle100(
	@CodDetalle			int,		-- IN
	@NumPed				int,		-- IN
	@CodProd			int,		-- IN
	@Cant				int			-- IN
)
AS	
	----- Identifica la invocacion que haciamos desde el batch -----
	DECLARE @PrecioObtenido 	FLOAT 	-- Parametro OUT del inner procedure
	DECLARE @StatusRetorno 		INT		-- Status de retorno del inner procedure
	DECLARE @Error				INT	
	
	EXECUTE @StatusRetorno = buscarPrecio10 @CodProd, @PrecioObtenido OUTPUT
	
	SET @Error = 0	
	
	IF @StatusRetorno != 0
		 begin
		 	IF @StatusRetorno = 70
		 		BEGIN
			 		
		 			--PRINT 'El producto no existe'
		 			--RETURN
			 		RAISERROR ('Producto inexistente', 12, 1) -- RAISERROR solo dispara un error, no cancela la transaccion o hace ROLLBACK
			 		SET @Error = @@ERROR
			 		
		 		END
		 	ELSE
		 		IF @StatusRetorno = 71
		 			BEGIN
		 				--PRINT 'El producto no posee precio'
			 			--RETURN
		 				RAISERROR ('Producto sin precio', 13, 1)
			 			SET @Error = @@ERROR
			 			
		 			END
		 		--END IF
		 	--END IF
		 end
	--END IF
	--ELSE
	
	IF	(@Error = 0) -- SI NO TIENE ERRORES INSERTA
		begin
			BEGIN TRY
				
				INSERT Detalle Values(@CodDetalle, @NumPed, @CodProd, @Cant,
					@Cant * @PrecioObtenido)
		 		PRINT'Se inserto una fila'
		 		RETURN 0;
		 	END TRY
		 	
		 	BEGIN CATCH
		 		EXECUTE	usp_getErrorInfo
		 		RETURN 90
		 	END CATCH
		 		
		end -- END IF
		
	RETURN
	
	-------
	
				SELECT * FROM Detalle
	
	insertarDetalle100 1540, 120, 70, 2; -- PRODUCTO INEXISTENTE
	insertarDetalle100 900, 120, 30, 2;	-- Producto sin precio
	insertarDetalle100 1000, 120, 20, 2;	-- Producto Con precio
	
	
	Delete FROM Detalle;



-----------------------------------------------------------------------------------------------------------
-----------------------------------------------------------------------------------------------------------
-----------------------------------------------------------------------------------------------------------
-----------------------------------------------------------------------------------------------------------
-----------------------------------------------------------------------------------------------------------

/*
	En el módulo de datos de pubs se necesitan eliminar los autores (y sus publicaciones)
	 cuando todas sus publicaciones hayan vendido menos de 25 ejemplares
	  en el período comprendido entre 1/ 1/ 1993 y el 31/ 12/ 1994
	  
	Utilice T-SQL para la resolucion
	
	Se debe tener en cuenta que:
	  
	a. El cálculo de ventas se debe realizar a partir de la columna qty en la tabla Sales
	b. son excluidos de la evaluación los autores que son coautores
	c. son excluidos de la evaluación en los autores que no poseen publicaciones editadas
	d. son excluidos de la evaluación los autores que no han vendido ejemplares en el periodo analizado
 */

-----------------------------------------------------------------------------
-- Excluir los autores que nunca publicaron --
	
SELECT Au. au_id, Au. au_fname, Au. au_lname
FROM Authors Au
WHERE Au. au_id IN (SELECT au_id FROM TitleAuthor);

-- O sino:
/*
SELECT COUNT(*)
FROM Authors Au
WHERE Au. au_id IN (SELECT au_id FROM TitleAuthor);
*/

-------------------------------------------------------
-- Corroboramos los excluidos por no haber publicado --

SELECT Au. au_id, Au. au_fname, Au. au_lname
FROM Authors Au
WHERE Au. au_id NOT IN (SELECT au_id FROM TitleAuthor);

-------------------------------------------------------
-- Excluir los que no poseen ventas entre 1/1/1993 y el 31/12/1994

SELECT Au. au_id, Au. au_fname, Au. au_lname
FROM Authors Au
WHERE EXISTS ( SELECT *
				FROM Sales INNER JOIN Titles
					ON Sales. title_id = Titles. title_id 
				INNER JOIN TitleAuthor Ta 
					ON Titles. title_id = Ta. title_id
				WHERE YEAR (ord_date) IN (1993, 1994)
				AND Ta. au_id = Au. au_id				-- Relaciono el Inner Query con el Query Principal
				);

-------------------------------------------------------
-- Los que no tienen ventas

SELECT Au. au_id, Au. au_fname, Au. au_lname
FROM Authors Au
WHERE NOT EXISTS ( SELECT *
				FROM Sales INNER JOIN Titles
					ON Sales. title_id = Titles. title_id 
				INNER JOIN TitleAuthor Ta 
					ON Titles. title_id = Ta. title_id
				WHERE YEAR (ord_date) IN (1993, 1994)
				AND Ta. au_id = Au. au_id				-- Relaciono el Inner Query con el Query Principal
				);

---------------------------------------------------------
-- Excluir los coautores

Select Au. au_id, au_fname, au_lname
	FROM authors Au
	WHERE NOT EXISTS (
						SELECT * 
						FROM titleauthor Ta
						WHERE Ta. au_id = Au.au_id 
							AND Ta. royaltyper <> 100
						);
/* No es correcto hacer:
Select Au. au_id, au_fname, au_lname
	FROM authors Au
	WHERE Au. au_id IN (
						SELECT au_id
						FROM titleauthor Ta
						WHERE Ta. royaltyper = 100
						);
 */

------------------------------------------------------------
-- Excluir los autores que tengan (al menos una) publicacion que vendió mas de 25 unidades
--y que posea ventas en esos años

SELECT SUM (SA. qty)					-- Cant de ventas de cada publicacion en esos años
FROM Sales Sa -- INNER JOIN Titles Ti
	--ON Sa.title_id = Ti. title_id
	--INNER JOIN Titleauthor Ta
	--ON Ti. title_id = Ta. title_id
WHERE YEAR (Sa.ord_date) IN (1993, 1994) 
	--AND 
GROUP BY Sa.title_id

---------------------------------------------------------------
-- Excluir los autores que tengan (al menos una) publicacion que vendió mas de 25 unidades
--y que posea ventas en esos años


Select Au. au_id, au_fname, au_lname
	FROM authors Au
	WHERE 25 <= ANY ( SELECT SUM (SA. qty)					-- Cant de ventas de cada publicacion en esos años
						FROM Sales Sa INNER JOIN Titles Ti
							ON Sa.title_id = Ti. title_id
							INNER JOIN Titleauthor Ta
							ON Ti. title_id = Ta. title_id
						WHERE YEAR (Sa.ord_date) IN (1993, 1994) 
						AND Au. au_id = Ta. au_id
						GROUP BY Sa.title_id
						);
						
------------------------------------------------------------------------------
-- Candidatos a eliminar

Select Au. au_id, au_fname, au_lname
	FROM authors Au
	WHERE 25 > ALL ( SELECT SUM (SA. qty)					-- Cant de ventas de cada publicacion en esos años
						FROM Sales Sa INNER JOIN Titles Ti
							ON Sa.title_id = Ti. title_id
							INNER JOIN Titleauthor Ta
							ON Ti. title_id = Ta. title_id
						WHERE YEAR (Sa.ord_date) IN (1993, 1994) 
						AND Au. au_id = Ta. au_id
						GROUP BY Sa.title_id
						);

--------------------------------------------------------------------------------
-- Poniendo Todas las condiciones Juntas (Es el SELECT que va en el Procedure): 
--------------------------------------------------------------------------------


SELECT Au. au_id, Au. au_fname, Au. au_lname		-- Excluir los autores que nunca publicaron 
FROM Authors Au
WHERE Au. au_id IN (SELECT au_id FROM TitleAuthor)
AND EXISTS ( SELECT *				-- Excluir los que no poseen ventas entre 1/1/1993 y el 31/12/1994
				FROM Sales INNER JOIN Titles
					ON Sales. title_id = Titles. title_id 
				INNER JOIN TitleAuthor Ta 
					ON Titles. title_id = Ta. title_id
				WHERE YEAR (ord_date) IN (1993, 1994)
				AND Ta. au_id = Au. au_id				-- Relaciono el Inner Query con el Query Principal
				)
AND				-- Excluir los autores que tengan (al menos una) publicacion que vendió mas de 25 unidades
				--y que posea ventas en esos años
	 25 > ALL ( SELECT SUM (SA. qty)					-- Cant de ventas de cada publicacion en esos años
						FROM Sales Sa INNER JOIN Titles Ti		-- tienen < de 25 publicaciones
							ON Sa.title_id = Ti. title_id
							INNER JOIN Titleauthor Ta1
							ON Ti. title_id = Ta1. title_id
						--WHERE YEAR (Sa.ord_date) IN (1993, 1994) -- no es necesario xq ya tengo la condicion
						AND Au. au_id = Ta1. au_id
						GROUP BY Sa.title_id
						)
	AND NOT EXISTS (						-- Excluir los coautores
						SELECT * 
						FROM titleauthor Ta
						WHERE Ta. au_id = Au.au_id 
							AND Ta. royaltyper <> 100
						);

---------------------------------------------------------------------------------
-- PROCEDURES:
---------------------------------------------------------------------------------
/*
	Eliminacion de Publicaciones y Autores
	
Para la eliminacion, implemente los procedimientos almacenados EliminarPublicacion y EliminarAutor
La "firma" de los procedimientos almacenados debe ser la siguiente:

CREATE PROCEDURE EliminarPublicacion
	@title_id varchar(6)
	

CREATE PROCEDURE EliminarAutor
	@au_id varchar (12)

EliminarPublicacion debe encargarse de eliminar las entradas en todas las tablas dependientes
 antes de proceder a eliminar la publicación
Ambos procedimientos deben validar posibles errores usando bloques try/catch y retornar:
 Un código de estatus si no se produjeron errores.
 El código de estatus igual el valor de @@Error si se produjeron errores.
 */

CREATE PROCEDURE usp_GetErrorInfo
	AS
		SELECT ERROR_NUMBER() AS ErrorNumber,
				ERROR_MESSAGE() AS ErrorMessage,
				ERROR_SEVERITY() AS ErrorSeverity,
				ERROR_STATE() AS ErrorState,
				ERROR_PROCEDURE() AS ErrorProcedure,
				ERROR_LINE() AS ErrorLine;

-------------------------

CREATE PROCEDURE EliminarPublicacion
	@title_id varchar(6)
	AS
		BEGIN TRY
		/* 							-- PARA LA PRUEBA VA SIN DELETE
			DELETE FROM Sales WHERE title_id = @title_id
			DELETE FROM Roysched WHERE title_id = @title_id				-- EXISTE ?
			DELETE FROM TitleAuthor WHERE title_id = @title_id
			DELETE FROM Titles WHERE title_id = @title_id		
			*/	
			RETURN 0
		END TRY
		
		BEGIN CATCH
			EXECUTE usp_GetErrorInfo
			RETURN @@ERROR	
		END CATCH

-----------------------

CREATE PROCEDURE EliminarAutor
	@au_id varchar (12)
	AS
		BEGIN TRY
		/* 							-- PARA LA PRUEBA VA SIN DELETE		
			DELETE FROM Authors WHERE au_id = @au_id
		*/
		RETURN 0
		END TRY
		
		BEGIN CATCH
			EXECUTE usp_GetErrorInfo
			RETURN @@ERROR
		END CATCH

	
-------------------------------------------------------------------------------------------------
-- BATCH PRINCIPAL
-------------------------------------------------------------------------------------------------
--Cursor de Autores
-------------------------------------------------------------------------------------------------
		
DECLARE  curAutores CURSOR
	FOR 		------------------------------ SELECT (QUERY DEL CURSOR) ------------------
	SELECT Au. au_id, Au. au_fname, Au. au_lname
		FROM authors Au
		WHERE Au. au_id IN (SELECT au_id 			-- Que haya publicado
							FROM TitleAuthor)
			AND EXISTS (			 				-- Que posea ventas esos años
						SELECT *
							FROM Sales INNER JOIN Titles
								ON Sales. title_id = Titles. title_id 
							INNER JOIN TitleAuthor Ta 
								ON Titles. title_id = Ta. title_id
							WHERE YEAR (ord_date) IN (1993, 1994)
							AND Ta. au_id = Au. au_id				-- Relaciono el Inner Query con el Query Principal
						)
			AND				
	 		25 > ALL ( 										-- Todas sus publicaciones hayan vendido menos de 25 publicaciones
	 					SELECT SUM (SA. qty)					-- Cant de ventas de cada publicacion en esos años
						FROM Sales Sa INNER JOIN Titles Ti		-- tienen < de 25 publicaciones
							ON Sa.title_id = Ti. title_id
							INNER JOIN Titleauthor Ta1
							ON Ti. title_id = Ta1. title_id
						--WHERE YEAR (Sa.ord_date) IN (1993, 1994) -- no es necesario xq ya tengo la condicion
						AND Au. au_id = Ta1. au_id
						GROUP BY Sa.title_id
						)
			AND NOT EXISTS (						-- No sean coautores
						SELECT * 
						FROM titleauthor Ta
						WHERE Ta. au_id = Au.au_id 
							AND Ta. royaltyper <> 100
						)
	-- FIN ---------------------------- FIN SELECT (QUERY DEL CURSOR) ------------------
						
	DECLARE @au_id 			varchar(12), --@title_id varchar(6),
	 		@au_fname 		varchar(20),
	 		@au_lname 		varchar(40)
	
	OPEN curAutores
	
			FETCH NEXT 		FROM curAutores
								INTO @au_id, @au_fname, @au_lname
					
					
		WHILE @@fetch_status = 0
			BEGIN
				PRINT'Procesando Autor: ' + @au_lname + ', ' + @au_fname
				
				
				FETCH NEXT 		FROM curAutores		INTO @au_id, @au_fname, @au_lname
								
			END --END WHILE
			
	CLOSE curAutores
	DEALLOCATE curAutores
	
	-- FIN CURSOR------------------------------------------------------------------------------------
	
	
	
-------------------------------------------------------------------------------------------------
-- BATCH PRINCIPAL V2
-------------------------------------------------------------------------------------------------
--Cursor de Autores y Publicaciones
-------------------------------------------------------------------------------------------------
	
DECLARE  curAutores CURSOR
	FOR 		------------------------------ SELECT (QUERY DEL CURSOR) ------------------
	SELECT Au. au_id, Au. au_fname, Au. au_lname
		FROM authors Au
		WHERE Au. au_id IN (SELECT au_id 			-- Que haya publicado
							FROM TitleAuthor)
			AND EXISTS (			 				-- Que posea ventas esos años
						SELECT *
							FROM Sales INNER JOIN Titles
								ON Sales. title_id = Titles. title_id 
							INNER JOIN TitleAuthor Ta 
								ON Titles. title_id = Ta. title_id
							WHERE YEAR (ord_date) IN (1993, 1994)
							AND Ta. au_id = Au. au_id				-- Relaciono el Inner Query con el Query Principal
						)
			AND				
	 		25 > ALL ( 										-- Todas sus publicaciones hayan vendido menos de 25 publicaciones
	 					SELECT SUM (SA. qty)					-- Cant de ventas de cada publicacion en esos años
						FROM Sales Sa INNER JOIN Titles Ti		-- tienen < de 25 publicaciones
							ON Sa.title_id = Ti. title_id
							INNER JOIN Titleauthor Ta1
							ON Ti. title_id = Ta1. title_id
						--WHERE YEAR (Sa.ord_date) IN (1993, 1994) -- no es necesario xq ya tengo la condicion
						AND Au. au_id = Ta1. au_id
						GROUP BY Sa.title_id
						)
			AND NOT EXISTS (						-- No sean coautores
						SELECT * 
						FROM titleauthor Ta
						WHERE Ta. au_id = Au.au_id 
							AND Ta. royaltyper <> 100
						)
	-- FIN ---------------------------- FIN SELECT (QUERY DEL CURSOR) ------------------
						
	DECLARE @au_id 			varchar(12),
	 		@au_fname 		varchar(20),
	 		@au_lname 		varchar(40)
	
	OPEN curAutores
	
			FETCH NEXT 		FROM curAutores
								INTO @au_id, @au_fname, @au_lname
					
					
		WHILE @@fetch_status = 0
			BEGIN
				PRINT'Procesando Autor: ' + @au_lname + ', ' + @au_fname
				
				---------------------- Recorrer Publicaciones ---------------------------------------------------------------------------
				
				DECLARE curPublicaciones CURSOR
				FOR
					SELECT Tit. title_id
						FROM titles Tit INNER JOIN titleauthor Tau
							ON Tit. title_id = Tau. title_id
					--	INNER JOIN Authors Aut
					--		ON Tau. au_id = Aut. au_id
						WHERE Tau. au_id = @au_id
						
				DECLARE @title_id varchar(6)
				
				--SET @ = 0
				
				OPEN curPublicaciones
				
				FETCH NEXT		FROM curPublicaciones	INTO @title_id
				
				WHILE @@fetch_status = 0
					BEGIN
						PRINT'Procesando Publicacion: ' + @title_id + ' de Autor: ' + @au_lname
						--
						
						FETCH NEXT		FROM curPublicaciones	INTO @title_id
					END --END WHILE
					
					
				CLOSE curPublicaciones
				DEALLOCATE curPublicaciones
				
				-- FIN CURSOR PUBLICACIONES -----------------------------------------------------------------------------------------------------------------
				
				
				FETCH NEXT 		FROM curAutores		INTO @au_id, @au_fname, @au_lname
								
			END --END WHILE
			
	CLOSE curAutores
	DEALLOCATE curAutores
	
	-- FIN CURSOR------------------------------------------------------------------------------------
	
	PRINT'Hola';
	
	
-------------------------------------------------------------------------------------------------
-- BATCH PRINCIPAL V3
-------------------------------------------------------------------------------------------------
-- Agrego el Procedure EliminarPublicaciones (manejo de Errores)
-------------------------------------------------------------------------------------------------
	
DECLARE  curAutores CURSOR
	FOR 		------------------------------ SELECT (QUERY DEL CURSOR) ------------------
	SELECT Au. au_id, Au. au_fname, Au. au_lname
		FROM authors Au
		WHERE Au. au_id IN (SELECT au_id 			-- Que haya publicado
							FROM TitleAuthor)
			AND EXISTS (			 				-- Que posea ventas esos años
						SELECT *
							FROM Sales INNER JOIN Titles
								ON Sales. title_id = Titles. title_id 
							INNER JOIN TitleAuthor Ta 
								ON Titles. title_id = Ta. title_id
							WHERE YEAR (ord_date) IN (1993, 1994)
							AND Ta. au_id = Au. au_id				-- Relaciono el Inner Query con el Query Principal
						)
			AND				
	 		25 > ALL ( 										-- Todas sus publicaciones hayan vendido menos de 25 publicaciones
	 					SELECT SUM (SA. qty)					-- Cant de ventas de cada publicacion en esos años
						FROM Sales Sa INNER JOIN Titles Ti		-- tienen < de 25 publicaciones
							ON Sa.title_id = Ti. title_id
							INNER JOIN Titleauthor Ta1
							ON Ti. title_id = Ta1. title_id
						--WHERE YEAR (Sa.ord_date) IN (1993, 1994) -- no es necesario xq ya tengo la condicion
						AND Au. au_id = Ta1. au_id
						GROUP BY Sa.title_id
						)
			AND NOT EXISTS (						-- No sean coautores
						SELECT * 
						FROM titleauthor Ta
						WHERE Ta. au_id = Au.au_id 
							AND Ta. royaltyper <> 100
						)
	-- FIN ---------------------------- FIN SELECT (QUERY DEL CURSOR) ------------------
						
	DECLARE @au_id 			varchar(12),
	 		@au_fname 		varchar(20),
	 		@au_lname 		varchar(40)
	
	OPEN curAutores
	
			FETCH NEXT 		FROM curAutores
								INTO @au_id, @au_fname, @au_lname
					
					
		WHILE @@fetch_status = 0
			BEGIN
				PRINT'Procesando Autor: ' + @au_lname + ', ' + @au_fname
				
				---------------------- Recorrer Publicaciones ---------------------------------------------------------------------------
				
				DECLARE curPublicaciones CURSOR
				FOR
					SELECT Tit. title_id
						FROM titles Tit INNER JOIN titleauthor Tau
							ON Tit. title_id = Tau. title_id
					--	INNER JOIN Authors Aut
					--		ON Tau. au_id = Aut. au_id
						WHERE Tau. au_id = @au_id
						
				DECLARE @title_id varchar(6)
				
				--SET @ = 0
				
				OPEN curPublicaciones
				
				FETCH NEXT		FROM curPublicaciones	INTO @title_id
				
				WHILE @@fetch_status = 0
					BEGIN
						PRINT'Procesando Publicacion: ' + @title_id + ' de Autor: ' + @au_lname
						--
						
						DECLARE @Retorno	int				-- Valor de retorno del Procedure
						EXECUTE @Retorno = EliminarPublicacion @title_id
						
						PRINT'La eliminacion de publicaciones, retorno: ' + convert(varchar, @retorno)
						IF @Retorno != 0
						BEGIN
							RAISERROR('ERROR en eliminacion de publicacion o sus dependencias', 15, 0)
							RETURN
						END --END IF
						
						
						FETCH NEXT		FROM curPublicaciones	INTO @title_id
					END --END WHILE
					
					
				CLOSE curPublicaciones
				DEALLOCATE curPublicaciones
				
				-- FIN CURSOR PUBLICACIONES -----------------------------------------------------------------------------------------------------------------
				
				
				FETCH NEXT 		FROM curAutores		INTO @au_id, @au_fname, @au_lname
								
			END --END WHILE
			
	CLOSE curAutores
	DEALLOCATE curAutores
	
	-- FIN CURSOR------------------------------------------------------------------------------------
	
		PRINT'Hola';
	
-------------------------------------------------------------------------------------------------
-- BATCH PRINCIPAL V4
-------------------------------------------------------------------------------------------------
-- Agrego el Procedure EliminarAutor y EliminarPublicacion (manejo de Errores)
-------------------------------------------------------------------------------------------------
	
DECLARE  curAutores CURSOR
	FOR 		------------------------------ SELECT (QUERY DEL CURSOR) ------------------
	SELECT Au. au_id, Au. au_fname, Au. au_lname
		FROM authors Au
		WHERE Au. au_id IN (SELECT au_id 			-- Que haya publicado
							FROM TitleAuthor)
			AND EXISTS (			 				-- Que posea ventas esos años
						SELECT *
							FROM Sales INNER JOIN Titles
								ON Sales. title_id = Titles. title_id 
							INNER JOIN TitleAuthor Ta 
								ON Titles. title_id = Ta. title_id
							WHERE YEAR (ord_date) IN (1993, 1994)
							AND Ta. au_id = Au. au_id				-- Relaciono el Inner Query con el Query Principal
						)
			AND				
	 		25 > ALL ( 										-- Todas sus publicaciones hayan vendido menos de 25 publicaciones
	 					SELECT SUM (SA. qty)					-- Cant de ventas de cada publicacion en esos años
						FROM Sales Sa INNER JOIN Titles Ti		-- tienen < de 25 publicaciones
							ON Sa.title_id = Ti. title_id
							INNER JOIN Titleauthor Ta1
							ON Ti. title_id = Ta1. title_id
						--WHERE YEAR (Sa.ord_date) IN (1993, 1994) -- no es necesario xq ya tengo la condicion
						AND Au. au_id = Ta1. au_id
						GROUP BY Sa.title_id
						)
			AND NOT EXISTS (						-- No sean coautores
						SELECT * 
						FROM titleauthor Ta
						WHERE Ta. au_id = Au.au_id 
							AND Ta. royaltyper <> 100
						)
	-- FIN ---------------------------- FIN SELECT (QUERY DEL CURSOR) ------------------
						
	DECLARE @au_id 			varchar(12),
	 		@au_fname 		varchar(20),
	 		@au_lname 		varchar(40)
	
	OPEN curAutores
	
			FETCH NEXT 		FROM curAutores
								INTO @au_id, @au_fname, @au_lname
					
					
		WHILE @@fetch_status = 0
			BEGIN
				PRINT'Procesando Autor: ' + @au_lname + ', ' + @au_fname
				
				---------------------- Recorrer Publicaciones ---------------------------------------------------------------------------
				
				DECLARE curPublicaciones CURSOR
				FOR
					SELECT Tit. title_id
						FROM titles Tit INNER JOIN titleauthor Tau
							ON Tit. title_id = Tau. title_id
					--	INNER JOIN Authors Aut
					--		ON Tau. au_id = Aut. au_id
						WHERE Tau. au_id = @au_id
						
				DECLARE @title_id varchar(6)
				
				--SET @ = 0
				
				OPEN curPublicaciones
				
				FETCH NEXT		FROM curPublicaciones	INTO @title_id
				
				WHILE @@fetch_status = 0
					BEGIN
						PRINT'Procesando Publicacion: ' + @title_id + ' de Autor: ' + @au_lname
						--
						
						DECLARE @Retorno	int				-- Valor de retorno del Procedure
						EXECUTE @Retorno = EliminarPublicacion @title_id
						
						PRINT'La eliminacion de publicaciones, retorno: ' + convert(varchar, @retorno)
						IF @Retorno != 0
						BEGIN
							RAISERROR('ERROR en eliminacion de publicacion o sus dependencias', 15, 0)
							RETURN
						END --END IF
						
						
						FETCH NEXT		FROM curPublicaciones	INTO @title_id
					END --END WHILE
					
					
				CLOSE curPublicaciones
				DEALLOCATE curPublicaciones
				
				-- FIN CURSOR PUBLICACIONES -----------------------------------------------------------------------------------------------------------------
				
				DECLARE @Retorno_Aut	int				-- Valor de retorno del Procedure
				EXECUTE @Retorno_Aut = EliminarAutor @au_id
						
				PRINT'La eliminacion de Autor, retorno: ' + convert(varchar, @Retorno_Aut)
				IF @Retorno_Aut != 0
				BEGIN
						RAISERROR('ERROR en eliminacion de Autor', 15, 0)
					RETURN
				END --END IF
				
				
				FETCH NEXT 		FROM curAutores		INTO @au_id, @au_fname, @au_lname
								
			END --END WHILE curAurtor
			
	CLOSE curAutores
	DEALLOCATE curAutores
	
	-- FIN CURSOR------------------------------------------------------------------------------------
	
	
		PRINT'Hola';
	
	
		
-------------------------------------------------------------------------------------------------
-- BATCH PRINCIPAL V5
-------------------------------------------------------------------------------------------------
-- Transaccionar, Agrego TRANSACTION
-------------------------------------------------------------------------------------------------
	
DECLARE  curAutores CURSOR
	FOR 		------------------------------ SELECT (QUERY DEL CURSOR) ------------------
	SELECT Au. au_id, Au. au_fname, Au. au_lname
		FROM authors Au
		WHERE Au. au_id IN (SELECT au_id 			-- Que haya publicado
							FROM TitleAuthor)
			AND EXISTS (			 				-- Que posea ventas esos años
						SELECT *
							FROM Sales INNER JOIN Titles
								ON Sales. title_id = Titles. title_id 
							INNER JOIN TitleAuthor Ta 
								ON Titles. title_id = Ta. title_id
							WHERE YEAR (ord_date) IN (1993, 1994)
							AND Ta. au_id = Au. au_id				-- Relaciono el Inner Query con el Query Principal
						)
			AND				
	 		25 > ALL ( 										-- Todas sus publicaciones hayan vendido menos de 25 publicaciones
	 					SELECT SUM (SA. qty)					-- Cant de ventas de cada publicacion en esos años
						FROM Sales Sa INNER JOIN Titles Ti		-- tienen < de 25 publicaciones
							ON Sa.title_id = Ti. title_id
							INNER JOIN Titleauthor Ta1
							ON Ti. title_id = Ta1. title_id
						--WHERE YEAR (Sa.ord_date) IN (1993, 1994) -- no es necesario xq ya tengo la condicion
						AND Au. au_id = Ta1. au_id
						GROUP BY Sa.title_id
						)
			AND NOT EXISTS (						-- No sean coautores
						SELECT * 
						FROM titleauthor Ta
						WHERE Ta. au_id = Au.au_id 
							AND Ta. royaltyper <> 100
						)
	-- FIN ---------------------------- FIN SELECT (QUERY DEL CURSOR) ------------------
						
	DECLARE @au_id 			varchar(12),
	 		@au_fname 		varchar(20),
	 		@au_lname 		varchar(40)
	
	OPEN curAutores
	
			FETCH NEXT 		FROM curAutores
								INTO @au_id, @au_fname, @au_lname
					
		BEGIN TRANSACTION -- Donde inicia la Transaccion del Cursor por actividad peligrosa
								
		WHILE @@fetch_status = 0
			BEGIN
				PRINT'Procesando Autor: ' + @au_lname + ', ' + @au_fname
				
				---------------------- Recorrer Publicaciones ---------------------------------------------------------------------------
				
				DECLARE curPublicaciones CURSOR
				FOR
					SELECT Tit. title_id
						FROM titles Tit INNER JOIN titleauthor Tau
							ON Tit. title_id = Tau. title_id
					--	INNER JOIN Authors Aut
					--		ON Tau. au_id = Aut. au_id
						WHERE Tau. au_id = @au_id
						
				DECLARE @title_id varchar(6)
				
				--SET @ = 0
				
				OPEN curPublicaciones
				
				FETCH NEXT		FROM curPublicaciones	INTO @title_id
				
				WHILE @@fetch_status = 0
					BEGIN
						PRINT'Procesando Publicacion: ' + @title_id + ' de Autor: ' + @au_lname
						--
						
						DECLARE @Retorno	int				-- Valor de retorno del Procedure
						EXECUTE @Retorno = EliminarPublicacion @title_id
						
						PRINT'La eliminacion de publicaciones, retorno: ' + convert(varchar, @retorno)
						IF @Retorno != 0
						BEGIN
							RAISERROR('ERROR en eliminacion de publicacion o sus dependencias', 15, 0)
							
							ROLLBACK TRANSACTION 		-- Hago ROLLBACK de la TRANSACTION (una sola) ya que hay un error (No se cancela sola la transaccion)
							
							RETURN 		-- El return (termina el programa) no tiene nada que ver con la TRANSACTION
						END --END IF
						
						
						FETCH NEXT		FROM curPublicaciones	INTO @title_id
					END --END WHILE
					
					
				CLOSE curPublicaciones
				DEALLOCATE curPublicaciones
				
				-- FIN CURSOR PUBLICACIONES -----------------------------------------------------------------------------------------------------------------
				
				DECLARE @Retorno_Aut	int				-- Valor de retorno del Procedure
				
				EXECUTE @Retorno_Aut = EliminarAutor @au_id			-- Sino se resolviera asi (con return value) se hace con Parametro de Salida 
				PRINT'La eliminacion de Autor, retorno: ' + convert(varchar, @Retorno_Aut)
				IF @Retorno_Aut != 0
				BEGIN
						RAISERROR('ERROR en eliminacion de Autor', 15, 0)
					RETURN
				END --END IF
				
				
				FETCH NEXT 		FROM curAutores		INTO @au_id, @au_fname, @au_lname
								
			END --END WHILE curAurtor
			
			COMMIT TRANSACTION -- Como no se hizo ningun ROLLBACK en el Cursor (hay que ponerlos nosotros si anticipamos un error)
			-- ROLLBACK TRANSACTION
			-- Puede haber varios ROLLBACK, pero solo un COMMIT
			
	CLOSE curAutores
	DEALLOCATE curAutores
	
	-- FIN CURSOR------------------------------------------------------------------------------------
	
	
		PRINT'Hola';
	
	
-------------------------------------------------------------------------------------------------
-- Pre- Requsitos para el Trigger
-------------------------------------------------------------------------------------------------

	CREATE TABLE SetUp(
		Tabla 		varchar(40)	NOT NULL,
		Ultimo		integer
		)
	
	INSERT Setup VALUES ('AutoresBadSeller', 1) -- puede ser 0 o 1
	
	CREATE TABLE AutoresBadSeller (
		IDAutor 		SmallInt		NOT NULL,
		au_idViejo 		varchar(12),	
		au_lname		varchar(40)		NOT NULL,
		au_fname		varchar(20)		NOT NULL,
		phone			char(12)			NULL,
		address			varchar(40)			NULL,
		city			varchar(20)			NULL,
		state			char(2)				NULL,
		zip				char(5)				NULL
		)
		
		
	CREATE PROCEDURE ObtenerID
	@NomTabla		varchar(20)	
	AS
		DECLARE @Ultimo 	Int
		BEGIN TRY
			SELECT @Ultimo = Ultimo FROM Setup WHERE Tabla = @NomTabla
			UPDATE Setup SET Ultimo = Ultimo + 1
		END TRY
		
		BEGIN CATCH
			EXECUTE usp_GetErrorInfo
			RETURN -100 	-- Error (manual) en recuperacion de UltimoID (1er valor de retorno utilizable)
							--Microsoft reserva 0 y -1 a -99
		
		END CATCH
		
		RETURN @Ultimo
		
		
-------------------------------------------------------------------------------------------------
-- Trigger V1
-------------------------------------------------------------------------------------------------
-- Recupero UltimoID
-------------------------------------------------------------------------------------------------
	
CREATE TRIGGER InsertarBadSeller
	ON Authors
	AFTER DELETE
	AS
		DECLARE @Ultimo 	Integer
		EXECUTE @Ultimo = ObtenerID 'AutoresBadSeller'
-- END Trigger------------------------------------------------------------------------------------------
		
		
-------------------------------------------------------------------------------------------------
-- Trigger V2
-------------------------------------------------------------------------------------------------
-- Recupero "OLD"
-------------------------------------------------------------------------------------------------
	
ALTER TRIGGER InsertarBadSeller
	ON Authors
	AFTER DELETE
	AS
		DECLARE @Ultimo 		Integer
		DECLARE @au_idViejo		varchar(12), @au_lname		varchar(40), @au_fname	varchar(20)
		
		EXECUTE @Ultimo = ObtenerID 'AutoresBadSeller'
		
		IF	@Ultimo != -100 --Error en recuperacion de UltimoID 
			BEGIN
				SELECT @au_idViejo = au_id, @au_fname = au_fname, @au_lname = au_lname
					FROM DELETED
					
			END --END IF
			
-- END Trigger------------------------------------------------------------------------------------------
		
	
-------------------------------------------------------------------------------------------------
-- Trigger V3
-------------------------------------------------------------------------------------------------
-- Manejo de Errores
-------------------------------------------------------------------------------------------------
	
ALTER TRIGGER InsertarBadSeller
	ON Authors
	AFTER DELETE
	AS
		DECLARE @Ultimo 		Integer
		DECLARE @au_idViejo		varchar(12), @au_lname		varchar(40), @au_fname	varchar(20)
		
		EXECUTE @Ultimo = ObtenerID 'AutoresBadSeller'
		
		IF	@Ultimo != -100 --Error en recuperacion de UltimoID 
			BEGIN
				SELECT @au_idViejo = au_id, @au_fname = au_fname, @au_lname = au_lname
					FROM DELETED  -- OLD
			END	-- END IF	
		ELSE -- Error de retorno -100
			BEGIN
				RAISERROR ('Error en recuperacion de Ultimo ID', 15, 0)
				ROLLBACK TRANSACTION
				RETURN				
			END --END ELSE
			
-- END Trigger------------------------------------------------------------------------------------------
					
			
-------------------------------------------------------------------------------------------------
-- Trigger V4
-------------------------------------------------------------------------------------------------
-- Insert con Try/Catch
-------------------------------------------------------------------------------------------------
	
ALTER TRIGGER InsertarBadSeller
	ON Authors
	AFTER DELETE
	AS
		DECLARE @Ultimo 		Integer
		DECLARE @au_idViejo		varchar(12), @au_lname		varchar(40), @au_fname	varchar(20)
		
		EXECUTE @Ultimo = ObtenerID 'AutoresBadSeller'
		
		IF	@Ultimo != -100 --Error en recuperacion de UltimoID 
			BEGIN
				SELECT @au_idViejo = au_id, @au_fname = au_fname, @au_lname = au_lname
					FROM DELETED  -- OLD
					
				--- INSERT (TRY/CATCH) -------------------------------------------------------
				BEGIN TRY
					INSERT AutoresBadSeller
								(IDAutor, 	 au_idViejo,  au_fname,  au_lname)
						VALUES 	(@Ultimo +1, @au_idViejo, @au_fname, @au_lname)
				END TRY
				
				BEGIN CATCH
					EXECUTE usp_GetErrorInfo
					ROLLBACK TRANSACTION
					RETURN
				END CATCH
				------ END (TRY/CATCH) ----------------------------------------------------
					
			END	-- END IF	
		ELSE -- Error de retorno -100
			BEGIN
				RAISERROR ('Error en recuperacion de Ultimo ID', 15, 0)
				ROLLBACK TRANSACTION
				RETURN				
			END --END ELSE
			
-- END Trigger------------------------------------------------------------------------------------------
							
			
------------------ Descomentar los Deletes ------------------------------------------------ 
----- Batch a Correr --------------------------------------
			
			
---------------------------------------------------------------------------------
-- PROCEDURES:
---------------------------------------------------------------------------------
			
ALTER PROCEDURE usp_GetErrorInfo
	AS
		SELECT ERROR_NUMBER() AS ErrorNumber,
				ERROR_MESSAGE() AS ErrorMessage,
				ERROR_SEVERITY() AS ErrorSeverity,
				ERROR_STATE() AS ErrorState,
				ERROR_PROCEDURE() AS ErrorProcedure,
				ERROR_LINE() AS ErrorLine;

-------------------------
ALTER PROCEDURE EliminarPublicacion
	@title_id varchar(6)
	AS
		BEGIN TRY
								-- PARA LA PRUEBA VA SIN DELETE
			DELETE FROM Sales WHERE title_id = @title_id
			DELETE FROM Roysched WHERE title_id = @title_id				-- EXISTE ?
			DELETE FROM TitleAuthor WHERE title_id = @title_id
			DELETE FROM Titles WHERE title_id = @title_id		
			
			RETURN 0
		END TRY
		
		BEGIN CATCH
			EXECUTE usp_GetErrorInfo
			RETURN @@ERROR	
		END CATCH

-----------------------

ALTER PROCEDURE EliminarAutor
	@au_id varchar (12)
	AS
		BEGIN TRY
									-- PARA LA PRUEBA VA SIN DELETE		
			DELETE FROM Authors WHERE au_id = @au_id
		
		RETURN 0
		END TRY
		
		BEGIN CATCH
			EXECUTE usp_GetErrorInfo
			RETURN @@ERROR
		END CATCH

---- FIN PROCEDURES --------------------------------------------------------------------------------------
	
		PRINT'Hola';		

-------------------------------------------------------------------------------------------------
-- BATCH PRINCIPAL V5
-------------------------------------------------------------------------------------------------
	
DECLARE  curAutores CURSOR
	FOR 		------------------------------ SELECT (QUERY DEL CURSOR) ------------------
	SELECT Au. au_id, Au. au_fname, Au. au_lname
		FROM authors Au
		WHERE Au. au_id IN (SELECT au_id 			-- Que haya publicado
							FROM TitleAuthor)
			AND EXISTS (			 				-- Que posea ventas esos años
						SELECT *
							FROM Sales INNER JOIN Titles
								ON Sales. title_id = Titles. title_id 
							INNER JOIN TitleAuthor Ta 
								ON Titles. title_id = Ta. title_id
							WHERE YEAR (ord_date) IN (1993, 1994)
							AND Ta. au_id = Au. au_id				-- Relaciono el Inner Query con el Query Principal
						)
			AND				
	 		25 > ALL ( 										-- Todas sus publicaciones hayan vendido menos de 25 publicaciones
	 					SELECT SUM (SA. qty)					-- Cant de ventas de cada publicacion en esos años
						FROM Sales Sa INNER JOIN Titles Ti		-- tienen < de 25 publicaciones
							ON Sa.title_id = Ti. title_id
							INNER JOIN Titleauthor Ta1
							ON Ti. title_id = Ta1. title_id
						--WHERE YEAR (Sa.ord_date) IN (1993, 1994) -- no es necesario xq ya tengo la condicion
						AND Au. au_id = Ta1. au_id
						GROUP BY Sa.title_id
						)
			AND NOT EXISTS (						-- No sean coautores
						SELECT * 
						FROM titleauthor Ta
						WHERE Ta. au_id = Au.au_id 
							AND Ta. royaltyper <> 100
						)
	-- FIN ---------------------------- FIN SELECT (QUERY DEL CURSOR) ------------------
						
	DECLARE @au_id 			varchar(12),
	 		@au_fname 		varchar(20),
	 		@au_lname 		varchar(40)
	
	OPEN curAutores
	
			FETCH NEXT 		FROM curAutores
								INTO @au_id, @au_fname, @au_lname
					
		BEGIN TRANSACTION -- Donde inicia la Transaccion del Cursor por actividad peligrosa
								
		WHILE @@fetch_status = 0
			BEGIN
				PRINT'Procesando Autor: ' + @au_lname + ', ' + @au_fname
				
				---------------------- Recorrer Publicaciones ---------------------------------------------------------------------------
				
				DECLARE curPublicaciones CURSOR
				FOR
					SELECT Tit. title_id
						FROM titles Tit INNER JOIN titleauthor Tau
							ON Tit. title_id = Tau. title_id
					--	INNER JOIN Authors Aut
					--		ON Tau. au_id = Aut. au_id
						WHERE Tau. au_id = @au_id
						
				DECLARE @title_id varchar(6)
				
				--SET @ = 0
				
				OPEN curPublicaciones
				
				FETCH NEXT		FROM curPublicaciones	INTO @title_id
				
				WHILE @@fetch_status = 0
					BEGIN
						PRINT'Procesando Publicacion: ' + @title_id + ' de Autor: ' + @au_lname
						--
						
						DECLARE @Retorno	int				-- Valor de retorno del Procedure
						EXECUTE @Retorno = EliminarPublicacion @title_id
						
						PRINT'La eliminacion de publicaciones, retorno: ' + convert(varchar, @retorno)
						IF @Retorno != 0
						BEGIN
							RAISERROR('ERROR en eliminacion de publicacion o sus dependencias', 15, 0)
							
							ROLLBACK TRANSACTION 		-- Hago ROLLBACK de la TRANSACTION (una sola) ya que hay un error (No se cancela sola la transaccion)
							
							RETURN 		-- El return (termina el programa) no tiene nada que ver con la TRANSACTION
						END --END IF
						
						
						FETCH NEXT		FROM curPublicaciones	INTO @title_id
					END --END WHILE
					
					
				CLOSE curPublicaciones
				DEALLOCATE curPublicaciones
				
				-- FIN CURSOR PUBLICACIONES -----------------------------------------------------------------------------------------------------------------
				
				DECLARE @Retorno_Aut	int				-- Valor de retorno del Procedure
				
				EXECUTE @Retorno_Aut = EliminarAutor @au_id			-- Sino se resolviera asi (con return value) se hace con Parametro de Salida 
				PRINT'La eliminacion de Autor, retorno: ' + convert(varchar, @Retorno_Aut)
				IF @Retorno_Aut != 0
				BEGIN
						RAISERROR('ERROR en eliminacion de Autor', 15, 0)
					RETURN
				END --END IF
				
				
				FETCH NEXT 		FROM curAutores		INTO @au_id, @au_fname, @au_lname
								
			END --END WHILE curAurtor
			
			COMMIT TRANSACTION -- Como no se hizo ningun ROLLBACK en el Cursor (hay que ponerlos nosotros si anticipamos un error)
			-- ROLLBACK TRANSACTION
			-- Puede haber varios ROLLBACK, pero solo un COMMIT
			
	CLOSE curAutores
	DEALLOCATE curAutores
	
	-- FIN CURSOR------------------------------------------------------------------------------------
	
			
	-- Ver si todo salio bien
	
	SELECT * FROM AutoresBadSeller;
	SELECT * FROM Setup;
	-- SELECT * FROM Authors;		
	
	SELECT * FROM Authors WHERE au_id IN ('172-32-1176','274-80-9391','712-45-1867')
	
	PRINT'Hola';	
			
			
			
-------------------------------------------------------------------------------------------------
-- Trigger V4
-------------------------------------------------------------------------------------------------
	
ALTER TRIGGER InsertarBadSeller
	ON Authors
	AFTER DELETE
	AS
		DECLARE @Ultimo 		Integer
		DECLARE @au_idViejo		varchar(12), @au_lname		varchar(40), @au_fname	varchar(20)
		
		EXECUTE @Ultimo = ObtenerID 'AutoresBadSeller'
		
		IF	@Ultimo != -100 --Error en recuperacion de UltimoID 
			BEGIN
				SELECT @au_idViejo = au_id, @au_fname = au_fname, @au_lname = au_lname
					FROM DELETED  -- OLD
					
				PRINT'Trigger V4 [InsertarBadSeller]' + @au_idViejo + ' , ' + @au_fname
					
				--- INSERT (TRY/CATCH) -------------------------------------------------------
				BEGIN TRY
					INSERT AutoresBadSeller
								(IDAutor, 	 au_idViejo,  au_fname,  au_lname)
						VALUES 	(@Ultimo +1, @au_idViejo, @au_fname, @au_lname)
				END TRY
				
				BEGIN CATCH
					EXECUTE usp_GetErrorInfo
					ROLLBACK TRANSACTION
					RETURN
				END CATCH
				------ END (TRY/CATCH) ----------------------------------------------------
					
			END	-- END IF	
		ELSE -- Error de retorno -100
			BEGIN
				RAISERROR ('Error en recuperacion de Ultimo ID', 15, 0)
				ROLLBACK TRANSACTION
				RETURN				
			END --END ELSE
			
-- END Trigger------------------------------------------------------------------------------------------
						
	
	
--------------------------------------------------------------------------------------------------------
--------------------------------------------------------------------------------------------------------
--------------------------------------------------------------------------------------------------------

				
SELECT * FROM INFORMATION_SCHEMA.TABLES
			

			
			
/*
 ============================================
SQL: Guía de Trabajo Nro. 4  
Stored Procedures y functions: Ejercicios
 ============================================
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
			
	-- PS1372		title_id
	-- 1389			pub_id
			
-- ALTER
CREATE PROCEDURE SP_obtenerPrecio(
	@pub_id			char(4)
	)
	AS
	BEGIN
		SELECT price FROM Titles
			WHERE pub_id = @pub_id
			RETURN 0;
	END	-- END PROCEDURE
------------
	
EXECUTE SP_obtenerPrecio 1389;	

alter PROCEDURE SP_obtenerPrecio(
	@title_id		varchar(6)
	)
	AS
	BEGIN
		SELECT price FROM Titles
			WHERE title_id = @title_id
			RETURN 0;
	END	-- END PROCEDURE
-----------		
	
EXECUTE SP_obtenerPrecio PS1372;
	
			

--PostgreSQL:
CREATE or Replace FUNCTION func_obtenerPrecio(
	IN p_pub_id 		char(4)	
	)
	RETURNS Setof numeric -- O SINO: Titles. price %TYPE
	Language plpgsql
	AS
	$$
	DECLARE
		--price1 titles. price %TYPE;
	BEGIN
		RETURN QUERY
		-- price1 := (					-- No anda si es mas de 1 valor
		SELECT price -- INTO price1		-- No anda si es mas de 1 valor
			FROM Titles
			WHERE pub_id = p_pub_id
		--	)
			;
	END
	$$	-- end FUNCTION

-- O SINO
	
CREATE or Replace FUNCTION func_obtenerPrecio(
	IN p_pub_id 		char(4)
	--, OUT p_price		numeric
	)
	RETURNS Setof Titles. price %type -- para output parameter: RETURNS numeric
	Language plpgsql
	AS
	$$
	DECLARE
		--price1 titles. price %TYPE;
	BEGIN
		RETURN QUERY
		SELECT price  -- INTO p_price
			FROM Titles
			WHERE pub_id = p_pub_id;
	END
	$$	-- end FUNCTION
	
	SELECT  *  
   FROM func_obtenerPrecio('1389'); --0736 --PS1372
			
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

	DECLARE
		@stor_id 		 char(4),
		@ord_num		varchar(20);
		@stor_id = 7067
		@ord_num = P2121
		
		
		SELECT ord_date 
			FROM Sales
			WHERE stor_id = 7067
			AND ord_num = 'P2121';
	
--SQL Server:

CREATE PROCEDURE Fecha_venta_store(
	
	)
			
			
			
		
	
	
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

BEGIN 
	
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
	
	BEGIN TRY
		
		UPDATE Productos 
			SET stock = stock - @cant
			WHERE codProd = @codProd
		
		INSERT INTO Detalle Values(@CodDetalle, @numPed	, @codProd, @cant, @cant * @precUnit) 
		
		COMMIT TRANSACTION
		--RETURN 0;
		
	END TRY

	BEGIN CATCH
	
		EXECUTE usp_GetErrorInfo
		ROLLBACK TRANSACTION
		--RETURN 99;
		
	END CATCH
	
END -- end batch


Select * from productos;
Select * from Detalle;
	
	
---------------------------------------------------------------------------------------------------------------

---------------------------------------------------------------------------------------------------------------

---------------------------------------------------------------------------------------------------------------
/*
 ============================================
SQL: 
SQL Dinamico: Pruebas y Ejercicios
 ============================================
 */
	
-------------------------------------------------------------------------
---------------- Ejemplo de código seguro vs. inseguro ------------------ 
-------------------------------------------------------------------------  

------- Código Inseguro (Posibilidad de alteración del SQL por injección de código) ----------

-- SQL Server:

-- Supongamos que @nombreTabla viene de la entrada del usuario:

-- SELECT * FROM venta.factura_detalle;
BEGIN
  BEGIN TRANSACTION
	 DECLARE @nombreTabla VARCHAR(50) = 'venta.factura; DROP TABLE 
	venta.factura_detalle; --';		-- Injeccion de codigo malicioso
	 DECLARE @query VARCHAR(1000);
	 SET @query = 'SELECT * FROM ' + @nombreTabla;		-- nombre tabla tiene mas de una sentencia y No tiene verificacion de lo que hay en la misma
	 EXEC(@query);  -- Esto podría ejecutar un SQL malicioso si @nombreTabla es manipulado
	 
	 -- SELECT * FROM venta.factura_detalle;
  ROLLBACK TRANSACTION
END

------------------ Código Seguro (Uso de Parámetros) --------------------
-------------------------------------------------------------------------

-- En SQL Server, utiliza una lista de tablas permitidas:

BEGIN
  BEGIN TRANSACTION
	
	 DECLARE @nombreTabla NVARCHAR(50) = 'venta.factura';
	 IF @nombreTabla NOT IN ('venta.factura', 'venta.factura_detalle')	-- Se chequea que la variable dada
	    THROW 50001, 'Tabla no permitida', 1;					-- Lanza error si no cumple con el chequeo (posible codigo malicioso)
	 --DECLARE @query NVARCHAR(1000) = N'SELECT * FROM ' + QUOTENAME(@nombreTabla);
	 DECLARE @query NVARCHAR(1000) = N'SELECT * FROM ' + @nombreTabla;
	 EXEC sp_executesql @query;
	
  ROLLBACK TRANSACTION
END

----------------------------------------------------
/*
El SQL dinámico es una herramienta poderosa y flexible, pero su uso conlleva riesgos de seguridad
 que deben gestionarse con cuidado.
 */

----------------------------------------------------

/*
El SQL dinámico se ejecuta con EXECUTE.
 Consulta en la que el nombre de la tabla y la columna se definen en tiempo de ejecución.
*/

-- SQL Server:

DECLARE @cadena VARCHAR(100)
 DECLARE @nomTabla VARCHAR(30) = 'venta.factura'	-- sigue siendo inseguro porque: puedo poner una tabla a la que podria no tener acceso o ejecutar otro comando
 DECLARE @nomColumna VARCHAR(60) = 'id_cliente'		-- sigue siendo inseguro porque: puedo poner cualquier columna de cualquier tabla
 SET @cadena = 'SELECT ' + @nomColumna + ' FROM ' + @nomTabla	-- sigue siendo inseguro porque: no hay verificacion
 EXEC (@cadena)
 
 -------------
 
-- PostgreSQL:
 
CREATE OR REPLACE FUNCTION sql_dinamico_ejemp(
	nom_tabla VARCHAR, 			-- sigue siendo inseguro porque: puedo poner una tabla a la que podria no tener acceso o ejecutar otro comando
	nom_columna VARCHAR			-- sigue siendo inseguro porque: puedo poner cualquier columna de cualquier tabla
 ) 
 RETURNS SETOF BIGINT AS
 $$
	 DECLARE
	    	v_cadena VARCHAR;
	 BEGIN
		    v_cadena := 'SELECT ' || nom_columna || ' FROM ' || nom_tabla;     -- sigue siendo inseguro porque: no hay verificacion
		    RAISE NOTICE '-Ejecutando: %', v_cadena;
		    RETURN QUERY EXECUTE v_cadena;			-- Devuelvo una Consulta (QUERY) ejecutando la cadena
	 END;
 $$
 LANGUAGE plpgsql;

 --Uso:

SELECT * FROM sql_dinamico_ejemp('venta.factura', 'id_cliente');

	
	
------------------ Transposición de filas a columnas --------------------
-------------------------------------------------------------------------
/*
 Por transposición de datos se entiende a el proceso de convertir información dispuesta en filas a 
columnas. En este ejemplo, generaremos una columna para cada mes y sumaremos la cantidad 
vendida de cada producto en cada mes. Esto no es SQL Dinámico, pero expone como introducción a
 otro caso más complejo.
 En estos ejemplos se sumariza la cantidad vendida por cada producto por cada mes.
 */

-- SQL Server:

SELECT p.descripcion AS Producto,
    SUM(CASE WHEN MONTH(f.fecha) = 1 THEN fd.cantidad ELSE 0 END) AS Ene,
    SUM(CASE WHEN MONTH(f.fecha) = 2 THEN fd.cantidad ELSE 0 END) AS Feb,
    SUM(CASE WHEN MONTH(f.fecha) = 3 THEN fd.cantidad ELSE 0 END) AS Mar,
    SUM(CASE WHEN MONTH(f.fecha) = 4 THEN fd.cantidad ELSE 0 END) AS Abr,
    SUM(CASE WHEN MONTH(f.fecha) = 5 THEN fd.cantidad ELSE 0 END) AS May,
    SUM(CASE WHEN MONTH(f.fecha) = 6 THEN fd.cantidad ELSE 0 END) AS Jun,
    SUM(CASE WHEN MONTH(f.fecha) = 7 THEN fd.cantidad ELSE 0 END) AS Jul,
    SUM(CASE WHEN MONTH(f.fecha) = 8 THEN fd.cantidad ELSE 0 END) AS Ago,
    SUM(CASE WHEN MONTH(f.fecha) = 9 THEN fd.cantidad ELSE 0 END) AS Sep,
    SUM(CASE WHEN MONTH(f.fecha) = 10 THEN fd.cantidad ELSE 0 END) AS Oct,
    SUM(CASE WHEN MONTH(f.fecha) = 11 THEN fd.cantidad ELSE 0 END) AS Nov,
    SUM(CASE WHEN MONTH(f.fecha) = 12 THEN fd.cantidad ELSE 0 END) AS Dic
    -- , SUM(CASE WHEN MONTH(f.fecha) = 13 THEN fd.cantidad ELSE 0 END) AS Prueba
 FROM venta.factura f
 INNER JOIN venta.factura_detalle fd ON f.id = fd.id_factura
 INNER JOIN producto.producto p ON fd.id_producto = p.id
 GROUP BY p.descripcion
 ORDER BY p.descripcion;

-----------------------------------

-- PostgreSQL:
	
 SELECT p.descripcion AS producto,
    SUM(CASE WHEN EXTRACT(MONTH FROM f.fecha) = 1 THEN fd.cantidad ELSE 0 END) AS ene,
    SUM(CASE WHEN EXTRACT(MONTH FROM f.fecha) = 2 THEN fd.cantidad ELSE 0 END) AS feb,
    SUM(CASE WHEN EXTRACT(MONTH FROM f.fecha) = 3 THEN fd.cantidad ELSE 0 END) AS mar,
    SUM(CASE WHEN EXTRACT(MONTH FROM f.fecha) = 4 THEN fd.cantidad ELSE 0 END) AS abr,
    SUM(CASE WHEN EXTRACT(MONTH FROM f.fecha) = 5 THEN fd.cantidad ELSE 0 END) AS may,
    SUM(CASE WHEN EXTRACT(MONTH FROM f.fecha) = 6 THEN fd.cantidad ELSE 0 END) AS jun,
    SUM(CASE WHEN EXTRACT(MONTH FROM f.fecha) = 7 THEN fd.cantidad ELSE 0 END) AS jul,
    SUM(CASE WHEN EXTRACT(MONTH FROM f.fecha) = 8 THEN fd.cantidad ELSE 0 END) AS ago,
    SUM(CASE WHEN EXTRACT(MONTH FROM f.fecha) = 9 THEN fd.cantidad ELSE 0 END) AS sep,
    SUM(CASE WHEN EXTRACT(MONTH FROM f.fecha) = 10 THEN fd.cantidad ELSE 0 END) AS oct,
    SUM(CASE WHEN EXTRACT(MONTH FROM f.fecha) = 11 THEN fd.cantidad ELSE 0 END) AS nov,
    SUM(CASE WHEN EXTRACT(MONTH FROM f.fecha) = 12 THEN fd.cantidad ELSE 0 END) AS dic
    -- , SUM(CASE WHEN EXTRACT(MONTH FROM f.fecha) = 13 THEN fd.cantidad ELSE 0 END) AS prueba
 FROM venta.factura f
 INNER JOIN venta.factura_detalle fd ON f.id = fd.id_factura
 INNER JOIN producto.producto p ON fd.id_producto = p.id
 GROUP BY p.descripcion
 ORDER BY p.descripcion;
			
------------------------------------------------------------------
 
 /*
 Estos scripts son de utilidad siempre que conozcamos la cantidad de columnas de la salida. En estos
 casos doce columnas, una por cada mes.
  */
 
------------------- Generación dinámica de columnas ---------------------
-------------------------------------------------------------------------
 /*
 Ahora, si necesitamos generar una salida donde las columnas de mes son variables en función de un
 rango (por ejemplo desde marzo-2022 hasta junio-2023), deberemos usar SQL dinámico. 
 */
 
 -- SQL Server:
 
 -- Modalidad batch:
 
 DECLARE @fechaInicio DATE = '2022-03-01';
 DECLARE @fechaFin DATE = '2023-06-01';
 
 DECLARE @fecha DATE;
 DECLARE @col VARCHAR(30);
 DECLARE @sqldin VARCHAR(300);
 
 -- tabla temporal si no existe
 IF OBJECT_ID('tempdb..#ventas_por_producto_mes') IS NOT NULL 
 	DROP TABLE #ventas_por_producto_mes;
 
 CREATE TABLE #ventas_por_producto_mes (
    id_producto BIGINT
 );
 
 -- Insertar productos únicos en el rango de fechas
 INSERT INTO #ventas_por_producto_mes (id_producto)
 	SELECT DISTINCT p.id
		FROM venta.factura f
		JOIN venta.factura_detalle fd ON f.id = fd.id_factura
		JOIN producto.producto p ON fd.id_producto = p.id
		WHERE f.fecha BETWEEN @fechaInicio AND @fechaFin;
		
 -- Agregar columnas dinámicas (meses) a la tabla temporal
 SET @fecha = @fechaInicio;
 
 WHILE (@fecha <= @fechaFin)
 BEGIN
    SET @col = RIGHT(CONVERT(VARCHAR(7), @fecha, 120), 7);  -- Formato YYYY-MM
    SET @fecha = DATEADD(MONTH, 1, @fecha);
 
    -- Agregar la columna si no existe
    SET @sqldin = 'ALTER TABLE #ventas_por_producto_mes ADD ['
    	+ @col + '] NUMERIC(38, 2) NULL';
    EXEC(@sqldin);
 END;	-- end WHILE
 
 -- Declarar variables para el cursor
 DECLARE @sqldin2 VARCHAR(300);
 DECLARE @cant NUMERIC(38,2);
 DECLARE @id_producto BIGINT;
 DECLARE @mes VARCHAR(7);
 
 -- Declarar el cursor para recorrer los datos de ventas por mes y producto
 DECLARE cur CURSOR FOR
 SELECT p.id AS id_producto, 
       RIGHT(CONVERT(VARCHAR(7), f.fecha, 120), 7) AS mes,  -- Formato 'YYYY-MM'
 
--------------
       
 SUM(fd.cantidad) AS cantidad
	 FROM venta.factura f
	 JOIN venta.factura_detalle fd ON f.id = fd.id_factura
	 JOIN producto.producto p ON fd.id_producto = p.id
	 WHERE f.fecha BETWEEN @fechaInicio AND @fechaFin
	 GROUP BY p.id, RIGHT(CONVERT(VARCHAR(7), f.fecha, 120), 7)
	 ORDER BY p.id, RIGHT(CONVERT(VARCHAR(7), f.fecha, 120), 7);
	 
 -- Abrir el cursor y procesar cada fila
 OPEN cur;
 FETCH NEXT FROM cur INTO @id_producto, @mes, @cant;
 WHILE @@FETCH_STATUS = 0
 BEGIN
    SET @sqldin2 = 'UPDATE #ventas_por_producto_mes SET [' + @mes + '] = 
		' + CONVERT(VARCHAR, @cant) 
                   + ' WHERE id_producto = ' + CONVERT(VARCHAR, @id_producto);
    EXEC(@sqldin2);
    
    FETCH NEXT FROM cur INTO @id_producto, @mes, @cant;
 END;	-- end WHILE
 
 -- Cerrar y liberar el cursor
 CLOSE cur;
 DEALLOCATE cur;
 
 -- Select con join para obtener la descripcion del producto
 SELECT p.descripcion, v.*
	 FROM #ventas_por_producto_mes v
	 JOIN producto.producto p ON v.id_producto = p.id;
 
 	
 --------------------------
 
 /*
 Paso a paso:
 
 1. Declaración de variables de fechas y asignación del rango de consulta;
 2. Declaración de variables que se utilizarán para construir columnas de mes dinámicas en la tabla temporal, y para 
generar y ejecutar sentencias SQL dinámicas.
 3. Creación de tabla temporal
 4. Inserción de productos únicos:
 insert into #ventas_por_producto_mes (id_producto) SELECT DISTINCT p.id ...
 5. Generación dinámica de columnas de mes a través de un while. En cada iteración, se construye un nombre de 
columna en formato YYYY-MM y se hace un “alter table” para agregarlo a la tabla temporaria.
 6. Cursor para calcular las ventas por producto y por mes. El cursor selecciona id_producto, mes (en formato YYYY
MM), y cantidad (sumando las cantidades vendidas) para cada producto y mes dentro del rango de fechas.
 7. Dentro del cursor para cada registro, se construye y ejecuta una sentencia SQL dinámica UPDATE para actualizar la 
columna correspondiente al mes en #ventas_por_producto_mes con la cantidad vendida.
 8. Se cierra el cursor.
 9. Select para visualización de resultados.
  */
 
 /*
 A continuación, la misma funcionalidad se codifica en un procedimiento almacenado, de modo de 
que quede encapsulado.
  */
 
 CREATE PROCEDURE generar_reporte_ventas_por_producto_mes
    @fechaInicio DATE,
    @fechaFin DATE
 AS
 BEGIN
    SET NOCOUNT ON;
 
    DECLARE @fecha DATE;
    DECLARE @col VARCHAR(30);
    DECLARE @sqldin VARCHAR(300);
    
    -- Crear tabla temporal si no existe
    IF OBJECT_ID('tempdb..#ventas_por_producto_mes') IS NOT NULL 
    	DROP TABLE #ventas_por_producto_mes;

    CREATE TABLE #ventas_por_producto_mes (
        id_producto BIGINT
    );
 
    -- Insertar productos únicos en el rango de fechas
    INSERT INTO #ventas_por_producto_mes (id_producto)
	    SELECT DISTINCT p.id
		    FROM venta.factura f
		    JOIN venta.factura_detalle fd ON f.id = fd.id_factura
		    JOIN producto.producto p ON fd.id_producto = p.id
		    WHERE f.fecha BETWEEN @fechaInicio AND @fechaFin;
 
  	-- Generar columnas dinámicas (meses) en la tabla temporal
    SET @fecha = @fechaInicio;
  
    WHILE (@fecha <= @fechaFin)
    BEGIN
 		SET @col = RIGHT(CONVERT(VARCHAR(7), @fecha, 120), 7);  -- Formato 'YYYY-MM'
        SET @fecha = DATEADD(MONTH, 1, @fecha);
    
    	-- Agregar la columna si no existe
        SET @sqldin = 'ALTER TABLE #ventas_por_producto_mes ADD [' + @col + 
        	'] NUMERIC(38, 2) NULL';
        EXEC(@sqldin);
    END;	-- END WHILE
	
    -- Declarar variables para el cursor
    DECLARE @sqldin2 VARCHAR(300);
    DECLARE @cant NUMERIC(38,2);
    DECLARE @id_producto BIGINT;
    DECLARE @mes VARCHAR(7);
    
     -- Declarar el cursor para recorrer los datos de ventas por mes y producto
    DECLARE cur CURSOR FOR
    SELECT p.id AS id_producto, 
        RIGHT(CONVERT(VARCHAR(7), f.fecha, 120), 7) AS mes,  -- Formato 'YYYY-MM'
        
        SUM(fd.cantidad) AS cantidad
		    FROM venta.factura f
		    JOIN venta.factura_detalle fd ON f.id = fd.id_factura
		    JOIN producto.producto p ON fd.id_producto = p.id
		    WHERE f.fecha BETWEEN @fechaInicio AND @fechaFin
		    GROUP BY p.id, RIGHT(CONVERT(VARCHAR(7), f.fecha, 120), 7)
		    ORDER BY p.id, RIGHT(CONVERT(VARCHAR(7), f.fecha, 120), 7);
    
     -- Abrir el cursor y procesar cada fila
    OPEN cur;
    FETCH NEXT FROM cur INTO @id_producto, @mes, @cant;
     
    WHILE @@FETCH_STATUS = 0
    BEGIN
    	-- Construir y ejecutar la instrucción SQL dinámica para actualizar la columna
        SET @sqldin2 = 'UPDATE #ventas_por_producto_mes SET [' + @mes + '] = ' +
 			CONVERT(VARCHAR, @cant) 
                       + ' WHERE id_producto = ' + CONVERT(VARCHAR, @id_producto);
        EXEC(@sqldin2);
        
        FETCH NEXT FROM cur INTO @id_producto, @mes, @cant;
    END;	-- END WHILE
    
     -- Cerrar y liberar el cursor
    CLOSE cur;
    DEALLOCATE cur;
     
    -- Devolver los resultados finales con JOIN para obtener la descripcion del producto
    SELECT p.descripcion, v.*
	    FROM #ventas_por_producto_mes v
	    JOIN producto.producto p ON v.id_producto = p.id;
 END; -- END PROCEDURE
    
 --    USO:
 
 EXEC generar_reporte_ventas_por_producto_mes '2022-03-01', '2023-06-01';
    
    
 ----------------------------------------------------------------------
 
 -- PostgreSQL:
 /*
 A continuación un ejemplo en PostgreSQL, donde la lógica se encapsula en una función. Los 
resultados de la función quedan registrados en una tabla que es sobre la que después se realiza la 
consulta.
 */
 
CREATE OR REPLACE FUNCTION venta.generar_reporte_ventas_por_producto_mes(
	fecha_inicio DATE, 
	fecha_fin DATE
)
 RETURNS VOID
 LANGUAGE plpgsql
 AS $$
 DECLARE
    fecha DATE;
    col_name VARCHAR;
    sql_alter TEXT;
    sql_update TEXT;
    id_producto BIGINT;
    mes VARCHAR(7);
    cantidad NUMERIC(38,2);
 BEGIN
    -- Crear la tabla de reporte si no existe
    CREATE TABLE IF NOT EXISTS venta.reporte_ventas_por_producto_mes (
        id_producto BIGINT
    );
    -- Limpiar la tabla de reporte antes de llenarla de nuevo
    TRUNCATE TABLE venta.reporte_ventas_por_producto_mes;

    -- Insertar productos únicos en el rango de fechas
    INSERT INTO venta.reporte_ventas_por_producto_mes (id_producto)
	    SELECT DISTINCT p.id
		    FROM venta.factura f
		    JOIN venta.factura_detalle fd ON f.id = fd.id_factura
		    JOIN producto.producto p ON fd.id_producto = p.id
		    WHERE f.fecha BETWEEN fecha_inicio AND fecha_fin;

    -- Generar columnas dinámicas (meses) en la tabla de reporte
    fecha := fecha_inicio;
    WHILE fecha <= fecha_fin LOOP
        col_name := TO_CHAR(fecha, 'YYYY-MM');
        sql_alter := FORMAT('ALTER TABLE venta.reporte_ventas_por_producto_mes 
			ADD COLUMN IF NOT EXISTS "%s" NUMERIC(38, 2);', col_name);
        EXECUTE sql_alter;
        fecha := fecha + INTERVAL '1 month';
    END LOOP;

    -- Calcular y actualizar las cantidades vendidas por cada producto y cada mes
    FOR id_producto, mes, cantidad IN
        SELECT p.id AS id_producto, 
               TO_CHAR(f.fecha, 'YYYY-MM') AS mes,
               SUM(fd.cantidad) AS cantidad
			        FROM venta.factura f
			        JOIN venta.factura_detalle fd ON f.id = fd.id_factura
			        JOIN producto.producto p ON fd.id_producto = p.id
			        WHERE f.fecha BETWEEN fecha_inicio AND fecha_fin
			        GROUP BY p.id, TO_CHAR(f.fecha, 'YYYY-MM')
			        ORDER BY p.id, TO_CHAR(f.fecha, 'YYYY-MM')
    LOOP

        -- Construir y ejecutar la instrucción SQL dinámica para actualizar la columna del mes específico
         sql_update := FORMAT(
            'UPDATE venta.reporte_ventas_por_producto_mes SET "%s" = %L WHERE 
				id_producto = %L;',
            mes, cantidad, id_producto
        );
        EXECUTE sql_update;
    END LOOP;
 END $$;	-- end FUNCTION
 --------------
         
   -- USO:
    
SELECT venta.generar_reporte_ventas_por_producto_mes('2022-09-01', '2023-03-01');

-- Consulta los resultados con JOIN para obtener la descripcion del producto
 SELECT p.descripcion, r.*
	 FROM venta.reporte_ventas_por_producto_mes r
	 JOIN producto.producto p ON r.id_producto = p.id;
 
 /*
 Paso a paso:
 
 La función generar_reporte_ventas_por_producto_mes se encarga de generar un reporte de ventas
 por producto, desglosado por mes, en un rango de fechas especificado por el usuario.
 1. Tabla de reporte permanente: la función utiliza una tabla de reporte permanente llamada
 reporte_ventas_por_producto_mes, donde almacena los resultados. Esta tabla se limpia al
 inicio de cada ejecución.
 2. Inserción de productos: se insertan en la tabla de reporte cada producto que tiene ventas
 dentro del rango de fechas (fecha_inicio y fecha_fin), garantizando que solo los productos
 relevantes sean incluidos en el reporte.
 3. Generación de columnas dinámicas para meses: para cada mes dentro del rango, la
 función agrega una columna dinámica en la tabla de reporte, nombrada en formato YYYY
MM (por ejemplo, 2022-09, 2022-10, etc.). Esto permite que cada mes tenga su propia
 columna en el reporte.
 4. Actualización de cantidades vendidas: se calcula la cantidad total vendida de cada
 producto en cada mes y se actualizan las columnas correspondientes en la tabla de reporte
 con estos valores
  */
 
 /*
 Resumen:
 El enfoque presentado para ambos motores de bases de datos, permite una estructura de reporte
 flexible y dinámica, ideal para reportes que incluyen columnas de salida variables (en este caso,
 meses según el rango de fechas especificado).
  */
 
 
 
------------------------------------------------------------------------------------------------------------

----------------- Importación de datos desde archivos -------------------
-------------------------------------------------------------------------
 
 /*
 A veces se necesita cierta “flexibilidad” para importar datos a la base de datos, y para eso es de 
utilidad utilizar SQL dinámico. 

A continuación un ejemplo de función en PostgreSQL para importar marcas. La ubicación del 
archivo es variable; el separador también es un argumento de la función. 
  */
 
CREATE OR REPLACE FUNCTION importar_marcas_desde_csv(
 	ruta_archivo TEXT,
    separador CHAR DEFAULT ','
 )
 RETURNS TABLE (total_registros INT, marcas_nuevas INT)
 AS
 $$
 DECLARE
    registro RECORD;
    marcas_insertadas INT := 0;
    sql_copy TEXT;
    max_codigo INT;
 BEGIN
    -- Crear una tabla temporal con varias columnas de tipo TEXT
    CREATE TEMP TABLE temp_marcas_csv (
		col1 TEXT, col2 TEXT, col3 TEXT, col4 TEXT);
    
 -- Construir y ejecutar la sentencia COPY para cargar los datos en la tabla temporal
    sql_copy := FORMAT(
        'COPY temp_marcas_csv FROM %L WITH (FORMAT csv, DELIMITER %L, HEADER)',
        	ruta_archivo, separador
    );
    EXECUTE sql_copy;
 
    -- Crear otra tabla temporal con solo la columna 'marca' que necesitamos
    CREATE TEMP TABLE temp_marcas AS
    SELECT col4 AS marca FROM temp_marcas_csv;
    
    -- Obtener el valor máximo actual de 'codigo' en la tabla de marcas
    SELECT COALESCE(MAX(codigo), 0) INTO max_codigo FROM producto.marca;
    
    -- Recorrer cada registro e insertar en la tabla de marcas si no existe
    FOR registro IN SELECT DISTINCT marca FROM temp_marcas LOOP
	    
        -- Verificar si la marca ya existe
        IF registro.marca IS NOT NULL AND NOT EXISTS (
            SELECT 1 FROM producto.marca WHERE descripcion = registro.marca
        ) THEN
            -- Insertar la nueva marca con un código correlativo y un id usando la secuencia
            INSERT INTO producto.marca (id, version, codigo, descripcion)
	            VALUES (nextval('producto.producto_sequence'),1,
	                max_codigo + 1,registro.marca);
            marcas_insertadas := marcas_insertadas + 1;
            max_codigo := max_codigo + 1; 
        END IF;
    END LOOP;
    -- Conteo de registros procesados y marcas nuevas insertadas
    RETURN QUERY SELECT 
        CAST((SELECT COUNT(*) FROM temp_marcas) AS INT) AS total_registros,
        CAST(marcas_insertadas AS INT) AS marcas_nuevas;
    -- Limpiar tablas temporales
    DROP TABLE IF EXISTS temp_marcas_csv;
    DROP TABLE IF EXISTS temp_marcas;
 END;
 $$ LANGUAGE plpgsql;
 			-------------------------------------------

   -- USO:
    
SELECT importar_marcas_desde_csv('c:/SDASDSAD', '2023-03-01');
    
 /*
Paso a paso:

 • Se crea una tabla temporal (temp_marcas_csv) con cuatro columnas de tipo TEXT para cargar todas las 
columnas del archivo CSV, sin importar cuáles sean.
 • Carga de Datos con SQL Dinámico: Se arma un COPY dinámico usando el separador de columnas 
especificado y carga los datos del archivo CSV en temp_marcas_csv.
 • Filtrado de la Columna marca: se crea una segunda tabla temporal, temp_marcas, que solo selecciona la cuarta 
columna (col4), que se asume es la columna marca.
 • Cálculo de código máximo sctual: se calcula  el valor máximo actual de codigo en la tabla producto.marca para
 generar códigos correlativos para las nuevas marcas.
 • Para cada marca en temp_marcas, se verifica si ya existe en producto.marca. Si no existe:
 • Se inserta con un id generado por la secuencia producto.producto_sequence.
 • Se le asigna un codigo correlativo y se incrementa el contador marcas_insertadas.
 • Retorno de Resultados: se devuelve el número total de registros procesados y las nuevas marcas insertadas.
  */
 
 /*
 En resumen, una función de importación de datos que usa SQL dinámico es más adaptable, fácil de
 mantener y versátil frente a archivos con diferentes formatos, delimitadores y estructuras de datos. 
Esto permite procesar datos de manera eficiente y confiable en entornos donde los formatos de los 
archivos de entrada pueden variar considerablemente
  */
 
 
 
 
------------------------------------------------------------------------------------------------------------


------------- Tareas de administración de bases de datos ----------------
-------------------------------------------------------------------------

/*
A continuación se presenta un ejemplo de función codificada en PostgreSQL para contar la cantidad
 de filas que tienen todas las tablas de una base de datos.
 
 Es una función relativamente simple, cuya finalidad es ofrecer una vista rápida y detallada del
 estado y tamaño de las tablas en la base de datos, lo cual es importante para la gestión, optimización
 y monitoreo de los datos. 
 */

CREATE OR REPLACE FUNCTION contar_filas_tablas()
 RETURNS TABLE (esquema_nombre TEXT, tabla_nombre TEXT, filas BIGINT)
 AS $$
 DECLARE
    registro RECORD;
    sql_query TEXT;
 BEGIN
    -- Recorrer todas las tablas de todos los esquemas de usuario en la base de datos
    FOR registro IN
        SELECT n.nspname AS esquema_nombre, c.relname AS tabla_nombre
	        FROM pg_class c
	        JOIN pg_namespace n ON c.relnamespace = n.oid
	        WHERE c.relkind = 'r'         -- Solo tablas (relkind = 'r')
	          AND n.nspname NOT IN ('pg_catalog', 'information_schema') -- Excluir esquemas del sistema
    LOOP
		
        -- Construir una consulta dinámica para contar filas en cada tabla de cada esquema
        sql_query := FORMAT('SELECT %L AS esquema_nombre, %L AS tabla_nombre, 
			COUNT(*) AS filas FROM %I.%I', 
                            registro.esquema_nombre, registro.tabla_nombre, 
                            registro.esquema_nombre, registro.tabla_nombre);
        
        -- Ejecutar la consulta y devolver el nombre del esquema, nombre de la tabla y el conteo de filas
        RETURN QUERY EXECUTE sql_query;
    END LOOP;
 END;
 $$ LANGUAGE plpgsql;


 -- USO:

 SELECT * FROM contar_filas_tablas() order by 1,2;


/*
Paso a paso:
 • La función contar_filas_tablas se declara con un retorno de tipo TABLE, con tres columnas: 
esquema_nombre, tabla_nombre  y filas. 
• La función recorre todas las tablas en la base de datos utilizando un bucle FOR.
 • La consulta inicial selecciona el nombre de cada esquema (n.nspname como 
esquema_nombre) y el nombre de cada tabla (c.relname como tabla_nombre).
 • Solo se incluyen las tablas de usuario (c.relkind = 'r') y se excluyen las tablas en los 
esquemas del sistema (pg_catalog y information_schema).
• Para cada tabla encontrada, se construye una consulta dinámica (sql_query) que cuenta las 
filas de esa tabla específica.
 • La consulta se genera con FORMAT, que usa %L para insertar literales de texto 
(esquema_nombre y tabla_nombre) y %I para tratar esquema_nombre y tabla_nombre como
 identificadores seguros en la consulta COUNT(*).
 • La función ejecuta la consulta dinámica para cada tabla utilizando RETURN QUERY 
EXECUTE.
 • Cada ejecución de RETURN QUERY EXECUTE sql_query devuelve un resultado con el 
nombre del esquema, el nombre de la tabla, y el conteo de filas para esa tabla en particular.
 • Una vez procesadas todas las tablas, la función termina, habiendo devuelto los nombres de 
esquema, nombres de tablas y conteo de filas para cada tabla en los esquemas de usuario de 
la base de datos.
 */














    
/*
 ============================================
 SELECT
 SQL: Guía de Trabajo Nro. 1 
Consultas básicas 
 ============================================
 */

------------------------------------------------------------------------


 ------------------------------------------------------------------------- 
 ---------------------- E j e r c i c i o   1 ---------------------------- 
 ------------------------------------------------------------------------.

-----------------------------------------------------------------
