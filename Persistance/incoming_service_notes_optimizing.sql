/*create table if not exists doc.incoming_service_notes as
select 
*
from doc.service_note_receivers snr 
where head_charge_sheet_id = id and top_level_charge_sheet_id is null and issuer_id is not null;

alter table doc.incoming_service_notes add column receiver_head_kindred_department_id int references doc.departments(id);
update doc.incoming_service_notes s set receiver_head_kindred_department_id = doc.find_head_kindred_department_for_inner(
select head_kindred_department_id from doc.employees where id = s.performer_id);*/

alter function doc.get_incoming_service_notes_for_employee(int4, _varchar) rename to get_incoming_service_notes_for_employee_old;

CREATE OR REPLACE FUNCTION doc.get_incoming_service_notes_for_employee(employee_id integer, stage_names character varying[] DEFAULT NULL::character varying[])
 RETURNS TABLE(own_charge boolean, type_id integer, type_name character varying, id integer, base_document_id integer, number character varying, receipt_date date, is_document_viewed boolean, outcomming_number character varying, name character varying, document_date date, creation_date date, creation_date_year integer, creation_date_month integer, author_id integer, author_short_name character varying, can_be_removed boolean, current_work_cycle_stage_number integer, current_work_cycle_stage_name character varying, department_name character varying, all_emp_charge_sheets_performed boolean, all_subord_charges_performed boolean, charges_stat character varying, are_applications_exists boolean, product_code character varying)
 LANGUAGE sql
 STABLE
AS $function$

    with incoming_service_notes_charges as ( 
    select  
      
    b.head_charge_sheet_id,  
    b.document_id as base_document_id,  
    b.performer_id as performer_id,  
    b.incoming_document_type_id as type_id,  
    b.performing_date,  
    c.short_full_name as type_name,  
    b.issuing_datetime,
      
    row_number() over (  
      partition by b.head_charge_sheet_id
        
      order by dtwcs.stage_number,  
        
      case  
          when b.performer_id = $1  
          then 0  
          else  
              case  
                  when replacing.ok
                  then 1  
                  else 2 
              end  
      end  
    ) as charge_number,  
      
    replacing.ok as is_performer_replacing_ok,
    
    b.input_number,
    total_charge_count,
    performed_charge_count,
    subordinate_charge_count,
    subordinate_performed_charge_count 
      
    from doc.service_note_receivers b  
    join doc.document_types c on c.id = b.incoming_document_type_id  
    join doc.employees cur_emp on cur_emp.id = $1   
    join doc.document_type_work_cycle_stages dtwcs on dtwcs.document_type_id = c.id and dtwcs.service_stage_name = case when b.performing_date is not null then 'Performed' else 'IsPerforming' end 
    join doc.employees_roles cur_emp_role on cur_emp_role.employee_id = $1  
    join lateral (select $1 = b.performer_id or doc.is_employee_acting_for_other_or_vice_versa($1, b.performer_id)) replacing(ok) on true
    where b.issuer_id is not null  
    and 
    	case 
			when $2 is not null 
				then array[dtwcs.stage_name] <@ null 
				else true 
		    end
    	and  
    (  
    b.performer_id = $1   
    or   
    case  
    when cur_emp_role.role_id not in (5)  
    then doc.is_employee_workspace_includes_other_employee($1 , b.performer_id)  
    else false end 
    or replacing.ok
    )
    )  
    select  

    case  
        when is_performer_replacing_ok   
        then  
      case   
          when isnc.performer_id = $1    
          then true 
          else (
		((select count(*) from doc.employees e where leader_id = isnc.performer_id and not was_dismissed and exists (select 1 from doc.employees_roles where employee_id = e.id and role_id = 3)) = 1)
		and
		exists (select 1 from doc.employees_roles er where er.employee_id = $1 and er.role_id = 3)
	       ) 
      end  
        else false  
    end as own_charge,  
      
    isnc.type_id,  
    isnc.type_name,  
    in_doc.id,
    isnc.base_document_id,
    in_doc.input_number as number,  
    isnc.issuing_datetime::date as receipt_date, 
      
    exists(  
    select 1  
    from doc.looked_service_notes lsn  
    where lsn.document_id = sn.id and lsn.looked_employee_id = $1   
    ) as is_document_viewed,  
      
    sn.document_number as outcomming_number,  
    sn.name, 
    sn.document_date::date, 
    sn.creation_date::date,  
    date_part('year', sn.creation_date)::integer as creation_date_year, 
    date_part('month', sn.creation_date)::integer as creation_date_month, 
    sn.author_id,  
    (emp.surname || ' '  || emp.name || ' '  || emp.patronymic)::varchar as author_short_name, 
    null::boolean as can_be_removed,  
      
    d.stage_number as current_work_cycle_stage_number,  
    d.stage_name as current_work_cycle_stage_name,  

    sn.signer_department_short_name,

    case 
        when is_performer_replacing_ok 
        then (isnc.performing_date is not null and isnc.total_charge_count is null) 
        else null
    end as all_emp_charge_sheets_performed,  

    case
	when is_performer_replacing_ok 
	then isnc.subordinate_charge_count > 0 and isnc.subordinate_performed_charge_count = isnc.subordinate_charge_count
	else null
    end as all_subord_charges_performed,
      
    case 
        when is_performer_replacing_ok and isnc.subordinate_charge_count > 0 and isnc.total_charge_count <> isnc.performed_charge_count 
        then isnc.subordinate_performed_charge_count || ' из ' || isnc.subordinate_charge_count  
        else null 
    end as charges_stat,
    
    sn.applications_exists,
    sn.product_code
      
    from incoming_service_notes_charges isnc 
    join doc.service_note_receivers in_doc on in_doc.id = isnc.head_charge_sheet_id 
    join doc.service_notes sn on sn.id = isnc.base_document_id 
    join doc.employees emp on emp.id = sn.author_id 
     
    join doc.document_type_work_cycle_stages d on d.document_type_id = isnc.type_id
    and
    d.service_stage_name =
    case when isnc.total_charge_count > 0  
         then  
      case when isnc.total_charge_count = isnc.performed_charge_count 
      then 'Performed' else 'IsPerforming' end  
         else 
         case 
	         when isnc.performing_date is not null
	         then 'Performed' else 'IsPerforming'
	     end
    end 
     
    where charge_number = 1 and in_doc.input_number_date is not null and in_doc.input_number is not null;
  
$function$
;