select
	s.ord_num,
	best.stor_id,
	best.title_id,
	case
		when COUNT(s.title_id) > 1 then 'only title'
		else 'more titles'
	end as Observations
from
	sales s
	join (
	select
		maxs.ord_num,
		totals.stor_id,
		totals.title_id,
		max_revenue revenue
	from
		(select
			s2.ord_num,
			max(price*s2.qty) max_revenue
		from
			sales s2
			join titles t3 on t3.title_id = s2.title_id
		group by s2.ord_num
		) maxs
		join (
		select
			s3.ord_num,
			s3.stor_id,
			s3.title_id,
			s3.qty*t2.price revenue
		from
			sales s3
			join titles t2 on t2.title_id = s3.title_id
		order by revenue
		) totals on totals.ord_num = maxs.ord_num and totals.revenue = maxs.max_revenue
	) best on best.ord_num = s.ord_num