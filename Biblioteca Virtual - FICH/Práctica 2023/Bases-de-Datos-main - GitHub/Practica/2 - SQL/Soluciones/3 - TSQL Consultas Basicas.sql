/* GUIA - CONSULTAS BASICAS */

-----------------------------------------
-------------- Ejercicio 1 --------------
-----------------------------------------
/*
select title_id, title, type, price*1.08
from titles
order by type, title;
*/

-----------------------------------------
-------------- Ejercicio 2 --------------
-----------------------------------------
/*
select title_id, title, type, price*1.08 as "precio actualizado"
from titles
order by type, title;
*/

-----------------------------------------
-------------- Ejercicio 3 --------------
-----------------------------------------
/*
select title_id, title, type, price*1.08 as "precio actualizado"
from titles
order by "precio actualizado" desc;
*/


-----------------------------------------
-------------- Ejercicio 4 --------------
-----------------------------------------

select title_id, title, type, price*1.08 as "precio actualizado"
from titles
order by 4 desc


-----------------------------------------
-------------- Ejercicio 5 --------------
-----------------------------------------
/*
select au_lname || ', ' || au_fname "Listado de Autores"
from authors
*/

-----------------------------------------
-------------- Ejercicio 6 --------------
-----------------------------------------
/*
select title_id || ' posee un valor de $' || price
from titles
*/

-----------------------------------------
-------------- Ejercicio 7 --------------
-----------------------------------------
/*
select title_id || ' posee un valor de $' || cast(price as varchar)
from titles
*/

-----------------------------------------
-------------- Ejercicio 8 --------------
-----------------------------------------
/*
select title, price
from titles
where not price > 13
*/

-----------------------------------------
-------------- Ejercicio 9 --------------
-----------------------------------------
/*
select lname, hire_date
from employee
where hire_date between '01/01/1991' and '01/01/1992'
*/

------------------------------------------
-------------- Ejercicio 10 --------------
------------------------------------------
/*
select au_id, address, city
from authors
where au_id in ('172-32-1176', '238-95-7766')
*/
/*
select au_id, address, city
from authors
where au_id not in ('172-32-1176', '238-95-7766')
*/

------------------------------------------
-------------- Ejercicio 11 --------------
------------------------------------------
/*
select title_id, title
from titles
where title like '%Computer%'
*/

------------------------------------------
-------------- Ejercicio 12 --------------
------------------------------------------
/*
select pub_name, city, state
from publishers
where state is null
*/

------------------------------------------
-------------- Ejercicio 13 --------------
------------------------------------------

select *
from sales
where extract(month from ord_date) = 6


