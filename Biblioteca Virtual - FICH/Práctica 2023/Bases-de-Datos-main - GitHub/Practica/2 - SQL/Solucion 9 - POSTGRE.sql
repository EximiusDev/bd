----------------------------------
--EJ 5--
----------------------------------

CREATE OR REPLACE FUNCTION test5()
	RETURNS trigger
	AS
	$$
	DECLARE
		revenue	FLOAT;
	BEGIN
		revenue := (SELECT SUM(price*qty)
		  	FROM sales S INNER JOIN titles T
				 		ON S.title_id = T.title_id
		  	WHERE T.pub_id = NEW.pub_id);
		IF revenue <= 1500
			THEN
				RAISE NOTICE 'INVALID: La editorial tiene un revenue total de %', revenue;
				RETURN NULL;
			ELSE
				RETURN NEW;
			END IF;
	END
	$$
	LANGUAGE plpgsql;

CREATE TRIGGER tr_ejercicio5
	BEFORE INSERT
	ON titles
	FOR EACH ROW
		EXECUTE PROCEDURE test5();


INSERT INTO titles
	SELECT 'PC4545', 'Prueba 1', 'trad_cook', '1389',
		14.99, 8000.0, 10, 4095, 'Prueba 1', CURRENT_TIMESTAMP;
INSERT INTO titles
	SELECT 'PC4646', 'Prueba 2', 'trad_cook', '0736',
		14.99, 8000.00, 10, 4095, 'Prueba 1', CURRENT_TIMESTAMP;


----------------------------------
--EJ 6--
----------------------------------


ALTER TABLE publishers
	ADD COLUMN FechaHoraAlta	DATE			NULL;
	
ALTER TABLE publishers
	ADD COLUMN UsuarioAlta		VARCHAR(255)	NULL;

CREATE OR REPLACE FUNCTION test6()
	RETURNS trigger
	AS
	$$
		DECLARE
		BEGIN
			NEW.FechaHoraAlta := CURRENT_TIMESTAMP;
			NEW.UsuarioAlta := SESSION_USER;
			RETURN NEW;
		END
	$$
	LANGUAGE plpgsql;

CREATE TRIGGER tr_ejercicio6
	BEFORE INSERT
	ON publishers
	FOR EACH ROW
		EXECUTE PROCEDURE test6();


INSERT INTO publishers
	values('8888', 'Editorial Ejercicio 8', 'Boston', 'MA', 'USA');


----------------------------------
--EJ 7--
----------------------------------

--Usaria T-SQL ya que es un Log y ademas no hay forma comoda
--de saber la cantidad de tuplas afectadas


----------------------------------
--EJ 8--
----------------------------------

--Ahora si podemos usar plpgsql tanto para opcion A y B porque
--es para CADA FILA insertada

--Opcion A: exactamente igual que en el Ejercicio 6

--Opcion B:
CREATE TABLE Registro
	(
	fecha				Date			NULL,
	tabla				varchar(100)	NULL,
	operacion			varchar(30)		NULL,
	usuario				varchar(30)		NULL
	);


CREATE OR REPLACE FUNCTION test8B()
	RETURNS trigger
	AS
	$$
	DECLARE
	BEGIN
		INSERT INTO Registro
			values(CURRENT_TIMESTAMP, 'publishers', 'INSERT', SESSION_USER);
		RETURN NULL;
	END
	$$
	LANGUAGE plpgsql;

CREATE TRIGGER tr_ejercicio8B
	AFTER INSERT
	ON publishers
	FOR EACH ROW
		EXECUTE PROCEDURE test8B();


INSERT INTO publishers
	values('8883', 'Editorial Ejercicio 8B parte 2', 'Boston', 'MA', 'USA');