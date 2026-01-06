create or replace function tr_ins_sensor()
returns trigger
as
$$
declare
begin 
	if new.estadoEmocional = (
		select estadoEmocional
		from LecturaSensor
		order by momento desc
		limit 1)
		then return null;
		else return new;
	end if;
end
$$
language plpgsql;

create trigger trTitles
	after insert
	on LecturaSensor
	for each row
		execute procedure tr_ins_sensor();