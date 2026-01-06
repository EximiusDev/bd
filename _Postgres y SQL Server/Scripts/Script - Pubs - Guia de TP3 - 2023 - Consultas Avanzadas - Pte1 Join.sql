-- USANDO DataBase pubs:

USE pubs;

------------------------------------------------------------------------

/*
 ============================================
SQL: Guía de Trabajo Nro. 3  
Consultas avanzadas 
Parte 1:  Joins 
 ============================================
 */

/*
-------------------------------------------------------------------------
-------------------------------------------------------------------------
1. Consultas que involucran más de una 
relación 
Expresiones JOIN 
-------------------------------------------------------------------------
-------------------------------------------------------------------------
*/

--------------------------- 1.1.  Producto cartesiano -------------------
/*
El Producto Cartesiano de dos relaciones R y S es el resultado de “emparejar” una tupla de R 
con una tupla de S es una tupla más larga, con un componente para cada una de los 
componentes de las tuplas que lo constituyen. 
Por convención, los componentes de R (el operando de la izquierda) preceden a los 
componentes de S en el orden de atributos del resultado. 
Ejemplo  
Supongamos las  relaciones R y S con los schemas y tuplas siguientes:
A B 
1 2 
3 4

B C D 
2 5 6 
4 7 8 
9 10 11

Lo que hacemos es combinar una tupla de R con cada una de las tuplas de S

Relación R 
A B
1 2

Relación S
B C D 
2 5 6 
4 7 8 
9 10 11

Producto Cartesiano
A R.B 	S.B C D
1 2 	2 	5 6  
1 2 	4 	7 8 
1 2 	9 	10 11

Como vemos, cuando el nombre de un atributo se repite, lo prefijamos con el nombre de la relación (A) y (B).  

De manera similar, para la segunda tupla de R:
3 4

2 5 6 
 
4 7 8
9 10 11 


3 4 	2 5 6 
3 4 	4 7 8 
3 4 	9 10 11

Por lo tanto el producto cartesiano consiste de las siguientes seis tuplas: 
 
A R.B S.B C D 
1 2 2 5 6 
1 2 4 7 8 
1 2 9 10 11 
3 4 2 5 6 
3 4 4 7 8 
3 4 9 10 11 
 */


-- SQL Server:
/*
Implementamos la solución en T-SQL de la siguiente manera:
 */
CREATE TABLE R1 ( 
    A 	Integer, 
    B 	Integer 
   );
    
 
CREATE TABLE S1 ( 
    B 	Integer, 
    C 	Integer, 
    D 	Integer 
   );
 
 
INSERT R1 VALUES (1, 2);
INSERT R1 VALUES (3, 4); 
 
INSERT S1 VALUES (2, 5, 6); 
INSERT S1 VALUES (4, 7, 8); 
INSERT S1 VALUES (9, 10, 11); 
 
 
SELECT A, R1.B 'R1.B', S1.B 'S1.B', C, D   
   FROM R1 CROSS JOIN S1;

--forma alternativa
SELECT A, R1.B 'R1.B', S1.B 'S1.B', C, D   
   FROM R1, S1;



/*
Veamos la tabla authors: 
*/
Select COUNT(*) FROM authors
 /*
Tenemos 23 autores  
Podemos combinar cada autor con todos los demás usando la siguiente sentencia: 
*/
SELECT a1.au_lname, a1.city, a2.au_lname, a2.city 
FROM authors a1 CROSS JOIN authors a2;

--..obtenemos 529 filas. (cada uno de los 23 autores combinados con 23 autores)

/*
 La sintaxis de CROSS JOIN tiene exactamente el mismo efecto que especificar las tablas en la 
cláusula FROM sin especificar ninguna cláusula de JOIN entre ellas: 
 */
SELECT a1.au_lname, a1.city, a2.au_lname, a2.city 
   FROM authors a1, authors a2;

--consulta anterior	
SELECT A, R1.B 'R1.B', S1.B 'S1.B', C, D   
   FROM R1, S1;

/*
Podemos mejorar la consulta a fin de evitar que un autor se “empareje” con si mismo. Por 
ejemplo: 
 */
SELECT a1.au_lname, a1.city, a2.au_lname, a2.city 
   FROM authors a1 CROSS JOIN authors a2 
   WHERE a1.au_lname <> a2.au_lname;

/*
 Esta consulta no parece ser muy útil, pero podemos adecuarla para -por ejemplo- listar todos 
los autores que viven en una misma ciudad:
 */

SELECT a1.au_lname, a2.au_lname, a1.city, a2.city 
FROM authors a1 CROSS JOIN authors a2 
WHERE a1.au_lname <> a2.au_lname AND 
a1.city = a2.city;

/*
El query funciona bien. El autor Straight vive en Oakland y el autor Green también (A)  
Sin embargo, todavía tenemos el problema de que cada tupla aparece dos veces... Straight se 
“empareja” con Green (A), y está bien, pero también Green se “empareja” con Straight (B).
 */

-- Podemos resolver esto modificando la consulta una vez más: 
 SELECT a1.au_lname, a2.au_lname, a1.city, a2.city 
   FROM authors a1 CROSS JOIN authors a2 
   WHERE a1.au_lname < a2.au_lname AND 
         a1.city = a2.city;

/*
 Ahora tenemos que Green “se empareja” con Straight (A), a la vez que evitamos que Straight 
se empareje con Green. 
 */


-----------------------   1.2. Natural Join  ----------------------------- 

-- En PostgreSQL (SQL Server no soporta Natural Joins)

/*
El Natural Join de dos relaciones R y S es el resultado de “emparejar” una tupla de R con una 
tupla de S es una tupla más larga solo cuando ambas tuplas coincidan en los valores de sus 
atributos comunes. 
 
 
Ejemplo  
 
Supongamos las  relaciones R y S con los schemas y tuplas siguientes: 

Relación R 
A B
1 2

Relación S
B C D 
2 5 6 
4 7 8 
9 10 11

Lo que hacemos es combinar una tupla de R con alguna de tupla de S que posea el mismo valor para el atributo B 

Natural Join
A B C D 
1 2 5 6
El atributo común no posee el mismo valor
El atributo común no posee el mismo valor


De manera similar, para la segunda tupla de R: 

Natural Join
A B C D 
El atributo común no posee el mismo valor
3 4 7 8 
El atributo común no posee el mismo valor



El natural join consiste entonces de las siguientes dos tuplas:  
 
A B C D 
1 2 5 6 
3 4 7 8

Implementamos la solución en PostgreSQL de la siguiente manera: 
 */
SELECT * 
   FROM R NATURAL JOIN S;

-- SQL Server no soporta Natural Joins.
	

CREATE TABLE R ( 
    A 	Integer, 
    B 	Integer 
   );
    
 
CREATE TABLE S ( 
    B 	Integer, 
    C 	Integer, 
    D 	Integer 
   ); 
 
INSERT R VALUES (1, 2);
INSERT R VALUES (3, 4); 
 
INSERT S VALUES (2, 5, 6); 
INSERT S VALUES (4, 7, 8); 
INSERT S VALUES (9, 10, 1); 

------------------------ 1.3. Equi INNER Joins --------------------------- 

/*
 
Un equi JOIN retorna solo las tuplas que poseen valores iguales para las columnas 
especificadas. 
El operador de comparación siempre es la igualdad (=) 
 
En la práctica, este es el tipo de JOIN más usado, y vamos a estar enlazando las tablas 
generalmente a través de las columnas que las asocian en el modelo físico (Primary Keys y 
Foreign Keys).
 */

/*
Ejemplo  
 
Supongamos las  relaciones R y S con los schemas y tuplas siguientes:

 Relación R 
A B
1 2

Relación S
B C D 
2 5 6 
4 7 8 
9 10 11

 y queremos obtener todos los atributos de ambas relaciones para cuando se cumpla que el 
atributo A de la relación R “se empareje” con el atributo D de la relación S:  
 */
SELECT R.*, S.*  
   FROM R, S 
   WHERE R.A = S.D;

--o, mejor aún, con la sintaxis de SQL-92: 
 
 
SELECT R.*, S.*  
   FROM R INNER JOIN S 
             ON R.A = S.D;

/*
Lo que hacemos es combinar una tupla de R con alguna de tupla de S que posea el mismo valor para el atributo especificado

Se fija para cada carga de valores Si A y D son iguales.
Si efectivamente son iguales, los atributos B y 
C formarán parte de la salida del SELECT 

En este ejemplo solo se produce coincidencia en este caso:

Equi JOIN

A R.B 	S.B C 	D 
1 	2 	9 	10 	1

*/

----------------------------


/*
Supongamos que deseamos obtener el título de las  
publicaciones junto al nombre de la editorial que las publicó.  
 
Como estos datos residen en dos tablas diferentes, es necesario 
establecer un join.



En este caso las tuplas a “emparejar” deben ser aquellas que  
hagan referencia a la misma editorial.  
 
En otras palabras, cada tupla a comparar debe poseer el mismo  
valor para la columna pub_id: 
 */
-- El siguiente es el Equi JOIN entre que lleva a cabo lo solicitado:

SELECT T.title, P.pub_name  
   FROM Titles T INNER JOIN Publishers P 
                    ON T.pub_id = P.pub_id;	

/*
Las columnas en común que establecen la asociación se especifican a través de la cláusula ON 
 */

/*
 
El motor de base de datos considera todos los pares de tuplas, uno de titles y otro de 
publishers.  
 
El atributo pub_id de la tupla titles debe tener el mismo código de editorial que el atributo 
pub_id en la tupla publishers. Esto es, las dos tuplas deben hacer referencia a la misma 
editorial. 
 
Si se encuentra un par de tuplas que satisface esta condición, los atributos title de la tupla 
de titles y pub_name de la tupla de  publishers se producen como parte de la salida del 
SELECT. 
 */

--------------------------------------------------------------------------
--------  1.4. Enlazar más de dos tablas en un Equi INNER JOIN  ---------- 

/*
Muchas veces necesitaremos “navegar” a través de nuestro modelo físico para extraer 
información de tablas vinculadas aunque no necesariamente de manera directa.
 
Por ejemplo, recordemos un fragmento del modelo físico de Pubs: 

Supongamos que queremos obtener los nombres de la editoriales que han editado 
publicaciones del autor con código '998-72-3567'. 

Los nombres de las editoriales residen en la tabla Publishers (A). 
...pero los códigos de los autores recién los encontramos en la relación TitleAuthor (B) 
 */

/*
Necesitaremos “navegar” a través de las columnas Primary Key y Foreign Key a fin de llegar a 
unir las tablas que resultan imprescindibles a fin de extraer la información que necesitamos. 

para eso igualamos ambos title_id y pub_id respectivamente para TitleAuthor y Titles, y Titles y Publishers

Podríamos definir la siguiente consulta:
 */
SELECT P.pub_name 
FROM Publishers P INNER JOIN Titles T  
ON P.pub_id = T.pub_id 
INNER JOIN titleauthor TA 
ON T.title_id = TA.title_id    
WHERE TA.au_id = '998-72-3567';


-----------------------   1.5. Outer Joins  ----------------------------- 

/*
 Dangling tuple 
 
Una tupla que en un join no encuentra coincidencia con ninguna tupla de la otra relación se 
dice que es una dangling tuple.
 */

/*
En nuestro ejemplo de JOIN 
 
...suponíamos las  relaciones R y S con los schemas y tuplas siguientes:
	 	 
Relación R 
A B
1 2

Relación S
B C D 
2 5 6 
4 7 8 
9 10 1

...y queríamos obtener: 
 */
SELECT R.*, S.*  
   FROM R INNER JOIN S 
             ON R.A = S.D;

/*
Obteníamos coincidencia en:
1 2 9 10 1

Tenemos una tupla de R que nunca encontró coincidencia: 

3 4 

Esta tupla nunca será recuperada, ya que no encuentra coincidencia en la relación S. 
Lo mismo sucede por supuesto con dos tuplas de S. 
 */

/*
Ejemplo 
Supongamos que queremos obtener un listado de código de editorial, nombre de editorial 
junto a los códigos de publicaciones que han editado. 
Tendríamos:
 */
SELECT publishers.pub_id, pub_name, titles.title_id 
FROM publishers INNER JOIN titles 
ON publishers.pub_id = titles.pub_id;

/*
Estamos haciendo un JOIN entre las tablas Publishers y Titles:
mediante pub_id
*/	

/*
 Analicemos un poco los datos: 
 */
SELECT *  
FROM publishers 
/*
 
 
Tomemos, por ejemplo, la primer editorial listada, la editorial '0736' 
 
Busquemos si hay publicaciones de ella en la tabla Titles: 
 */
SELECT title_id, pub_id  
   FROM titles  
   WHERE pub_id = '0736' 
 /*
 
 
Obtenemos: 
 
Hay publicaciones. 

Ahora: 
Tomemos, por ejemplo, la editorial '1622':  
 */
  
SELECT title_id, pub_id  
   FROM titles  
   WHERE pub_id = '1622' 
 
   /*
Obtenemos: 
 
Esto significa que nunca recuperaremos a la editorial '1622' con el JOIN que escribimos. 
Simplemente porque no tiene publicaciones editadas y el JOIN no encontrará ninguna tupla en 
Titles para “emparejarse”.   
 
A estas tuplas de publishers las estamos perdiendo. Son dangling tuples.

Esto puede darse, por ejemplo, porque cargamos las Editoriales pero todavía no cargamos 
sus publicaciones.  
 
Básicamente, el query: 
 */
SELECT publishers.pub_id, pub_name, titles.title_id 
   FROM publishers INNER JOIN titles 
                     ON publishers.pub_id = titles.pub_id;
   
   /*
   ...retorna dieciocho filas en el resultado.  
Las filas corresponden a las editoriales que  
poseen títulos publicados: 
    */
   
   /*
   Podemos recuperar esas editoriales “perdidas” escribiendo, en lugar de un 
INNER JOIN, un LEFT JOIN:
    */

   SELECT publishers.pub_id, pub_name, titles.title_id 
   FROM publishers LEFT JOIN titles 
                      ON publishers.pub_id = titles.pub_id;
   
   /*
Ahora obtenemos tuplas adicionales, correspondientes  
a las editoriales que no poseen publicaciones:
    */
   
   /*
Observamos que ahora sí, recuperamos  a la  
editorial 1622 (A) aún cuando ésta no posea  
publicaciones editadas  
 
Al valor title_id se le ha asignado un  
NULL (B)


Las distinguimos porque poseen código de publicación con un valor NULL. 
 
 
 
 
Volviendo al ejemplo de las relaciones R y S, tendríamos
    */
  SELECT R.*, S.*  
   FROM R LEFT JOIN S 
             ON R.A = S.D;
   
   /*
  Como vemos, La tupla 
 
 3 4
 
...ahora es recuperada. 

    */
  
   /*
  El LEFT JOIN también puede escribirse como LEFT OUTER JOIN 
 
 
 
El RIGHT JOIN sigue exactamente la misma idea. 


La sentencia podría escribirse también de esta forma, con idéntico resultado: 
 */
   SELECT publishers.pub_id, pub_name, titles.title_id 
   FROM titles RIGHT JOIN publishers 
                  ON titles.pub_id  = publishers.pub_id;
   
   /* 
El RIGHT JOIN también puede escribirse como RIGHT OUTER JOIN 
 */
 
 /*
 
 Finalmente podemos usar la sintaxis FULL OUTER JOIN. 
   
    El FULL OUTER JOIN considera las dangling tuplas de ambos “lados”. En nuestro ejemplo 
obtenemos el mismo resultado:	
     */
   SELECT publishers.pub_id, pub_name, titles.title_id 
FROM publishers FULL OUTER JOIN titles 
ON publishers.pub_id = titles.pub_id;
   
   /*
   Aquí deberíamos obtener también publicaciones que hiciesen referencia a editoriales que no 
tuviesen ocurrencia en Publishers. Por supuesto, no obtenemos ninguna tupla de estas 
características 
 
Es difícil que necesitemos recuperar dangling tuples de ambos lados. 
Por ejemplo, podemos querer listar clientes aún cuando no tengan ocurrencias de facturas, 
pero difícilmente encontremos ocurrencias de facturas que no pertenezcan a algún cliente.
    */
   
/*
Volviendo al ejemplo de las relaciones R y S:

Relación R 
A B
1 2

Relación S
B C D 
2 5 6 
4 7 8 
9 10 1

	...tendríamos:	
 */
   SELECT R.*, S.*  
   FROM R FULL OUTER JOIN S 
             ON R.A = S.D; 
   

   ---------------------   1.6.  Tuple variables  --------------------------- 
   
   /*
    
A veces es necesario especificar un query que involucre dos o más tuplas de la misma tabla.  
 
Podemos listar una relación o tabla en la cláusula FROM cuantas veces la necesitemos, pero 
necesitamos una forma de referirnos a cada ocurrencia de ella. SQL nos permite definir, 
para cada ocurrencia de una tabla en la cláusula FROM, un “alias” que denominamos tuple 
variable. 
 
Luego, en las cláusulas SELECT y WHERE podemos eliminar la ambigüedad entre atributos de la 
o las tablas precediéndolos por la tuple variable apropiada y un punto. 
*/

/*
Ejemplo 
 
Supongamos que queremos obtener podemos querer saber acerca de pares de autores que 
viven en la misma ciudad:
 */
 SELECT Autor1.au_lname, Autor2.au_lname 
   FROM authors Autor1, authors Autor2 
   WHERE Autor1.city = Autor2.city AND 
         Autor1.au_lname < Autor2.au_lname; 
 
 
 /*
En la cláusula FROM vemos la declaración de dos tuple variables, Autor1 y Autor2 (A). Cada 
una es un alias para la tabla authors. En la cláusula SELECT las usamos para hacer 
referencia a los componentes name de las dos tuplas [au_lname] (B). 
Estos alias también son utilizados en la cláusula WHERE (C). 
 
La segunda condición en la cláusula WHERE (D) se incluye a fin de evitar que las tuple 
variables Autor1 y Autor2 hagan referencia a la misma tupla. (obtendríamos un autor que 
encontró una coincidencia consigo mismo). 
 */
 	
 SELECT Autor1.au_lname, Autor1.au_fname, Autor2.au_lname, Autor2.au_fname 
   FROM authors Autor1, authors Autor2 
   WHERE Autor1.city = Autor2.city AND 
         Autor1.au_lname < Autor2.au_lname; 
    