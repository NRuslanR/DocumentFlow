/*create table doc.incoming_service_note_charge_performing_stats(
incoming_document_id int not null references doc.service_note_receivers (id) on update cascade on delete cascade,
performer_id int not null references doc.employees (id) on update cascade on delete cascade,
total_charge_count int,
performed_charge_count int,
subordinate_charge_count int,
subordinate_performed_charge_count int,
constraint pkey primary key (incoming_document_id, performer_id)
);*/

alter table doc.service_note_receivers add column total_charge_count int;
alter table doc.service_note_receivers add column performed_charge_count int;
alter table doc.service_note_receivers add column subordinate_charge_count int;
alter table doc.service_note_receivers add column subordinate_performed_charge_count int;

create or replace function doc.incoming_service_note_charge_performing_stats_calc_trigger_func() returns trigger
as
$$
declare
	current_charge_row record;
	charge_row record;
begin

	if TG_OP = 'INSERT' then
		current_charge_row = new;

	else current_charge_row = old;
	
	end if;

	if current_charge_row.issuer_id is null then 
		return current_charge_row;
	end if;

	for charge_row in 
		with recursive get_upstream_charge_branch_for_current (id, performer_id, top_level_charge_sheet_id) as (
			select 
			snr.id,
			snr.performer_id,
			snr.top_level_charge_sheet_id
			from doc.service_note_receivers snr
			where snr.id in (current_charge_row.id, current_charge_row.top_level_charge_sheet_id)

			union

			select
			snr.id,
			snr.performer_id,
			snr.top_level_charge_sheet_id
			from doc.service_note_receivers snr
			join get_upstream_charge_branch_for_current ucb on ucb.top_level_charge_sheet_id = snr.id
		)
		select 
		in_doc.id as incoming_document_id, ucb.performer_id, stats.* 
		from get_upstream_charge_branch_for_current ucb
		join (select id from get_upstream_charge_branch_for_current where top_level_charge_sheet_id is null) as in_doc on true  
		join doc.get_employee_service_note_charge_sheets_performing_statistics(current_charge_row.document_id, ucb.performer_id, ucb.id) stats on true
	loop

		if charge_row.total_charge_count = charge_row.performed_charge_count then
			charge_row.total_charge_count = null; 
			charge_row.performed_charge_count = null; 
			charge_row.subordinate_charge_count = null; 
			charge_row.subordinate_performed_charge_count = null; 
		end if;
		
		update doc.service_note_receivers 
		set total_charge_count = charge_row.total_charge_count,
		    performed_charge_count = charge_row.performed_charge_count,
		    subordinate_charge_count = charge_row.subordinate_charge_count,
		    subordinate_performed_charge_count = charge_row.subordinate_performed_charge_count
		where head_charge_sheet_id = charge_row.incoming_document_id and performer_id = charge_row.performer_id;
		
	end loop;

	return current_charge_row;
	
end
$$
language plpgsql;

--alter table doc.service_note_receivers enable trigger incoming_service_note_charge_performing_stats_calc_trigger;
--alter table doc.service_note_receivers disable trigger incoming_service_note_charge_performing_stats_calc_trigger;

CREATE OR REPLACE FUNCTION doc.get_employee_service_note_charge_sheets_performing_statistics(
    IN document_id integer,
    IN employee_id integer,   
    IN start_top_level_charge_sheet_id integer DEFAULT NULL::integer)
  RETURNS TABLE(performed_charge_count bigint, total_charge_count bigint, subordinate_charge_count bigint, subordinate_performed_charge_count bigint) AS
$BODY$
begin
	
if document_id is null then 
	return query select 0::bigint as performed_charge_count, 0::bigint as total_charge_count, 0::bigint as subordinate_charge_count, 0::bigint as subordinate_performed_charge_count;


else

	return query
	with recursive get_available_employee_charge_sheets (id, performing_date, top_level_charge_sheet_id) as
	(
	select 
	a.id,
	a.performing_date,
	null::integer as top_level_charge_sheet_id
	from 
	doc.service_note_receivers a
	where a.document_id = $1 and 
	      case 
	          when $3 is not null
	          then (a.id = $3 or a.top_level_charge_sheet_id = $3)
	          else true
	      end 
	      and (a.performer_id = $2 or doc.is_employee_acting_for_other_or_vice_versa($2, a.performer_id))
	union
	select 
	a.id,
	a.performing_date,
	a.top_level_charge_sheet_id	
	from doc.service_note_receivers a
	join get_available_employee_charge_sheets b on a.top_level_charge_sheet_id = b.id
	)
	select 
	count(distinct case when performing_date is not null then id else null end) as performed_charge_count,
	count(distinct id) as total_charge_count,
	count(distinct case when top_level_charge_sheet_id is not null then id else null end) as subordinate_charge_count,
	count(distinct case when top_level_charge_sheet_id is not null and performing_date is not null then id else null end) as subordinate_performed_charge_count
	from get_available_employee_charge_sheets;

end if;

end
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100
  ROWS 1000;
--ALTER FUNCTION doc.get_employee_service_note_charge_sheets_performing_statistics(integer, integer, integer) OWNER TO sup;
GRANT EXECUTE ON FUNCTION doc.get_employee_service_note_charge_sheets_performing_statistics(integer, integer, integer) TO umz_doc_edit;
REVOKE ALL ON FUNCTION doc.get_employee_service_note_charge_sheets_performing_statistics(integer, integer, integer) FROM public;

create trigger incoming_service_note_charge_performing_stats_calc_trigger 
after 
insert 
or update of top_level_charge_sheet_id, performing_date, performer_id, issuer_id, document_id 
or delete 
on doc.service_note_receivers
for each row 
execute procedure doc.incoming_service_note_charge_performing_stats_calc_trigger_func();

update doc.service_note_receivers snr
set 
	total_charge_count = q.total_charge_count, 
	performed_charge_count = q.performed_charge_count, 
	subordinate_charge_count = q.subordinate_charge_count,
	subordinate_performed_charge_count = q.subordinate_performed_charge_count
from (
	select 
	snr.head_charge_sheet_id, 
	snr.performer_id,
	stats.*
	from doc.service_notes sn
	join doc.service_note_receivers snr on sn.id = snr.document_id
	join doc.get_employee_service_note_charge_sheets_performing_statistics(snr.document_id, snr.performer_id, snr.head_charge_sheet_id) stats on true
	where snr.performing_date is null and issuer_id is not null and stats.total_charge_count <> stats.performed_charge_count
) q
where snr.head_charge_sheet_id = q.head_charge_sheet_id and snr.performer_id = q.performer_id; 

/*
select 
(performing_stat.subordinate_charge_count > 0 and performing_stat.subordinate_performed_charge_count = performing_stat.subordinate_charge_count), 
* from 
doc.get_employee_service_note_charge_sheets_performing_statistics(231118, 1355, 2072) performing_stat

select * from doc.get_incoming_service_note_charge_performing_stats(52868, 126, 1355)

select * from doc.service_notes where document_number = '01/05-40'

select * from doc.service_note_receivers where document_id = 236157 and id = head_charge_sheet_id*/