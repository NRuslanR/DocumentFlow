CREATE OR REPLACE FUNCTION doc.personnel_order_set_head_charge_sheet_for_new_charge_sheet()
  RETURNS trigger AS
$BODY$
begin

	update doc.personnel_order_charges 
	set head_charge_sheet_id = doc.get_personnel_order_head_charge_sheet_for(new.id)
	where id = new.id;
	
	return new;
end
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;

GRANT EXECUTE ON FUNCTION doc.personnel_order_set_head_charge_sheet_for_new_charge_sheet() TO umz_doc_edit;
REVOKE ALL ON FUNCTION doc.personnel_order_set_head_charge_sheet_for_new_charge_sheet() FROM public;

CREATE TRIGGER personnel_order_set_head_charge_sheet_for_new_charge_sheet_trigger
  AFTER INSERT OR UPDATE
  ON doc.personnel_order_charges
  FOR EACH ROW
  WHEN (((new.head_charge_sheet_id IS NULL) AND (new.issuer_id IS NOT NULL)))
  EXECUTE PROCEDURE doc.personnel_order_set_head_charge_sheet_for_new_charge_sheet();

---------------------------------------------------------------------------------------------------------------------------------------------------------------------------

  CREATE OR REPLACE FUNCTION doc.personnel_order_charge_performing_stats_calc_trigger_func()
  RETURNS trigger AS
$BODY$
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
			from doc.personnel_order_charges snr
			where snr.id in (current_charge_row.id, current_charge_row.top_level_charge_sheet_id)

			union

			select
			snr.id,
			snr.performer_id,
			snr.top_level_charge_sheet_id
			from doc.personnel_order_charges snr
			join get_upstream_charge_branch_for_current ucb on ucb.top_level_charge_sheet_id = snr.id
		)
		select 
		ucb.performer_id, stats.* 
		from get_upstream_charge_branch_for_current ucb
		join doc.get_employee_personnel_order_charge_sheets_performing_statistics(current_charge_row.document_id, ucb.performer_id, ucb.id) stats on true
	loop

		if charge_row.total_charge_count = charge_row.performed_charge_count then
			charge_row.total_charge_count = null; 
			charge_row.performed_charge_count = null; 
			charge_row.subordinate_charge_count = null; 
			charge_row.subordinate_performed_charge_count = null; 
		end if;
		
		update doc.personnel_order_charges 
		set total_charge_count = charge_row.total_charge_count,
		    performed_charge_count = charge_row.performed_charge_count,
		    subordinate_charge_count = charge_row.subordinate_charge_count,
		    subordinate_performed_charge_count = charge_row.subordinate_performed_charge_count
		where document_id = current_charge_row.document_id and performer_id = charge_row.performer_id;
		
	end loop;

	return current_charge_row;
	
end
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;

revoke EXECUTE ON FUNCTION doc.personnel_order_charge_performing_stats_calc_trigger_func() from public;
grant EXECUTE ON FUNCTION doc.personnel_order_charge_performing_stats_calc_trigger_func() to umz_doc_edit;

CREATE TRIGGER personnel_order_charge_performing_stats_calc_trigger
  AFTER INSERT OR UPDATE OF top_level_charge_sheet_id, performing_date, performer_id, issuer_id, document_id OR DELETE
  ON doc.personnel_order_charges
  FOR EACH ROW
  EXECUTE PROCEDURE doc.personnel_order_charge_performing_stats_calc_trigger_func();

  -----------------------------------------------------------------------------------

  CREATE OR REPLACE FUNCTION doc.get_employee_personnel_order_charge_sheets_performing_statistics(
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
	doc.personnel_order_charges a
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
	from doc.personnel_order_charges a
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
  LANGUAGE plpgsql STABLE
  COST 100
  ROWS 1000;

GRANT EXECUTE ON FUNCTION doc.get_employee_personnel_order_charge_sheets_performing_statistics(integer, integer, integer) TO umz_doc_edit;
REVOKE ALL ON FUNCTION doc.get_employee_personnel_order_charge_sheets_performing_statistics(integer, integer, integer) FROM public;

-------------------------------------------------------------------

drop function doc.get_personnel_orders_for_employee(IN employee_id integer);
CREATE OR REPLACE FUNCTION doc.get_personnel_orders_for_employee(IN employee_id integer)
  RETURNS TABLE(
	is_document_viewed boolean, id integer, base_document_id integer, type_id integer, sub_type_id integer, 
	sub_type_name character varying, name character varying, number character varying, document_date date, creation_date date, 
	creation_date_year integer, creation_date_month integer, type_name character varying, current_work_cycle_stage_number integer, 
	current_work_cycle_stage_name character varying, author_id integer, author_short_name character varying, author_department_short_name character varying, 
	can_be_removed boolean, are_applications_exists boolean, product_code character varying, all_emp_charge_sheets_performed boolean, all_subord_charges_performed boolean
) AS
$BODY$
select  
    distinct
    exists( 
    select 1 
    from doc.looked_personnel_orders lpo 
    where lpo.document_id = po.id and lpo.looked_employee_id = $1  
    ) as is_document_viewed, 
    po.id, 
    po.id as base_document_id,
    po.type_id, 
    po.sub_type_id,
    posk.name as sub_type_name,
    po.name, 
    po.document_number as number, 
    po.document_date::date,
    po.creation_date::date, 
    date_part('year', po.creation_date)::integer as creation_date_year, 
    date_part('month', po.creation_date)::integer as creation_date_month, 
    dt.short_full_name as type_name, 
    dtwcs.stage_number as current_work_cycle_stage_number, 
    dtwcs.stage_name as current_work_cycle_stage_name, 
    po.author_id,
    (e.surname || ' ' || e.name || ' ' || e.patronymic)::varchar as author_short_name,
    d.short_name as author_department_short_name,
    null::boolean as can_be_removed,
    doc.are_document_applications_exists(po.id, po.type_id),
    po.product_code,
    
    case 
        when most_substituted_charge_sheet.is_performer_replacing_ok 
        then (most_substituted_charge_sheet.performing_date is not null and most_substituted_charge_sheet.total_charge_count is null) 
        else null
    end as all_emp_charge_sheets_performed,  

    case
	when most_substituted_charge_sheet.is_performer_replacing_ok 
	then most_substituted_charge_sheet.subordinate_charge_count > 0 and most_substituted_charge_sheet.subordinate_performed_charge_count = most_substituted_charge_sheet.subordinate_charge_count
	else null
    end as all_subord_charges_performed
    
    from doc.personnel_orders po 
    join doc.personnel_order_sub_kinds posk on posk.id = po.sub_type_id
    join doc.employees e on e.id = po.author_id  
    join doc.departments d on d.id = e.department_id
    join doc.document_types dt on po.type_id = dt.id 
    join doc.document_type_work_cycle_stages dtwcs on dtwcs.id = po.current_work_cycle_stage_id 
    join doc.employees e1 on e1.id = $1  
    join doc.employees_roles er on er.employee_id = $1
    left join doc.personnel_order_creating_access_employees pocae on pocae.employee_id = $1
    left join doc.personnel_order_signings pos on pos.document_id = po.id 
    left join doc.personnel_order_approvings poa on poa.document_id = po.id 
    left join lateral (
	with get_employee_charge_sheets as (
		select 
		id,
		
		row_number() over (  
		      partition by poc.document_id
			
		      order by 
		      
		      case 
			  when poc.performing_date is null
			  then 0
			  else 1
		      end,  
			
		      case  
			  when poc.performer_id = $1  
			  then 0  
			  else  
			      case  
				  when replacing.ok
				  then 1  
				  else 2 
			      end  
		      end  
		) as charge_sheet_number,  

		replacing.ok as is_performer_replacing_ok,

		performing_date,
		
		total_charge_count,
		performed_charge_count,
		subordinate_charge_count,
		subordinate_performed_charge_count 
		
		from doc.personnel_order_charges poc
		join lateral (select $1 = poc.performer_id or doc.is_employee_acting_for_other_or_vice_versa($1, poc.performer_id)) as replacing(ok) on true
		where 
			(poc.document_id = po.id) 
			and (poc.issuer_id is not null)  
			and  
			(  
				replacing.ok 
				or   
				case  
				when er.role_id not in (5)  
				then doc.is_department_includes_other_department(e1.department_id,  (select department_id from doc.employees where id = poc.performer_id)) 
				and doc.is_employee_workspace_includes_other_employee($1 , poc.performer_id)  
				else false end  
			)
	)
	select 
	id, 
	performing_date,
	is_performer_replacing_ok,
	total_charge_count,
	performed_charge_count,
	subordinate_charge_count,
	subordinate_performed_charge_count  
	from get_employee_charge_sheets where charge_sheet_number = 1 
	
    ) as most_substituted_charge_sheet on true
    
    where 
    
	(po.author_id = $1) 
	or(
		(e.head_kindred_department_id = e1.head_kindred_department_id) and
		pocae.employee_id is not null 
		or
		doc.is_employee_replacing_for_other($1, po.author_id)
	)
	or (
		(po.is_sent_to_signing or dtwcs.stage_number = 6) 
		and exists (
			select 
			1 
			from doc.personnel_order_control_groups__sub_kinds pocgsk
			join doc.personnel_order_control_groups__employees pocge on pocge.control_group_id = pocgsk.control_group_id
			where 
				pocgsk.personnel_order_sub_kind_id = po.sub_type_id 
				and (
					$1 = pocge.employee_id
					/*or 		
					doc.is_employee_replacing_for_other($1, pocge.employee_id)*/
				)
		)
			
	)
	or (
		(dtwcs.stage_number = 2 or poa.cycle_number is not null) and
		(
			$1 = poa.approver_id
			or
			case 
			    when er.role_id in (2, 3, 4, 6)
			    then doc.is_employee_workspace_includes_other_employee($1, poa.approver_id)
			    else false
			end
			or
			doc.is_employee_replacing_for_other($1, poa.approver_id)
		)
	)
	or most_substituted_charge_sheet.id is not null;
			
		
$BODY$
  LANGUAGE sql STABLE
  COST 100
  ROWS 1000;

grant execute on FUNCTION doc.get_personnel_orders_for_employee(IN employee_id integer) to umz_doc_edit;
revoke all privileges on FUNCTION doc.get_personnel_orders_for_employee(IN employee_id integer) from public;

drop FUNCTION doc.get_personnel_orders_for_employee_by_ids(
    IN employee_id integer,
    IN document_ids integer[]);
CREATE OR REPLACE FUNCTION doc.get_personnel_orders_for_employee_by_ids(
    IN employee_id integer,
    IN document_ids integer[])
  RETURNS TABLE(
	is_document_viewed boolean, id integer, base_document_id integer, type_id integer, sub_type_id integer, 
	sub_type_name character varying, name character varying, number character varying, document_date date, 
	creation_date date, creation_date_year integer, creation_date_month integer, type_name character varying, 
	current_work_cycle_stage_number integer, current_work_cycle_stage_name character varying, author_id integer, 
	author_short_name character varying, author_department_short_name character varying, can_be_removed boolean, 
	are_applications_exists boolean, product_code character varying, all_emp_charge_sheets_performed boolean, all_subord_charges_performed boolean
   ) AS
$BODY$
select  
    distinct
    exists( 
    select 1 
    from doc.looked_personnel_orders lpo 
    where lpo.document_id = po.id and lpo.looked_employee_id = $1  
    ) as is_document_viewed, 
    po.id, 
    po.id as base_document_id,
    po.type_id, 
    po.sub_type_id,
    posk.name as sub_type_name,
    po.name, 
    po.document_number as number, 
    po.document_date::date,
    po.creation_date::date, 
    date_part('year', po.creation_date)::integer as creation_date_year, 
    date_part('month', po.creation_date)::integer as creation_date_month, 
    dt.short_full_name as type_name, 
    dtwcs.stage_number as current_work_cycle_stage_number, 
    dtwcs.stage_name as current_work_cycle_stage_name, 
    po.author_id,
    (e.surname || ' ' || e.name || ' ' || e.patronymic)::varchar as author_short_name,
    d.short_name as author_department_short_name,
    null::boolean as can_be_removed,
    doc.are_document_applications_exists(po.id, po.type_id),
    po.product_code,
    
    case 
        when most_substituted_charge_sheet.is_performer_replacing_ok 
        then (most_substituted_charge_sheet.performing_date is not null and most_substituted_charge_sheet.total_charge_count is null) 
        else null
    end as all_emp_charge_sheets_performed,  

    case
	when most_substituted_charge_sheet.is_performer_replacing_ok 
	then most_substituted_charge_sheet.subordinate_charge_count > 0 and most_substituted_charge_sheet.subordinate_performed_charge_count = most_substituted_charge_sheet.subordinate_charge_count
	else null
    end as all_subord_charges_performed
    
    from doc.personnel_orders po 
    join doc.personnel_order_sub_kinds posk on posk.id = po.sub_type_id
    join doc.employees e on e.id = po.author_id  
    join doc.departments d on d.id = e.department_id
    join doc.document_types dt on po.type_id = dt.id 
    join doc.document_type_work_cycle_stages dtwcs on dtwcs.id = po.current_work_cycle_stage_id 
    join doc.employees e1 on e1.id = $1  
    join doc.employees_roles er on er.employee_id = $1
    left join doc.personnel_order_creating_access_employees pocae on pocae.employee_id = $1
    left join doc.personnel_order_signings pos on pos.document_id = po.id 
    left join doc.personnel_order_approvings poa on poa.document_id = po.id 
    left join lateral (
	with get_employee_charge_sheets as (
		select 
		id,
		
		row_number() over (  
		      partition by poc.document_id
			
		      order by 
		      
		      case 
			  when poc.performing_date is null
			  then 0
			  else 1
		      end,  
			
		      case  
			  when poc.performer_id = $1  
			  then 0  
			  else  
			      case  
				  when replacing.ok
				  then 1  
				  else 2 
			      end  
		      end  
		) as charge_sheet_number,  

		replacing.ok as is_performer_replacing_ok,

		performing_date,
		
		total_charge_count,
		performed_charge_count,
		subordinate_charge_count,
		subordinate_performed_charge_count 
		
		from doc.personnel_order_charges poc
		join lateral (select $1 = poc.performer_id or doc.is_employee_acting_for_other_or_vice_versa($1, poc.performer_id)) as replacing(ok) on true
		where 
			(poc.document_id = po.id) 
			and (poc.issuer_id is not null)  
			and  
			(  
				replacing.ok 
				or   
				case  
				when er.role_id not in (5)  
				then doc.is_department_includes_other_department(e1.department_id,  (select department_id from doc.employees where id = poc.performer_id)) 
				and doc.is_employee_workspace_includes_other_employee($1 , poc.performer_id)  
				else false end  
			)
	)
	select 
	id, 
	performing_date,
	is_performer_replacing_ok,
	total_charge_count,
	performed_charge_count,
	subordinate_charge_count,
	subordinate_performed_charge_count  
	from get_employee_charge_sheets where charge_sheet_number = 1 
	
    ) as most_substituted_charge_sheet on true
    
    where 
	(po.id = any($2))
	and 
	(
	(po.author_id = $1) 
	or(
		(e.head_kindred_department_id = e1.head_kindred_department_id) and
		pocae.employee_id is not null 
		or
		doc.is_employee_replacing_for_other($1, po.author_id)
	)
	or (
		(po.is_sent_to_signing or dtwcs.stage_number = 6) 
		and exists (
			select 
			1 
			from doc.personnel_order_control_groups__sub_kinds pocgsk
			join doc.personnel_order_control_groups__employees pocge on pocge.control_group_id = pocgsk.control_group_id
			where 
				pocgsk.personnel_order_sub_kind_id = po.sub_type_id 
				and (
					$1 = pocge.employee_id
					/*or 		
					doc.is_employee_replacing_for_other($1, pocge.employee_id)*/
				)
		)
			
	)
	or (
		(dtwcs.stage_number = 2 or poa.cycle_number is not null) and
		(
			$1 = poa.approver_id
			or
			case 
			    when er.role_id in (2, 3, 4, 6)
			    then doc.is_employee_workspace_includes_other_employee($1, poa.approver_id)
			    else false
			end
			or
			doc.is_employee_replacing_for_other($1, poa.approver_id)
		)
	)
	or most_substituted_charge_sheet.id is not null);
					
		
$BODY$
  LANGUAGE sql STABLE
  COST 100
  ROWS 1000;

GRANT EXECUTE ON FUNCTION doc.get_personnel_orders_for_employee_by_ids(integer, integer[]) TO umz_doc_edit;
REVOKE ALL ON FUNCTION doc.get_personnel_orders_for_employee_by_ids(integer, integer[]) FROM public;

CREATE OR REPLACE FUNCTION doc.personnel_order_receiving_departments_trigger_func()
  RETURNS trigger AS
$BODY$
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
	from doc.personnel_order_charges snr 
	join doc.employees e on e.id = snr.performer_id
	join doc.departments d on d.id = e.department_id
	where snr.document_id = old.document_id and top_level_charge_sheet_id is null;

	update doc.personnel_orders  
	set receiving_department_names = _receiving_department_names
	where id = current_row.document_id;
	
	return current_row;
	
end
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;

grant execute on function doc.personnel_order_receiving_departments_trigger_func() to umz_doc_edit;
REVOKE EXECUTE ON FUNCTION doc.personnel_order_receiving_departments_trigger_func() FROM public;

CREATE TRIGGER personnel_order_receiving_departments_trigger
  AFTER UPDATE OR DELETE
  ON doc.personnel_order_charges
  FOR EACH ROW
  EXECUTE PROCEDURE doc.personnel_order_receiving_departments_trigger_func();
