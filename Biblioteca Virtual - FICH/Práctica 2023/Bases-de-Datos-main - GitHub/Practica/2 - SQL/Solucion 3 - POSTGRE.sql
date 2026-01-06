--GUIA 7 (GUIA 1 de SQL)--

--------
--EJ 1--
--------
SELECT title_id, title, type, price*1.08 FROM titles ORDER BY type, title

-------
--EJ 2--
-------
--Con alias (Postgre)
SELECT title_id, title, type, price*1.08 AS "Precio Actualizado" FROM titles ORDER BY type, title

--------
--EJ 3--
--------
SELECT title_id, title, type, price*1.08 AS "Precio Actualizado" FROM titles ORDER BY "Precio Actualizado" DESC

--------
--EJ 4--
--------
SELECT title_id, title, type, price*1.08 AS "Precio Actualizado" FROM titles ORDER BY 4 DESC

--------
--EJ 5--
--------
SELECT au_lname || ', ' || au_fname AS "Listado de Autores" FROM authors ORDER BY "Listado de Autores"

--------
--EJ 6--
--------
SELECT title_id || ' posee un valor de $' || price::varchar(5) FROM titles

--------
--EJ 8--
--------
SELECT title, price FROM titles
	WHERE NOT price > 13

--------
--EJ 9--
--------
SELECT lname, hire_date FROM employee
	WHERE hire_date BETWEEN '01-01-1991' AND '01-01-1992'

---------
--EJ 10--
---------
SELECT au_id, address, city FROM authors
	WHERE au_id IN ('172-32-1176', '238-95-7766')

SELECT au_id, address, city FROM authors
	WHERE au_id NOT IN ('172-32-1176', '238-95-7766')

---------
--EJ 11--
---------
SELECT title_id, title FROM titles
	WHERE title LIKE '%computer%'

---------
--EJ 12--
---------
SELECT pub_name, city, state FROM publishers
	WHERE state IS NULL

---------
--EJ 13--
---------
SELECT * FROM sales
	WHERE date_part('MONTH',ord_date) = 6