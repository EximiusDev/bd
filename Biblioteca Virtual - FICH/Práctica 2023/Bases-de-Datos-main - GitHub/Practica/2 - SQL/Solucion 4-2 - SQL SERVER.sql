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
INSERT INTO proveed VALUES ('FLUKE INGENIERIA', 'RUTA 9 Km. 80');
INSERT INTO proveed VALUES ('PVD PATCHES', 'Pinar de Rocha 1154');

--------
--EJ 5--
--------
CREATE TABLE ventas (
	codVent		int			IDENTITY(1,1),
	fechaVent	datetime	NOT NULL DEFAULT CURRENT_TIMESTAMP,
	usuarioDB	varchar(30)	NOT NULL DEFAULT USER,
	monto		float		NULL
);

--------
--EJ 6--
--------
SELECT * INTO clistafe FROM cliente WHERE codPost = 3000;

--------
--EJ 7--
--------
INSERT clistafe
	SELECT *
	FROM cliente;

--------
--EJ 8--
--------
UPDATE cliente SET dir = 'TCM 168' WHERE dir LIKE '%1%';

--------
--EJ 9--
--------
DELETE clistafe WHERE codPost IS NULL;