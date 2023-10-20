-- чтобы не копировалась дата выпуска
CREATE OR REPLACE FUNCTION tpp.copy_additional_izv_types_to_issue_journal_func()
 RETURNS trigger
 LANGUAGE plpgsql
AS $function$
declare 
	_product_id integer;
	_buf_product_id integer;
	_receipt_date date;
	_issuing_date date;
	_author_id integer;
	query varchar;
begin 
	if not exists(	
		select 
		1 
		from tpp.spr_issue_journal sij 
		join tpp.spr_izv_type sit on sit.id = sij.izv_type_id 
		where 
			index_id = new.izv_index_id 
			and index_nbr::varchar = new.izv_number 
			and sit.izv_type_short_name ~* '^(ии|пи)$' 
			and exists (select 1 from tpp.spr_izv_type sit2 where sit2.id = new.izv_type_id and sit2.izv_type_short_name ~* '^(дии|дпи)$')
	) then
		return new;
	end if;

	query :=
		'with change_parts as (
			select distinct 
			sdd.* 
			from tpp.sp_docum d
			join tpp.sp_docum_d sdd on sdd.docum_id = d.id 
			where d.izv_index_id = $1 and d.izv_number = $2 and d.izv_type_id = 
				case when $3 = 2 then 1 else case when $3 = 4 then 3 else null end end
		),
		pivot as (
			select 
				row_number() over (partition by cp.id order by sdt.spec_nbr) as number,
				case when sdli.product_id is not null then sdli.product_id else sdlib.product_id end as product_id,
				case when cp.creation_dt is not null then cp.creation_dt else cp.datei end as receipt_date, 
				case when cp.creation_dt is not null then cp.creation_dt else cp.datei end as issuing_date, 
				case when cp.person_id is not null then cp.person_id else (select person.id from exchange.person_get_id_by_login(cp.useri) as person(id)) end as author_id
			from change_parts cp 
			left join tpp.sp_docum_list_izv sdli on sdli.docum_id = cp.id and not sdli.is_isp and exists (select 1 from nsi.spr_product where id = sdli.product_id and pdet_id in (4, 1))
			left join works.sp_docum_list_izv_buf sdlib on sdlib.docum_id = cp.id and not sdlib.is_isp and exists (select 1 from works.prod_ where id = sdlib.product_id and pdet_id in (4, 1))
			left join tpp.spr_docum_type sdt on sdt.id = case when sdli.docum_type_id is not null then sdli.docum_type_id else sdlib.docum_type_id end
			where cp.numerator = (select min(numerator) from change_parts)
		) 
		select 
			product_id,
			receipt_date,
			issuing_date,
			author_id
		from pivot 
		where number = 1';
		
	_product_id = null;
	_buf_product_id = null;

	execute query into _product_id, _receipt_date, _issuing_date, _author_id using new.izv_index_id, new.izv_number, new.izv_type_id;

	if _author_id is null then 
		return new;
	end if;

	insert into tpp.spr_issue_journal(
		index_id, index_nbr, izv_type_id, izv_pizm_id, di_order, product_id, works_prod_id, recipient_id, issue_dt, receipt_dt
	)
	values (
		new.izv_index_id, new.izv_number::int, new.izv_type_id, new.izv_pizm_id, new.di_order,
		_product_id, _buf_product_id, _author_id, _issuing_date, _receipt_date
	)
	on conflict on constraint unique_izv_column_list
	do update set
		index_id = new.izv_index_id,
		index_nbr = new.izv_number::int,
		izv_type_id = new.izv_type_id,
		izv_pizm_id = new.izv_pizm_id,
		di_order = new.di_order,
		product_id = _product_id,
		works_prod_id = _buf_product_id,
		recipient_id = _author_id,
		issue_dt = _issuing_date,
		receipt_dt = _receipt_date;
			
	return new;
end;
$function$
;

update tpp.spr_issue_journal 
set is_issue = transfer_dt is not null;

drop trigger if exists copy_additional_izv_types_to_issue_journal_trigger on tpp.sp_docum;

create trigger copy_additional_izv_types_to_issue_journal_trigger after
insert or update on tpp.sp_docum for each row execute function tpp.copy_additional_izv_types_to_issue_journal_func();

with source as (
select 
	izv_index_id,
	izv_number::int,
	izv_type_id,
	izv_pizm_id,
	di_order,
	is_issue,
	product_id,
	buf_product_id,
	person_id,
	creation_dt,
	receipt_date
from (
select 
	distinct
	row_number() over (partition by sd.id order by sdt.spec_nbr) as number,
	sd.izv_index_id,
	sd.izv_number::int,
	sd.izv_type_id,
	sd.izv_pizm_id,
	sd.di_order,
	sd.transfer_dt is not null as is_issue,
	sdli.product_id,
	sdlib.product_id as buf_product_id,
	
	case when sdd.person_id is not null then sdd.person_id else (select person.id from exchange.person_get_id_by_login(sdd.useri) as person(id)) end as person_id,
	case when sdd.creation_dt is not null then sdd.creation_dt else sdd.datei end as creation_dt,
	case when sdd.creation_dt is not null then sdd.creation_dt else sdd.datei end as receipt_date
	
from tpp.sp_docum sd

join tpp.spr_issue_journal sij 
	on 
		sij.index_id = sd.izv_index_id 
		and sij.index_nbr::varchar = sd.izv_number
		and exists (select 1 from tpp.spr_izv_type sit where sit.id = sij.izv_type_id and sit.izv_type_short_name ~* '^(ии|пи)$')


join tpp.sp_docum_d sdd on sdd.docum_id = sd.id 

left join tpp.sp_docum_list_izv sdli 
	on 
		sdli.docum_id = sdd.id 
		and not sdli.is_isp 
		and exists (select 1 from nsi.spr_product where id = sdli.product_id and pdet_id in (4, 1))

left join works.sp_docum_list_izv_buf sdlib 
	on 
	sdlib.docum_id = sdd.id 
	and not sdlib.is_isp 
	and exists (select 1 from works.prod_ where id = sdlib.product_id and pdet_id in (4, 1))

left join tpp.spr_docum_type sdt on sdt.id = 
	case 
		when sdlib.docum_type_id is not null then sdli.docum_type_id 
		else sdlib.docum_type_id
	end
	
join tpp.spr_izv_type sit on sit.id = sd.izv_type_id 
where
	sdd.numerator = (select min(numerator) from tpp.sp_docum_d sdd2 where sdd2.docum_id = sd.id)
	and
	sit.izv_type_short_name ~* '^(дии|дпи)$'
) q
where number = 1
)
insert into tpp.spr_issue_journal (
	index_id, index_nbr, izv_type_id, izv_pizm_id,
	di_order, is_issue, product_id, works_prod_id, 
	recipient_id, issue_dt, receipt_dt
)
select * from source
on conflict do nothing;

with source as (
select 
	izv_index_id,
	izv_number::int,
	izv_type_id,
	izv_pizm_id,
	di_order,
	is_issue,
	product_id,
	buf_product_id,
	person_id,
	creation_dt,
	receipt_date
from (
select 
	distinct
	row_number() over (partition by sd.id order by sdt.spec_nbr) as number,
	sd.izv_index_id,
	sd.izv_number::int,
	sd.izv_type_id,
	sd.izv_pizm_id,
	sd.di_order,
	sd.transfer_dt is not null as is_issue,
	sdli.product_id,
	sdlib.product_id as buf_product_id,
	
	case when sdd.person_id is not null then sdd.person_id else (select person.id from exchange.person_get_id_by_login(sdd.useri) as person(id)) end as person_id,
	case when sdd.creation_dt is not null then sdd.creation_dt else sdd.datei end as creation_dt,
	case when sdd.creation_dt is not null then sdd.creation_dt else sdd.datei end as receipt_date
	
from tpp.sp_docum sd

join tpp.spr_issue_journal sij 
	on 
		sij.index_id = sd.izv_index_id 
		and sij.index_nbr::varchar = sd.izv_number
		and exists (select 1 from tpp.spr_izv_type sit where sit.id = sij.izv_type_id and sit.izv_type_short_name ~* '^(ии|пи)$')


join tpp.sp_docum_d sdd on sdd.docum_id = sd.id 

left join tpp.sp_docum_list_izv sdli 
	on 
		sdli.docum_id = sdd.id 
		and not sdli.is_isp 
		and exists (select 1 from nsi.spr_product where id = sdli.product_id and pdet_id in (4, 1))

left join works.sp_docum_list_izv_buf sdlib 
	on 
	sdlib.docum_id = sdd.id 
	and not sdlib.is_isp 
	and exists (select 1 from works.prod_ where id = sdlib.product_id and pdet_id in (4, 1))

left join tpp.spr_docum_type sdt on sdt.id = 
	case 
		when sdlib.docum_type_id is not null then sdli.docum_type_id 
		else sdlib.docum_type_id
	end
	
join tpp.spr_izv_type sit on sit.id = sd.izv_type_id 
where
	sdd.numerator = (select min(numerator) from tpp.sp_docum_d sdd2 where sdd2.docum_id = sd.id)
	and
	sit.izv_type_short_name ~* '^(дии|дпи)$'
) q
where number = 1
)
update tpp.spr_issue_journal sij 
set 
	index_id = source.izv_index_id,
	index_nbr = source.izv_number::int,
	izv_type_id = source.izv_type_id,
	izv_pizm_id = source.izv_pizm_id,
	di_order = source.di_order,
	is_issue = source.is_issue,
	product_id = source.product_id,
	works_prod_id = source.buf_product_id,
	recipient_id = source.person_id,
	issue_dt = source.creation_dt,
	receipt_dt = source.receipt_date
from source 
where source.izv_index_id = sij.index_id and source.izv_number = sij.index_nbr and source.izv_type_id = sij.izv_type_id and source.di_order = sij.di_order;