--рассмотреть возможность хранения вычисляемых столбцов в таблице получателей
/*create table doc.service_note_performing_stats(
document_id int not null primary key references doc.service_notes (id) on update cascade on delete cascade,
total_charge_count int,
performed_charge_count int
);*/

alter table doc.service_note_receivers rename column employee_id to performer_id;
alter table doc.service_note_receivers rename column real_sender_employee_id to issuer_id;
alter table doc.document_receivers rename column employee_id to performer_id;
alter table doc.document_receivers rename column real_sender_employee_id to issuer_id;
alter table doc.service_notes add column total_charge_count int;
alter table doc.service_notes add column performed_charge_count int;

--UPDATE выстуапать может как insert и оригинальный update из-за хранения вх.сз, поручений и листов поручений в одной строке одной таблицы
create or replace function doc.service_note_performing_stats_trigger_func() returns trigger
as
$$
declare
	current_charge_row record;
	current_total_charge_count int;
	current_performed_charge_count int;
begin
	
	if TG_OP = 'UPDATE' then
	
		current_charge_row = new;

	else current_charge_row = old; end if;

	if current_charge_row.top_level_charge_sheet_id is not null or current_charge_row.issuer_id is null or old.performing_date is not null then 
		return current_charge_row; 
	end if;

	select 
	total_charge_count, performed_charge_count into current_total_charge_count, current_performed_charge_count
	from doc.service_notes where id = current_charge_row.document_id;

	
	if current_total_charge_count is null then 
		current_total_charge_count = 0;
		current_performed_charge_count = 0;
	end if;

	if TG_OP = 'UPDATE' then

		if old.issuer_id is null then
			current_total_charge_count = current_total_charge_count + 1;
		end if;

		if old.performing_date is null and current_charge_row.performing_date is not null then 
			current_performed_charge_count = current_performed_charge_count + 1;
		end if;

	else 
		current_total_charge_count = current_total_charge_count - 1;

		if current_charge_row.performing_date is not null then 
			current_performed_charge_count = current_performed_charge_count - 1;
		end if;
	end if;
	
	if current_total_charge_count = current_performed_charge_count then
		update doc.service_notes set total_charge_count = null, performed_charge_count = null where id = current_charge_row.document_id;

	else

		update doc.service_notes set total_charge_count = current_total_charge_count, performed_charge_count = current_performed_charge_count 
		where id = current_charge_row.document_id;
	end if;

	return current_charge_row;

end
$$
language plpgsql;

--alter table doc.service_note_receivers enable trigger service_note_performing_stats_trigger;
--alter table doc.service_note_receivers disable trigger service_note_performing_stats_trigger;

create trigger service_note_performing_stats_trigger after update or delete on doc.service_note_receivers
for each row execute procedure doc.service_note_performing_stats_trigger_func();

CREATE OR REPLACE FUNCTION doc.get_service_note_performing_statistics(IN document_id bigint)
  RETURNS TABLE(total_charge_count bigint, performed_charge_count bigint) AS
$BODY$
begin

if $1 is null then 
	return query select 0::bigint as total_charge_count, 0::bigint as performed_charge_count;

else
	return query
	select    
	count(*) as total_charge_count,
	count(b.performing_date) as performed_charge_count
	from doc.service_notes a
	join doc.employees author on author.id = a.author_id
	join doc.service_note_receivers b on b.document_id = a.id
	join doc.employees performer on performer.id = b.performer_id
	where 
		a.id = $1 
		and b.issuer_id is not null 
		and top_level_charge_sheet_id is null
		and author.head_kindred_department_id <> performer.head_kindred_department_id;
end if;
end
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100
  ROWS 1000;
--ALTER FUNCTION doc.get_service_note_performing_statistics(bigint) OWNER TO sup;
GRANT EXECUTE ON FUNCTION doc.get_service_note_performing_statistics(bigint) TO umz_doc_edit;
REVOKE ALL ON FUNCTION doc.get_service_note_performing_statistics(bigint) FROM public;
COMMENT ON FUNCTION doc.get_service_note_performing_statistics(bigint) IS 'Возвращает статистику по исполнению поручений документа document_id в целом. Учитывается только первые непосредственные исполнители';

update doc.service_notes sn
set total_charge_count = q.total_charge_count, performed_charge_count = q.performed_charge_count
from (
	select
	sn.id,
	stat.*
	from doc.service_notes sn
	join doc.get_service_note_performing_statistics(sn.id) stat(total_charge_count, performed_charge_count) on true
	where 
		sn.author_id is not null and
		sn.current_work_cycle_stage_id = 4 and
		stat.total_charge_count <> stat.performed_charge_count
) q
where sn.id = q.id;

	
---------------------------------------------------------------------------------------------------------------------
/*create table doc.service_note_receiving_departments(
document_id int not null primary key references doc.service_notes (id) on update cascade on delete cascade,
receiving_department_names varchar 
);*/

alter table doc.service_notes add column receiving_department_names varchar;

create or replace function doc.service_note_receiving_departments_trigger_func() returns trigger
as
$$
declare
	current_row record;
	_receiving_department_names varchar;
begin

	if TG_OP = 'UPDATE' then
		current_row = new;

	else current_row = old; end if;

	if current_row.top_level_charge_sheet_id is not null then 
		return current_row; 
	end if;

	select 
	string_agg(distinct d.short_name, ', ') into _receiving_department_names
	from doc.service_note_receivers snr 
	join doc.employees e on e.id = snr.performer_id
	join doc.departments d on d.id = e.department_id
	where snr.document_id = old.document_id and top_level_charge_sheet_id is null;

	update doc.service_notes 
	set receiving_department_names = _receiving_department_names
	where id = current_row.document_id;
	
	return current_row;
	
end
$$
language plpgsql;

create trigger service_note_receiving_departments_trigger after update or delete on doc.service_note_receivers
for each row 
execute procedure doc.service_note_receiving_departments_trigger_func();

--alter table doc.service_note_receivers enable trigger service_note_receiving_departments_trigger;
--alter table doc.service_note_receivers disable trigger service_note_receiving_departments_trigger;

update doc.service_notes sn
set receiving_department_names = q.receiving_department_names
from (
	select
		sn.id,
		string_agg(distinct d.short_name, ', ') as receiving_department_names
		from doc.service_notes sn
		join doc.service_note_receivers snr on snr.document_id = sn.id
		join doc.employees e on e.id = snr.performer_id
		join doc.departments d on d.id = e.department_id
		where sn.author_id is not null and top_level_charge_sheet_id is null
		group by sn.id
) q
where sn.id = q.id


	/*

select * from doc.service_note_receivers where document_id = 232199

select * from doc.employees where id in (1286, 1247)*/