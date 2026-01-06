create database hospital;

create schema persona;
create schema estructura;
create schema gestion;


/*==============================================================*/
/* Nivel 1                                                      */
/*==============================================================*/

create table persona.provincia (
   id_provincia         smallint            not null,
   nom_provincia        varchar(30)          not null,
   constraint pk_provincia primary key (id_provincia)
);


create table gestion.cargo (
   id_cargo             smallint            not null,
   nom_cargo            varchar(30)         not null,
   constraint pk_cargo primary key (id_cargo)
);


create table gestion.especialidad (
   id_especialidad      smallint             not null,
   nom_especialidad     varchar(40)          not null,
   constraint pk_especialidad primary key (id_especialidad)
);


create table estructura.seccion (
   id_seccion           smallint             not null,
   nom_seccion          varchar(30)          not null,
   constraint pk_seccion primary key (id_seccion)
);


/*==============================================================*/
/* Nivel 2                                                      */
/*==============================================================*/

create table estructura.sector (
   id_seccion           smallint             not null,
   id_sector            smallint             not null,
   nom_sector           varchar(30)          not null,
   constraint pk_sector primary key (id_seccion, id_sector),
   constraint fk_sector_seccion foreign key (id_seccion) references estructura.seccion (id_seccion)
);


create table persona.localidad (
   id_provincia         smallint             not null,
   id_localidad         smallint             not null,
   nom_localidad        varchar(40)          not null,
   constraint pk_localidad primary key (id_provincia, id_localidad),
   constraint fk_localidad_provincia foreign key (id_provincia) references persona.provincia (id_provincia)
);


/*==============================================================*/
/* Nivel 3                                                      */
/*==============================================================*/

create table persona.persona (
   tipodoc              char                 not null,
   nrodoc               integer              not null,
   sexo                 char                 not null,
   apenom               varchar(40)          not null,
   domicilio            varchar(50)          null,
   fenaci               date                 null,
   id_provivive          smallint             not null,
   id_locavive           smallint             not null,
   id_provinace          smallint             null,
   id_locanace           smallint             null,
   tipodocpadre         char                 null,
   nrodocpadre          integer              null,
   sexopadre            char                 null,
   tipodocmadre         char                 null,
   nrodocmadre          integer              null,
   sexomadre            char                 null,
   constraint pk_persona
   primary key (tipodoc, nrodoc, sexo),
   constraint fk_persona_localidad_nace foreign key (id_provinace, id_locanace) references persona.localidad (id_provincia, id_localidad),
   constraint fk_persona_localidad_vive foreign key (id_provivive, id_locavive) references persona.localidad (id_provincia, id_localidad),
   constraint fk_persona_persona_padre foreign key (tipodocpadre, nrodocpadre, sexopadre) references persona.persona (tipodoc, nrodoc, sexo),
   constraint fk_persona_persona_madre foreign key (tipodocmadre, nrodocmadre, sexomadre) references persona.persona (tipodoc, nrodoc, sexo)
);


/*==============================================================*/
/* Nivel 4                                                      */
/*==============================================================*/

create table persona.empleado (
   id_empleado          integer              not null,
   tipodoc              char                 not null,
   nrodoc               integer              not null,
   sexo                 char                 not null,
   feingreso            date                 not null,
   constraint pk_empleado primary key (id_empleado),
   constraint fk_empleado_persona foreign key (tipodoc, nrodoc, sexo) references persona.persona (tipodoc, nrodoc, sexo),
   constraint unq_empleado unique (tipodoc, nrodoc, sexo)
);



create table persona.medico (
   matricula            smallint             not null,
   id_especialidad      smallint             not null,
   tipodoc              char                 not null,
   nrodoc               integer              not null,
   sexo                 char                 not null,
   constraint pk_medico primary key (matricula),
   constraint fk_medico_especialidad foreign key (id_especialidad) references gestion.especialidad (id_especialidad),
   constraint fk_medico_persona foreign key (tipodoc, nrodoc, sexo) references persona.persona (tipodoc, nrodoc, sexo),
   constraint unq_medico unique (tipodoc, nrodoc, sexo)
);

/*==============================================================*/
/* Nivel 5                                                      */
/*==============================================================*/

create table gestion.historial (
   id_empleado          integer              not null,
   fechainicio          date                 not null,
   id_cargo             smallint             not null,
   fechafin             date                 null,
   constraint pk_historial primary key (id_empleado, fechainicio),
   constraint fk_historial_empleado foreign key (id_empleado) references persona.empleado (id_empleado),
   constraint fk_historial_cargo foreign key (id_cargo) references gestion.cargo (id_cargo)
);


create table estructura.sala (
   id_seccion           smallint             not null,
   id_sector            smallint             not null,
   nro_sala             smallint             not null,
   id_especialidad      smallint             not null,
   id_empleado          integer              not null,
   nom_sala             varchar(30)          not null,
   capacidad            smallint             null,
   constraint pk_sala primary key (id_seccion, id_sector, nro_sala),
   constraint fk_sala_sector foreign key (id_seccion, id_sector) references estructura.sector (id_seccion, id_sector),
   constraint fk_sala_especialidad foreign key (id_especialidad) references gestion.especialidad (id_especialidad),
   constraint fk_sala_empleado foreign key (id_empleado) references persona.empleado (id_empleado)
);


/*==============================================================*/
/* Nivel 6                                                      */
/*==============================================================*/

create table gestion.asignacion (
   id_asignacion        integer              not null,
   matricula            smallint             not null,
   tipodoc              char                 not null,
   nrodoc               integer              not null,
   sexo                 char                 not null,
   id_empleado          integer              not null,
   id_seccion           smallint             not null,
   id_sector            smallint             not null,
   nro_sala             smallint             not null,
   feasigna             date                 not null,
   fesalida             date                 null,
   constraint pk_asignacion primary key (id_asignacion),
   constraint fk_asignacion_persona foreign key (tipodoc, nrodoc, sexo) references persona.persona(tipodoc, nrodoc, sexo),
   constraint fk_asignacion_medico foreign key (matricula) references persona.medico (matricula),
   constraint fk_asignacion_empleado foreign key (id_empleado) references persona.empleado (id_empleado),
   constraint fk_asignacion_sala foreign key (id_seccion, id_sector, nro_sala) references estructura.sala (id_seccion, id_sector, nro_sala)
);

create table gestion.trabaja_en (
   id_empleado          integer              not null,
   id_seccion           smallint             not null,
   id_sector            smallint             not null,
   nro_sala             smallint             not null,
   constraint pk_trabaja_en primary key (id_empleado, id_seccion, id_sector, nro_sala),
   constraint fk_trabaja_en_empleado foreign key (id_empleado) references persona.empleado (id_empleado),
   constraint fk_trabaja_en_sala foreign key (id_seccion, id_sector, nro_sala) references estructura.sala (id_seccion, id_sector, nro_sala)
);

/*==============================================================*/
/* Insersióm                                                    */
/*==============================================================*/

insert into persona.provincia values (1, 'SANTA FE');
insert into persona.provincia values (2, 'ENTRE RIOS');
insert into persona.provincia values (3, 'CORDOBA');
insert into persona.provincia values (4, 'BUENOS AIRES');
select * from persona.provincia;

insert into gestion.cargo values (1, 'ADMINISTRATIVO');
insert into gestion.cargo values (2, 'TELEFONISTA');
insert into gestion.cargo values (3, 'GERENTE');
insert into gestion.cargo values (4, 'ORDENANZA');
select * from gestion.cargo;

insert into gestion.especialidad values (1, 'PSIQUITRIA');
insert into gestion.especialidad values (2, 'TRAUMATOLOGIA');
insert into gestion.especialidad values (3, 'CARDIOLOGIA');
insert into gestion.especialidad values (4, 'PEDIATRIA');
select * from gestion.especialidad;

insert into estructura.seccion values (1, 'CONSULTORIOS ABIERTOS');
insert into estructura.seccion values (2, 'INTENACION');
select * from estructura.seccion;

insert into estructura.sector values ( 1, 1, 'NORTE');
insert into estructura.sector values ( 1, 2, 'SUR');
insert into estructura.sector values ( 2, 1, 'TERAPIA INTERMEDIA');
insert into estructura.sector values ( 2, 2, 'TERAPIA ABIERTA');
select * from estructura.sector;

insert into persona.localidad values ( 1, 1, 'SANTA FE');
insert into persona.localidad values ( 1, 2, 'SANTO TOME');
insert into persona.localidad values ( 2, 1, 'PARANA');
insert into persona.localidad values ( 2, 2, 'CONCORDIA');
select * from persona.localidad;

insert into persona.persona values ('D', 23456789,'M','RODRIGUEZ CACHITO','SAN MARTIN 1234','12-05-2001',1,1,NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL); 
insert into persona.persona values ('D', 34567890,'F','FERNANDEZ TOTA','SAN JERONIMO 3344','11-07-2004',1,2,NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL); 
insert into persona.persona values ('D', 45223456,'M','RODRIGUEZ CACHIRULO','SAN MARTIN 1234','12-05-2010',2,1,NULL, NULL, 'D', 23456789,'M', NULL, NULL, NULL); 
insert into persona.persona values ('D', 48456789,'M','GARCIA PELOTONIO','URQUIZA 2234','12-05-2013',2,2,NULL, NULL, NULL, NULL, NULL, 'D', 34567890,'F'); 
select * from persona.persona;

insert into persona.empleado values (1, 'D', 23456789,'M','12-05-2004');
select * from persona.empleado;

insert into persona.medico values (12345, 3, 'D', 34567890,'F');
select * from persona.medico;

insert into gestion.historial values (1,'12-05-2004', 2, null);  
select * from gestion.historial;

insert into estructura.sala values (2,1,10,2,1,'LA QUEBRADA DE HUMAHUACA', 14);
select * from estructura.sala;

insert into gestion.asignacion values (1, 12345, 'D', 48456789,'M',1,2,1,10,'12-09-2023',null);
select * from gestion.asignacion;

insert into gestion.trabaja_en values (1, 2,1,10);
select * from gestion.trabaja_en;

*----------------------------------------------------------------------------------------
1 - Listar nombre de localidad y nombre de provincia a la que pertenecen:
*----------------------------------------------------------------------------------------

select * from persona.localidad;
select * from persona.provincia;

SELECT loca.nom_localidad localidad, prov.nom_provincia provincia
  FROM persona.provincia prov, persona.localidad loca 
  WHERE loca.id_provincia = prov.id_provincia;

*----------------------------------------------------------------------------------------
2 - Obtener un listado ordenado por nombre de provincia que contenga el nombre de la provincia 
    y la cantidad de localidades que posee cuyo nombre comience con la letra ‘S’ pero solamente 
    de aquellas provincias que tengan más de 5 localidades con esta condición:
*----------------------------------------------------------------------------------------

SELECT nom_provincia provincia, count(*) localidades 
  FROM persona.provincia p, persona.localidad l
  WHERE nom_localidad like 'S%' AND p.id_provincia = l.id_provincia 
  GROUP BY 1 
  HAVING COUNT(*)>1 
  ORDER BY 2 desc;


*----------------------------------------------------------------------------------------
3 - JOIN con mas de dos tablas - Obtener un listado de las asignaciones del día 
    ordenado por nombre del internado mostrando:

		Número de asignación,
		Documento (tipo, número y sexo) y nombre del internado
*----------------------------------------------------------------------------------------


SELECT asig.id_asignacion, internado.tipodoc, internado.nrodoc, internado.sexo, internado.apenom
  FROM gestion.asignacion asig, persona.persona internado
  WHERE asig.tipodoc = internado.tipodoc AND asig.nrodoc = internado.nrodoc AND asig.sexo = internado.sexo
    AND asig.feasigna = current_date
  ORDER BY internado.apenom;


*----------------------------------------------------------------------------------------
4 - Obtener un listado de las asignaciones del día ordenado por nombre del internado mostrando:

	Número de asignación,
	Documento (tipo, número y sexo) y nombre del internado,
	Nombre del medico interviniente, matrícula y especialidad que tiene,
*----------------------------------------------------------------------------------------

SELECT asig.id_asignacion, internado.tipodoc, internado.nrodoc, internado.sexo, internado.apenom internado, 
       med.matricula, permed.apenom, esp.nom_especialidad
  FROM gestion.asignacion asig, persona.persona internado, persona.medico med, persona.persona permed, gestion.especialidad esp
  WHERE asig.tipodoc = internado.tipodoc AND asig.nrodoc = internado.nrodoc AND asig.sexo = internado.sexo 
    AND asig.matricula = med.matricula AND med.tipodoc = permed.tipodoc AND med.nrodoc = permed.nrodoc AND med.sexo = permed.sexo 
    AND med.id_especialidad = esp.id_especialidad AND asig.feasigna = current_date
  ORDER BY internado.apenom;

*----------------------------------------------------------------------------------------
5 - obtener un listado de las asignaciones del día ordenado por nombre del internado mostrando:

	Número de asignación,
	Documento (tipo, número y sexo) y nombre del internado,
	Nombre del medico interviniente, matrícula y especialidad que tiene,
	Identificativo y nombre del empleado que realizó la carga,
*----------------------------------------------------------------------------------------

SELECT asig.id_asignacion, internado.tipodoc, internado.nrodoc, internado.sexo, internado.apenom internado, med.matricula, permed.apenom, 
       esp.nom_especialidad, asig.id_empleado, peremp.apenom empleado
  FROM gestion.asignacion asig, persona.persona internado, persona.medico med, persona.persona permed, 
       gestion.especialidad esp, persona.empleado emp, persona.persona peremp
  WHERE asig.tipodoc = internado.tipodoc AND asig.nrodoc = internado.nrodoc AND asig.sexo = internado.sexo AND asig.matricula = med.matricula 
    AND med.tipodoc = permed.tipodoc AND med.nrodoc = permed.nrodoc AND med.sexo = permed.sexo AND med.id_especialidad = esp.id_especialidad
    AND asig.id_empleado = emp.id_empleado AND emp.tipodoc = peremp.tipodoc AND emp.nrodoc = peremp.nrodoc AND emp.sexo = peremp.sexo AND asig.feasigna = current_date
  ORDER BY internado.apenom;


*----------------------------------------------------------------------------------------
6 - Obtener un listado de las asignaciones del día ordenado por nombre del internado mostrando:

	Número de asignación,
	Documento (tipo, número y sexo) y nombre del internado,
	Nombre del medico interviniente, matrícula y especialidad que tiene,
	Identificativo y nombre del empleado que realizó la carga,
	Nombre de la sección, del sector y de la sala donde la persona se interna
*----------------------------------------------------------------------------------------

SELECT asig.id_asignacion, internado.tipodoc, internado.nrodoc, internado.sexo, internado.apenom internado, med.matricula, permed.apenom, 
       esp.nom_especialidad, asig.id_empleado, peremp.apenom empleado, secc.nom_seccion seccion, sect.nom_sector sector, sa.nom_sala sala
  FROM gestion.asignacion asig, persona.persona internado, persona.medico med, persona.persona permed, 
       gestion.especialidad esp, persona.empleado emp, persona.persona peremp,
       estructura.seccion secc, estructura.sector sect, estructura.sala sa
  WHERE asig.tipodoc = internado.tipodoc AND asig.nrodoc = internado.nrodoc AND asig.sexo = internado.sexo AND asig.matricula = med.matricula 
    AND med.tipodoc = permed.tipodoc AND med.nrodoc = permed.nrodoc AND med.sexo = permed.sexo AND med.id_especialidad = esp.id_especialidad 
    AND asig.id_empleado = emp.id_empleado AND emp.tipodoc = peremp.tipodoc AND emp.nrodoc = peremp.nrodoc AND emp.sexo = peremp.sexo
    AND asig.id_seccion = sa.id_seccion AND asig.id_sector = sa.id_sector AND asig.nro_sala = sa.nro_sala AND sa.id_seccion = secc.id_seccion 
    AND sa.id_sector = sect.id_sector AND sa.id_seccion = sect.id_seccion -- AND asig.feasigna = current_date
  ORDER BY internado.apenom;
