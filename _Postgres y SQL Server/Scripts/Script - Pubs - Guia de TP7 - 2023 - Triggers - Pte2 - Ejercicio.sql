-- USANDO DataBase pubs:

USE pubs;

------------------------------------------------------------------------

/*
 ============================================
SQL: Guía de Trabajo Nro. 7  
Triggers 
Parte 2 
 ============================================
 */

/*
-------------------------------------------------------------------------
-------------------------------------------------------------------------
Ejercicios 
-------------------------------------------------------------------------
-------------------------------------------------------------------------
*/

-------------------------------------------------------------------------- 
----------------------- E j e r c i c i o   1 ----------------------------
-------------------------------------------------------------------------.

/*
Ejercicio 1.  
 
En SQL Server, cree una copia (Autores) de la tabla Authors. Luego defina un trigger llamado 
tr_ejercicio1 asociado al evento DELETE sobre la misma. El trigger debe retornar un 
mensaje (usando PRINT) “Se eliminaron n filas”  indicando la cantidad de filas afectadas 
en la operación. Dispare luego la siguiente sentencia SQL para probar el trigger. 
 
 
DELETE 
   FROM autores 
   WHERE au_id = "172-32-1176" or 
         au_id = "213-46-8915" 
    
         Copia:     

SELECT *  
INTO titles10 
FROM titles 
WHERE 1=0 

-- O sino:

SELECT *  
INTO titles10 
FROM titles 
LIMIT 0 
 */

-- SQL Server:










-------------------------------------------------------------------------

-- PostgreSQL:





















-------------------------------------------------------------------------- 
----------------------- E j e r c i c i o   x ----------------------------
-------------------------------------------------------------------------.
