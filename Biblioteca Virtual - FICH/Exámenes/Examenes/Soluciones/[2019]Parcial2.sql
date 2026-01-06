create schema parcial2_2019;

create table proveedor(
	idproveedor	integer		not null,
	descrip		varchar(200),
	constraint pk_idproveedor primary key (idproveedor)
);

create table componente(
	idcomponente	integer	not null,
	descrip			varchar(100),
	constraint pk_idcomponente primary key (idcomponente)
);

create table provcomp(
	idproveedor		integer	not null,
	idcomponente	integer	not null,
	foreign key (idproveedor) references proveedor (idproveedor),
	foreign key (idcomponente) references componente (idcomponente)
);
