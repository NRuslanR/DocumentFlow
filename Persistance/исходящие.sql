drop function doc.get_outcoming_service_notes_for_employee(int, varchar[]);
CREATE OR REPLACE FUNCTION doc.get_outcoming_service_notes_for_employee(
    IN employee_id integer,
    IN stage_names character varying[] DEFAULT NULL::character varying[])
  RETURNS TABLE(is_document_viewed boolean, id integer, base_document_id integer, type_id integer, name character varying, number character varying, 
  document_date date, creation_date date, creation_date_year integer, creation_date_month integer, type_name character varying, current_work_cycle_stage_number integer, 
  current_work_cycle_stage_name character varying, author_id integer, is_self_registered boolean, author_short_name character varying, department_name character varying, 
  can_be_removed boolean, charges_stat character varying, applications_exists boolean, product_code character varying) AS
$BODY$
select  
    exists( 
    select 1 
    from doc.looked_service_notes lsn 
    where lsn.document_id = a.id and lsn.looked_employee_id = $1  
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

    a.applications_exists,

    a.product_code
    
    from doc.service_notes a 
    join doc.employees e on e.id = a.author_id  
    join doc.document_types b on a.type_id = b.id 
    join doc.document_type_work_cycle_stages c on c.id = a.current_work_cycle_stage_id 
    join doc.employees_roles er on er.employee_id = $1  
    join doc.employees e1 on e1.id = $1  
    left join doc.service_note_signings s on s.document_id = a.id 
    left join doc.employees signer on signer.id = s.signer_id 
    where 
    case when $2 is not null then array[c.stage_name] <@ $2 else true end
    and
    (a.author_id is not null) and  
    (  
    (  
    (e.head_kindred_department_id = e1.head_kindred_department_id)  
    and  
    (  
    (a.author_id = $1)  
    or  
    case 
        when er.role_id in (2,3,4,6)
        then 
            doc.is_employee_workspace_includes_other_employee($1 , a.author_id)  
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
    (s.signer_id = $1) 
    or 
    case 
        when er.role_id in (2,3,4,6)
        then doc.is_employee_workspace_includes_other_employee($1 , s.signer_id)
        else false
    end
    )
    ) 
    or doc.is_employee_replacing_for_others($1, array[a.author_id, s.signer_id])
    )

$BODY$
  LANGUAGE sql STABLE
  COST 100
  ROWS 1000;

GRANT EXECUTE ON FUNCTION doc.get_outcoming_service_notes_for_employee(integer, character varying[]) TO umz_doc_edit;
REVOKE ALL ON FUNCTION doc.get_outcoming_service_notes_for_employee(integer, character varying[]) FROM public;

select * from doc.get_outcoming_service_notes_for_employee(1332);
