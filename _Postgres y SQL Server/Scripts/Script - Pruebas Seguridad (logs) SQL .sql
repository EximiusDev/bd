--- SQL Server:
/*
 ============================================
 Tablas temporales locales y globales 
 ============================================
 */

/*
 En T-SQL podemos definir tablas temporales locales. Las mismas se 
crean como cualquier otra tabla, pero su nombre debe ser precedido por el 
símbolo #. Por ejemplo:
*/
 CREATE TABLE #clienteTemp  
  ( 
   codCli		int  			 NOT NULL, 
   ape			varchar(30) 	 NOT NULL, 
   nom			varchar(30) 	 NOT NULL, 
   dir			varchar(40) 	 NOT NULL, 
   codPost		char(9) 		 NULL 
  );
  
 /*
  Estas tablas son eliminadas cuando finaliza la sesión (conexión) que las 
creó. No son visibles desde otras sesiones a la base de datos. 	

Una variante son las tablas temporales globales. Las mismas son 
visibles desde otras sesiones diferentes a la que la creó. (Se eliminan 
también automáticamente cuando finaliza la sesión que las creó, pero -si 
todavía están en uso por alguna otra sesión en ese momento- el DBMS 
espera hasta que se libere totalmente su uso antes de eliminarlas. )
*/
CREATE TABLE ##clienteTemp  
  ( 
   codCli		int  			 NOT NULL, 
   ape			varchar(30) 	 NOT NULL, 
   nom			varchar(30) 	 NOT NULL, 
   dir			varchar(40) 	 NOT NULL, 
   codPost		char(9) 		 NULL
  );
/*
  Todos los usuarios poseen privilegios para crear y usar tablas temporales globales o 
locales en tempdb. 
 */ 
  SELECT * FROM tempdb.#clienteTemp;

--------------------------------------------------------------------------------------
/*
 ============================================
 LOGIN ID
 
 Se puede crear una nueva Login ID para SQL Server
 desde el script (tener en cuenta que se deberia estar conectado 
 a la Base de Datos desde un Servidor como un Usuario)
 ============================================
 */
CREATE LOGIN curso					-- PARA UN USUARIO
WITH PASSWORD = 'cursocurso',
DEFAULT_DATABASE = hospital;

/*
 Podemos obtener la info acerca de los Logins creados en la instancia
 a traves de la catalog view server_principals del schema sys
 de la base de datos master:
 
 SELECT name, principal_id, type, type_desc,
 default_database_name
 FROM master.sys.server_principals
*/

SELECT name, principal_id, type, type_desc,
 default_database_name
 FROM master.sys.server_principals
 
 /*
  Un database user es un database principal en la terminología de SQL Server. Podemos 
pensar que es similar a un Login, pero dentro del scope de la base de datos.  

Sucede que hemos dado a curso acceso a esta instancia de SQL Server, pero no posee 
aún permiso para acceder a las bases de datos. No posee acceso ni siquiera a su base de 
datos default pubs. 

Para autorizar a un Login SQL Server a acceder a una base de datos particular, el 
DBA necesita crear un database user dentro de esa base de datos que haga 
referencia al Login en cuestión. 

el DBA crea un database user a partir de un SQL Server Login ID a través de una 
sentencia T-SQL con la siguiente sintaxis: 
  */
 CREATE USER curso  
FOR LOGIN curso;
 
 /*
 Podemos obtener información acerca de los users de una base de datos a 
través de la catalog view database_principals del schema sys de cualquier 
base de datos: 
 
USE pubs 
 
SELECT name, principal_id, type, type_desc,  
       default_schema_name 
   FROM sys.database_principals 
  */
 
 USE hospital
 
SELECT name, principal_id, type, type_desc,  
       default_schema_name 
   FROM sys.database_principals;

/*
Cuando se crea una base de datos, se crea automáticamente un usuario especial 
llamado dbo (por database owner), asociado a la SQL Server login account que la 
creó. 
Este special database user tiene permisos para realizar cualquier actividad dentro de 
la base de datos. 
 */
 