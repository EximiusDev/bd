/*
-- mayor venta por orden (sin title_id)
select
	s1.ord_num,
	MAX(s1.qty * t1.price) mayor
from
	sales s1
	join titles t1 on t1.title_id = s1.title_id
group by s1.ord_num;

-- total por titulo x venta
select
	s2.ord_num,
	s2.title_id,
	s2.stor_id,
	s2.qty * t2.price total
from
	sales s2
	join titles t2 on t2.title_id = s2.title_id;

-- mayor por orden (con title_id)
select
	mayores.ord_num,
	totales.stor_id,
	totales.title_id
from
	(select
		s1.ord_num,
		MAX(s1.qty * t1.price) mayor
	from
		sales s1
		join titles t1 on t1.title_id = s1.title_id
	group by s1.ord_num) mayores
join (select
		s2.ord_num,
		s2.title_id,
		s2.stor_id,
		s2.qty * t2.price total
	from
		sales s2
		join titles t2 on t2.title_id = s2.title_id) totales
		on totales.ord_num = mayores.ord_num
		and totales.total = mayores.mayor;
*/

-- final
select
	distinct s.ord_num,
	totales.stor_id,
	totales.title_id,
	case when mayores.cont > 1
		then 'Mas de una publicacion en la venta'
		else 'Unica publicacion en la venta'
	end
from
	sales s
join
	(select
		s1.ord_num,
		MAX(s1.qty * t1.price) mayor,
		count(s1.title_id) cont
	from
		sales s1
		join titles t1 on t1.title_id = s1.title_id
	group by s1.ord_num) mayores	-- tabla de sales con la mejor ganancia
	on mayores.ord_num = s.ord_num
join (select
		s2.ord_num,
		s2.title_id,
		s2.stor_id,
		s2.qty * t2.price total
	from
		sales s2
		join titles t2 on t2.title_id = s2.title_id) totales	-- tabla de sales x titles con cada total
	on totales.ord_num = mayores.ord_num
	and totales.total = mayores.mayor;


