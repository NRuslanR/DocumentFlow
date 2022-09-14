with new as (
select  
    exists( 
    select 1 
    from doc.looked_service_notes lsn 
    where lsn.document_id = a.id and lsn.looked_employee_id = 1356  
    ) as is_document_viewed, 
    a.id as id, 
    a.id as base_document_id,
    a.type_id, 
    a.name, 
    a.document_number as number, 
    a.document_date::date,
    a.creation_date::date, 
    date_part('year', a.creation_date)::integer as creation_date_year, 
    date_part('month', a.creation_date)::integer as creation_date_month, 
    b.short_full_name as type_name, 
    c.stage_number as current_work_cycle_stage_number, 
    c.stage_name as current_work_cycle_stage_name, 
    a.author_id, 
    a.is_self_registered,  
    (e.surname || ' ' || e.name || ' ' || e.patronymic)::varchar as author_short_name,

    a.receiving_department_names as department_name, 
    null::boolean as can_be_removed, 

    case 
        when total_charge_count is null or total_charge_count = 0 
        then null 
	else (performed_charge_count || ' из ' || total_charge_count)::varchar
    end as charges_stat,

    --doc.are_document_applications_exists(a.id, b.id) as are_applications_exists,

    a.product_code
    
    from doc.service_notes a 
    join doc.employees e on e.id = a.author_id  
    join doc.document_types b on a.type_id = b.id 
    join doc.document_type_work_cycle_stages c on c.id = a.current_work_cycle_stage_id 
    join doc.employees_roles er on er.employee_id = 1356  
    join doc.employees e1 on e1.id = 1356  
    left join doc.service_note_signings s on s.document_id = a.id 
    left join doc.employees signer on signer.id = s.signer_id 
    where 
    case when null is not null then array[c.stage_name] <@ null else true end
    and
    (a.author_id is not null) and  
    (  
    (  
    (e.head_kindred_department_id = e1.head_kindred_department_id)  
    and  
    (  
    (a.author_id = 1356)  
    or  
    case 
        when er.role_id in (2,3,4,6)
        then 
            doc.is_employee_workspace_includes_other_employee(1356 , a.author_id)  
	    and
	    case  
		when (select role_id from doc.employees_roles where employee_id = a.author_id) in (2,3,4,6)  
		then true 
		else  
		    a.is_sent_to_signing 
		    or (c.stage_number >= 5)  
	    end 
        else false
    end 
    ))
    or  
    ( 
    (a.is_sent_to_signing or c.stage_number in (6)) 
    and  
    (e1.head_kindred_department_id = signer.head_kindred_department_id)
    and
    (
    (s.signer_id = 1356) 
    or 
    case 
        when er.role_id in (2,3,4,6)
        then doc.is_employee_workspace_includes_other_employee(1356 , s.signer_id)
        else false
    end
    )
    ) 
    or doc.is_employee_replacing_for_others(1356, array[a.author_id, s.signer_id])
    )
),
old as (
select  
    exists( 
    select 1 
    from doc.looked_service_notes lsn 
    where lsn.document_id = a.id and lsn.looked_employee_id = 1356  
    ) as is_document_viewed, 
    a.id as id, 
    a.id as base_document_id,
    a.type_id, 
    a.name, 
    a.document_number as number, 
    a.document_date::date,
    a.creation_date::date, 
    date_part('year', a.creation_date)::integer as creation_date_year, 
    date_part('month', a.creation_date)::integer as creation_date_month, 
    b.short_full_name as type_name, 
    c.stage_number as current_work_cycle_stage_number, 
    c.stage_name as current_work_cycle_stage_name, 
    a.author_id, 
    a.is_self_registered,  
    (e.surname || ' ' || e.name || ' ' || e.patronymic)::varchar as author_short_name,

    a.receiving_department_names as department_name, 
    null::boolean as can_be_removed, 

    case 
        when total_charge_count is null or total_charge_count = 0 
        then null 
	else (performed_charge_count || ' из ' || total_charge_count)::varchar
    end as charges_stat,

    --doc.are_document_applications_exists(a.id, b.id) as are_applications_exists,

    a.product_code
    
    from doc.service_notes a 
    join doc.employees e on e.id = a.author_id  
    join doc.document_types b on a.type_id = b.id 
    join doc.document_type_work_cycle_stages c on c.id = a.current_work_cycle_stage_id 
    join doc.employees_roles er on er.employee_id = 1356  
    join doc.employees e1 on e1.id = 1356  
    left join doc.service_note_signings s on s.document_id = a.id 
    left join doc.employees signer on signer.id = s.signer_id 
    where 
    case when null is not null then array[c.stage_name] <@ null else true end
    and
    (a.author_id is not null) and  
    (  
    (  
    (e.head_kindred_department_id = e1.head_kindred_department_id)  
    and  
    (  
    (a.author_id = 1356 )  
    or  
    (  
    doc.is_employee_workspace_includes_other_employee(1356 , a.author_id)  
    and  
    case  
        when (select role_id from doc.employees_roles where employee_id = a.author_id) in (2,3,4,6)  
        then true 
        else  
            a.is_sent_to_signing 
            or (c.stage_number >= 5)  
    end 
    )  
    or doc.is_employee_replacing_for_other(1356 , a.author_id)  
    )) 
    or  
    ( 
    (a.is_sent_to_signing or c.stage_number in (6)) 
    and  
    doc.is_department_includes_other_department(e1.department_id, signer.department_id) 
    and  
    (s.signer_id = 1356  or 
     doc.is_employee_workspace_includes_other_employee(1356 , s.signer_id) or  
     doc.is_employee_replacing_for_other(1356 , s.signer_id)) 
    ) 
    )
)
(
select * from new
except
select * from old
)
union
(
select * from old
except
select * from new
);