------------------------------------
--EJ 1--
------------------------------------

SELECT *
	INTO authors_copy
	FROM authors;

CREATE OR ALTER TRIGGER trDeleteAuthor_copy
	ON authors_copy
	FOR DELETE
	AS
	DECLARE
		@countFilas INTEGER;
	BEGIN
		SET @countFilas = (SELECT COUNT(au_id)
								FROM deleted);
		PRINT 'Se eliminaron ' + CONVERT(VARCHAR, @countFilas) + ' filas';
		RETURN
	END



DELETE
	FROM authors_copy
	WHERE	au_id = '172-32-1176' or
			au_id = '213-46-8915';


------------------------------------
--EJ 2--
------------------------------------


CREATE OR ALTER TRIGGER tr_ejercicio2
	ON authors
	AFTER UPDATE, INSERT
	AS
		DECLARE	@contFilas INTEGER;
		SET @contFilas = (SELECT COUNT(*) FROM inserted);
		IF @contFilas > 0
		BEGIN
			PRINT 'Datos insertados en transaction log: '
			SELECT * FROM inserted;
		END
		SET @contFilas = (SELECT COUNT(*) FROM deleted);
		IF @contFilas > 0
		BEGIN
			PRINT 'Datos insertados en transaction log: ';
			SELECT * FROM deleted;
		END
	RETURN



INSERT INTO authors
	SELECT '111-11-1111', 'Lynne', 'Jeff', '415 658-9932',
			'Galvez y Ochoa', 'Berkeley', 'CA', '94705', 1;

UPDATE authors
	SET au_fname = 'Nicanor' WHERE au_id = '111-11-1111';


------------------------------------
--EJ 3--
------------------------------------

-- aca usa la otra database

CREATE OR ALTER TRIGGER tr_ejercicio3
	ON productos
	AFTER INSERT
	AS
		IF (SELECT TOP 1 stock FROM inserted ORDER BY stock) < 0
			BEGIN
				RAISERROR('El stock debe ser positivo o cero', 12, 1);
				ROLLBACK TRANSACTION;
			END
		RETURN



INSERT INTO productos
	VALUES (10, 'Producto 10', 200, -6);

------------------------------------
--EJ 4--
------------------------------------

CREATE OR ALTER TRIGGER tr_ejercicio4
	ON titles
	AFTER INSERT
	AS
		IF (SELECT SUM(ST.totalLibro)
				FROM (SELECT T.pub_id, T.title_id, T.price*S.qty totalLibro
							FROM sales S INNER JOIN titles T
								ON S.title_id = T.title_id) ST
							INNER JOIN publishers P
								ON ST.pub_id = P.pub_id
				GROUP BY P.pub_id) < 1500
			BEGIN
				RAISERROR('La editarial que ha querido insertar no ha vendido mas de 1500',12,1);
			END
		RETURN


INSERT INTO titles
	SELECT 'PC4545', 'Prueba 1', 'trad_cool', '1389',
			14.99, 8000, 10, 4095, 'Prueba 1', CURRENT_TIMESTAMP;



------------------------------------
--EJ 7--
------------------------------------

CREATE TABLE Registro
	(
	fecha				DATE	NULL,
	tabla				varchar(100)	NULL,
	operacion			varchar(30)	NULL,
	CantFilasAfectadas	INTEGER	NULL
	);

SELECT *
	INTO employee_copy
	FROM employee;

CREATE TRIGGER tr_Ejercicio7
	ON employee_copy
	AFTER DELETE
	AS
	DECLARE @cantFilas	INTEGER;
	SET @cantFilas = (SELECT COUNT(*)
						FROM deleted);
	IF @cantFilas > 1
	BEGIN
		INSERT INTO Registro
			values (CURRENT_TIMESTAMP, 'employee', 'DELETE', @CantFilas);
	END


SELECT * FROM employee WHERE job_id = 8

DELETE
	FROM employee_copy
	WHERE job_id = 8;

SELECT * FROM Registro;

------------------------------------
--EJ 8--
------------------------------------

