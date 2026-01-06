-- DICCIONARIO DE DATOS
-- USANDO DataBase pubs:

-- USE pubs;


/*
	 Ejemplo:
 El siguiente ejemplo muestra cómo el uso del esquema INFORMATION_SCHEMA es parte del
 estándar SQL y debería funcionar en cualquier sistema que lo respete:
 */

-- Consultar las tablas de un esquema en cualquier motor compatible con el estándar SQL
 SELECT table_name
 FROM INFORMATION_SCHEMA.TABLES
 WHERE table_schema = 'public';-- Obtener columnas de una tabla en particular
 SELECT column_name, data_type
 FROM INFORMATION_SCHEMA.COLUMNS
 WHERE table_name = 'mi_tabla';

/*
-------------------------------------------------------------------------
Diccionario de Datos en PostgreSQL
-------------------------------------------------------------------------
*/
-- PostgreSQL:

 -- a. Ver las tablas de un esquema

 SELECT table_schema, table_name
 FROM information_schema.tables
 WHERE table_schema = 'public';

 -- b. Ver las columnas de una tabla
 
 SELECT column_name, data_type, character_maximum_length
 FROM information_schema.columns
 WHERE table_name = 'nombre_tabla';
 
 -- c. Obtener detalles de las restricciones de una tabla
 
 SELECT constraint_name, constraint_type
 FROM information_schema.table_constraints
 WHERE table_name = 'nombre_tabla';
 
 -- d. Ver las claves foráneas
 
 SELECT tc.constraint_name, kcu.column_name, 
       ccu.table_name AS foreign_table_name, ccu.column_name AS 
foreign_column_name
 FROM information_schema.table_constraints AS tc 
JOIN information_schema.key_column_usage AS kcu
 ON tc.constraint_name = kcu.constraint_name
 JOIN information_schema.constraint_column_usage AS ccu
 ON ccu.constraint_name = tc.constraint_name
 WHERE tc.constraint_type = 'FOREIGN KEY' AND tc.table_name = 'nombre_tabla';

------------------------------------------------------------------------

 /*
-------------------------------------------------------------------------
Diccionario de Datos en SQL Server
-------------------------------------------------------------------------
*/
-- SQL Server:
 
 -- a. Ver las tablas de una base de datos
 
 SELECT TABLE_SCHEMA, TABLE_NAME
 FROM INFORMATION_SCHEMA.TABLES
 WHERE TABLE_TYPE = 'BASE TABLE';
 
 -- b. Ver las columnas de una tabla
 
 SELECT COLUMN_NAME, DATA_TYPE, CHARACTER_MAXIMUM_LENGTH
 FROM INFORMATION_SCHEMA.COLUMNS
 WHERE TABLE_NAME = 'nombre_tabla';
 
 -- c. Ver restricciones de una tabla
 
 SELECT CONSTRAINT_NAME, CONSTRAINT_TYPE
 FROM INFORMATION_SCHEMA.TABLE_CONSTRAINTS
 WHERE TABLE_NAME = 'nombre_tabla';
 
 -- d. Ver claves ajenas
 
 SELECT FK.TABLE_NAME AS TablaHija, CU.COLUMN_NAME AS ColumnaHija,
       PK.TABLE_NAME AS TablaPadre, PT.COLUMN_NAME AS ColumnaPadre
 FROM INFORMATION_SCHEMA.REFERENTIAL_CONSTRAINTS C
 JOIN INFORMATION_SCHEMA.TABLE_CONSTRAINTS FK
  ON C.CONSTRAINT_NAME = FK.CONSTRAINT_NAME
 JOIN INFORMATION_SCHEMA.TABLE_CONSTRAINTS PK
  ON C.UNIQUE_CONSTRAINT_NAME = PK.CONSTRAINT_NAME
 JOIN INFORMATION_SCHEMA.KEY_COLUMN_USAGE CU
  ON C.CONSTRAINT_NAME = CU.CONSTRAINT_NAME
 JOIN (
  SELECT i1.TABLE_NAME, i2.COLUMN_NAME
  FROM INFORMATION_SCHEMA.TABLE_CONSTRAINTS i1
  JOIN INFORMATION_SCHEMA.KEY_COLUMN_USAGE i2
  ON i1.CONSTRAINT_NAME = i2.CONSTRAINT_NAME
  WHERE i1.CONSTRAINT_TYPE = 'PRIMARY KEY'
 ) PT
  ON PT.TABLE_NAME = PK.TABLE_NAME;
 
 
/*
 ============================================

 ============================================
 */

------------------------ Stored Procedures  -----------------------------

-- SQL Server:


-- PostgreSQL:

/*
-------------------------------------------------------------------------
1. Parámetros 
-------------------------------------------------------------------------
*/






------------------------- 8.1. CASE simple ------------------------------- 	

-------------------------------------------------------------------------- 
----------------------- E j e r c i c i o   1 ---------------------------- 
-------------------------------------------------------------------------.
