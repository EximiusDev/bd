create database TP1_Hospital;

create schema nivel_1;
create schema nivel_2;
create schema nivel_3;
create schema nivel_4;
create schema nivel_5;
create schema nivel_6;

/*
 create table nivel_2.localidad(
id_provincia		integer				not null,
id					integer				not null,
nom_localidad		varchar(40)		not null,
constraint pk_localidad primary key (id),
constraint uk_localidad unique (id_provincia, id), // no va
constraint fk_localidad_provincia foreign key (id_provincia) references nivel_1.provincia (id)
);

alter table persona.provincia add constraint pk_provincia primary key (id_provincia);
 */


/*
 ============================================
 NIVEL 1
 ============================================
 */

create table nivel_1.provincia(
id					integer			not null,
nom_provincia		varchar(30)		not null,
constraint pk_especialidad primary key (id)
);

create table nivel_1.especialidad(
id					integer			not null,
nom_especialidad	varchar(40)		not null,
constraint pk_especialidad primary key (id)
);


alter table nivel_1.especialidad add constraint pk_especialidad1 primary key (id);
alter table nivel_1.especialidad drop constraint pk_especialidad1;

create table nivel_1.seccion(
id					integer			not null,
nom_seccion			varchar(30)		not null
);

alter table nivel_1.seccion add constraint pk_seccion primary key (id);

create table nivel_1.cargo(
id					integer			not null,
nom_cargo			varchar(30)		not null
);

alter table nivel_1.cargo add constraint pk_cargo primary key (id);

/*
 ============================================
 NIVEL 2
 ============================================
 */

create table nivel_2.localidad(
id_provincia		integer				not null,
id					integer				not null,
nom_localidad		varchar(40)			not null,
constraint pk_localidad primary key (id_provincia, id),
constraint fk_localidad_provincia foreign key (id_provincia) references nivel_1.provincia (id)
);

create table nivel_2.sector(
id_seccion		integer				not null,
id				integer				not null,
nom_sector		varchar(30)			not null
);

alter table nivel_2.sector add constraint pk_sector primary key (id_seccion, id);
alter table nivel_2.sector add constraint fk_sector_seccion foreign key (id_seccion) references nivel_1.seccion (id);

/*
 ============================================
 NIVEL 3
 ============================================
 */

create table nivel_3.persona(
 tipodoc		char 		not null,
 nrodoc			integer 	not null,
 sexo	        char 		not null,
 apenom 		varchar(40) not null,
 domicilio 	    varchar(50) null,
 fenaci 		date 		null,
 id_provivive 	smallint 	not null,
 id_locavive 	smallint 	not null,
 id_provinace 	smallint 	null,
 id_locanace 	smallint 	null,
 tipodocpadre 	char 		null,
 nrodocpadre 	integer 	null,
 sexopadre 		char 		null,
 tipodocmadre 	char 		null,
 nrodocmadre 	integer 	null,
 sexomadre 		char 		null,
 constraint pk_persona primary key (tipodoc, nrodoc, sexo),
 constraint fk_persona_localidad_vive foreign key (id_provivive, id_locavive) references nivel_2.localidad (id_provincia, id),
 constraint fk_persona_localidad_nace foreign key (id_provinace, id_locanace) references nivel_2.localidad (id_provincia, id),
 constraint fk_persona_persona_padre foreign key (tipodocpadre, nrodocpadre, sexopadre) references nivel_3.persona (tipodoc, nrodoc, sexo),
 constraint fk_persona_persona_madre foreign key (tipodocmadre, nrodocmadre, sexomadre) references nivel_3.persona (tipodoc, nrodoc, sexo)
);

/*
 ============================================
 NIVEL 4
 ============================================
 medico
  empleado
  
 */
create table nivel_4.empleado (
 id				integer		not null,
 tipodoc		char 		not null,
 nrodoc			integer 	not null,
 sexo	        char 		not null,
 feingreso		date		not null,
 constraint pk_empleado primary key (id),
 constraint fk_empleado_persona foreign key (tipodoc, nrodoc, sexo) references nivel_3.persona (tipodoc, nrodoc, sexo)
);

create table nivel_4.medico (
 matricula			integer		not null,
 id_especialidad	integer		not null,
 tipodoc			char 		not null,
 nrodoc				integer 	not null,
 sexo	    	    char 		not null,
 feingreso			date		not null
);
alter table nivel_4.medico drop column feingreso;
/*
 constraint pk_medico primary key (matricula),
 constraint fk_medico_persona foreign key (tipodoc, nrodoc, sexo) references nivel_3.persona (tipodoc, nrodoc, sexo),
 constraint fk_medico_especialidad foreign key (id_especialidad) references nivel_3.persona (id)
 */
alter table nivel_4.medico add constraint pk_medico primary key (matricula);
alter table nivel_4.medico add constraint fk_medico_persona foreign key (tipodoc, nrodoc, sexo) references nivel_3.persona (tipodoc, nrodoc, sexo);
alter table nivel_4.medico add constraint fk_medico_especialidad foreign key (id_especialidad) references nivel_1.especialidad (id);

/*
 ============================================
 NIVEL 5
 ============================================
 sala
 historial
 */
create table nivel_5.sala (
id_seccion			integer				not null,
id_sector			integer				not null,
nro_sala			integer				not null,
id_especialidad		integer				not null,
id_empleado			integer				not null,
nom_sala			varchar(30)			not null,
capacidad			integer				not null,
constraint pk_sala primary key (id_seccion, id_sector, nro_sala),
constraint fk_sala_sector foreign key (id_seccion, id_sector) references nivel_2.sector (id_seccion, id),
constraint fk_sala_especialidad foreign key (id_especialidad) references nivel_1.especialidad (id),
constraint fk_sala_empleado foreign key (id_empleado) references nivel_4.empleado (id)
);

create table nivel_5.historial (
id_empleado			integer				not null,
fechaInicio			date 				not null,
fechaFin			date 				null,
id_cargo			integer				not null
);

alter table nivel_5.historial add constraint pk_historial primary key (id_empleado, fechaInicio);
alter table nivel_5.historial add constraint fk_historial_empleado foreign key (id_empleado) references nivel_4.empleado (id);


alter table nivel_5.historial drop constraint fk_sala_empleado;

alter table nivel_5.historial drop column fechaFin;
alter table nivel_5.historial add column fechaFin date null;

/*
 ============================================
 NIVEL 6
 ============================================
 trabaja en
 asignacion
 */

create table nivel_6.Trabaja_en (	
id_empleado			integer				not null,
id_seccion			integer				not null,
id_sector			integer				not null,
nro_sala			integer				not null,
constraint pk_Trabaja_en primary key (id_empleado, id_seccion, id_sector, nro_sala),
constraint fk_Trabaja_en_empleado foreign key (id_empleado) references nivel_4.empleado (id),
constraint fk_Trabaja_en_sala foreign key (id_seccion, id_sector, nro_sala) references nivel_5.sala (id_seccion, id_sector, nro_sala)
);

create table nivel_6.asignacion (
 id					integer			not null,
 matricula			integer			not null,
 tipodoc			char 			not null,
 nrodoc				integer 		not null,
 sexo	    	    char 			not null,
 id_empleado		integer			not null,
 feasigna			date 			not null,
 fesalida			date 			null
);

alter table nivel_6.asignacion add column id_seccion			integer				not null;
alter table nivel_6.asignacion add column id_sector			integer				not null;
alter table nivel_6.asignacion add column nro_sala			integer				not null;

alter table nivel_6.asignacion add constraint pk_asignacion primary key (id);
alter table nivel_6.asignacion add constraint fk_asignacion_empleado foreign key (id_empleado) references nivel_4.empleado (id);
alter table nivel_6.asignacion add constraint fk_asignacion_medico foreign key (matricula) references nivel_4.medico (matricula);
alter table nivel_6.asignacion add constraint fk_asignacion_persona foreign key (tipodoc, nrodoc, sexo) references nivel_3.persona (tipodoc, nrodoc, sexo);


alter table nivel_6.asignacion add constraint fk_asignacion_sala foreign key (id_seccion, id_sector, nro_sala) references nivel_5.sala (id_seccion, id_sector, nro_sala)


 /*==============================================================*/
/* Insersióm                                                    */
/*==============================================================*/
/*
 INSERT INTO persona.localidad (id_provincia, id_localidad, nom_localidad)
 VALUES ( 1, 1, 'SANTA FE');
 */

insert into nivel_1.provincia values (1, 'SANTA FE');
insert into nivel_1.provincia values (2, 'ENTRE RIOS');
insert into nivel_1.provincia values (3, 'CORDOBA');
insert into nivel_1.provincia values (4, 'BUENOS AIRES');
select * from nivel_1.provincia;
   
insert into nivel_1.cargo values (1, 'ADMINISTRATIVO');
insert into nivel_1.cargo values (2, 'TELEFONISTA');
insert into nivel_1.cargo values (3, 'GERENTE');
insert into nivel_1.cargo values (4, 'ORDENANZA');
select * from nivel_1.cargo;

insert into nivel_1.especialidad values (1, 'PSIQUITRIA');
insert into nivel_1.especialidad values (2, 'TRAUMATOLOGIA');
insert into nivel_1.especialidad values (3, 'CARDIOLOGIA');
insert into nivel_1.especialidad values (4, 'PEDIATRIA');
select * from nivel_1.especialidad;

insert into nivel_1.seccion values (1, 'CONSULTORIOS ABIERTOS');
insert into nivel_1.seccion values (2, 'INTENACION');
select * from nivel_1.seccion;

insert into nivel_2.sector values ( 1, 1, 'NORTE');
insert into nivel_2.sector values ( 1, 2, 'SUR');
insert into nivel_2.sector values ( 2, 1, 'TERAPIA INTERMEDIA');
insert into nivel_2.sector values ( 2, 2, 'TERAPIA ABIERTA');
select * from nivel_2.sector;

insert into nivel_2.localidad values ( 1, 1, 'SANTA FE');
insert into nivel_2.localidad values ( 1, 2, 'SANTO TOME');
insert into nivel_2.localidad values ( 2, 1, 'PARANA');
insert into nivel_2.localidad values ( 2, 2, 'CONCORDIA');
select * from nivel_2.localidad;

insert into nivel_3.persona values ('D', 23456789,'M','RODRIGUEZ CACHITO','SAN MARTIN 1234','12-05-1981',1,1,NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL); 
insert into nivel_3.persona values ('D', 34567890,'F','FERNANDEZ TOTA','SAN JERONIMO 3344','11-07-1984',1,2,NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL); 
insert into nivel_3.persona values ('D', 45223456,'M','RODRIGUEZ CACHIRULO','SAN MARTIN 1234','12-05-2010',2,1,NULL, NULL, 'D', 23456789,'M', NULL, NULL, NULL); 
insert into nivel_3.persona values ('D', 48456789,'M','GARCIA PELOTONIO','URQUIZA 2234','12-05-2013',2,2,NULL, NULL, NULL, NULL, NULL, 'D', 34567890,'F'); 
insert into nivel_3.persona values ('D', 40123456,'M','RODRIGUEZ BENITO','SAN MARTIN 1234','12-05-2000',2,1,1, 1, 'D', 23456789,'M', 'D', 34567890,'F');
select * from nivel_3.persona;

insert into nivel_4.empleado values (1, 'D', 23456789,'M','12-05-2004');
select * from nivel_4.empleado;

insert into nivel_4.medico values (12345, 3, 'D', 34567890,'F');
select * from nivel_4.medico;

insert into nivel_5.historial values (1,'12-05-2004', 2,null);  
select * from nivel_5.historial;

insert into nivel_5.sala values (2,1,10,2,1,'LA QUEBRADA DE HUMAHUACA', 14);
select * from nivel_5.sala;

insert into nivel_6.asignacion values (1, 12345, 'D', 48456789,'M',1,'12-09-2023',null,2,1,10);
select * from nivel_6.asignacion;

insert into nivel_6.trabaja_en values (1, 2,1,10);
select * from nivel_6.trabaja_en;
  


-----------------------------------------------------------------------------------------
-----------------------------------------------------------------------------------------
-----------------------------------------------------------------------------------------
/*
 TP de SELECT - Practica 2023 - SQL
 TPN1
 */

*----------------------------------------------------------------------------------------
1 - Listar nombre de localidad y nombre de provincia a la que pertenecen:
*----------------------------------------------------------------------------------------

SELECT lo.nom_localidad, pr. nom_provincia
FROM persona. localidad lo, persona. provincia pr
WHERE lo. id_provincia = pr.id_provincia 

---------------------------- resuelto en clases

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

SELECT prov. nom_provincia , count ( * )
FROM persona. provincia prov, persona. localidad local 
WHERE nom_localidad like 'S%' 
AND prov.id_provincia  = local. id_provincia 
GROUP BY prov. nom_provincia
HAVING count(*) < 5
ORDER BY prov.nom_provincia desc;

---------------------------- resuelto en clases

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


SELECT asig. id_asignacion, intern.tipodoc, intern.nrodoc, intern.sexo, intern.apenom
FROM gestion. asignacion asig, persona. persona intern
WHERE asig.tipodoc = intern.tipodoc
AND asig.nrodoc = intern.nrodoc
AND asig.sexo = intern.sexo
ORDER BY intern.apenom;

AND asig.fechaasigna = current_date

---------------------------- resuelto en clases

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

SELECT asig. id_asignacion, intern.tipodoc, intern.nrodoc, intern.sexo, intern.apenom,
permed. apenom, med. matricula,  esp. nom_especialidad
FROM gestion. asignacion asig, persona.persona intern, 
persona.persona permed, persona.medico med, gestion. especialidad esp
WHERE asig.tipodoc = intern.tipodoc
AND asig.nrodoc = intern.nrodoc
AND asig.sexo = intern.sexo

AND asig.matricula = med.matricula
AND med. id_especialidad = esp. id_especialidad
AND med. tipodoc = permed.tipodoc
AND med.nrodoc = permed.nrodoc
AND med.sexo = permed.sexo
ORDER BY intern.apenom;

AND fechaasigna = current_date

---------------------------- resuelto en clases

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

SELECT asig. id_asignacion, intern.tipodoc, intern.nrodoc, intern.sexo, intern.apenom,
permed. apenom, med. matricula,  esp. nom_especialidad,
emp. id_empleado, peremp. apenom
FROM gestion. asignacion asig, persona.persona intern, 
persona.persona permed, persona.medico med, gestion. especialidad esp,
persona. empleado emp, persona. persona peremp
WHERE asig.tipodoc = intern.tipodoc
AND asig.nrodoc = intern.nrodoc
AND asig.sexo = intern.sexo
AND asig.matricula = med.matricula
AND med. id_especialidad = esp. id_especialidad
AND med. tipodoc = permed.tipodoc
AND med.nrodoc = permed.nrodoc
AND med.sexo = permed.sexo

AND asig. id_empleado = emp. id_empleado
AND emp. tipodoc = peremp.tipodoc
AND emp.nrodoc = peremp.nrodoc
AND emp.sexo = peremp.sexo
ORDER BY intern.apenom;

AND fechaasigna = current_date

---------------------------- resuelto en clases

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

SELECT asig. id_asignacion, intern.tipodoc, intern.nrodoc, intern.sexo, intern.apenom,
permed. apenom, med. matricula,  esp. nom_especialidad,
emp. id_empleado, peremp. apenom,
secc. nom_seccion , sect. nom_sector  , sal. nom_sala
FROM gestion. asignacion asig, persona.persona intern, 
persona.persona permed, persona.medico med, gestion. especialidad esp,
persona. empleado emp, persona. persona peremp,
estructura.seccion secc, estructura.sector sect, estructura.sala sal
WHERE asig.tipodoc = intern.tipodoc
AND asig.nrodoc = intern.nrodoc
AND asig.sexo = intern.sexo
AND asig.matricula = med.matricula
AND med.id_especialidad = esp. id_especialidad
AND med.tipodoc = permed.tipodoc
AND med.nrodoc = permed.nrodoc
AND med.sexo = permed.sexo
AND asig.id_empleado = emp. id_empleado
AND emp.tipodoc = peremp.tipodoc
AND emp.nrodoc = peremp.nrodoc
AND emp.sexo = peremp.sexo

AND asig.id_seccion = secc.id_seccion
AND asig.id_sector = sect.id_sector
AND asig.nro_sala = sal.nro_sala

AND secc.id_seccion = sect.id_seccion
AND sect.id_sector = sal.id_sector
ORDER BY intern.apenom;

AND fechaasigna = current_date

---------------------------- resuelto en clases
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


/*

SELECT 
FROM 
WHERE 
AND 
GROUP BY 
HAVING 
ORDER BY 

---------------------------- resuelto en clases
 */



alter table estructura.sector RENAME nom_nom_sector to nom_sector;

-------------------------------------------------------------------------------------------
-------------------------------------------------------------------------------------------

/*
 Ejemplo comando SELECT de TP4 - 2020
 Ejerc4
 Nota: ver que solo se ven las provincias que si tienen una Localidad
 */

SELECT persona. localidad. id_provincia, count(*)
FROM persona.localidad
GROUP BY persona. localidad. id_provincia
ORDER BY persona. localidad. id_provincia;

/*
 Ejemplo comando SELECT de TP4 - 2020
 Ejerc5:
 Recuperar los nom de las prov y la cant de local q tiene def c/u.
  Ordenar por nombre de prov. Join entre localidad y provincia
  
  SELECT prov. nom_provincia, count(*)
FROM persona.localidad local, persona. provincia prov
WHERE local. id_provincia = prov. id_provincia
GROUP BY prov. nom_provincia
ORDER BY prov. nom_provincia;
 */
SELECT persona. provincia. nom_provincia, count(*)
FROM persona.localidad, persona. provincia
WHERE persona. localidad. id_provincia = persona. provincia. id_provincia
GROUP BY persona. provincia. nom_provincia
HAVING count(*) < 50
ORDER BY persona. provincia. nom_provincia;

