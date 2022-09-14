drop function doc.get_outcoming_service_notes_for_employee(int);
CREATE OR REPLACE FUNCTION doc.get_outcoming_service_notes_for_employee(IN employee_id integer)
  RETURNS TABLE(is_document_viewed boolean, id integer, base_document_id integer, type_id integer, name character varying, number character varying, document_date date, creation_date date, 
  creation_date_year integer, creation_date_month integer, type_name character varying, current_work_cycle_stage_number integer, 
  current_work_cycle_stage_name character varying, author_id integer, is_self_registered boolean, author_short_name character varying, 
  department_name character varying, can_be_removed boolean, charges_stat character varying, are_applications_exists boolean, product_code varchar
  ) AS
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

    doc.are_document_applications_exists(a.id, b.id) as are_applications_exists,

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
    (a.author_id is not null) and  
    (  
    (  
    (e.head_kindred_department_id = e1.head_kindred_department_id)  
    and  
    (  
    (a.author_id = $1 )  
    or  
    (  
    doc.is_employee_workspace_includes_other_employee($1 , a.author_id)  
    and  
    case  
        when (select role_id from doc.employees_roles where employee_id = a.author_id) in (2,3,4,6)  
        then true 
        else  
            a.is_sent_to_signing 
            or (c.stage_number >= 5)  
    end 
    )  
    or doc.is_employee_replacing_for_other($1 , a.author_id)  
    )) 
    or  
    ( 
    (a.is_sent_to_signing or c.stage_number in (6)) 
    and  
    doc.is_department_includes_other_department(e1.department_id, signer.department_id) 
    and  
    (s.signer_id = $1  or 
     doc.is_employee_workspace_includes_other_employee($1 , s.signer_id) or  
     doc.is_employee_replacing_for_other($1 , s.signer_id)) 
    ) 
    );
$BODY$
  LANGUAGE sql VOLATILE
  COST 100
  ROWS 1000;

GRANT EXECUTE ON FUNCTION doc.get_outcoming_service_notes_for_employee(integer) TO umz_doc_edit;
REVOKE ALL ON FUNCTION doc.get_outcoming_service_notes_for_employee(integer) FROM public;
COMMENT ON FUNCTION doc.get_outcoming_service_notes_for_employee(integer) IS 'Возвращает исходящие служебные записки, к которым имеет доступ сотрудник';

drop function doc.get_outcoming_service_notes_for_employee_by_ids(int, int[]);
CREATE OR REPLACE FUNCTION doc.get_outcoming_service_notes_for_employee_by_ids(
    IN employee_id integer,
    IN document_ids integer[])
  RETURNS TABLE(is_document_viewed boolean, id integer, base_document_id integer, type_id integer, name character varying, 
  number character varying, document_date date, creation_date date, creation_date_year integer, creation_date_month integer, 
  type_name character varying, current_work_cycle_stage_number integer, current_work_cycle_stage_name character varying, author_id integer, 
  is_self_registered boolean, author_short_name character varying, department_name character varying, can_be_removed boolean, charges_stat character varying,
  are_applications_exists boolean, product_code varchar
) AS
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

    doc.are_document_applications_exists(a.id, b.id) as are_applications_exists,

    a.product_code
    
    from doc.service_notes a 
    join doc.employees e on e.id = a.author_id  
    join doc.document_types b on a.type_id = b.id 
    join doc.document_type_work_cycle_stages c on c.id = a.current_work_cycle_stage_id 
    join doc.employees_roles er on er.employee_id = $1  
    join doc.employees e1 on e1.id = $1  
    left join doc.service_note_signings s on s.document_id = a.id 
    left join doc.employees signer on signer.id = s.signer_id 
    where (a.id = any($2)) and 
    (
    (a.author_id is not null) and  
    (  
    (  
    (e.head_kindred_department_id = e1.head_kindred_department_id)  
    and  
    (  
    (a.author_id = $1 )  
    or  
    (  
    doc.is_employee_workspace_includes_other_employee($1 , a.author_id)  
    and  
    case  
        when (select role_id from doc.employees_roles where employee_id = a.author_id) in (2,3,4,6)  
        then true 
        else  
            a.is_sent_to_signing 
            or (c.stage_number >= 5)  
    end 
    )  
    or doc.is_employee_replacing_for_other($1 , a.author_id)  
    )) 
    or  
    ( 
    (a.is_sent_to_signing or c.stage_number in (6)) 
    and  
    doc.is_department_includes_other_department(e1.department_id, signer.department_id) 
    and  
    (s.signer_id = $1  or 
     doc.is_employee_workspace_includes_other_employee($1 , s.signer_id) or  
     doc.is_employee_replacing_for_other($1 , s.signer_id)) 
    ) 
    ));
$BODY$
  LANGUAGE sql VOLATILE
  COST 100
  ROWS 1000;

GRANT EXECUTE ON FUNCTION doc.get_outcoming_service_notes_for_employee_by_ids(integer, integer[]) TO umz_doc_edit;
REVOKE ALL ON FUNCTION doc.get_outcoming_service_notes_for_employee_by_ids(integer, integer[]) FROM public;
COMMENT ON FUNCTION doc.get_outcoming_service_notes_for_employee_by_ids(integer, integer[]) IS 'Возвращает исходящие служебные записки, к которым имеет доступ сотрудник, по их идентификаторам';

drop function doc.get_incoming_service_notes_for_employee(int);
CREATE OR REPLACE FUNCTION doc.get_incoming_service_notes_for_employee(IN employee_id integer)
  RETURNS TABLE(own_charge boolean, type_id integer, type_name character varying, id integer, base_document_id integer, number character varying, 
  receipt_date date, is_document_viewed boolean, outcomming_number character varying, name character varying, document_date date, creation_date date, 
  creation_date_year integer, creation_date_month integer, author_id integer, author_short_name character varying, can_be_removed boolean, current_work_cycle_stage_number integer, 
  current_work_cycle_stage_name character varying, department_name character varying, all_emp_charge_sheets_performed boolean, all_subord_charges_performed boolean, 
  charges_stat character varying, are_applications_exists boolean, product_code varchar) AS
$BODY$

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
    (  
    b.performer_id = $1   
    or   
    case  
    when cur_emp_role.role_id not in (5)  
    then doc.is_department_includes_other_department(  
    cur_emp.department_id,  
    (select department_id from doc.employees where id = b.performer_id)  
    ) and doc.is_employee_workspace_includes_other_employee($1 , b.performer_id)  
    else false end  
    or doc.is_employee_replacing_for_other($1 , b.performer_id)  
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
    doc.are_document_applications_exists(sn.id, sn.type_id) as are_application_exists,

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
  
$BODY$
  LANGUAGE sql VOLATILE
  COST 100
  ROWS 1000;

GRANT EXECUTE ON FUNCTION doc.get_incoming_service_notes_for_employee(integer) TO umz_doc_edit;
REVOKE ALL ON FUNCTION doc.get_incoming_service_notes_for_employee(integer) FROM public;
COMMENT ON FUNCTION doc.get_incoming_service_notes_for_employee(integer) IS 'Возвращает входящие служебные записки, к которым имеет доступ сотрудник';


drop function doc.get_incoming_service_notes_for_employee_by_ids(int, int[]);
CREATE OR REPLACE FUNCTION doc.get_incoming_service_notes_for_employee_by_ids(
    IN employee_id integer,
    IN document_ids integer[])
  RETURNS TABLE(own_charge boolean, type_id integer, type_name character varying, id integer, base_document_id integer, 
  number character varying, receipt_date date, is_document_viewed boolean, outcomming_number character varying, name character varying, 
  document_date date, creation_date date, creation_date_year integer, creation_date_month integer, author_id integer, author_short_name character varying, 
  can_be_removed boolean, current_work_cycle_stage_number integer, current_work_cycle_stage_name character varying, department_name character varying, 
  all_emp_charge_sheets_performed boolean, all_subord_charges_performed boolean, charges_stat character varying, are_applications_exists boolean, product_code varchar) AS
$BODY$

    with incoming_service_notes_charges as ( 
    select  
      
    b.head_charge_sheet_id,  
    b.document_id as base_document_id,  
    b.performer_id as performer_id,  
    b.incoming_document_type_id as type_id,  
    b.performing_date,  
    dtwcs.service_stage_name as document_service_stage_name,
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
    where (b.head_charge_sheet_id = any($2)) and b.issuer_id is not null
    and  
    (  
   b.performer_id = $1   
    or   
    case  
    when cur_emp_role.role_id not in (5)  
    then doc.is_department_includes_other_department(  
    cur_emp.department_id,  
    (select department_id from doc.employees where id = b.performer_id)  
    ) and doc.is_employee_workspace_includes_other_employee($1 , b.performer_id)  
    else false end  
    or doc.is_employee_replacing_for_other($1 , b.performer_id)  
    )  
    )  
    select  
      
    case  
        when isnc.is_performer_replacing_ok 
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

    doc.are_document_applications_exists(sn.id, sn.type_id) as are_applications_exists,

    sn.product_code
      
    from incoming_service_notes_charges isnc 
    join doc.service_note_receivers in_doc on in_doc.id = isnc.head_charge_sheet_id 
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
		 else
		 case 
	         when isnc.performing_date is not null
	         then 'Performed' else 'IsPerforming'
	     end   
	    end 
     
    where charge_number = 1 and in_doc.input_number_date is not null and in_doc.input_number is not null;
  
$BODY$
  LANGUAGE sql VOLATILE
  COST 100
  ROWS 1000;
  
GRANT EXECUTE ON FUNCTION doc.get_incoming_service_notes_for_employee_by_ids(integer, integer[]) TO umz_doc_edit;
REVOKE ALL ON FUNCTION doc.get_incoming_service_notes_for_employee_by_ids(integer, integer[]) FROM public;
COMMENT ON FUNCTION doc.get_incoming_service_notes_for_employee_by_ids(integer, integer[]) IS 'Возвращает входящие служебные записки, к которым имеет доступ сотрудник, по их идентификаторам';

DROP FUNCTION doc.get_approveable_service_notes_for_employee_by_ids(integer,integer[]);
DROP FUNCTION doc.get_incoming_service_notes_from_departments(bigint[]);
DROP FUNCTION doc.get_approveable_service_notes_from_departments(bigint[]);
DROP FUNCTION doc.get_outcoming_service_notes_from_departments(bigint[]);
DROP FUNCTION doc.get_personnel_orders_for_employee_by_ids(integer,integer[]);
DROP FUNCTION doc.get_personnel_orders_for_employee(integer);
drop function doc.get_approveable_service_notes_for_employee(int);
CREATE OR REPLACE FUNCTION doc.get_approveable_service_notes_for_employee(IN employee_id integer)
  RETURNS TABLE(is_document_viewed boolean, id integer, base_document_id integer, type_id integer, name character varying, number character varying, document_date date, 
  creation_date date, creation_date_year integer, creation_date_month integer, type_name character varying, current_work_cycle_stage_number integer, 
  current_work_cycle_stage_name character varying, author_id integer, charges_stat character varying, author_short_name character varying, can_be_removed boolean, 
  sender_department_name character varying, receiver_department_names character varying, are_applications_exists boolean,product_code character varying) AS
$BODY$

    select 
    exists( 
    select 1 
    from doc.looked_service_notes lsn 
    where lsn.document_id = a.id and lsn.looked_employee_id = $1) as is_document_viewed, 
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
    join doc.employees cur_user on cur_user.id = $1  
    join doc.employees_roles cur_user_role on cur_user_role.employee_id = $1  
    where 
    exists ( 
    select 1 
    from doc.service_note_approvings 
    where 
    document_id = a.id 
    and 
    (approver_id = $1 
    or 
    case 
        when cur_user_role.role_id in (2,3,4,6) and  
       (select role_id from doc.employees_roles where employee_id = approver_id) in (2,3,4,6) 
        then doc.is_employee_workspace_includes_other_employee($1 , approver_id) 
        else doc.is_employee_acting_for_other_or_vice_versa($1 , approver_id) 
    end) 
    and 
    (cycle_number is not null or c.stage_number = 2));
$BODY$
  LANGUAGE sql VOLATILE
  COST 100
  ROWS 1000;

GRANT EXECUTE ON FUNCTION doc.get_approveable_service_notes_for_employee(integer) TO umz_doc_edit;
REVOKE ALL ON FUNCTION doc.get_approveable_service_notes_for_employee(integer) FROM public;
COMMENT ON FUNCTION doc.get_approveable_service_notes_for_employee(integer) IS 'Возвращает согласуемые служебные записки, к которым имеет доступ сотрудник';

CREATE OR REPLACE FUNCTION doc.get_approveable_service_notes_for_employee_by_ids(
    IN employee_id integer,
    IN document_ids integer[])
  RETURNS TABLE(is_document_viewed boolean, id integer, base_document_id integer, type_id integer, name character varying, number character varying, document_date date, 
  creation_date date, creation_date_year integer, creation_date_month integer, type_name character varying, current_work_cycle_stage_number integer, current_work_cycle_stage_name character varying, 
  author_id integer, charges_stat character varying, author_short_name character varying, can_be_removed boolean, sender_department_name character varying, 
  receiver_department_names character varying, are_applications_exists boolean, product_code varchar) AS
$BODY$

    select 
    exists( 
    select 1 
    from doc.looked_service_notes lsn 
    where lsn.document_id = a.id and lsn.looked_employee_id = $1) as is_document_viewed, 
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
    join doc.employees cur_user on cur_user.id = $1  
    join doc.employees_roles cur_user_role on cur_user_role.employee_id = $1  
    where (a.id = any ($2)) and ( 
    exists ( 
    select 1 
    from doc.service_note_approvings 
    where 
    document_id = a.id 
    and 
    (approver_id = $1 
    or 
    case 
        when cur_user_role.role_id in (2,3,4,6) and  
       (select role_id from doc.employees_roles where employee_id = approver_id) in (2,3,4,6) 
        then doc.is_employee_workspace_includes_other_employee($1 , approver_id) 
        else doc.is_employee_acting_for_other_or_vice_versa($1 , approver_id) 
    end) 
    and 
    (cycle_number is not null or c.stage_number = 2)));
$BODY$
  LANGUAGE sql VOLATILE
  COST 100
  ROWS 1000;

GRANT EXECUTE ON FUNCTION doc.get_approveable_service_notes_for_employee_by_ids(integer, integer[]) TO umz_doc_edit;
REVOKE ALL ON FUNCTION doc.get_approveable_service_notes_for_employee_by_ids(integer, integer[]) FROM public;
COMMENT ON FUNCTION doc.get_approveable_service_notes_for_employee_by_ids(integer, integer[]) IS 'Возвращает согласуемые служебные записки, к которым имеет доступ сотрудник, по их идентификаторам';

CREATE OR REPLACE FUNCTION doc.get_incoming_service_notes_from_departments(IN department_ids bigint[])
  RETURNS TABLE(id integer, base_document_id integer, type_id integer, type_name character varying, number character varying, receipt_date date, 
  outcomming_number character varying, name character varying, document_date date, creation_date date, creation_date_year integer, creation_date_month integer, 
  current_work_cycle_stage_number integer, current_work_cycle_stage_name character varying, author_id integer, author_short_name character varying, department_name character varying, 
  can_be_removed boolean, product_code varchar) AS
$BODY$
select 
    distinct
    snr.id,
    sn.id as base_document_id, 
    dt.id as type_id, 
    dt.short_full_name as type_name,     
    snr.input_number as number, 
    snr.input_number_date::date as receipt_date, 
    sn.document_number as outcomming_number, 
    sn.name, 
    sn.document_date::date,
    sn.creation_date::date, 
    date_part('year', sn.creation_date)::integer as creation_date_year, 
    date_part('month', sn.creation_date)::integer as creation_date_month, 
    dtwcs.stage_number as current_work_cycle_stage_number, 
    dtwcs.stage_name as current_work_cycle_stage_name,
    sn.author_id, 
    (author.surname || ' '  || author.name || ' '  || author.patronymic)::varchar as author_short_name,
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
    null::boolean as can_be_removed,
    sn.product_code
   
    from doc.service_notes sn
    join doc.service_note_receivers snr on snr.document_id = sn.id
    join doc.document_types dt on dt.id = snr.incoming_document_type_id   
    join doc.document_type_work_cycle_stages dtwcs on dtwcs.document_type_id = dt.id and dtwcs.service_stage_name = case when snr.performing_date is not null then 'Performed' else 'IsPerforming' end
    join doc.employees author on author.id = sn.author_id
    join doc.employees performer on performer.id = snr.performer_id
    where 
	snr.input_number is not null 
	and snr.input_number_date is not null 
	and snr.issuer_id is not null
	and performer.department_id = any($1);

$BODY$
  LANGUAGE sql VOLATILE
  COST 100
  ROWS 1000;

GRANT EXECUTE ON FUNCTION doc.get_incoming_service_notes_from_departments(bigint[]) TO umz_doc_edit;
REVOKE ALL ON FUNCTION doc.get_incoming_service_notes_from_departments(bigint[]) FROM public;
COMMENT ON FUNCTION doc.get_incoming_service_notes_from_departments(bigint[]) IS 'Возвращает входящие служебные записки из подразделений';

CREATE OR REPLACE FUNCTION doc.get_approveable_service_notes_from_departments(IN department_ids bigint[])
  RETURNS TABLE(id integer, base_document_id integer, type_id integer, name character varying, number character varying, document_date date, 
  creation_date date, creation_date_year integer, creation_date_month integer, type_name character varying, current_work_cycle_stage_number integer, 
  current_work_cycle_stage_name character varying, author_id integer, author_short_name character varying, can_be_removed boolean, sender_department_name character varying, 
  receiver_department_names character varying, product_code varchar) AS
$BODY$

select 
    distinct
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

    a.product_code
    
    from doc.service_notes a 
    join doc.employees e on e.id = a.author_id 
    join doc.document_types b on a.type_id = b.id 
    join doc.document_type_work_cycle_stages c on c.id = a.current_work_cycle_stage_id 
    where 
	exists(
		select 
		1 
		from doc.service_note_approvings sna
		where 
			document_id = a.id and 
			(cycle_number is not null or c.stage_number = 2) and
			exists(select 1 from doc.employees where id = sna.approver_id and department_id = any($1))

	)
	

$BODY$
  LANGUAGE sql VOLATILE
  COST 100
  ROWS 1000;

GRANT EXECUTE ON FUNCTION doc.get_approveable_service_notes_from_departments(bigint[]) TO umz_doc_edit;
REVOKE ALL ON FUNCTION doc.get_approveable_service_notes_from_departments(bigint[]) FROM public;
COMMENT ON FUNCTION doc.get_approveable_service_notes_from_departments(bigint[]) IS 'Возвращает согласуемые служебные записки из подразделений';


CREATE OR REPLACE FUNCTION doc.get_outcoming_service_notes_from_departments(IN department_ids bigint[])
  RETURNS TABLE(id integer, base_document_id integer, type_id integer, name character varying, number character varying, document_date date, 
  creation_date date, creation_date_year integer, creation_date_month integer, type_name character varying, current_work_cycle_stage_number integer,
   current_work_cycle_stage_name character varying, author_id integer, is_self_registered boolean, author_short_name character varying, department_name character varying, 
   can_be_removed boolean, product_code varchar) AS
$BODY$
select   
    distinct
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
    (e.surname || ' '  || e.name || ' '  || e.patronymic)::varchar as author_short_name, 
    a.receiving_department_names as department_name,
    null::boolean as can_be_removed,
    a.product_code
    
    from doc.service_notes a 
    join doc.employees e on e.id = a.author_id  
    join doc.document_types b on a.type_id = b.id 
    join doc.document_type_work_cycle_stages c on c.id = a.current_work_cycle_stage_id 
    where e.department_id = any($1);

$BODY$
  LANGUAGE sql VOLATILE
  COST 100
  ROWS 1000;

GRANT EXECUTE ON FUNCTION doc.get_outcoming_service_notes_from_departments(bigint[]) TO umz_doc_edit;
REVOKE ALL ON FUNCTION doc.get_outcoming_service_notes_from_departments(bigint[]) FROM public;
COMMENT ON FUNCTION doc.get_outcoming_service_notes_from_departments(bigint[]) IS 'Возвращает исходящие служебные записки из подразделений';

CREATE OR REPLACE FUNCTION doc.get_personnel_orders_for_employee(IN employee_id integer)
  RETURNS TABLE(is_document_viewed boolean, id integer, base_document_id integer, type_id integer, sub_type_id integer, sub_type_name character varying, 
  name character varying, number character varying, document_date date, creation_date date, creation_date_year integer, creation_date_month integer, 
  type_name character varying, current_work_cycle_stage_number integer, current_work_cycle_stage_name character varying, author_id integer, 
  author_short_name character varying, author_department_short_name character varying, can_be_removed boolean, are_applications_exists boolean, product_code varchar) AS
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
    po.product_code
    
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
	);
			
		
$BODY$
  LANGUAGE sql VOLATILE
  COST 100
  ROWS 1000;

GRANT EXECUTE ON FUNCTION doc.get_personnel_orders_for_employee(integer) TO umz_doc_edit;
REVOKE ALL ON FUNCTION doc.get_personnel_orders_for_employee(integer) FROM public;

DROP FUNCTION doc.get_personnel_orders_from_departments(integer[]);
CREATE OR REPLACE FUNCTION doc.get_personnel_orders_for_employee_by_ids(
    IN employee_id integer,
    IN document_ids integer[])
  RETURNS TABLE(is_document_viewed boolean, id integer, base_document_id integer, type_id integer, sub_type_id integer, 
  sub_type_name character varying, name character varying, number character varying, document_date date, creation_date date, 
  creation_date_year integer, creation_date_month integer, type_name character varying, current_work_cycle_stage_number integer, 
  current_work_cycle_stage_name character varying, author_id integer, author_short_name character varying, author_department_short_name character varying, 
  can_be_removed boolean, are_applications_exists boolean, product_code varchar) AS
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
    po.product_code
    
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
    where (po.id = any($2)) and
	((po.author_id = $1) 
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
	));
			
		
$BODY$
  LANGUAGE sql VOLATILE
  COST 100
  ROWS 1000;

GRANT EXECUTE ON FUNCTION doc.get_personnel_orders_for_employee_by_ids(integer, integer[]) TO umz_doc_edit;
REVOKE ALL ON FUNCTION doc.get_personnel_orders_for_employee_by_ids(integer, integer[]) FROM public;

CREATE OR REPLACE FUNCTION doc.get_personnel_orders_from_departments(IN department_ids integer[])
  RETURNS TABLE(id integer, base_document_id integer, type_id integer, sub_type_id integer, sub_type_name character varying, 
  name character varying, number character varying, document_date date, creation_date date, creation_date_year integer, creation_date_month integer, 
  type_name character varying, current_work_cycle_stage_number integer, current_work_cycle_stage_name character varying, author_id integer, author_short_name character varying, 
  author_department_short_name character varying, can_be_removed boolean, product_code varchar) AS
$BODY$

select  
    distinct
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
    po.product_code
    
    from doc.personnel_orders po 
    join doc.personnel_order_sub_kinds posk on posk.id = po.sub_type_id
    join doc.employees e on e.id = po.author_id  
    join doc.departments d on d.id = e.department_id
    join doc.document_types dt on po.type_id = dt.id 
    join doc.document_type_work_cycle_stages dtwcs on dtwcs.id = po.current_work_cycle_stage_id 
    where e.department_id = any($1);
    
$BODY$
  LANGUAGE sql VOLATILE
  COST 100
  ROWS 1000;

GRANT EXECUTE ON FUNCTION doc.get_personnel_orders_from_departments(integer[]) TO umz_doc_edit;
REVOKE ALL ON FUNCTION doc.get_personnel_orders_from_departments(integer[]) FROM public;

