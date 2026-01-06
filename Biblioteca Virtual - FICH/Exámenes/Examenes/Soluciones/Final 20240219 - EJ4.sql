/*
CREATE TABLE Zona(
	IDZona		SMALLINT	NOT NULL,
	zona		VARCHAR(40)	NOT NULL,
	CONSTRAINT PK_zona PRIMARY KEY (IDZona)
);

CREATE TABLE Vendedor (
	IDVendedor	SMALLINT	NOT NULL,
	ApeNom		VARCHAR(50)	NOT NULL,
	CONSTRAINT PK_vendedor PRIMARY KEY (IDVendedor)
);

CREATE TABLE Factura (
	IDFactura	INTEGER		NOT NULL,
	IDZona		SMALLINT	NOT NULL,
	IDVendedor	SMALLINT	NOT NULL,
	monto		FLOAT		NOT NULL,
	CONSTRAINT PK_factura PRIMARY KEY (IDFactura)
);
*/
SELECT Z.IDZona, F.IDFactura, F.monto, V.ApeNom 'Vendedor',	CASE
																WHEN F.monto > (SELECT AVG(monto) FROM Factura
																					WHERE IDZona = F.IDZona)
																	THEN 'Supera la media de la zona'
																ELSE 'No supera la media de la zona'
															END 'Observacion'
	FROM Zona Z INNER JOIN Factura F
					ON Z.IDZona = F.IDZona
				INNER JOIN Vendedor V
					ON F.IDVendedor = V.IDVendedor
	WHERE F.IDFactura IN (SELECT TOP 3 IDFactura
							FROM Factura
							WHERE IDZona = F.IDZona
							ORDER BY monto DESC)
	ORDER BY Z.IDZona, F.monto DESC;