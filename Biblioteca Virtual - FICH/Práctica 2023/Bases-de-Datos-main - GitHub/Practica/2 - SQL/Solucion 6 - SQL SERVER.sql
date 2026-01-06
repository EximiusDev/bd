-----------------------------------
--EJ 1--
-----------------------------------

CREATE PROC obtenerPrecio
	(
	@prmTitle_id VARCHAR(40)
	)
	AS
		SELECT price
			FROM titles
			WHERE title_id = @prmTitle_id
		RETURN;

EXECUTE obtenerPrecio @prmTitle_id = 'PS1372';

-----------------------------------
--EJ 2
-----------------------------------

CREATE PROC obtenerFechaVenta
	(
	@prmStor_id VARCHAR(4),
	@prmOrd_num VARCHAR(20)
	)
	AS
		SELECT ord_date
			FROM sales
			WHERE stor_id = @prmStor_id
				AND ord_num = @prmOrd_num
		RETURN;

EXECUTE obtenerFechaVenta
	@prmStor_id = 7067,
	@prmOrd_num = P2121;

-----------------------------------
--EJ 3--
-----------------------------------

INSERT INTO productos
	(CodProd, descr, precUnit, stock)
	VALUES(10, 'Articulo 1', 50, 20);
INSERT INTO productos
	(CodProd, descr, precUnit, stock)
	VALUES(20, 'Articulo 2', 70, 40);

CREATE PROC insertarDetalle
	(
	@prmCodDetalle	INTEGER,
	@prmNumPed		INTEGER,
	@prmCodProd		INTEGER,
	@prmCant		INTEGER
	)
	AS
		DECLARE @precio	FLOAT
		EXECUTE buscarPrecio @prmCodProd, @precio OUTPUT;
		INSERT INTO pubs.dbo.detalle
			(CodDetalle, numPed, codProd, cant, precioTot)
			VALUES (@prmCodDetalle,@prmNumPed,@prmCodProd,@prmCant,@prmCant * @precio);
		RETURN;

CREATE PROC buscarPrecio
	(
	@prmCodProd	INTEGER,
	@prmPrecio	FLOAT	OUTPUT
	)
	AS
		SET @prmPrecio = (SELECT precUnit
							FROM pubs.dbo.productos
							WHERE codProd = @prmCodProd);
		RETURN;

EXECUTE pubs.dbo.insertarDetalle 1, 1, 10, 7;


-----------------------------------
--EJ 4--
-----------------------------------

CREATE PROC insertarDetalle
	(
	@prmCodDetalle	INTEGER,
	@prmNumPed		INTEGER,
	@prmCodProd		INTEGER,
	@prmCant		INTEGER
	)
	AS
		IF (SELECT COUNT(*)
				FROM productos
				WHERE codProd = @prmCodProd) = 0
			BEGIN
				PRINT 'El codigo de producto no existe';
				RETURN -50;
			END
		ELSE
			BEGIN
				IF (SELECT precUnit
						FROM productos
						WHERE codProd = @prmCodProd) IS NULL
				BEGIN
					PRINT 'El producto no tiene precio';
					RETURN -51;
				END
			END

		DECLARE @precio	FLOAT
		EXECUTE buscarPrecio @prmCodProd, @precio OUTPUT;

		INSERT INTO pubs.dbo.detalle
			(CodDetalle, numPed, codProd, cant, precioTot)
			VALUES (@prmCodDetalle,@prmNumPed,@prmCodProd,@prmCant,@prmCant * @precio);
		RETURN;

-----------------------------------
--EJ 5--
-----------------------------------