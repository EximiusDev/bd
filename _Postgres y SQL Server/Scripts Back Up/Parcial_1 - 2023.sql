CREATE DATABASE Parcial_1_2023;
 
create schema Ejercicio_2;
create schema Ejercicio_3;

/*
 ============================================
 Ejercicio_1
 ============================================
 */




----------------------------------------------------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------------------------------------------------
/*
 ============================================
 Ejercicio_2
 ============================================
 */

BEGIN TRANSACTION;


-- Tablas originales
CREATE TABLE Ejercicio_2.persona (
	tipo CHARACTER(1) not null,
	numero INTEGER not null,
	CONSTRAINT persona_pk PRIMARY KEY(tipo,numero),
	CONSTRAINT persona_chk CHECK ( tipo IN ('1','2','3') )
);

CREATE TABLE Ejercicio_2.profesor (
	nro_legajo INTEGER not null,
	tipo CHARACTER(1) not null,
	numero INTEGER not null,
	CONSTRAINT profesor_pk PRIMARY KEY(nro_legajo),
	CONSTRAINT profesor_fk FOREIGN KEY (tipo,numero)
		REFERENCES Ejercicio_2.persona(tipo,numero)
);


COMMIT transaction;


-- Inserts de persona
INSERT INTO Ejercicio_2.persona (tipo, numero)
VALUES ('1', 1001);

INSERT INTO Ejercicio_2.persona (tipo, numero)
VALUES ('2', 2002);

INSERT INTO Ejercicio_2.persona (tipo, numero)
VALUES ('3', 3003);



-- Inserts de profesor
INSERT INTO Ejercicio_2.profesor (nro_legajo, tipo, numero)
VALUES (101, '1', 1001);

INSERT INTO Ejercicio_2.profesor (nro_legajo, tipo, numero)
VALUES (202, '2', 2002);


/*
 Resolucion:
 
 UPDATE  nombre_de_la_tabla    
SET   columna1 = valor_nuevo, 
columna2 = valor_nuevo, 
... 
columnaN = valor_nuevo, 
[WHERE condición];

 */

BEGIN TRANSACTION;

-- Alterar la tabla
-- Quitar restriccion de CHECK (CONSTRAINT persona_chk CHECK)

alter table Ejercicio_2.persona drop constraint persona_chk;

alter table Ejercicio_2.profesor drop constraint profesor_fk;



update Ejercicio_2.persona set tipo = 'A' where tipo = '1';
update Ejercicio_2.persona set tipo = 'B' where tipo = '2';
update Ejercicio_2.persona set tipo = 'C' where tipo = '3';

select * from Ejercicio_2.persona;

update Ejercicio_2.profesor set tipo = 'A' where tipo = '1';
update Ejercicio_2.profesor set tipo = 'B' where tipo = '2';
update Ejercicio_2.profesor set tipo = 'C' where tipo = '3';
select * from Ejercicio_2.profesor;

--alter table Ejercicio_2.persona alter column numero ...

alter table Ejercicio_2.persona add constraint persona_chk checK (tipo in ('A','B','C'));
-- alter table persona.persona add constraint chk_tipodoc checK (tipodoc in ('D','E','C','P'));

alter table Ejercicio_2.profesor add constraint profesor_fk FOREIGN KEY (tipo,numero)
		REFERENCES Ejercicio_2.persona(tipo,numero);

select * from Ejercicio_2.persona;
select * from Ejercicio_2.profesor;

INSERT INTO Ejercicio_2.persona (tipo, numero)
VALUES ('3', 4444);

INSERT INTO Ejercicio_2.persona (tipo, numero)
VALUES ('C', 4444);

INSERT INTO Ejercicio_2.profesor (nro_legajo, tipo, numero)
VALUES (111, 'B', 2002);

COMMIT TRANSACTION;

---- FORMA ALTERNATIVA
/*
 BEGIN TRANSACTION;
 
alter table Ejercicio_2.persona 
	drop constraint persona_chk;

alter table Ejercicio_2.profesor 
	drop constraint profesor_fk;

UPDATE Ejercicio_2.persona
	SET tipo = CASE
	WHEN tipo = '1' THEN 'A'
    WHEN tipo = '2' THEN 'B'
	WHEN tipo = '3' THEN 'C'
	ELSE 'X'
END;

UPDATE Ejercicio_2.profesor 
	SET tipo = CASE
	WHEN tipo = '1' THEN 'A'
	WHEN tipo = '2' THEN 'B'
	WHEN tipo = '3' THEN 'C'
	ELSE 'X'
END;


COMMIT TRANSACTION;

ROLLBACK transaction;


BEGIN TRANSACTION;

*/

----------------------------------------------------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------------------------------------------------
/*
 ============================================
 Ejercicio_3
 ============================================
 */

BEGIN TRANSACTION;

CREATE TABLE Ejercicio_3.pais (
	codigo_pais 	CHARACTER(3) 		not null,
	nombre_pais 	CHARACTER(32) 	not null,
	CONSTRAINT codigo_pais PRIMARY KEY(codigo_pais)
);

CREATE TABLE Ejercicio_3.provincia (
	codigo_pais 		CHARACTER(3) 	not null,
	codigo_provincia 	INTEGER 		not null,
	nombre_provincia 	CHARACTER(30) 	not null,
	CONSTRAINT provincia_pk PRIMARY KEY(codigo_pais,codigo_provincia),
	CONSTRAINT provincia_fk FOREIGN KEY (codigo_pais)
		REFERENCES Ejercicio_3.pais(codigo_pais)
);
/*
CREATE TABLE Ejercicio_3.localidad (
	codigo_pais 		CHARACTER(3) 	not null,
	codigo_provincia 	INTEGER 		not null,
	codigo_localidad 	INTEGER 		not null,
	nombre_localidad 	CHARACTER(120) 	not null,
	codigo_postal 		INTEGER 		null
	CONSTRAINT localidad_pk PRIMARY KEY(codigo_pais,codigo_provincia,codigo_localidad),
	CONSTRAINT localidad_fk FOREIGN KEY (codigo_pais,codigo_provincia)
		REFERENCES Ejercicio_3.provincia(codigo_pais,codigo_provincia),
	CONSTRAINT localidad_uq UNIQUE(codigo_postal)
);
*/
CREATE TABLE Ejercicio_3.localidad (
	codigo_pais 		CHARACTER(3) 	not null,
	codigo_provincia 	INTEGER 		not null,
	codigo_localidad 	INTEGER 		not null,
	nombre_localidad 	CHARACTER(120) 	not null,
	codigo_postal 		INTEGER 		null
);

alter table Ejercicio_3.localidad add CONSTRAINT localidad_pk PRIMARY KEY(codigo_pais,codigo_provincia,codigo_localidad);
alter table Ejercicio_3	.localidad add 
		CONSTRAINT localidad_fk FOREIGN KEY (codigo_pais,codigo_provincia)
		REFERENCES Ejercicio_3.provincia(codigo_pais,codigo_provincia);
alter table Ejercicio_3	.localidad add
		CONSTRAINT localidad_uq UNIQUE(codigo_postal);

COMMIT TRANSACTION;

--ROLLBACK transaction;

 /*==============================================================*/
/* Insersión (pais, provincia, localidad)                                                    */
/*==============================================================*/

BEGIN TRANSACTION;

--Ejercicio_3.pais
INSERT INTO Ejercicio_3.pais (codigo_pais, nombre_pais)
 VALUES ( 1, 'ARGENTINA');
insert into Ejercicio_3.pais values (2, 'FRANCIA');
insert into Ejercicio_3.pais values (3, 'BRASIL');

--Ejercicio_3.provincia
INSERT into Ejercicio_3.provincia (codigo_pais, codigo_provincia, nombre_provincia)
values (1, 1 , 'Entre Rios');
insert into Ejercicio_3.provincia values (1, 24 , 'URUGUAY');
insert into Ejercicio_3.provincia values (3, 1 , 'Santa Catarina');
insert into Ejercicio_3.provincia values (3, 2 , 'Río Grande del Sur');

--Ejercicio_3.localidad  
INSERT into Ejercicio_3.localidad (codigo_pais, codigo_provincia, codigo_localidad, nombre_localidad, codigo_postal)
values (1, 1 , 1, 'Parana', 3100);
insert into Ejercicio_3.localidad values (3, 1 , 1, 'Florianopolis', 88010);

COMMIT TRANSACTION;
--ROLLBACK transaction;

delete from Ejercicio_3.localidad;
--delete from Ejercicio_3.localidad where codigo_postal = null;

BEGIN TRANSACTION;


CREATE TABLE Ejercicio_3.persona (
	tipo 			CHARACTER(1) 	not null,
	numero 			INTEGER 		not null,
	apellido 		CHARACTER(150) 	null,
	nombres 		CHARACTER(150) 	null,
	domicilio 		CHARACTER(300) 	null,
	codigo_postal 	INTEGER 		null,
	CONSTRAINT persona_pk PRIMARY KEY(tipo,numero),
	CONSTRAINT persona_uq UNIQUE (codigo_postal)
);

/*
CREATE TABLE Ejercicio_3.persona (
	tipo CHARACTER(1) not null,
	numero INTEGER not null,
	apellido CHARACTER(150) null,
	nombres CHARACTER(150) null,
	domicilio CHARACTER(300) null,
	codigo_postal INTEGER null,
	CONSTRAINT persona_pk PRIMARY KEY(tipo,numero),
	CONSTRAINT persona_fk FOREIGN KEY (codigo_postal)
		REFERENCES Ejercicio_3.localidad(codigo_postal),
);
*/
COMMIT TRANSACTION;


 /*==============================================================*/
/* Insersión (tipo, numero, apellido, nombres, domicilio, codigo_postal)                                                    */
/*==============================================================*/

BEGIN TRANSACTION;

INSERT into Ejercicio_3.persona (tipo, numero, apellido, nombres, domicilio, codigo_postal)
values ('M', 40123456 , 'Perez', 'Juan', 'La Calle 1000', 3100);
INSERT into Ejercicio_3.persona values ('F', 40123456 , 'Pereza', 'Juana', 'La Avenida 2000', 88010);

COMMIT TRANSACTION;
/*
 Resolucion:
 */
BEGIN TRANSACTION;


-- Primero que hay que hacer es añadir las nuevas entradas a persona que van a contener la foreign key

ALTER TABLE Ejercicio_3.persona
	ADD COLUMN codigo_localidad INTEGER			 ;
ALTER TABLE Ejercicio_3.persona
	ADD COLUMN codigo_pais 		CHARACTER(3)	;
ALTER TABLE Ejercicio_3.persona
	ADD COLUMN codigo_provincia INTEGER			;

--ROLLBACK transaction;
COMMIT TRANSACTION;

-- Segundo crear la constraint
BEGIN TRANSACTION;

select * from Ejercicio_3.persona;

ALTER TABLE Ejercicio_3.persona
	ADD CONSTRAINT persona_fk FOREIGN KEY (codigo_pais,codigo_provincia,codigo_localidad)
		REFERENCES Ejercicio_3.localidad(codigo_pais,codigo_provincia,codigo_localidad);

COMMIT TRANSACTION;

--tercero: Actualizo los valores ya ingresados (si los hay)

BEGIN TRANSACTION;

/*
UPDATE Ejercicio_3.persona
SET codigo_pais = (select codigo_pais from Ejercicio_3.localidad where codigo_postal = 3100 ), 
	codigo_provincia = (select codigo_provincia from Ejercicio_3.localidad where codigo_postal = 3100 ),
	codigo_localidad = (select codigo_localidad from Ejercicio_3.localidad where codigo_postal = 3100 ) 
 WHERE codigo_pais = null and codigo_postal = 3100;
*/
--No es la forma mas eficiente pero no conozco otra de actualizar los valores
UPDATE Ejercicio_3.persona
SET codigo_pais = 1, 
	codigo_provincia = 1,
	codigo_localidad =  1
 WHERE codigo_postal = 3100;

select * from Ejercicio_3.persona;

UPDATE Ejercicio_3.persona
SET codigo_pais = 3, 
	codigo_provincia = 1,
	codigo_localidad =  1
 WHERE codigo_postal = 88010;

COMMIT TRANSACTION;
ROLLBACK transaction;


-- Cuarto: eliminar la constraint unique de persona
BEGIN TRANSACTION;

ALTER TABLE Ejercicio_3.persona
	DROP CONSTRAINT persona_uq;

COMMIT TRANSACTION;



-- Quinto: eliminar la columna de codigo postal
BEGIN TRANSACTION;

ALTER TABLE Ejercicio_3.persona
	DROP column codigo_postal;

COMMIT TRANSACTION;

ROLLBACK transaction;

select * from Ejercicio_3.persona;

drop table Ejercicio_3.persona;

/*
 ============================================
 NIVEL 
 
 
 
 
 CREATE DATABASE hospital;

 CREATE SCHEMA persona;
 CREATE SCHEMA estructura;
 CREATE SCHEMA gestion;
 
 
 
 
  CREATE TABLE persona.provincia (
 id_provincia 	smallint		not null,
 nom_provincia 	varchar(30)	 	not null
 
 );
 
 create table gestion.cargo(
 id_cargo		smallint		not null,
 nom_cargo		varchar (30)	not null
 
 );
 
 ============================================
 */
 
 /*
 ALTER TABLE Ejercicio_3.persona
	alter COLUMN codigo_localidad INTEGER			not null;
ALTER TABLE Ejercicio_3.persona
	alter COLUMN codigo_pais 		CHARACTER(3)	not null;
ALTER TABLE Ejercicio_3.persona
	alter COLUMN codigo_provincia INTEGER			not null;
 
 */