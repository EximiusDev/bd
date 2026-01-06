-- USANDO DataBase pubs:

USE pubs;

------------------------------------------------------------------------

/*
 ============================================
 SQL: Guía de Trabajo Nro. 2  
Data Manipulation Language 
 ============================================
 */

/*
-------------------------------------------------------------------------
-------------------------------------------------------------------------
1. Pre-requisitos 
-------------------------------------------------------------------------
-------------------------------------------------------------------------
*/


 ------------------------------------------------------------------------- 
 ---------------------- E j e r c i c i o   1 ---------------------------- 
 ------------------------------------------------------------------------.
/*
Ejercicio 1.  A continuación definiremos un pequeño esquema de tablas para realizar 
ejercicios de manipulación de datos. Sobre la base de datos pubs ejecute las siguientes 
sentencias SQL. No importa si observan cláusulas que no conocen. Las analizaremos a 
continuación: 
 */

/*
 ============================================
Sobre SQL Server: 
 ============================================
 */

CREATE TABLE cliente  
  ( 
   codCli  	int  			NOT NULL,  
   ape   	varchar(30) 	NOT NULL, 
   nom  	varchar(30)  	NOT NULL, 
   dir  	varchar(40) 	NOT NULL, 
   codPost 	char(9) 		NULL 		DEFAULT 3000 
  );


CREATE TABLE productos  
  ( 
   codProd  	int  			NOT NULL, 
   descr   		varchar(30) 	OT NULL, 
   precUnit 	float  			NOT NULL, 
   stock 		smallint 		NOT NULL 
  );


CREATE TABLE proveed  
  ( 
   codProv  	int  			IDENTITY(1,1), 
   razonSoc  	varchar(30) 	NOT NULL,  
   dir  		varchar(30)  	NOT NULL 
  ) 

 
CREATE TABLE pedidos  
  ( 
   numPed  		int  		NOT NULL, 
   fechPed   	datetime 	NOT NULL, 
   codCli 		int   		NOT NULL 
  ) 
 
 
 
CREATE TABLE detalle  
  ( 
   codDetalle  	int  	NOT NULL, 
   numPed  		int  	NOT NULL, 
   codProd    	int  	NOT NULL, 
   cant  		int   	NOT NULL, 
   precioTot  	float  	NULL 
  ) 






