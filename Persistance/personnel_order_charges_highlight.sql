drop function if exists doc.get_personnel_orders_for_employee(employee_id integer);
CREATE OR REPLACE FUNCTION doc.get_personnel_orders_for_employee(employee_id integer)
 RETURNS TABLE(
 is_document_viewed boolean, id integer, base_document_id integer, type_id integer, sub_type_id integer, 
 sub_type_name character varying, name character varying, number character varying, document_date date, creation_date date, creation_date_year integer, 
 creation_date_month integer, type_name character varying, current_work_cycle_stage_number integer, 
 current_work_cycle_stage_name character varying, author_id integer, author_short_name character varying, 
 author_department_short_name character varying, can_be_removed boolean, are_applications_exists boolean, 
 product_code character varying, all_emp_charge_sheets_performed boolean, all_subord_charges_performed boolean)
 LANGUAGE sql
 STABLE
AS $function$

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
    	when t.is_performer_replacing_ok
    	then t.performing_date is not null
    	else cast(null as boolean)
    end as all_emp_charge_sheets_performed,
    
    cast(null as boolean) as all_subord_charges_performed
    
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
		with personnel_order_charge_sheets as (
			select 
				row_number() over (partition by head_charge_sheet_id order by 
					case 
						when poc.performer_id = $1
						then 0
						else 
							case
								when replacing.ok 
								then 1
								else 2
							end				
					end,
					case 
						when poc.performing_date is null
						then 0
						else 1
					end
				) as charge_sheet_number,
				poc.performing_date,
				poc.document_id
				, true as is_performer_replacing_ok
				from doc.personnel_order_charges poc  
				join lateral(select poc.performer_id = $1 or doc.is_employee_acting_for_other_or_vice_versa($1, poc.performer_id)) replacing(ok) on true
				where 
				poc.document_id = po.id 
				and poc.issuer_id is not null 
				and (
					replacing.ok
					or
					case 
					    when er.role_id in (2, 3, 4, 6)
					    then doc.is_employee_workspace_includes_other_employee($1, poc.performer_id)
					    else false
					end
		    	)
	    ) select document_id, performing_date, is_performer_replacing_ok from personnel_order_charge_sheets where charge_sheet_number = 1
	
	) t(document_id, performing_date, is_performer_replacing_ok) on t.document_id = po.id
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
	or t.document_id is not null;
					
$function$;

drop function if exists doc.get_personnel_orders_for_employee_by_ids(employee_id integer, document_ids integer[]);
CREATE OR REPLACE FUNCTION doc.get_personnel_orders_for_employee_by_ids(employee_id integer, document_ids integer[])
 RETURNS TABLE(
 is_document_viewed boolean, id integer, base_document_id integer, type_id integer, sub_type_id integer, 
 sub_type_name character varying, name character varying, number character varying, document_date date, creation_date date, creation_date_year integer, 
 creation_date_month integer, type_name character varying, current_work_cycle_stage_number integer, 
 current_work_cycle_stage_name character varying, author_id integer, author_short_name character varying, 
 author_department_short_name character varying, can_be_removed boolean, are_applications_exists boolean, 
 product_code character varying, all_emp_charge_sheets_performed boolean, all_subord_charges_performed boolean)
 LANGUAGE sql
 STABLE
AS $function$

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
    	when t.is_performer_replacing_ok
    	then t.performing_date is not null
    	else cast(null as boolean)
    end as all_emp_charge_sheets_performed,
    
    cast(null as boolean) as all_subord_charges_performed
    
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
		with personnel_order_charge_sheets as (
			select 
				row_number() over (partition by head_charge_sheet_id order by 
					case 
						when poc.performer_id = $1
						then 0
						else 
							case
								when replacing.ok 
								then 1
								else 2
							end				
					end,
					case 
						when poc.performing_date is null
						then 0
						else 1
					end
				) as charge_sheet_number,
				poc.performing_date,
				poc.document_id
				, true as is_performer_replacing_ok
				from doc.personnel_order_charges poc  
				join lateral(select poc.performer_id = $1 or doc.is_employee_acting_for_other_or_vice_versa($1, poc.performer_id)) replacing(ok) on true
				where 
				poc.document_id = po.id 
				and poc.issuer_id is not null 
				and (
					replacing.ok
					or
					case 
					    when er.role_id in (2, 3, 4, 6)
					    then doc.is_employee_workspace_includes_other_employee($1, poc.performer_id)
					    else false
					end
		    	)
	    ) select document_id, performing_date, is_performer_replacing_ok from personnel_order_charge_sheets where charge_sheet_number = 1
	
	) t(document_id, performing_date, is_performer_replacing_ok) on t.document_id = po.id
    where 
    (po.id = any($2))
    and
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
	or t.document_id is not null;
					
$function$;

