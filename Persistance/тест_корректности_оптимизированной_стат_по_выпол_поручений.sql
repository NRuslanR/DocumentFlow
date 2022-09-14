with old as(
with incoming_service_notes_charges as ( 
    select  
      
    b.head_charge_sheet_id,  
    b.document_id as base_document_id,  
    b.performer_id as performer_id,  
    b.incoming_document_type_id as type_id,  
    b.performing_date,  
    c.short_full_name as type_name,  
    dtwcs.service_stage_name as document_service_stage_name,
    b.issuing_datetime,
      
    row_number() over (  
      partition by b.head_charge_sheet_id
        
      order by dtwcs.stage_number,  
        
      case  
          when b.performer_id = 1355  
          then 0  
          else  
              case  
                  when own_charge.ok  
                  then 1  
                  else 2  
              end  
      end  
    ) as charge_number,  
      
    own_charge.ok as own_charge  
      
    from doc.service_note_receivers b  
    join doc.document_types c on c.id = b.incoming_document_type_id  
    join doc.employees cur_emp on cur_emp.id = 1355   
    join doc.document_type_work_cycle_stages dtwcs on dtwcs.document_type_id = c.id and dtwcs.service_stage_name = case when b.performing_date is not null then 'Performed' else 'IsPerforming' end 
    join doc.employees_roles cur_emp_role on cur_emp_role.employee_id = 1355  
    join lateral (select b.performer_id = 1355  or doc.is_employee_subleader_or_replacing_for_other(1355 , b.performer_id)) own_charge(ok) on true 
    where b.issuer_id is not null  
    and  
    (  
    b.performer_id = 1355   
    or   
    case  
    when cur_emp_role.role_id not in (5)  
    then doc.is_department_includes_other_department(  
    cur_emp.department_id,  
    (select department_id from doc.employees where id = b.performer_id)  
    ) and doc.is_employee_workspace_includes_other_employee(1355 , b.performer_id)  
    else false end  
    or doc.is_employee_replacing_for_other(1355 , b.performer_id)  
    )  
    )  
    select  
      
    case  
        when isnc.own_charge  
        then  
      case   
          when isnc.performer_id = 1355    
          then own_charge  
          else (select count(*) from doc.employees e where leader_id = isnc.performer_id and not was_dismissed and exists (select 1 from doc.employees_roles where employee_id = e.id and role_id = 3)) = 1  
      end  
        else false  
    end as own_charge,  
      
    isnc.type_id,  
    isnc.type_name,  
    in_doc.id,  
    isnc.base_document_id,
    in_doc.input_number as number,  
    isnc.issuing_datetime::date as receipt_date,
    --isnc.performing_date,
    
    exists(  
    select 1  
    from doc.looked_service_notes lsn  
    where lsn.document_id = sn.id and lsn.looked_employee_id = 1355   
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
      
    case when sn.is_self_registered   
    then (select short_name from doc.departments where code = left(sn.document_number, length(sn.document_number) - position('/' in reverse(sn.document_number))) and prizn_old is null)  
    else (  
    select signer_dep.short_name  
    from doc.service_note_signings sns  
    join doc.employees signer on signer.id = sns.signer_id  
    join doc.departments signer_dep on signer_dep.id = signer.head_kindred_department_id  
    where document_id = sn.id  
    )  
    end as department_name,  
      
    (  
    (performing_stat.total_charge_count > 0 and performing_stat.total_charge_count = performing_stat.performed_charge_count) or  
    (performing_stat.total_charge_count = 0 and isnc.performing_date is not null)  
    ) as all_emp_charge_sheets_performed,  

    (
	(performing_stat.subordinate_charge_count > 0 and performing_stat.subordinate_performed_charge_count = performing_stat.subordinate_charge_count) or
	(performing_stat.subordinate_charge_count = 0 and isnc.performing_date is not null)
    ) as all_subord_charges_performed,
    
    case when performing_stat.subordinate_charge_count > 0 and performing_stat.total_charge_count <> performing_stat.performed_charge_count then  
    performing_stat.subordinate_performed_charge_count || ' из ' || performing_stat.subordinate_charge_count  
    else null end as charges_stat
      
    from incoming_service_notes_charges isnc 
    join doc.service_note_receivers in_doc on in_doc.id = isnc.head_charge_sheet_id 
    join doc.service_notes sn on sn.id = isnc.base_document_id 
    join doc.employees emp on emp.id = sn.author_id 
     
    join doc.get_employee_service_note_charge_sheets_performing_statistics(  
    case when isnc.performing_date is null then in_doc.document_id else null end, 
    1355,
    in_doc.id
    ) performing_stat on true 
      
    join doc.document_type_work_cycle_stages d on d.document_type_id = isnc.type_id
    and
    d.service_stage_name =
    case when performing_stat.total_charge_count > 0  
         then  
      case when performing_stat.total_charge_count = performing_stat.performed_charge_count 
      then 'Performed' else 'IsPerforming' end  
         else isnc.document_service_stage_name 
    end 
     
    where charge_number = 1 and in_doc.input_number_date is not null and in_doc.input_number is not null --and in_doc.id = 20792
),
new as (
with incoming_service_notes_charges as ( 
    select  
      
    b.head_charge_sheet_id,  
    b.document_id as base_document_id,  
    b.performer_id as performer_id,  
    b.incoming_document_type_id as type_id,  
    b.performing_date,  
    c.short_full_name as type_name,  
    dtwcs.service_stage_name as document_service_stage_name,
    b.issuing_datetime,
      
    row_number() over (  
      partition by b.head_charge_sheet_id
        
      order by dtwcs.stage_number,  
        
      case  
          when b.performer_id = 1355  
          then 0  
          else  
              case  
                  when own_charge.ok  
                  then 1  
                  else 2  
              end  
      end  
    ) as charge_number,  
      
    own_charge.ok as own_charge,

    total_charge_count,
    performed_charge_count,
    subordinate_charge_count,
    subordinate_performed_charge_count
      
    from doc.service_note_receivers b  
    join doc.document_types c on c.id = b.incoming_document_type_id  
    join doc.employees cur_emp on cur_emp.id = 1355   
    join doc.document_type_work_cycle_stages dtwcs on dtwcs.document_type_id = c.id and dtwcs.service_stage_name = case when b.performing_date is not null then 'Performed' else 'IsPerforming' end 
    join doc.employees_roles cur_emp_role on cur_emp_role.employee_id = 1355  
    join lateral (select b.performer_id = 1355  or doc.is_employee_subleader_or_replacing_for_other(1355 , b.performer_id)) own_charge(ok) on true 
    where b.issuer_id is not null  
    and  
    (  
    b.performer_id = 1355   
    or   
    case  
    when cur_emp_role.role_id not in (5)  
    then doc.is_department_includes_other_department(  
    cur_emp.department_id,  
    (select department_id from doc.employees where id = b.performer_id)  
    ) and doc.is_employee_workspace_includes_other_employee(1355 , b.performer_id)  
    else false end  
    or doc.is_employee_replacing_for_other(1355 , b.performer_id)  
    )  
    )  
    select  
      
    case  
        when isnc.own_charge  
        then  
      case   
          when isnc.performer_id = 1355    
          then own_charge  
          else (select count(*) from doc.employees e where leader_id = isnc.performer_id and not was_dismissed and exists (select 1 from doc.employees_roles where employee_id = e.id and role_id = 3)) = 1  
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
    where lsn.document_id = sn.id and lsn.looked_employee_id = 1355   
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
      
    case when sn.is_self_registered   
    then (select short_name from doc.departments where code = left(sn.document_number, length(sn.document_number) - position('/' in reverse(sn.document_number))) and prizn_old is null)  
    else (  
    select signer_dep.short_name  
    from doc.service_note_signings sns  
    join doc.employees signer on signer.id = sns.signer_id  
    join doc.departments signer_dep on signer_dep.id = signer.head_kindred_department_id  
    where document_id = sn.id  
    )  
    end as department_name,  
      
    (  
	replacing is not null and
	(isnc.performing_date is not null and isnc.total_charge_count is null)  
    ) as all_emp_charge_sheets_performed,  

    (
	replacing is not null and
	(
		(isnc.subordinate_charge_count > 0 and isnc.subordinate_performed_charge_count = isnc.subordinate_charge_count) or
		(isnc.performing_date is not null)
	)
    ) as all_subord_charges_performed,
      
    case 
        when replacing is not null and isnc.subordinate_charge_count > 0 and isnc.total_charge_count <> isnc.performed_charge_count 
        then isnc.subordinate_performed_charge_count || ' из ' || isnc.subordinate_charge_count  
        else null 
    end as charges_stat
      
    from incoming_service_notes_charges isnc 
    join doc.service_note_receivers in_doc on in_doc.id = isnc.head_charge_sheet_id 
    left join doc.is_employee_acting_for_other_or_vice_versa(1355, isnc.performer_id) replacing(ok) on 1355 = isnc.performer_id or replacing.ok
    join doc.service_notes sn on sn.id = isnc.base_document_id 
    join doc.employees emp on emp.id = sn.author_id 
    join doc.document_type_work_cycle_stages d on 
	    d.document_type_id = isnc.type_id
	    and
	    d.service_stage_name =
	    case when isnc.total_charge_count > 0  
		 then  
		     case when isnc.total_charge_count = isnc.performed_charge_count 
		     then 'Performed' else 'IsPerforming' end  
		 else isnc.document_service_stage_name 
	    end 
     
    where charge_number = 1 and in_doc.input_number_date is not null and in_doc.input_number is not null-- and in_doc.id = 41971
)
select 
* from(
select * from old 
except
select * from new 
) q
order by q.id
--select * from doc.get_incoming_service_notes_for_employee(1355) a where not exists (select 1 from doc.incoming_service_note_charge_performing_stats b where b.incoming_document_id = a.id)

--select * from doc.incoming_service_note_charge_performing_stats where incoming_document_id = 20792

--select * from doc.service_note_receivers where head_charge_sheet_id = 228106

--    select * from doc.service_note_receivers where document_id = 234581