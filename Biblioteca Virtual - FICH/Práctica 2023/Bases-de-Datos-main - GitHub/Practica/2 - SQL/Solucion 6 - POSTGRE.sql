----------------------------------------
--EJ 1--
----------------------------------------

CREATE OR REPLACE FUNCTION obtenerPrecio
	(
	IN prmTitle_id VARCHAR(40)
	)
	RETURNS FLOAT
	
	AS
	$$
	DECLARE
		precio FLOAT;
	BEGIN
		precio := (SELECT price
			FROM titles
			WHERE title_id = prmTitle_id);
		RETURN precio;
	END
	$$
	LANGUAGE plpgsql

SELECT obtenerPrecio (prmTitle_id := 'PS1372');

----------------------------------------
--EJ 2--
----------------------------------------

CREATE OR REPLACE FUNCTION obtenerFechaVenta
	(
	IN prmStor_id CHAR(4),
	IN prmOrd_num VARCHAR(20)
	)
	RETURNS date
	AS
	$$
	DECLARE
		fechaVenta date;
	BEGIN
		fechaVenta := (SELECT DISTINCT ord_date
					  	FROM sales
					  	WHERE stor_id = prmStor_id AND
					  		ord_num = prmOrd_num);
		RETURN fechaVenta;
	END
	$$
	LANGUAGE plpgsql

SELECT obtenerFechaVenta (	prmStor_id := '7067',
						 	prmOrd_num := 'P2121');


----------------------------------------
--EJ 3--
----------------------------------------

INSERT INTO productos (codProd, descr, precUnit, stock)
	VALUES (10, 'Articulo 1', 50, 20);
INSERT INTO productos (codProd, descr, precUnit, stock)
	VALUES (20, 'Articulo 2', 70, 40);

CREATE OR REPLACE FUNCTION buscarPrecio
	(
	IN prmCodProd INTEGER,
	OUT precio FLOAT
	)
	RETURNS FLOAT
	AS
	$$
	DECLARE
	BEGIN
		SELECT precUnit
			INTO precio
			FROM productos
			WHERE codProd = prmCodProd;
	END
	$$
	LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION insertarDetalle
	(
	IN prmCodDetalle	INTEGER,
	IN prmNumPed		INTEGER,
	IN prmCodProd		INTEGER,
	IN prmCant			INTEGER
	)
	RETURNS void
	AS
	$$
	DECLARE
		precio FLOAT;
	BEGIN
		precio = buscarPrecio(prmCodProd);
		INSERT INTO detalle
			(CodDetalle, numPed, codProd, cant, precioTot)
			VALUES (prmCodDetalle, prmNumPed, prmCodProd, prmCant, prmCant * precio);
		RETURN;
	END
	$$
	LANGUAGE plpgsql;

SELECT insertarDetalle (
	prmCodDetalle := 0,
	prmNumPed := 1,
	prmCodProd := 10,
	prmCant := 5);

SELECT insertarDetalle (
	prmCodDetalle := 1,
	prmNumPed := 2,
	prmCodProd := 20,
	prmCant := 7);

----------------------------------------
--EJ 4--
----------------------------------------

CREATE OR REPLACE FUNCTION insertarDetalle
	(
	IN prmCodDetalle	INTEGER,
	IN prmNumPed		INTEGER,
	IN prmCodProd		INTEGER,
	IN prmCant			INTEGER
	)
	RETURNS void
	AS
	$$
	DECLARE
		precio FLOAT;
	BEGIN
		IF EXISTS (SELECT *
				  	FROM productos
				  	WHERE codProd = prmCodProd)
		THEN
			RAISE NOTICE 'El producto no existe';
			RETURN;
		END IF;
		IF (SELECT precUnit
					FROM productos
					WHERE codProd = prmCodProd) IS NULL
		THEN
			RAISE NOTICE 'El producto no tiene precio';
			RETURN;
		END IF;
			
		precio = buscarPrecio(prmCodProd);
		INSERT INTO detalle
			(CodDetalle, numPed, codProd, cant, precioTot)
			VALUES (prmCodDetalle, prmNumPed, prmCodProd, prmCant, prmCant * precio);
		RETURN;
	END
	$$
	LANGUAGE plpgsql;

----------------------------------------
--EJ 5--
----------------------------------------