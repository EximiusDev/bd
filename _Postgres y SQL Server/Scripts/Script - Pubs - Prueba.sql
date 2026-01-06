-- USANDO DataBase pubs:

USE pubs;

/*
 ============================================
 SELECT
 ============================================
 */

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

------------------------------------------------------------------------

/*
 ============================================
 SELECT
 SQL: Guía de Trabajo Nro. 1 
Consultas básicas 
 ============================================
 */
 ------------------------------------------------------------------------- 
 ---------------------- E j e r c i c i o   1 ---------------------------- 
 ------------------------------------------------------------------------.
/*
1. Obtenga el código de título, título, tipo y precio incrementado en un 8% de todas las 
publicaciones, ordenadas por tipo y título. 
*/
/*
 En este caso nos piden información sobre las publicaciones, así que sabemos que la misma 
se encontrará en la tabla titles. 
 */
SELECT * FROM titles 

--1.1
/*
 Nos solicitan código de título (title_id), título (title), tipo (type) de todas las publicaciones. 
 */
SELECT title_id, title, type FROM titles;

--1.2
/*
 El ejercicio nos pide además que el precio (columna price) se muestre incrementado en un 
8%. 

price * 1.08
 */
SELECT title_id, title, type, price * 1.08 , price FROM titles;

--1.3
/*
 Por último, nos solicitan las publicaciones ordenadas por tipo y título. Esto significa que 
ordenamos las publicaciones por tipo y, si se presenta el caso de que dos tuplas o filas 
posean el mismo tipo, el motor de base de datos ordena este subconjunto por título. 
 */

SELECT title_id, title, type, price * 1.08 , price FROM titles
ORDER BY type, title;

/*
 Observe que la cuarta columna del conjunto resultado no posee encabezado. Este 
encabezado se puede definir proporcionando un alias para esa columna.
Asi: 
 */
SELECT title_id, title, type, price * 1.08 "PRECIO +8%", price FROM titles
ORDER BY type, title;

-----------------------------------------------------------------

-- Alias de columna 

-- SQL Server:
/*
 Especificamos un alias directamente después del nombre de la columna. 
Recordemos que en el caso de que el alias incluya espacios, debemos encerrarlo 
entre comillas: 
 */
SELECT au_lname 'Apellido del autor', city ciudad 
FROM authors;

-- PostgreSQL (y SQL Server):
/*
 Especificamos el alias usando la cláusula AS: 
 */
SELECT au_lname AS Apellido, city ciudad 
FROM authors;

/*
Si el alias de columna posee más de una palabra, además debemos encerrar 
el nombre entre comillas dobles: 
*/
SELECT au_lname AS "Apellido del autor", city ciudad 
FROM authors;

-- SQL Server y PostgreSQL:
--Se puede hacer uso de un Alias sin la cláusula AS;
SELECT au_lname "Apellido del autor" , city ciudad 
FROM authors;

------------------------------------------------------------------------- 
---------------------- E j e r c i c i o   2 ---------------------------- 
------------------------------------------------------------------------.
/*
 2. Reescriba la consulta del ejercicio 1 pero proporcionando el alias precio actualizado para la 
columna calculada.
 */
SELECT title_id, title, type, price * 1.08 "Precio Actualizado", price FROM titles
ORDER BY type, title;

SELECT title_id, title, type, price * 1.08 "PRECIO +8%", price FROM titles
ORDER BY type, title;

------------------------------------------------------------------------- 
---------------------- E j e r c i c i o   3 ---------------------------- 
------------------------------------------------------------------------.
/*
 3. Modifique la consulta del ejercicio 2 a fin de obtener los datos por orden descendente de 
precio actualizado.  
*/

SELECT title_id, title, type, price * 1.08 "Precio Actualizado", price FROM titles
ORDER BY "Precio Actualizado" DESC;

------------------------------------------------------------------------- 
---------------------- E j e r c i c i o   4 ---------------------------- 
------------------------------------------------------------------------.
/*
4. Es posible expresar el número de orden en la lista de salida del SELECT para identificar la 
columna sobre la cual se desea ordenar. Por ejemplo: ORDER BY 5. Reescriba la consulta de 
esta forma. 
*/

SELECT title_id, title, type, price * 1.08 "Precio Actualizado", price FROM titles
ORDER BY 4 DESC;


-- Constantes en la lista de salida del SELECT 
/*
Podemos especificar valores literales (fijos) como parte de la lista de salida del SELECT. 
 */

-- SQL Server:
/*
 La siguiente sentencia SQL utiliza el operador de concatenación + para generar un 
conjunto resultado con una única columna de salida: 
 */
SELECT 'El apellido del empleado es ' + lname  'Datos del empleado' 
FROM employee;

-- PostgreSQL:
/*
 El operador de concatenación en PostgreSQL es ||. Los literales en la lista de 
salida del SELECT deben encerrarse entre comillas simples: 
*/
SELECT 'El apellido del empleado es ' || lname  
AS "Datos del empleado" 
FROM employee;

------------------------------------------------------------------------- 
---------------------- E j e r c i c i o   5 ---------------------------- 
------------------------------------------------------------------------.
/*
 5. Obtenga en una única columna el apellido y nombres de los autores separados por coma 
con una cabecera de columna Listado de Autores. Ordene el conjunto resultado.
 */

-- SQL Server:
SELECT au_lname + ', ' + au_fname 
'Listado de Autores'
FROM authors
ORDER BY "Listado de Autores";

SELECT 'Autor: ' + au_lname + ', ' + au_fname 
"Listado de Autores"
FROM authors
ORDER BY "Listado de Autores" desc;

-- PostgreSQL:
SELECT au_lname || ', ' || au_fname 
AS "Listado de Autores"
FROM authors
ORDER BY "Listado de Autores";

SELECT 'Autor: ' || au_lname || ', ' || au_fname 
"Listado de Autores"
FROM authors
ORDER BY "Listado de Autores";


/*
 Los motores de bases de datos muchas veces proporcionan conversión entre tipos de datos 
automática. Otras veces, tenemos que hacer nosotros mismos una conversión explícita entre 
tipos. 
 
Siempre es más seguro que tengamos el control total sobre el código, y esto lo logramos 
haciendo la conversión explícita entre tipos de datos. 
 */
------------------------------------------------------------------------- 
---------------------- E j e r c i c i o   6 ---------------------------- 
------------------------------------------------------------------------.
/*
6. Obtenga un conjunto resultado para la tabla de 
publicaciones que proporcione, para cada fila, una 
salida como la siguiente. 
bu1032 posee un valor de $19.99
bu1111 posee un valor de $11.95
¿Qué sucede?
*/
-- SQL Server (NO ANDA):
SELECT title_id + ' posee un valor de $' + price 
FROM titles
ORDER BY title_id;

-- PostgreSQL (SI ANDA):
SELECT title_id || ' posee un valor de $' || price 
FROM titles
ORDER BY title_id;

/*
 Como en SQL Server NO ANDA por la conversion de datos:

Acá necesitamos asegurarnos de qué tipo de dato es cada columna. Podemos volver al 
script de creación de pubs para averiguarlo. También podemos usar el Administrador 
Corporativo. Pero más rápido es usar un stored procedure del sistema que proporciona 
SQL Server y que brinda esta información: sp_help. 
 
Por ejemplo, para titles ejecutamos: 
 
sp_help titles 
*/

sp_help titles;
sp_help N'titles';
 sp_help 

 --REVISAR sp_help NO PUEDO VER LOS COMPONENTES DE LAS TABLAS
 
 /*
  Conversión de datos numéricos a caracter 
 
Podemos convertir datos numéricos a caracter de manera explícita usando la función CAST: 
 
  
CAST (columna-a-convertir AS tipo-de-dato-destino) 
 
Por ejemplo: 
 */
SELEct CAST(price AS varchar) 
   from titles;
 
/*
 es:  
 
convert (tipo-de-dato-destino, columna-a-convertir) 
 
Por ejemplo: 
 */
SELECT CONVERT(varchar, price) 
   from titles;
 
/*
PostgreSQL también proporciona la siguiente sintaxis: 
 
columna-a-convertir::tipo-de-dato-destino 
 
Por ejemplo: 
 */
SELECT price::varchar(5) 
   FROM titles;
 
 
SELECT price::numeric(5,1) 
   FROM titles;

  
------------------------------------------------------------------------- 
---------------------- E j e r c i c i o   6 ---------------------------- 
------------------------------------------------------------------------.
/*
7. Reescriba el ejercicio 6 utilizando estas variantes explícitas de conversión de tipos. 
*/
-- forma generica:
SELEct CAST(price AS varchar) 
   from titles;

 -- SQL Server:
SELEct title_id + ' posee un valor de $' + CAST(price AS varchar) 
FROM titles
ORDER BY title_id;

SELECT title_id + ' posee un valor de $' + CONVERT(varchar, price) 
FROM titles
ORDER BY title_id;

-- PostgreSQL:
SELECT title_id || ' posee un valor de $' || CAST(price AS varchar)
FROM titles
ORDER BY title_id;

SELECT title_id || ' posee un valor de $' || price::varchar(5) 
FROM titles
ORDER BY title_id;



/*
-------------------------------------------------------------------------
-------------------------------------------------------------------------
2. La cláusula WHERE
-------------------------------------------------------------------------
-------------------------------------------------------------------------
*/
/*
Hasta ahora no hemos especificado cláusulas WHERE. Las cláusulas WHERE nos permiten 
especificar una condición que las filas deben cumplir a fin de formar parte de la lista de 
salida del SELECT. 
*/
/*
Operadores 
 
Para especificar las condiciones de las cláusulas WHERE necesitamos de operadores 
relacionales y lógicos. 
 
Los operadores relacionales son >, >=, <, <=, = y <>.  
 
Los operadores lógicos son AND, OR y NOT. 
*/

------------------------------------------------------------------------- 
---------------------- E j e r c i c i o   8 ---------------------------- 
------------------------------------------------------------------------.
/*
8. Obtenga título y precio de todas las publicaciones que no valen más de $13. Pruebe definir 
la condición de WHERE con el operador NOT. 
*/

SELECT title , price
FROM titles
WHERE price <= 13
ORDER BY price DESC;

SELECT title , price
FROM titles
WHERE NOT price > 13
ORDER BY price DESC;


/*  
Fechas en cláusulas WHERE 
 
Las fechas se especifican entre comillas simples. El formato depende de la configuración del 
motor de base de datos. Un formato usual es mm/dd/aaaa. 
*/
SELECT ord_date
FROM sales;

SELECT ord_date
FROM sales
WHERE ord_date < '1993-09-14 00:00:00.000';

SELECT ord_date
FROM sales
WHERE ord_date < '01/01/1994';

SELECT ord_date
FROM sales
WHERE ord_date < '1994';


/*
  
El predicado BETWEEN 
 
Recordemos que el predicado BETWEEN especifica la comparación dentro de un intervalo entre 
valores cuyo tipos de datos son comparables: 
 
WHERE precio BETWEEN 5 AND 10 
 
La cláusula NOT se puede utilizar con BETWEEN para indicar que la condición debe evaluar 
contra lo que existe fuera del intervalo: 
 
WHERE precio NOT BETWEEN 5 AND 10
*/
SELECT title , price
FROM titles
ORDER BY price DESC;

SELECT title , price
FROM titles
WHERE  price > 5
AND price < 10
ORDER BY price DESC;

SELECT title , price
FROM titles
WHERE price BETWEEN 5 AND 10
ORDER BY price DESC;

SELECT title , price
FROM titles
WHERE price NOT BETWEEN 5 AND 10
ORDER BY price DESC;


------------------------------------------------------------------------- 
---------------------- E j e r c i c i o   9 ---------------------------- 
------------------------------------------------------------------------.
/*
 9. Obtenga los apellidos y fecha de contratación de todos los empleados que fueron 
contratados entre el 01/01/1991 y el 01/01/1992. Use el predicado BETWEEN para elaborar la 
condición. 
 */

SELECT lname, hire_date
FROM employee
WHERE hire_date BETWEEN '01/01/1991' AND '01/01/1992'
ORDER BY hire_date;

SELECT lname, hire_date
FROM employee
WHERE hire_date > '1991' 
AND hire_date < '1992'
ORDER BY hire_date;


/*
 
El operador [NOT] IN 
 
Recordemos que el operador IN especifica la comparación cuantificada: hace una lista de un 
conjunto de valores y evalúa si un valor está en la lista. La lista debe expresarse entre 
paréntesis: 
 
WHERE precio IN (25, 30) 

IN:
 Verifica si un valor está dentro de un conjunto de valores (Encuentra los valores de cierto campo)
 Ej:
*/
SELECT title , price
FROM titles
WHERE price IN (10, 30, 20);	

SELECT title , price
FROM titles
WHERE price = 10 
OR price = 30
OR price = 20;

SELECT title , price
FROM titles
WHERE price = ANY (10, 30, 20);



------------------------------------------------------------------------- 
---------------------- E j e r c i c i o  10 ---------------------------- 
------------------------------------------------------------------------.
 /*
10. Obtenga los códigos, domicilio y ciudad de los autores con código 172-32-1176 y  
238-95-7766. Utilice el operador IN para definir la condición de búsqueda. 
Modifique la consulta para obtener todos los autores que no poseen esos códigos. 
*/

SELECT au_id, address, city
FROM Authors
WHERE au_id IN ( '172-32-1176', '238-95-7766');


SELECT au_id, address, city
FROM Authors
WHERE au_id = '172-32-1176' OR 
      au_id = '238-95-7766';

--La negación (todos los autores que no son estos dos), sería: 
 
SELECT au_id, address, city
FROM Authors
WHERE au_id NOT IN ('172-32-1176', '238-95-7766');



/*
El predicado LIKE. Caracteres comodín. 
 
Recordemos que el predicado LIKE permite especificar una comparación de caracteres 
utilizando caracteres comodín (wild cards) para recuperar filas cuando solo se conoce un 
patrón del dato buscado. LIKE generalmente se utiliza sobre columnas de tipo caracter. 
 
Los caracteres comodín generalmente soportados son: 
% 0 a n caracteres (de cualquier caracter). 
_    Exactamente un caracter (de cualquier caracter). 
[]  Exactamente un caracter del conjunto o rango especificado, por ej.: [aAc] o [a-c]
Ej:
 */
SELECT title_id, title
FROM titles
WHERE title LIKE 'Computer%';

/*
 LIKE
 Comodín 									 Significado
%				 	Cualquier string de cero o más caracteres
 _					Cualquier carácter simple
 [ ]				Cualquier carácter simple dentro del rango especificado entre corchetes
 [^]				Cualquier carácter simple no incluido dentro del rango especificado entre corchetes

Este ejemplo usa un conjunto de valores para 
encontrar aquellos nombres de autores que 
comiencen con las letras B, D, E, or R: 
*/
    select * from authors
                         where au_lname LIKE '[BDER]%';
/*
  Este ejemplo usa un rango de caracteres para 
encontrar los autores cuyo nombre comienza con 
cualquier letra mayúscula entre la D y la H inclusive:
*/
 select * from authors
                         where au_lname LIKE '[D-H]%';
/*
Este ejemplo usa un conjunto de valores, un 
comodín de posición, y un rango de caracteres para 
encontrar todas las salas cuyo nombre tenga seis 
caracteres y que los cuatro primeros sean ‘SALA‘, el 
quinto puede ser cualquier caracter y el sexto sea un 
número:
*/
 select * from titles
where title_id LIKE 'BU_[0-1]_[0-9]'; 

select * from titles
where title_id LIKE 'BU[0-9]%';


------------------------------------------------------------------------- 
---------------------- E j e r c i c i o  11 ---------------------------- 
------------------------------------------------------------------------.
 /*
11. Obtenga código y título de todos los títulos que incluyen la palabra Computer en su título.  
*/

SELECT title_id, title
FROM titles
WHERE title LIKE '%computer%';


/*
Valores NULL 
 
Un valor NULL para una columna indica que el valor para esa columna es desconocido. No es 
lo mismo que blanco, cero o cualquier otro valor discreto. A veces puede significar que el 
valor para una columna particular no es significativo.  
 
Los valores NULL son casos especiales y deben tratarse en forma especial cuando se realizan 
comparaciones. 
A los propósitos del ordenamiento, los valores NULL son considerados los más bajos. 
 */
SELECT title_id, title, price FROM Titles
WHERE price IS NULL;	

------------------------------------------------------------------------- 
---------------------- E j e r c i c i o  12 ---------------------------- 
------------------------------------------------------------------------.
/*
12. Obtenga el nombre, ciudad y estado de las editoriales cuyo estado (columna state) no 
está definido. Recordemos que para ello debemos utilizar la cláusula IS (o su negación IS 
NOT)  
¿Qué sucede si explícitamente compara la columna contra el valor NULL?. 
*/

SELECT pub_name, city, state FROM Publishers 
WHERE state IS NULL;

-- No aparece nada (EXISTEN VALORES), si comparo explícitamente la columna contra el valor NULL. 
SELECT pub_name, city, state FROM Publishers 
WHERE state = NULL;
-- WHERE state = NULL; Esta cláusula no dispara ningún error, pero no devuelve lo que esperamos. 


/*
-------------------------------------------------------------------------
-------------------------------------------------------------------------
3. Limitar la cantidad de tuplas
-------------------------------------------------------------------------
-------------------------------------------------------------------------
*/

-- SQL Server:
/*
 Obtenemos las n primeras tuplas de un query SQL utilizando el modificador TOP. 
Por ejemplo: 
*/
SELECT TOP 1 * 
FROM titles;

-- Solo aparece n (1) tupla(s) a la salida de la consulta


-- PostgreSQL:
/*
En PostgreSQL obtenemos un comportamiento similar usando la cláusula
 LIMIT. Por ejemplo:
 */ 
SELECT * 
FROM titles 
LIMIT 1;



/*
-------------------------------------------------------------------------
-------------------------------------------------------------------------
4. Funciones 
-------------------------------------------------------------------------
-------------------------------------------------------------------------
*/

----------------------------- 4.1. Fechas ------------------------------- 

-- Componentes de una fecha

-- SQL Server:
/*
YEAR(columna) retorna el año de la fecha como un entero de cuatro dígitos,
 MONTH(columna) proporciona el mes de la fecha como un entero de 1 a 12. 
DAY (columna) retorna el día del mes de la fecha como un entero.  
*/
SELECT YEAR(pubdate), pubdate
FROM titles;


-- PostgreSQL:
/*
En PostgreSQL debemos usar la funcion date_part. Por ejemplo 
 
date_part('year', columna) retorna el año de la fecha como un número de 
doble precisión. 
  
date_part('month', columna) retorna el mes de la fecha como un número
 de doble precisión. 
 
date_part('day', columna) retorna el mes de la fecha como un número de 
doble precisión. 
 */
SELECT date_part('year', pubdate), pubdate
FROM titles;
/*
Podemos obtener el mismo resultado con la función EXTRACT. Por ejemplo: 
 
EXTRACT('year' FROM columna) retorna el año de la fecha como un número 
de doble precisión. 
  
EXTRACT ('month' FROM columna) retorna el mes de la fecha como un 
número de doble precisión. 
 
EXTRACT ('day' FROM columna) retorna el mes de la fecha como un número 
de doble precisión. 
*/
SELECT EXTRACT('year' FROM pubdate) , pubdate
FROM titles;



------------------------------------------------------------------------- 
---------------------- E j e r c i c i o  13 ---------------------------- 
------------------------------------------------------------------------.
/*
13. La información de publicaciones vendidas reside en la tabla Sales. Liste las filas de 
ventas correspondientes al mes de Junio de cualquier año.
*/
-- "Junio" = MES [6]

-- SQL Server:
SELECT *
FROM Sales
WHERE MONTH(ord_date) = 6;


-- PostgreSQL:
SELECT *
FROM Sales
WHERE date_part('MONTH', ord_date) = 6;

SELECT *
FROM Sales
WHERE EXTRACT('MONTH' FROM ord_date) = 6;



---------------------- Fecha actual 

-- SQL Server (y PostgreSQL):
/*
CURRENT_TIMESTAMP retorna la fecha y hora actual como un valor datetime. Se 
invoca sin paréntesis. 
 */
SELECT CURRENT_TIMESTAMP;

-- PostgreSQL:
/*
PostgreSQL proporciona también la función CURRENT_TIMESTAMP que retorna 
la fecha y hora actuales. 
 
La función now() retorna también el mismo resultado. 
*/
SELECT CURRENT_TIMESTAMP;
SELECT now();


---------------------- Fechas como texto 

-- SQL Server:
/*
Ya vimos que podíamos convertir el dato de una columna a un tipo destino a 
través de la función convert(). convert() posee una versión extendida que 
permite convertir datos de columnas de tipo datetime a diferentes formatos de 
visualización de texto. La sintaxis es: 
 
convert (varchar, columna-datetime, codigo-de-formato) 
Ej:
*/
SELECT CONVERT(varchar, hire_date, 2), hire_date
   FROM Employee; 
/*
codigo-de-formato es un código que establece como se va a mostrar la fecha en 
formato varchar. Por ejemplo, el formato 3 muestra la fecha con formato 
dd/mm/yyyy: 
 */
SELECT CONVERT(varchar, hire_date, 3), hire_date
   FROM Employee; 


-- PostgreSQL:
/*
No se puede hacer la conversion, tampoco cambiar el formato,
Igualmente se hace automaticamente:
*/
/*
SELECT CAST( hire_date as varchar), hire_date
   FROM Employee;

SELECT hire_date::varchar(10), hire_date
   FROM Employee;
*/


----------------------------- 4.2. Strings ------------------------------- 

----------------- Subcadenas 
/*
La función substring() extrae una subcadena de una cadena principal. Su sintaxis es: 
substring (columna-o-expresion, desde, cantidad) 
columna-o-expresion es la cadena desde la cual se extraerán los caracteres. desde es la 
posición de inicio de la extracción. substring() retorna una cadena de tipo varchar. Por 
ejemplo: 
substring (columna-o-expresion, desde, cantidad)
*/
SELECT substring(title, 5, 8) 
FROM titles;

----------------- Conversión de números a strings

-- SQL Server:
/*
La función str() convierte una expresión numérica a una cadena. Su sintaxis es: 
str (expresion-numerica, longitud-total, cantidad-decimales) 
donde longitud es la longitud total incluyendo la coma y las cifras decimales. Por 
ejemplo: 
str (expresion-numerica, longitud-total, cantidad-decimales) 
*/
SELECT STR(price, 4, 2) 
from titles;

-- PostgreSQL (y SQL Server):
/*
En PostgreSQL utilizamos la función CAST ya vista 
*/
SELECT CAST( price as varchar(4) ), price
   FROM titles;
--SQL Server no soporta cadenas mas cortas de la cantidad de caracteres que tiene (cadena completa)


----------------- Otras funciones de manejo de Strings 

-- SQL Server:
/*
T-SQL soporta también las funciones manejo de texto right(), upper(),
 lower(), rtrim() y ltrim().
 */
SELECT right(title, 10), title
FROM titles;

SELECT lower(title), title
FROM titles;

SELECT ltrim(title,'co'), title
FROM titles;

SELECT rtrim(title,'[?smyht]'), title
FROM titles;
-- NO SE DIFERENCIA ENTRE MAYUSCULAS y minusculas


-- PostgreSQL:
/*
PostgreSQL soporta upper() y  lower(). 
 
Proporciona la función TRIM, que permite eliminar los caracteres 
especificados del principio, final o principio y final de una cadena. Por 
ejemplo, para eliminar cualquier caracter 'E' al principio de la cadena: 
 */
SELECT TRIM(LEADING 'E' FROM title) 
   from titles; 
/*
Para eliminar cualquier caracter 's' al final de la cadena: 
 */
SELECT TRIM(TRAILING 's' FROM title) 
   from titles;
 
 /*
y para eliminar cualquier caracter 's' al principio o final de la cadena: 
 */
SELECT TRIM(BOTH 's' FROM title) 
   from titles;   
 /*
En cualquier caso, si se omite el caracter a eliminar, se asume espacio.
*/
---- NO SE DIFERENCIA ENTRE MAYUSCULAS y minusculas




/*
SELECT 
FROM 
WHERE 
ORDER BY 
*/