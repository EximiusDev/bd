-- USANDO DataBase pubs:

USE pubs;

/*
 ============================================
 SELECT
 ============================================
 */
/*
SELECT au_lname AS Apellido, city ciudad 
FROM authors;

SELECT au_lname AS "Apellido del autor", city ciudad 
FROM authors;

SELECT au_lname "Apellido del autor", city ciudad 
FROM authors;

SELECT aut. au_lname "Apellido del autor", aut. city ciudad 
FROM authors aut;

-- Falta algo (ESTA MAL)
SELECT au_lname"Apellido del autor", au_fname, city ciudad, 
title
FROM authors aut, titles tit, titleauthor
WHERE aut. au_id = titleauthor. au_id
AND titleauthor. title_id = tit. title_id;
*/

------------------------------------------------------------------------
------------------Mostrar columnas con lo que quieras

select 'Gone With the Wind', 1939, 231, 'drama';

--PostgreSQL:

select ('Gone With the Wind', 1939, 231, 'drama');















/*
SELECT 
FROM 
WHERE 
ORDER BY 
*/