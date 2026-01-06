create or replace function tr_del_sales()
returns trigger
as
$$
declare
	table_name		varchar(15);
	copy_cmn		varchar(255);
begin
	-- nombre de la tabla de copia
	table_name := 'Sales' || year(current_date) || '_' || month(current_date) || '_' || day(current_date);
	-- sql dinamico para crear tabla y copiar original
	copy_cmn := 'select * into ' || table_name || ' from sales';
	-- copiar tabla original
	execute copy_cmn;

	return null;
end;
$$
language plpgsql;

create trigger trSales
	before
	delete on sales
	execute procedure tr_del_sales();