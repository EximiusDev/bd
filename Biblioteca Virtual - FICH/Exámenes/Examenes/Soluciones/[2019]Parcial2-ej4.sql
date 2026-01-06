-- componentes de prov 200
select
	idcomponente,
	count()
from
	provcomp
where
	idproveedor = 200;

-- proveedores con componentes de prov 200
select
	idproveedor
from
	provomp
where
	idcomponente in (select idcomponente from provcomp where idproveedor=200)
group by
	idproveedor
having
	count(idcomponente) = ()