with get_outcomings as (
select  
    a.id as id, 
    a.type_id, 
    c.service_stage_name,
	employee_author.ok as is_employee_author,
	employee_signer.ok as is_employee_signer
	
    from doc.service_notes a 
    join doc.employees e on e.id = a.author_id  
    join doc.document_types b on a.type_id = b.id 
    join doc.document_type_work_cycle_stages c on c.id = a.current_work_cycle_stage_id 
    join doc.employees_roles er on er.employee_id = 1355  
    join doc.employees e1 on e1.id = 1355  
    left join doc.service_note_signings s on s.document_id = a.id 
    left join doc.employees signer on signer.id = s.signer_id 
	join lateral (
		select 
			a.author_id = 1355 
			or doc.is_employee_acting_for_other_or_vice_versa(1355, a.author_id)
		 	or doc.are_employees_subleaders_of_same_leader(array[1355, a.author_id])
			or doc.are_employees_secretaries_of_same_leader(array[1355, a.author_id])
	) employee_author(ok) on true
	join lateral (
		select
			s.signer_id = 1355
			or doc.is_employee_acting_for_other_or_vice_versa(1355, s.signer_id)
	) employee_signer(ok) on true
    where 
    (a.author_id is not null) and  
    (    
    (e.head_kindred_department_id = e1.head_kindred_department_id and employee_author.ok)
    or  
    ( 
    a.is_sent_to_signing 
    and  
    e1.head_kindred_department_id = signer.head_kindred_department_id
    and employee_signer.ok 
    ) 
	)
),
get_incomings as (
with incoming_service_notes_charges as ( 
    select  
      
    b.head_charge_sheet_id as id,  
    b.incoming_document_type_id as type_id,
	
    row_number() over (  
      partition by b.head_charge_sheet_id
        
      order by dtwcs.stage_number,  
        
      case  
          when b.performer_id = 1355  
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
    
    total_charge_count,
    performed_charge_count,
    coalesce(subordinate_charge_count, 0) as subordinate_charge_count,
	performing_date
      
    from doc.service_note_receivers b  
    join doc.document_types c on c.id = b.incoming_document_type_id  
    join doc.employees cur_emp on cur_emp.id = 1355   
    join doc.document_type_work_cycle_stages dtwcs on dtwcs.document_type_id = c.id and dtwcs.service_stage_name = case when b.performing_date is not null then 'Performed' else 'IsPerforming' end 
    join doc.employees_roles cur_emp_role on cur_emp_role.employee_id = 1355  
    join lateral (select 1355 = b.performer_id or doc.is_employee_acting_for_other_or_vice_versa(1355, b.performer_id)) replacing(ok) on true
    where b.issuer_id is not null  
    and replacing.ok
    )  
    select  

	isnc.id,
    isnc.type_id,     
    d.service_stage_name,
	is_performer_replacing_ok,
	isnc.subordinate_charge_count > 0 as subordinate_charges_exists

    from incoming_service_notes_charges isnc 
    join doc.service_note_receivers in_doc on in_doc.id = isnc.id 
     
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
     
    where charge_number = 1 and in_doc.input_number_date is not null and in_doc.input_number is not null
),
get_approveables as (
	select 
    distinct
    a.id as id, 
    (select id from doc.document_types where service_name = 'approveable_service_note') as type_id, 
    c.service_stage_name,
	employee_approver.ok as is_employee_approver
    
    from doc.service_notes a 
    join doc.employees e on e.id = a.author_id 
    left join doc.employees resp on resp.spr_person_id = a.performer_id 
    left join doc.departments author_head_dep on author_head_dep.id = resp.head_kindred_department_id 
    join doc.document_types b on a.type_id = b.id 
    join doc.document_type_work_cycle_stages c on c.id = a.current_work_cycle_stage_id 
    join doc.employees cur_user on cur_user.id = 1355  
    join doc.employees_roles cur_user_role on cur_user_role.employee_id = 1355 
	join doc.service_note_approvings sna on sna.document_id = a.id
	join doc.document_approving_results dar on dar.id = sna.performing_result_id
	join lateral (
		select
			sna.approver_id = 1355 
			or doc.is_employee_acting_for_other_or_vice_versa(1355 , sna.approver_id) 
	) employee_approver(ok) on true
    where 
    employee_approver.ok 
    and c.stage_number = 2 and dar.id = 3 
)
select 
type_id,
count(
	case 
		when 
			(service_stage_name = 'IsSigning' 
			and is_employee_signer)
			or (service_stage_name = 'Created' and is_employee_author)
		then 1
		else null 
	end
) over () as own_action_count,
count(
	case 
		when service_stage_name = 'IsPerforming'
		then 1 
		else null 
	end
) over () as in_working_count
from get_outcomings

union

select 
type_id,
count(case when (service_stage_name = 'IsPerforming' and not subordinate_charges_exists) then 1 else null end)
 over () as own_action_count,
count(case when (service_stage_name = 'IsPerforming') then 1 else null end) over () as in_working_count
from get_incomings

union

select 
type_id,
count (
	case 
		when service_stage_name = 'IsApproving'
		then 1
		else null
	end
) over () own_action_count,
0 as in_working_count
from get_approveables