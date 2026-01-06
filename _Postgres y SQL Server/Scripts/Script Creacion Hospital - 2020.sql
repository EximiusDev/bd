CREATE DATABASE hospital;
/*  CREATE DATABASE nombre_de_la_base [adicionales]
 */

USE hospital;

 CREATE SCHEMA persona;
 CREATE SCHEMA estructura;
 CREATE SCHEMA gestion;
 
 /* CREATE SCHEMA nombre_del_esquema */

 /*
 ============================================
 NIVEL 1
 ============================================
 */
 
 CREATE TABLE persona.provincia (
 id_provincia 	smallint		not null,
 nom_provincia 	varchar(30)	 	not null,
 CONSTRAINT pk_provincia PRIMARY KEY (id_provincia)
 );
 
 create table gestion.cargo(
 id_cargo		smallint		not null,
 nom_cargo		varchar (30)	not null,
 CONSTRAINT pk_cargo PRIMARY KEY (id_cargo)
 );
 
 create table gestion.especialidad(
 id_especialidad	smallint		not null,
 nom_especialidad	varchar (40)	not null,
 CONSTRAINT pk_especialidad PRIMARY KEY (id_especialidad)
 );
 
 CREATE TABLE estructura.seccion (
 id_seccion 	smallint		not null,
 nom_seccion 	varchar(30)	 	not null,
 CONSTRAINT pk_seccion PRIMARY KEY (id_seccion)
 );
 
 /*
   CREATE TABLE [esquema.]nombre_tabla (
 Columna1  tipo_dato (tamaño)
 [NOT NULL] [DEFAULT valor_por_default] 
[CONSTRAINT nombre_constraint_de_columna] 
[UNIQUE] [PRIMARY KEY]
 [REFERENCES [esquema.]nombre_tabla (columna/s)]
 [CHECK (condición)],
 ….., ColumnaN….,
 [CONSTRAINT nombre_constraint_de_tabla] 
[UNIQUE (columna/s)] 
[PRIMARY KEY (columna/s)]
 [CHECK (condición)]
 [FOREIGN KEY (columna/s) REFERENCES [esquema.]nombre_tabla
 (columna/s)]
 12
 );
  */
 
 /* DROP TABLE persona.provincia */
 

  /*
 ============================================
 NIVEL 2
 ============================================
 */
 
 CREATE TABLE estructura.sector (
 id_seccion 		smallint		not null,
 id_sector 			smallint		not null,
 nom_sector			varchar(30)		not null,
 constraint pk_sector primary key (id_seccion, id_sector),
 constraint fk_sector_seccion foreign key (id_seccion) references estructura.seccion (id_seccion)
 );
 
 CREATE TABLE persona.localidad (
 id_provincia 		smallint		not null,
 id_localidad 		smallint		not null,
 nom_localidad		varchar(40)		not null,
 constraint pk_localidad primary key (id_provincia, id_localidad),
 constraint fk_localidad_provincia foreign key (id_provincia) references persona.provincia (id_provincia)
 );
  
  /*
 ============================================
 NIVEL 3
 ============================================
 */
 
 CREATE TABLE persona.persona(
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
 constraint fk_persona_localidad_vive foreign key (id_provivive, id_locavive) references persona.localidad (id_provincia, id_localidad),
 constraint fk_persona_localidad_nace foreign key (id_provinace, id_locanace) references persona.localidad (id_provincia, id_localidad),
 constraint fk_persona_persona_padre foreign key (tipodocpadre, nrodocpadre, sexopadre) references persona.persona (tipodoc, nrodoc, sexo),
 constraint fk_persona_persona_madre foreign key (tipodocmadre, nrodocmadre, sexomadre) references persona.persona (tipodoc, nrodoc, sexo)
 );
 
 /*
 ============================================
 NIVEL 4
 ============================================
 */
 CREATE table persona.medico (
 matricula		 	smallint 	not null,
 id_especialidad	smallint 	not null,
 tipodoc			char 		not null,
 nrodoc				integer 	not null,
 sexo	        	char 		not null,
 constraint pk_medico primary key (matricula),
 constraint fk_medico_persona foreign key (tipodoc, nrodoc, sexo) references persona.persona (tipodoc, nrodoc, sexo),
 constraint fk_medico_especialidad foreign key (id_especialidad) references gestion.especialidad (id_especialidad)
 );
 
 CREATE table persona.empleado (
 id_empleado		integer 	not null,
 feingreso		 	date	 	not null,
 tipodoc			char 		not null,
 nrodoc				integer 	not null,
 sexo	        	char 		not null,
 constraint pk_empleado primary key (id_empleado),
 constraint fk_empleado_persona foreign key (tipodoc, nrodoc, sexo) references persona.persona (tipodoc, nrodoc, sexo)
 );
 
 /*
 ============================================
 NIVEL 5
 ============================================
 */
 
 create table gestion.historial (
 id_empleado		integer 	not null,
 id_cargo			smallint 	not null,
 fechainicio	 	date	 	not null,
 fechafin		 	date	 	null,
 constraint pk_historial primary key (id_empleado, fechainicio),
 constraint fk_historial_empleado foreign key (id_empleado) references persona.empleado (id_empleado), 
 constraint fk_historial_cargo foreign key (id_cargo) references gestion.cargo (id_cargo)
 );
 
 create table estructura.sala(
 id_seccion 		smallint		not null,
 id_sector 			smallint		not null,
 nro_sala			smallint 		not null,
 id_especialidad	smallint 		not null,
 id_empleado		integer 		not null,
 nom_sala			varchar(30)		not null,
 capacidad			smallint		null,
 constraint pk_sala primary key (id_seccion, id_sector, nro_sala),
 constraint fk_sala_sector foreign key (id_seccion, id_sector) references estructura.sector (id_seccion, id_sector),
 constraint fk_sala_especialidad foreign key (id_especialidad) references gestion.especialidad (id_especialidad),
 constraint fk_sala_empleado foreign key (id_empleado) references persona.empleado (id_empleado)
 );
 
 /*
 ============================================
 NIVEL 6
 ============================================
 */
  
 create table gestion.asignacion (
 id_asignacion		integer 		not null,
 matricula		 	smallint 	not null,
 tipodoc			char 		not null,
 nrodoc				integer 	not null,
 sexo	        	char 		not null,
 id_empleado		integer 	not null,
 id_seccion 		smallint	not null,
 id_sector 			smallint	not null,
 nro_sala			smallint 	not null,
 fechaasigna	 	date	 	not null,
 fechasalida	 	date	 	null,
 constraint pk_asignacion primary key (id_asignacion),
 constraint fk_asignacion_medico foreign key (matricula) references persona.medico (matricula),
 constraint fk_empleado_persona foreign key (tipodoc, nrodoc, sexo) references persona.persona (tipodoc, nrodoc, sexo),
 constraint fk_sala_empleado foreign key (id_empleado) references persona.empleado (id_empleado),
 constraint fk_sala_sector foreign key (id_seccion, id_sector, nro_sala) references estructura.sala (id_seccion, id_sector, nro_sala)
 );
 
 create table gestion.trabaja_en (
 id_empleado		integer 		not null,
 id_seccion 		smallint		not null,
 id_sector 			smallint		not null,
 nro_sala			smallint 		not null,
 constraint pk_trabaja_en primary key (id_empleado, id_seccion, id_sector, nro_sala),
 constraint fk_sala_sector foreign key (id_seccion, id_sector, nro_sala) references estructura.sala (id_seccion, id_sector, nro_sala),
 constraint fk_sala_empleado foreign key (id_empleado) references persona.empleado (id_empleado)
 );

 
  /*
 ============================================
 INSERT (insertar Valores) requiere de nivel 2
 ============================================
 */
  
   
 INSERT INTO persona.provincia (id_provincia, nom_provincia)
 VALUES (1, 'SANTA FE');

 INSERT INTO persona.provincia (id_provincia, nom_provincia)
 VALUES (2, 'ENTRE RIOS');
 
 INSERT INTO persona.provincia VALUES (3, 'CORDOBA');
 INSERT INTO persona.provincia VALUES (4, 'BUENOS AIRES');
 
/* INSERT INTO [esquema.]nombre_de_la_tabla
 [(nombre_de_columna1, 
nombre_de_columna2, ...)]
 VALUES (‘valor1’, ‘valor2’, ...);
 */
 
 
 
 /* LOCALIDAD */
 
 INSERT INTO persona.localidad (id_provincia, id_localidad, nom_localidad)
 VALUES ( 1, 1, 'SANTA FE');
 INSERT INTO persona.localidad VALUES ( 1, 2, 'SANTO TOME');
 INSERT INTO persona.localidad VALUES ( 2, 1, 'PARANALANDIA');
 INSERT INTO persona.localidad VALUES ( 2, 2, 'CONCORDIA');

 

 
 /*
 UPDATE  [esquema.]nombre_de_la_tabla   
SET  
columna1 = valor_nuevo,
 columna2 = valor_nuevo,
 ...
 columnaN = valor_nuevo
 [WHERE condicion];
 */
 
 UPDATE persona.localidad SET nom_localidad = 'PARANA'
 WHERE id_provincia = 2 AND id_localidad = 1;
 
 UPDATE persona.localidad SET nom_localidad = 'PARANALANDIA'
 Where nom_localidad LIKE 'PARANA%';
 
 
 /*
  DELETE (elimina la informacion contenida en una tabla) 
  
  truncate table hace lo mismo pero borra todo sin dejar registro en el log
  
  DELETE  FROM [esquema.]nombre_de_la_tabla  
[WHERE condición];
  */
 delete from persona.provincia;
 delete from persona.localidad;
 
 delete from persona.provincia Where nom_provincia LIKE 'BUENOS%';
 delete from persona.localidad  WHERE id_provincia = 2 AND id_localidad = 2;
  
 
 /*
  Drop borra la tabla o estructura
  */
 drop table persona.persona;
 
 /*
  SELECT
  
  SELECT columna1, columna2, ......,columnaN  
FROM [esquema.]nombre_de_la_tabla;
  */
  
 
 select * from persona.provincia;
 select * from persona.localidad;
 select * from persona.localidad where nom_localidad like 'SA%';
 
 SELECT nom_localidad FROM persona.localidad
 WHERE id_provincia = 1;
 
 SELECT apenom, tipodoc, nrodoc FROM persona.persona
 WHERE id_provivive = 1 AND id_locavive = 1;
 
 /*
 ============================================
 requiere de nivel 3
 ============================================
 */
 /*
  CREATE VIEW nombre_de_la_vista
 ((nombre_columnas_de_la_vista))
 AS 
(SELECT columna(s) FROM [esquema.]tabla(s) WHERE condicion(es));
  */
 

  CREATE VIEW persona_santafe
 (tipo_documento, nro_documento, apellido_nombre)
 AS (SELECT tipodoc, nrodoc, apenom FROM persona.persona
 WHERE id_provivive = 1 AND id_locavive = 1);
  
  /*
   set search_path to persona
   
   cambia la posicion de inicio por defecto al esquema 'persona'
  */
   
   
   /*==============================================================*/
/* Insersión                                                    */
/*==============================================================*/

  USE hospital;
  
/*
insert into persona.provincia values (1, 'SANTA FE');
insert into persona.provincia values (2, 'ENTRE RIOS');
insert into persona.provincia values (3, 'CORDOBA');
insert into persona.provincia values (4, 'BUENOS AIRES');
select * from persona.provincia;
*/
   
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
/*
insert into persona.localidad values ( 1, 1, 'SANTA FE');
insert into persona.localidad values ( 1, 2, 'SANTO TOME');
insert into persona.localidad values ( 2, 1, 'PARANA');
insert into persona.localidad values ( 2, 2, 'CONCORDIA');
select * from persona.localidad;
*/

insert into persona.persona values ('D', 23456789,'M','RODRIGUEZ CACHITO','SAN MARTIN 1234','12-05-1981',1,1,NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL); 
insert into persona.persona values ('D', 34567890,'F','FERNANDEZ TOTA','SAN JERONIMO 3344','11-07-1984',1,2,NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL); 
insert into persona.persona values ('D', 45223456,'M','RODRIGUEZ CACHIRULO','SAN MARTIN 1234','12-05-2010',2,1,NULL, NULL, 'D', 23456789,'M', NULL, NULL, NULL); 
insert into persona.persona values ('D', 48456789,'M','GARCIA PELOTONIO','URQUIZA 2234','12-05-2013',2,2,NULL, NULL, NULL, NULL, NULL, 'D', 34567890,'F'); 
insert into persona.persona values ('D', 40123456,'M','RODRIGUEZ BENITO','SAN MARTIN 1234','12-05-2000',2,1,1, 1, 'D', 23456789,'M', 'D', 34567890,'F');
select * from persona.persona;

insert into persona.empleado values (1,'12-05-2004', 'D', 23456789,'M');
select * from persona.empleado;

insert into persona.medico values (12345, 3, 'D', 34567890,'F');
select * from persona.medico;

insert into gestion.historial values (1, 2,'12-05-2004', null);  
select * from gestion.historial;

insert into estructura.sala values (2,1,10,2,1,'LA QUEBRADA DE HUMAHUACA', 14);
select * from estructura.sala;

insert into gestion.asignacion values (1, 12345, 'D', 48456789,'M',1,2,1,10,'12-09-2023',null);
select * from gestion.asignacion;

insert into gestion.trabaja_en values (1, 2,1,10);
select * from gestion.trabaja_en;
  
/*
 * Eliminacion de tablas (1ero tengo que borrar las foreign key que referencian dichas tablas) 
 * Ejemplo con especialidad
*/

alter table persona.medico drop constraint fk_medico_especialidad;
alter table estructura.sala drop constraint fk_sala_especialidad;

drop table especialidad;

/*
 * Es muy comun tener indices por cada foreign key se referencia
 * [SE TIENE QUE HACER UN INDICE DE FOREIGN KEY EN PARCIALES Y FINALES]
 * (recordar que las primary key y unique tienen indice por defecto)
 */

-----------------------------------------------------------------------------------------
 /*==============================================================*/
/* JOIN                                                    */
/*==============================================================*/

USE hospital;

-- SELECT NORMAL (sin JOIN)[VER ERROR (producto cartesiano todos contra todos)]
SELECT nom_localidad, nom_provincia FROM persona.localidad, persona.provincia;
-- Esta mal porque hace el producto carteciano (todos contra todos)


-- uso de JOIN para filtrar resultados (localidad y provincia)
SELECT loca.nom_localidad lugar , pr.nom_provincia estado FROM persona. localidad loca, persona. provincia pr
WHERE loca. id_provincia = pr. id_provincia order BY 2;

/*
 loca y pr son alias para: persona. localidad loca, persona. provincia pr respectivamente,
 donde se referencia en FROM a dichas tablas
 los alias NO son obligatorios pero si se usan deben usarse en toda la consulta
 
 tengo un solo JOIN entre localidad y provincia,
  para relacionar ambas id_provincia de las tablas con el mismo valor
 
 */
-- uso de JOIN para filtrar resultados (asignacion y persona asignada o internada)
SELECT asig.id_asignacion, internado.tipodoc, internado.nrodoc, internado apenom
 FROM gestion.asignacion asig, persona.persona internado
WHERE asig. tipodoc = internado.tipodoc
AND asig. nrodoc = internado. nrodoc
AND asig. sexo = internado. sexo;

AND asig. fechaasigna = current_date
ORDER BY internado. apenom;	
/*
  tengo un solo JOIN entre asignacion y persona(internado),
  para relacionar las columnas tipodoc, nrodoc,sexo;
   de las distintas tablas con el mismo valor
 */
/*
 AND asig. fechaasigna = current_date -> no hay ninguna fecha asignacion que sea el dia de hoy por lo tanto lo saque
ORDER BY internado. apenom;	-> como es un solo valor no tiene sentido pero ordena por el nombre
 */
/*
 ver que sin la clausula WHERE donde se igualan los campos da como resultado un asignacion para todas las personas (ERROR / MAL)
 es un pruducto cartesiano de todos contra todos (hay una unica asignacion puede habier a lo sumo 1 valor como resultado) 
*/


-- uso de JOIN EN MAS (+) DE 2 TABLAS (asignacion, persona, medico, especialidad)
SELECT asig.id_asignacion, internado.tipodoc, internado.nrodoc, internado apenom,
med. matricula, permed. apenom, esp. nom_especialidad
 FROM gestion.asignacion asig, persona.persona internado,
 persona. medico med, persona. persona permed, gestion. especialidad esp
WHERE asig. tipodoc = internado.tipodoc
AND asig. nrodoc = internado. nrodoc
AND asig. sexo = internado. sexo

AND asig.matricula = med. matricula
AND med. tipodoc = permed.tipodoc
AND med. nrodoc = permed. nrodoc
AND med. sexo = permed. sexo
AND med. id_especialidad = esp. id_especialidad

ORDER BY internado. apenom;	

/*
 Al agregar medico y especialidad tambien tengo que agregar un JOIN entre:
   asignacion y medico,
   medico y persona (persona_medico), y,
   medco y especialidad
   Ademas de los anteriores 
   asignacion y persona (internado)
 */

-- uso de JOIN agrego mas (+) tablas (asignacion, persona, medico, especialidad, empleado)
SELECT asig.id_asignacion, internado.tipodoc, internado.nrodoc, internado apenom,
med. matricula, permed. apenom, esp. nom_especialidad,
asig. id_empleado, peremp. apenom
 FROM gestion.asignacion asig, persona.persona internado,
 persona. medico med, persona. persona permed, gestion. especialidad esp,
 persona.empleado emp, persona.persona peremp
WHERE asig. tipodoc = internado.tipodoc
AND asig. nrodoc = internado. nrodoc
AND asig. sexo = internado. sexo
AND asig.matricula = med. matricula
AND med. tipodoc = permed.tipodoc
AND med. nrodoc = permed. nrodoc
AND med. sexo = permed. sexo
AND med. id_especialidad = esp. id_especialidad

AND asig. id_empleado = emp. id_empleado
AND emp. tipodoc = peremp.tipodoc
AND emp. nrodoc = peremp. nrodoc
AND emp. sexo = peremp. sexo

ORDER BY internado. apenom;	


-- uso de JOIN agrego muchas mas (+) tablas (asignacion, persona, medico, especialidad, empleado, seccion, sector, sala)
SELECT asig.id_asignacion, internado.tipodoc, internado.nrodoc, internado apenom,
med. matricula, permed. apenom, esp. nom_especialidad,
asig. id_empleado, peremp. apenom,
secc. id_seccion seccion, sect. id_sector sector, sa.nro_sala sala
 FROM gestion.asignacion asig, persona.persona internado,
 persona. medico med, persona. persona permed, gestion. especialidad esp,
 persona.empleado emp, persona.persona peremp,
 estructura. seccion secc, estructura. sector sect, estructura. sala sa
WHERE asig. tipodoc = internado.tipodoc
AND asig. nrodoc = internado. nrodoc
AND asig. sexo = internado. sexo
AND asig.matricula = med. matricula
AND med. tipodoc = permed.tipodoc
AND med. nrodoc = permed. nrodoc
AND med. sexo = permed. sexo
AND med. id_especialidad = esp. id_especialidad
AND asig. id_empleado = emp. id_empleado
AND emp. tipodoc = peremp.tipodoc
AND emp. nrodoc = peremp. nrodoc
AND emp. sexo = peremp. sexo

AND asig. nro_sala = sa. nro_sala
AND asig. id_sector = sa.id_sector
AND asig. id_seccion = sa. id_seccion
AND asig. id_sector = sect.id_sector
AND asig. id_seccion = sect. id_seccion
AND asig. id_seccion = secc. id_seccion


ORDER BY internado. apenom;	

--FORMA ALTERNATIVA (intersecciones AND diferentes)
SELECT asig.id_asignacion, internado.tipodoc, internado.nrodoc, internado apenom,
med. matricula, permed. apenom, esp. nom_especialidad,
asig. id_empleado, peremp. apenom,
sa.nro_sala sala
 FROM gestion.asignacion asig, persona.persona internado,
 persona. medico med, persona. persona permed, gestion. especialidad esp,
 persona.empleado emp, persona.persona peremp,
 estructura. sala sa
WHERE asig. tipodoc = internado.tipodoc
AND asig. nrodoc = internado. nrodoc
AND asig. sexo = internado. sexo
AND asig.matricula = med. matricula
AND med. tipodoc = permed.tipodoc
AND med. nrodoc = permed. nrodoc
AND med. sexo = permed. sexo
AND med. id_especialidad = esp. id_especialidad
AND asig. id_empleado = emp. id_empleado
AND emp. tipodoc = peremp.tipodoc
AND emp. nrodoc = peremp. nrodoc
AND emp. sexo = peremp. sexo

AND asig. nro_sala = sa. nro_sala
AND asig. id_sector = sa.id_sector
AND asig. id_seccion = sa. id_seccion
AND sa. id_sector = sect.id_sector
AND sa. id_seccion = sect. id_seccion
AND sa. id_seccion = secc. id_seccion


ORDER BY internado. apenom;	


--FORMA ALTERNATIVA (solo sala)
SELECT asig.id_asignacion, internado.tipodoc, internado.nrodoc, internado apenom,
med. matricula, permed. apenom, esp. nom_especialidad,
asig. id_empleado, peremp. apenom,
sa.nro_sala sala
 FROM gestion.asignacion asig, persona.persona internado,
 persona. medico med, persona. persona permed, gestion. especialidad esp,
 persona.empleado emp, persona.persona peremp,
 estructura. sala sa
WHERE asig. tipodoc = internado.tipodoc
AND asig. nrodoc = internado. nrodoc
AND asig. sexo = internado. sexo
AND asig.matricula = med. matricula
AND med. tipodoc = permed.tipodoc
AND med. nrodoc = permed. nrodoc
AND med. sexo = permed. sexo
AND med. id_especialidad = esp. id_especialidad
AND asig. id_empleado = emp. id_empleado
AND emp. tipodoc = peremp.tipodoc
AND emp. nrodoc = peremp. nrodoc
AND emp. sexo = peremp. sexo

AND asig. nro_sala = sa. nro_sala
AND asig. id_sector = sa.id_sector
AND asig. id_seccion = sa. id_seccion


ORDER BY internado. apenom;	


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


