USE pubs2;

--------------------------------
--EJ 1--
--------------------------------

SELECT au_lname, au_fname, title
	FROM authors A INNER JOIN titleauthor TA
						ON A.au_id = TA.au_id
				   INNER JOIN titles T
						ON TA.title_id = T.title_id
	ORDER BY au_lname;

--------------------------------
--EJ 2--
--------------------------------

SELECT pub_name, fname, lname
	FROM employee E INNER JOIN publishers P
		ON E.pub_id = P.pub_id
	WHERE E.job_lvl >= 200;

--------------------------------
--EJ 3--
--------------------------------

SELECT au_lname, au_fname, SUM(Total) Ingresos
	FROM authors A INNER JOIN titleauthor TA
					ON A.au_id = TA.au_id
				   INNER JOIN (	SELECT titles.title_id, titles.price * SUM(qty) Total
									FROM titles INNER JOIN sales S
												ON titles.title_id = S.title_id
									GROUP BY titles.title_id, price) T
					ON TA.title_id = T.title_id
	GROUP BY A.au_id, A.au_lname, A.au_fname
	ORDER BY Ingresos DESC;

--------------------------------
--EJ 4--
--------------------------------

SELECT type, AVG(price) Media
	FROM titles T
	GROUP BY T.type
	HAVING AVG(price) > 12
	ORDER BY Media;

--------------------------------
--EJ 5--
--------------------------------

SELECT 'Empleado mas reciente: ' + lname + ', ' + fname, hire_date
	FROM Employee E
	WHERE hire_date >= ALL (SELECT hire_date
								FROM employee);

--------------------------------
--EJ 6--
--------------------------------

SELECT DISTINCT P.pub_name
	FROM publishers P INNER JOIN titles T
		ON P.pub_id = T.pub_id
	WHERE T.type = 'business';

--------------------------------
--EJ 7--
--------------------------------

SELECT T.title_id, T.title			-- Los que no se vendieron en 1993 ni 1994
	FROM titles T INNER JOIN sales S
		ON T.title_id = S.title_id
	WHERE S.ord_date IS NOT NULL AND
			YEAR(S.ord_date) NOT IN (1993,1994)
UNION
SELECT T.title_id, T.title			-- Los que no se vendieron nunca
	FROM titles T
	WHERE T.title_id NOT IN (SELECT title_id
								FROM sales);

--------------------------------
--EJ 8
--------------------------------

SELECT title, pub_name, price
	FROM titles T INNER JOIN publishers P
		ON T.pub_id = P.pub_id
	WHERE T.price < (SELECT AVG(price)
						FROM titles
						WHERE pub_id = P.pub_id);

--------------------------------
--EJ 9--
--------------------------------

SELECT au_fname, au_lname, CASE(contract)
							WHEN 0 THEN 'No'
							ELSE 'Si'
							END
	FROM authors
	WHERE state = 'CA';

--------------------------------
--EJ 10--
--------------------------------

SELECT lname, CASE
				WHEN job_lvl > 200
					THEN 'Puntaje mayor que 200'
				WHEN job_lvl >= 100
					THEN 'Puntaje entre 100 y 200'
				ELSE 'Puntaje menor que 100'
				END Nivel, job_lvl
	FROM employee
	ORDER BY job_lvl DESC, lname;