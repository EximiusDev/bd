-- USANDO DataBase pubs:

USE pubs;

------------------------------------------------------------------------

/*
 ============================================
SQL: Guía de Trabajo Nro. 3  
Consultas avanzadas 
Ejercicios 
 ============================================
 */

-------------------------------------------------------------------------- 
----------------------- E j e r c i c i o   1 ---------------------------- 
-------------------------------------------------------------------------.
/*
Ejercicio 1. Obtenga un listado de apellidos y 
nombres de autores junto a los títulos de las 
publicaciones de su autoría. Ordene el listado 
por apellido del autor.
 */
SELECT A. au_lname, A.au_fname, T.title
FROM Authors A INNER JOIN TitleAuthor TA 
ON A. au_id = TA. au_id 
INNER JOIN Titles T
ON TA. title_id = T. title_id
ORDER BY au_lname;	

-- O sino: 
SELECT A. au_lname, A.au_fname, T.title
FROM Authors A, Titles T, TitleAuthor TA 
WHERE  A. au_id = TA. au_id 
AND TA. title_id = T. title_id
ORDER BY au_lname;	


-------------------------------------------------------------------------- 
----------------------- E j e r c i c i o   2 ---------------------------- 
-------------------------------------------------------------------------.
/*
Ejercicio 2. Obtenga un listado que incluya los nombres 
de las editoriales (tabla publishers) y los nombres y 
apellidos de sus empleados (tabla employee) pero sólo 
para los empleados con  
job level de 200 o más.
 */
publishers

employee

job level >= 200

SELECT P. pub_name, E.lname, E.fname, e. job_lvl
FROM Publishers P, Employee E
WHERE P. pub_id = E. pub_id
AND E. job_lvl >= 200;

-- O sino:
SELECT P. pub_name, E.lname, E.fname, e. job_lvl
FROM Publishers P INNER JOIN Employee E
ON P. pub_id = E. pub_id
WHERE E. job_lvl >= 200;

-------------------------------------------------------------------------- 
----------------------- E j e r c i c i o   3 ---------------------------- 
-------------------------------------------------------------------------.
/*
	Ejercicio 3. Recordemos que tabla sales contiene información de 
	ventas de publicaciones. Cada venta era identificada unívocamente por 
	un número de orden (ord_num), el almacén donde se produjo 
	(stor_id) y la publicación vendida (title_id). 
	La venta poseía también la fecha de venta  (ord_date) y la cantidad 
	vendida de la publicación (qty).
	
	Se desea obtener un listado como el siguiente, que muestre 
	los ingresos (precio de publicación * cantidad vendida) que ha 
	proporcionado cada autor a partir de las ventas de sus 
	publicaciones. Ordene el listado por orden descendente de 
	ingresos.
 */

-- NO ANDA BIEN
SELECT A. au_lname, A.au_fname, (T. price * S. qty)  'Ingresos'
FROM  Authors A, Titles T, TitleAuthor TA, Sales S
WHERE  A. au_id = TA. au_id 
AND TA. title_id = T. title_id
AND T. title_id = S. title_id
ORDER BY Ingresos DESC;
/* REVISAR
 No funciona porque podemos tener varias ventas por publicacion
  entonces tenemos que sumar todas las ventas para publicacion 
 */

-- SI FUNCIONA BIEN
select au_lname, au_fname, sum(s.qty*t.price) as cant 
	from sales s inner join titles t 
		on s.title_id =t.title_id  inner join titleauthor tau
			on tau.title_id = t.title_id inner join authors a 
				on tau.au_id = a.au_id
	group by au_lname ,au_fname 
	order by cant  desc;


-------------------------------------------------------------------------- 
----------------------- E j e r c i c i o   4 ---------------------------- 
-------------------------------------------------------------------------.
/*
Ejercicio 4. Obtenga los tipos de publicaciones (columna type) cuya media de precio sea 
mayor a $12. 
 */

SELECT T.type, AVG(T.price)
FROM Titles T
GROUP BY T.type
HAVING AVG(T.price) > 12;

-------------------------------------------------------------------------- 
----------------------- E j e r c i c i o   5 ---------------------------- 
-------------------------------------------------------------------------.
/*
Ejercicio 5.  
La tabla employee posee información de los empleados de cada editorial. 
 
Por cada empleado tenemos su identificación (emp_id), su nombre  
(fname) y apellido (lname). Cada empleado pertenece a una editorial 
(pub_id) y posee una fecha de contratación (hire_date).  

Las funciones de los empleados se describen en la tabla jobs. Cada 
empleado posee una función (job_id). 

Obtenga el apellido y nombre del empleado contratado más 
recientemente.
 */

SELECT E.lname, E.fname, E.hire_date
FROM Employee E
ORDER BY E.hire_date DESC;

SELECT E.lname, E.fname, E.hire_date
FROM Employee E
WHERE E.hire_date = ( SELECT MAX(E.hire_date)
FROM Employee E );

-------------------------------------------------------------------------- 
----------------------- E j e r c i c i o   6 ---------------------------- 
-------------------------------------------------------------------------.
/*
Ejercicio 6. Obtenga un listado de nombres de editoriales que han editado publicaciones de 
tipo business.  
*/
SELECT P.pub_name, T. type
FROM Publishers P INNER JOIN Titles T
ON P.pub_id = T.pub_id;


SELECT DISTINCT P.pub_name, T. type
FROM Publishers P INNER JOIN Titles T
ON P.pub_id = T.pub_id
WHERE T. type = 'business';


-------------------------------------------------------------------------- 
----------------------- E j e r c i c i o   7 ---------------------------- 
-------------------------------------------------------------------------.
/*
Ejercicio 7. Obtenga un listado de títulos de las publicaciones que no se vendieron ni en 1993 
ni en 1994. (Columna ord_date en tabla Sales) 
 */
SELECT T. title, S.ord_date
FROM Titles T INNER JOIN Sales S
ON T. title_id = S.title_id
order by S.ord_date;


SELECT T. title, S.ord_date
FROM Titles T INNER JOIN Sales S
ON T. title_id = S.title_id
WHERE S.ord_date NOT BETWEEN '1993-01-01 00:00:00.000' AND '1994-12-31 00:00:00.000';

-- O sino
SELECT T. title, S.ord_date
FROM Titles T INNER JOIN Sales S
ON T. title_id = S.title_id
WHERE YEAR(S.ord_date) NOT BETWEEN 1993 and 1994;


SELECT title, titles.title_id 
FROM titles 
WHERE EXISTS (SELECT * 
FROM sales 
WHERE sales.title_id = titles.Title_id AND 
YEAR(ord_date) NOT IN (1993, 1994) );


-------------------------------------------------------------------------- 
----------------------- E j e r c i c i o   8 ---------------------------- 
-------------------------------------------------------------------------.

/*
Ejercicio 8. Obtenga un listado como el siguiente con las publicaciones que poseen un precio 
menor que el promedio de precios de las publicaciones de la editorial a la que pertenecen. 
 */

SELECT T. title, P. pub_name, T.price
FROM Titles T INNER JOIN Publishers P
ON  P.pub_id =  T.pub_id
WHERE T.price <  (SELECT AVG(T.price)
FROM Titles T);

SELECT T. title, P. pub_name, T.price
FROM Titles T INNER JOIN Publishers P
ON  P.pub_id =  T.pub_id
WHERE T.price <  (SELECT AVG(T2.price)
FROM Titles T2
WHERE P.pub_id = T2.pub_id);

-------------------------------------------------------------------------- 
----------------------- E j e r c i c i o   9 ---------------------------- 
-------------------------------------------------------------------------.
/*
Ejercicio 9. La tabla authors posee una columna llamada 
contract con valores 0 ó 1 indicando si el autor posee o 
no contrato con la editora. Se desea obtener un listado 
como el siguiente para los autores de California (columna 
state con valor CA). 
 */
au_lname
au_fname
state
contract

SELECT A. au_fname nombre, A. au_lname Apellido, CASE A.contract  
          WHEN 1 THEN 'Si' 
          WHEN 0 THEN 'No'   
          ELSE 'ERROR'
       END Posee_contrato	 -- Alias de case
FROM Authors A
WHERE A. state = 'CA';

-------------------------------------------------------------------------- 
----------------------- E j e r c i c i o  10 ---------------------------- 
-------------------------------------------------------------------------.
/*
Ejercicio 10. La columna job_lvl indica el puntaje del  
empleado dentro de su área de especialización.  
Se desea obtener un reporte como el siguiente,  
ordenado por puntaje y apellido del empleado: 
 */

Employee
lname
job_lvl

SELECT E. lname nombre, CASE  
          WHEN job_lvl < 100 THEN 'Puntaje menor que 100' 
          WHEN job_lvl > 200 THEN 'Puntaje mayor que 200'   
          ELSE 'Puntaje entre 100 y 200'
       END Nivel	 -- Alias de case
FROM Employee E
ORDER BY Nivel, lname;










/*
-------------------------------------------------------------------------
-------------------------------------------------------------------------
5. Eliminación de duplicados - Agregación - Grupos
-------------------------------------------------------------------------
-------------------------------------------------------------------------
*/


----------------------- Eliminación de duplicados -----------------------