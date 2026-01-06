CREATE DATABASE hospital;

 CREATE SCHEMA persona;
 CREATE SCHEMA estructura;
 CREATE SCHEMA gestion;

 /*
 ============================================
 NIVEL 1
 ============================================
 */
 
 CREATE TABLE persona.provincia (
 id_provincia 	smallint		not null,
 nom_provincia 	varchar(30)	 	not null
 );
 
 alter table persona.provincia add constraint pk_provincia primary key (id_provincia);
 
 create table gestion.cargo(
 id_cargo		smallint		not null,
 nom_cargo		varchar (30)	not null
 
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
 ============================================
 NIVEL 2
 ============================================
 */
 
 CREATE TABLE estructura.sector (
 id_seccion 		smallint		not null,
 id_sector 			smallint		not null,
 nom_sector			varchar(30)		not null
 );
 
 /*
   constraint pk_sector primary key (id_seccion, id_sector),
 constraint fk_sector_seccion foreign key (id_seccion) references estructura.seccion (id_seccion)
  */
 
 CREATE TABLE persona.localidad (
 id_provincia 		smallint		not null,
 id_localidad 		smallint		not null,
 nom_localidad		varchar(40)		not null
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
 sexomadre 		char 		null
 );
 
 /*
  (’DNI’,’LE’,’LC’,’PAS’,’OTR’)
  ('D','E','C','P')
  */
 
 /*
 CREATE TABLE persona.persona(
 tipodoc		char 		not null
 CONSTRAINT chk_tipodocumento CHECK (tipodocumento IN ('D','E','C','P')),
 nrodoc			integer 	not null
 CONSTRAINT chk_nrodocumentoCHECK (nrodocumento > 1000000),
 sexo	        char 		not null,
 apenom 		varchar(40) not null,
 domicilio 	    varchar(50) null,
 fenacimiento 	date 		null,
 id_provivive 	smallint 	not null,
 id_locavive 	smallint 	not null,
 id_provinace 	smallint 	null,
 id_locanace 	smallint 	null,
 tipodocpadre 	char 		null,
 nrodocpadre 	integer 	null,
 sexopadre 		char 		null,
 tipodocmadre 	char 		null,
 nrodocmadre 	integer 	null,
 sexomadre 		char 		null
 CONSTRAINT pk_persona PRIMARY KEY (tipodocumento, nrodocumento),
 CONSTRAINT fk_persona_locanacio FOREIGN KEY (codigoprovincianacio, codigolocalidadnacio) REFERENCES persona.localidad (codigoprovincia, codigolocalidad)
 
 fefalleci		date 		null,
 CONSTRAINT chk_fechanac_fechafalle
 CHECK (fenacimiento <= fefalleci)	
 );
 alter table persona.persona add constraint chk_tipodoc checK (tipodoc in ('D','E','C','P'));
 */
 
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
 /*
 constraint fk_medico_especialidad foreign key (id_especialidad) references gestion.especialidad (id_especialidad)
 */
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
 id_asignacion		integer 	not null,
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
 
 
 
 
 
 
/*==============================================================*/
/* Insersióm                                                    */
/*==============================================================*/

begin transaction;
 
 
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

/*
  begin transaction; -> inicia la transacciom
  roleback transaction; -> vuelve al estado previo al inicio de la transaccion
  commit transaction; -> sube la transaccion a la base de datos
 */

roleback transaction;
commit transaction;

/*
 * 
 */