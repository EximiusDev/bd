/*
create table PuntajeCampaign(
	idpuntajecampaign	integer		not null,
	idcampaign			integer		not null,
	au_id				varchar(11)	not null,
	puntaje				integer		not null,
	usuario				varchar(40),
	fechaultmodif		timestamp,
	constraint pk_puntajecampaign primary key (idpuntajecampaign),
	constraint fk_puntajecampaign foreign key (au_id) references authors(au_id)
);
*/

create or replace function tr_ins_sales()
returns trigger
as
$$
declare
	idpc	integer;
	punt	integer;
	ida		varchar(11);
	cursorauthor cursor for (select au_id from titleauthor where title_id = new.title_id);
begin
	-- id puntaje campaign
	idpc := (
		select max(idpuntajecampaign)+1
		from puntajecampaign pc);

	-- por cada author del title
	open cursorauthor;
	
	loop
		fetch next from cursorauthor into ida;
	
		exit when not found
	
		punt := new.qty + (select royaltyper/10 from titleauthor where au_id = ida and title_id = new.title_id);
		if (select idpuntajecampaign
			from puntajecampaign
			where idcampaign = 12 and au_id = ida) is null
			then
				insert into puntajecampaign
				values (idpc,12,ida,punt,current_user,now());
			else
				update puntajecampaign
					set puntaje = puntaje + punt,
						fechaultmodif = now()
				where idcampaign = 12
					and au_id = ida;
		end if;
	end loop
	
	close cursorauthor
	
	return new;
end
$$
language plpgsql;

create trigger trSales
after
insert on sales
for each row
execute procedure tr_ins_sales();