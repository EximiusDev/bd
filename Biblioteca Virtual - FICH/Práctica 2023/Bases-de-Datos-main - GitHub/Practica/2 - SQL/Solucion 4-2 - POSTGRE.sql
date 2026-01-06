--------
--EJ 2--
--------
INSERT INTO cliente (codCli, ape, nom, dir) VALUES (1, 'LOPEZ', 'JOSE MARIA', 'Gral. Paz 3124');


--------
--EJ 3--
--------
INSERT INTO cliente
	VALUES (2, 'GERVASOLI', 'MAURU', 'San Luis 472', NULL);

--------
--EJ 4--
--------
INSERT INTO proveed (razonSoc, dir) VALUES ('FLUKE INGENIERIA', 'RUTA 9 Km. 80');
INSERT INTO proveed (razonSoc, dir) VALUES ('PVD PATCHES', 'Pinar de Rocha 1154');

--------
--EJ 5--
--------
CREATE TABLE ventas (
	codVent		SERIAL,
	fechaVent	timestamp	NOT NULL DEFAULT CURRENT_TIMESTAMP,
	usuarioDB	varchar(30)	NOT NULL DEFAULT USER,
	monto		float		NULL
);
INSERT INTO ventas (monto) VALUES (110);

--------
--EJ 6--
--------
SELECT * INTO clistafe FROM cliente WHERE CAST(codPost AS integer) = 3000;

--------
--EJ 7--
--------
INSERT INTO clistafe
	SELECT *
	FROM cliente;

--------
--EJ 8--
--------
UPDATE cliente SET dir = 'TCM 168' WHERE dir LIKE '%1%';

--------
--EJ 9--
--------
DELETE FROM clistafe WHERE codPost is NULL;