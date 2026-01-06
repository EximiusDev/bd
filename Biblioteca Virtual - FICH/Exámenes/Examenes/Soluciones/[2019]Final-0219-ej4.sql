/*
create schema final20240219;
create table zona(
	idzona	integer		not null,
	zona	varchar(40)	not null,
	constraint pk_idzona primary key (idzona)
);

create table vendedor(
	idvendedor	integer		not null,
	apenom		varchar(50)	not null,
	constraint pk_idvendedor primary key (idvendedor)
);

create table factura(
	idfactura	integer		not null,
	idzona		integer		not null,
	idvendedor	integer		not null,
	monto		float		not null,
	constraint pk_idfactura primary key (idfactura),
	foreign key (idzona) references zona (idzona),
	foreign key (idvendedor) references vendedor (idvendedor)
);
*/

select
	promedios.idzona,
	f.idfactura,
	f.monto,
	v.apenom,
	case when f.monto > promedios.promedio
		then 'Supera'
		else 'No supera'
	end
from (
	select
		f1.idzona,
		avg(f1.monto) promedio
	from
		factura f1
	group by f1.idzona
	) promedios					-- promedios por zona
join factura f
	on f.idzona = promedios.idzona
join vendedor v
	on v.idvendedor = f.idvendedor
where f.idfactura in
	(select
		idfactura
	from
		factura f2
	where f2.idzona = promedios.idzona
	order by f2.monto
	limit 3)
order by promedios.idzona asc, f.monto desc;
















