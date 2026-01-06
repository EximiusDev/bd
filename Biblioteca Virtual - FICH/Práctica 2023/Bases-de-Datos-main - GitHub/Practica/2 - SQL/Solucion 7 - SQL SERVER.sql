---------------------------------------
--EJ 1--
---------------------------------------

CREATE PROC actualizarPrecioEditorial
	(
	@prmPub_id CHAR(4)
	)
	AS
		DECLARE curPrices CURSOR				-- declarar cursor
			FOR
				SELECT price
					FROM titles
					WHERE pub_id = @prmPub_id
					FOR UPDATE;
		DECLARE @price MONEY;					-- declarar variable de recuperacion

		OPEN curPrices							-- abrir cursor

		FETCH NEXT								-- recuperar primer elemento
			FROM curPrices
			INTO @price

		WHILE @@fetch_status = 0				-- recorrer consulta
			BEGIN								-- operar con el cursor
				IF @price IS NOT NULL
				BEGIN
					IF @price > 10
					BEGIN
						UPDATE titles
							SET price = price*0.75
							WHERE CURRENT OF curPrices;
					END
					ELSE
					BEGIN
						UPDATE titles
							SET price = price*1.25
							WHERE CURRENT OF curPrices;
					END
				END
				
				FETCH NEXT						-- recuperar siguiente valor
					FROM curPrices
					INTO @price
			END

			CLOSE curPrices;					-- cerrar cursor
			DEALLOCATE curPrices;				-- eliminar cursor
		RETURN;

EXECUTE actualizarPrecioEditorial '0736';

---------------------------------------
--EJ 2--
---------------------------------------

-- Solo se puede hacer en POSTGRESQL
-- Necesitamos cursores implicitos, cosa que SQL SERVER no tiene

---------------------------------------
--EJ 3--
---------------------------------------

CREATE PROC obtenerMasCaras
	AS
		DECLARE curTypes CURSOR
			FOR
				SELECT DISTINCT type
					FROM titles;
		DECLARE @type	CHAR(12);

		OPEN curTypes;
		FETCH NEXT
			FROM curTypes
			INTO @type;

		WHILE @@fetch_status = 0
		BEGIN
			
			DECLARE curPrices CURSOR
				FOR
					SELECT TOP(3) title, price
						FROM titles
						WHERE type = @type
						ORDER BY price DESC;
			DECLARE @title	VARCHAR(80),
					@price	MONEY;

			OPEN curPrices;
			FETCH NEXT
				FROM curPrices
				INTO @title, @price;

			PRINT 'Publicaciones mas caras de tipo ' + @type;
			PRINT '-----------------------------------------';

			WHILE @@fetch_status = 0
			BEGIN
				PRINT @title + '								' + CAST(@price AS VARCHAR(10));

				FETCH NEXT
					FROM curPrices
					INTO @title, @price;
			END
			
			PRINT '\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\';

			CLOSE curPrices;
			DEALLOCATE curPrices;

			FETCH NEXT
				FROM curTypes
				INTO @type;
		END

		CLOSE curTypes;
		DEALLOCATE curTypes;
		RETURN;

---------------------------------------
--EJ 4--
---------------------------------------

-- Sin cursores
SELECT au_fname, au_lname
	FROM authors A INNER JOIN titleauthor TA
						ON A.au_id = TA.au_id
					INNER JOIN titles T
						ON TA.title_id = T.title_id
					INNER JOIN publishers P
						ON P.pub_id = T.pub_id AND
							P.city = A.city;

-- Con cursores
DECLARE curAuthors CURSOR
	FOR
		SELECT A.au_id, P.pub_id
			FROM authors A	INNER JOIN titleauthor TA
								ON A.au_id = TA.au_id
							INNER JOIN titles T
								ON TA.title_id = T.title_id
							INNER JOIN publishers P
								ON T.pub_id = P.pub_id;
DECLARE @au_id	VARCHAR(11),
		@pub_id	CHAR(4);

OPEN curAuthors;
FETCH NEXT
	FROM curAuthors
	INTO @au_id, @pub_id;

WHILE @@fetch_status = 0
BEGIN
	IF @au_id IS NOT NULL AND @pub_id IS NOT NULL
	BEGIN
		DECLARE @ACity	VARCHAR(60),
				@PCity	VARCHAR(60),
				@au_lname	VARCHAR(50),
				@au_fname	VARCHAR(50);

		SELECT @ACity = city, @au_lname = au_lname, @au_fname = au_fname
			FROM authors
			WHERE au_id = @au_id;
		SELECT @PCity = city
			FROM publishers
			WHERE pub_id = @pub_id;
		IF	@ACity = @PCity
		BEGIN
			SELECT @au_lname = au_lname, @au_fname = au_fname
				FROM authors
				WHERE au_id = @au_id;
			PRINT 'el autor ' + @au_lname + ' ' + @au_fname + ' reside en la misma ciudad que su editorial.';
		END
	END

	FETCH NEXT
		FROM curAuthors
		INTO @au_id, @pub_id;
END

CLOSE curAuthors;
DEALLOCATE curAuthors;

---------------------------------------
--EJ 5--
---------------------------------------

-- Sin cursores/loops

UPDATE employee
	SET pub_id = (SELECT TOP 1 T.pub_id
						FROM titles T
							INNER JOIN (SELECT title_id, SUM(qty) total_ventas
											FROM sales
											GROUP BY title_id) S
								ON T.title_id = S.title_id
						GROUP BY T.pub_id
						ORDER BY SUM(price*total_ventas) DESC)
	WHERE emp_id = (SELECT TOP 1 emp_id
						FROM employee E
							INNER JOIN (SELECT TOP 2 T.pub_id, SUM(price*total_ventas) facturado
											FROM titles T
												INNER JOIN (SELECT title_id, SUM(qty) total_ventas
																FROM sales
																GROUP BY title_id) S
													ON T.title_id = S.title_id
											GROUP BY T.pub_id
											ORDER BY facturado) P
								ON E.pub_id = P.pub_id
						WHERE E.job_id = 5
						ORDER BY hire_date);

-- Con cursores/loops

-- encontrar el empleado mas viejo de las dos empresas que menos facturan

-- 1) encontrar el editor mas viejo de las empresas que menos facturan

--		cursor para recorrer los editores
DECLARE curEmployee CURSOR
	FOR
		SELECT emp_id, pub_id
			FROM employee
			WHERE job_id = 5;

DECLARE @emp_id			CHAR(9),	-- donde recuperar el valor del cursor
		@pub_id			CHAR(4),
		@olderEmp_id	CHAR(9),	-- donde guardar el empleado mas viejo
		@minHire_date	datetime;
SET @minHire_date = '3000-01-01';

OPEN curEmployee;
FETCH NEXT
	FROM curEmployee
	INTO @emp_id, @pub_id;

WHILE @@fetch_status = 0
BEGIN
	--		si es empleado de las editoriales que menos facturan
	IF @pub_id
		IN (SELECT TOP 2 T.pub_id
				FROM titles T
					INNER JOIN (SELECT title_id, SUM(qty) total_ventas
									FROM sales
									GROUP BY title_id) S
						ON T.title_id = S.title_id
				GROUP BY T.pub_id
				ORDER BY SUM(price*total_ventas))
	BEGIN
		DECLARE @hire_date datetime;
		SELECT @hire_date = hire_date
			FROM employee
			WHERE emp_id = @emp_id;
		-- PXH22250M de editorial 0877 contratado el 1993-08-19 00:00:00.000
		PRINT @emp_id + ' de editorial ' + @pub_id + ' contratado el ' + CAST(@hire_date AS VARCHAR(40));

		IF @hire_date < @minHire_date
		BEGIN
			SET @minHire_date = @hire_date;
			SET @olderEmp_id = @emp_id;
		END
	END

	FETCH NEXT
		FROM curEmployee
		INTO @emp_id, @pub_id;
END

CLOSE curEmployee;
DEALLOCATE curEmployee;

-- b) movemos el empleado encontrado a la empresa que MAS factura
UPDATE employee
	SET pub_id = (SELECT TOP 1 T.pub_id
						FROM titles T
							INNER JOIN (SELECT title_id, SUM(qty) total_ventas
											FROM sales
											GROUP BY title_id) S
								ON T.title_id = S.title_id
						GROUP BY T.pub_id
						ORDER BY SUM(price*total_ventas) DESC)
	WHERE emp_id = @olderEmp_id;