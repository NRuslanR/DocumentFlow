with new as (
select 
    exists( 
    select 1 
    from doc.looked_service_notes lsn 
    where lsn.document_id = a.id and lsn.looked_employee_id = 1247) as is_document_viewed, 
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
    null::varchar as charges_stat, 
    (e.name || ' '  || e.surname || ' '  || e.patronymic)::varchar as author_short_name, 
    null::boolean as can_be_removed,
    
    (
	select 
	d.short_name 
	from doc.service_note_signings sns 
	join doc.employees e on e.id = sns.signer_id
	join doc.departments d on d.id = e.department_id
	where sns.document_id = a.id
    ) as sender_department_name,
    
    (
	select 
	string_agg(distinct d.short_name, ', ')
	from doc.service_note_receivers snr 
	join doc.employees e on e.id = snr.performer_id
	join doc.departments d on d.id = e.department_id
	where snr.document_id = a.id and top_level_charge_sheet_id is null
    ) as receiver_department_names,

    doc.are_document_applications_exists(a.id, a.type_id) as are_applications_exists,

    a.product_code
    
    from doc.service_notes a 
    join doc.employees e on e.id = a.author_id 
    left join doc.employees resp on resp.spr_person_id = a.performer_id 
    left join doc.departments author_head_dep on author_head_dep.id = resp.head_kindred_department_id 
    join doc.document_types b on a.type_id = b.id 
    join doc.document_type_work_cycle_stages c on c.id = a.current_work_cycle_stage_id 
    join doc.employees cur_user on cur_user.id = 1247  
    left join doc.employees cur_user_leader on cur_user_leader.id = cur_user.leader_id  
    join doc.employees_roles cur_user_role on cur_user_role.employee_id = 1247  
    left join doc.employees_roles cur_user_leader_role on cur_user_leader_role.employee_id = cur_user_leader.id  
    where 
    case when null is not null then array[c.stage_name] <@ null else true end
    and
    exists ( 
    select 1 
    from doc.service_note_approvings sna 
    join doc.employees app on app.id = sna.approver_id
    where 
    document_id = a.id 
    and 
    (approver_id = 1247 
    or 
    case 
        when cur_user_role.role_id in (2,3,4,6) and  
       (select role_id from doc.employees_roles where employee_id = approver_id) in (2,3,4,6) 
        then 
		(row(cur_user.id, cur_user_role.role_id, cur_user.department_id, cur_user.head_kindred_department_id)::doc.employee_link = any(app.leader_links))
		or 
		(cur_user_role.role_id in (3,4,6) and (row(cur_user_leader.id, cur_user_leader_role.role_id, cur_user_leader.department_id, cur_user_leader.head_kindred_department_id)::doc.employee_link = any(app.leader_links)))
		
        else doc.is_employee_acting_for_other_or_vice_versa(1247 , approver_id) 
    end) 
    and 
    (cycle_number is not null or c.stage_number = 2))
),
old as (
select * from doc.get_approveable_service_notes_for_employee(1247)
)
select * from old
except
select * from new 
union
select * from new
except
select * from old 
--t;232779;232779;2;"заявка расширении  сети ВКС";"0900/12479-Э";"2020-1247-11";"2020-1247-10";2020;1247;"Исходящая с/з";9;"Исполнена";1247;"";"Михаил Самылкин Юрьевич";;"ОСВТ";"ОТИС";t;""

--select (row(1247,2,15,15)::doc.employee_link = any(array[row(1247,2,15,15)::doc.employee_link,(1247,2,2750,15)::doc.employee_link]))

--select * from doc.employees e join doc.employees_roles er on er.employee_id = e.id where er.role_id = 2