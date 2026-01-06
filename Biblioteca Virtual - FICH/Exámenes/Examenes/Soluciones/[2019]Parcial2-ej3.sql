create table informeventas (
	ord_num			varchar(20) not null,
	stor_id			char(4)		not null,
	publicacion1	varchar(6)	not null,
	Observaciones	varchar(60),
);

create or replace function tr_ins_sales()
returns trigger
as
$$
declare
begin
	insert into informeventas
	values (new.ord_num, new.stor_id, new.title_id);
end
$$
language plpgsql;

create trigger trSales
	insert on sales
	for each row
		execute procedure tr_ins_sales();
