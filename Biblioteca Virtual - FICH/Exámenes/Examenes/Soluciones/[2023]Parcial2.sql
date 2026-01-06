/*
create schema parcial22023;

create table Triangulo (
	idTriangulo	integer	not null,
	descripcion	varchar(60),
	constraint pk_Triangulo primary key (idTriangulo)
);

create table Lado (
	idLado		integer	not null,
	idTriangulo	integer	not null,
	descripcion	varchar(60),
	longitudcm	integer,
	constraint pk_Lado primary key (idLado),
	foreign key (idTriangulo) references Triangulo (idTriangulo)
);

-- Triangulo valido
insert into triangulo
values (1, 'Triangulo 1');

insert into lado
values (1, 1, 'Lado AB', 5);

insert into lado
values (2, 1, 'Lado AC', 5);

insert into lado
values (3, 1, 'Lado BC', 9);

-- Triangulo no-valido

insert into triangulo
values (2, 'Triangulo 2');

insert into lado
values (4, 2, 'Lado AB', 3);

insert into lado
values (5, 2, 'Lado AC', 5);

insert into lado
values (6, 2, 'Lado BC', 9);

insert into triangulo
values (3, 'Triangulo 3');

insert into lado 
values (7, 3, 'Lado AB', 4);

insert into lado 
values (8, 3, 'Lado AC', 10);

insert into lado 
values (9, 3, 'Lado BC', 5);
*/

select
	l1.idtriangulo
from
	lado l1
	join lado l2 on l2.idtriangulo = l1.idTriangulo
		and l2.idlado != l1.idlado
group by l1.idlado
having
	sum(l2.longitudcm) < l1.longitudcm;














