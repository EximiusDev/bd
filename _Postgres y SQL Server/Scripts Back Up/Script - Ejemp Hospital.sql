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
 
 create table gestion.cargo(
 id_cargo		smallint		not null,
 nom_cargo		varchar (30)	not null
 
 );
 