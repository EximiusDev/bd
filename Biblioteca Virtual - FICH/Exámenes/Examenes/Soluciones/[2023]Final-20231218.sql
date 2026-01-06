/*
create schema final20231218

create table LecturaSensor(
	numeroSerie		integer not null,
	momento			timestamp,
	estadoEmocional	char,
	constraint pk_numeroSerie primary key (numeroSerie)
)

create table Visitas(
	fechaVisita		timestamp not null,
	observaciones	varchar
)
*/

create or replace function LeerDatos(
	in	archivoLecturas	varchar,
	in	observaciones	varchar
)
returns varchar
as
$$
declare
	copy_command	text;
	insertadas		integer;
begin
	-- insertar visita
	insert into Visitas
	values (current_date, observaciones);

	-- construir query dinamico
	copy_command := format('\\COPY LecturaSensor FROM %L WITH (FORMAT csv, HEADER true)', archivoLecturas);
	
	-- ejecutar comando
	execute copy_command;

	get diagnostics insertadas = ROW_COUNT;

	return format('%s columnas insertadas',insertadas);
end;
$$
language plpgsql;




