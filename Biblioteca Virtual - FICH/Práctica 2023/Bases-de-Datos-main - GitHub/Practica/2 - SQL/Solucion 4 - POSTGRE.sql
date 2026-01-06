CREATE TABLE cliente(
	codCli		int			NOT NULL,
	ape			varchar(30)	NOT NULL,
	nom			varchar(30)	NOT NULL,
	dir			varchar(40)	NOT NULL,
	codPost		char(9)		NULL DEFAULT 3000
);

CREATE TABLE productos(
	codProd		int			NOT NULL,
	descr		varchar(30)	NOT NULL,
	precUnit	float		NOT NULL,
	stock		smallint	NOT NULL
);

CREATE TABLE proveed (
	codProv		SERIAL,
	razonSoc	varchar(30)	NOT NULL,
	dir			varchar(30)	NOT NULL
);

CREATE TABLE pedidos (
	numPed		int			NOT NULL,
	fechPed		date		NOT NULL,
	codCli		int			NOT NULL
);

CREATE TABLE detalle (
	codDetalle	int			NOT NULL,
	numPed		int			NOT NULL,
	codProd		int			NOT NULL,
	cant		int			NOT NULL,
	precioTot	float		NULL
);