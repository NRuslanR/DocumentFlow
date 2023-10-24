--
-- PostgreSQL database dump
--

-- Dumped from database version 14.6
-- Dumped by pg_dump version 14.9

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET client_encoding = 'WIN1251';
SET standard_conforming_strings = off;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET escape_string_warning = off;
SET row_security = off;

--
-- Name: doc; Type: SCHEMA; Schema: -; Owner: sup
--

CREATE SCHEMA doc;


ALTER SCHEMA doc OWNER TO sup;

--
-- Name: SCHEMA doc; Type: COMMENT; Schema: -; Owner: sup
--

COMMENT ON SCHEMA doc IS 'Схема для электронного документооборота';


--
-- Name: employee_link; Type: TYPE; Schema: doc; Owner: u_57791
--

CREATE TYPE doc.employee_link AS (
	employee_id bigint,
	role_id bigint,
	department_id bigint,
	head_kindred_department_id bigint
);


ALTER TYPE doc.employee_link OWNER TO u_57791;

--
-- Name: employee_replacement; Type: TYPE; Schema: doc; Owner: u_57791
--

CREATE TYPE doc.employee_replacement AS (
	deputy_id integer,
	replacement_period_start timestamp without time zone,
	replacement_period_end timestamp without time zone
);


ALTER TYPE doc.employee_replacement OWNER TO u_57791;

--
-- Name: add_new_department(character varying, character varying, character varying, integer); Type: FUNCTION; Schema: doc; Owner: developers
--

CREATE FUNCTION doc.add_new_department(code character varying, short_name character varying, full_name character varying, top_level_department_id integer DEFAULT NULL::integer) RETURNS integer
    LANGUAGE sql
    AS $_$
	insert into doc.departments (
		code,
		short_name,
		full_name,
		top_level_department_id,
		is_activated
	)
	values ($1, $2, $3, $4, true)
	returning id;
$_$;


ALTER FUNCTION doc.add_new_department(code character varying, short_name character varying, full_name character varying, top_level_department_id integer) OWNER TO developers;

--
-- Name: add_new_employee(integer, character varying, character varying, character varying, character varying, character varying, character varying, integer, character varying, integer, integer, boolean, boolean); Type: FUNCTION; Schema: doc; Owner: developers
--

CREATE FUNCTION doc.add_new_employee(department_id integer, short_full_name character varying, speciality character varying, personnel_number character varying, name character varying, surname character varying, patronymic character varying, leader_id integer, login character varying, spr_person_id integer, role_id integer, is_foreign boolean DEFAULT false, is_sd_user boolean DEFAULT false) RETURNS integer
    LANGUAGE sql
    AS $_$
	with add_employee_personnel_info as (
		insert into doc.employees (
			department_id,
			short_full_name,
			speciality,
			personnel_number,
			name,
			surname,
			patronymic,
			leader_id,
			login,
			spr_person_id,
			is_foreign,
			is_sd_user
		)
		values ($1, $2, $3, $4, $5, $6, $7, $8, $9, $10, $12, $13) 
		returning id
	),
	add_employee_role_info as (
		insert into doc.employees_roles (
			employee_id,
			role_id
		)
		values ((select id from add_employee_personnel_info), $11)
		returning employee_id
	)
	select 
	employee_id
	from (
		select
			(select employee_id from add_employee_role_info)
	) q	
$_$;


ALTER FUNCTION doc.add_new_employee(department_id integer, short_full_name character varying, speciality character varying, personnel_number character varying, name character varying, surname character varying, patronymic character varying, leader_id integer, login character varying, spr_person_id integer, role_id integer, is_foreign boolean, is_sd_user boolean) OWNER TO developers;

--
-- Name: are_document_applications_exists(integer, integer); Type: FUNCTION; Schema: doc; Owner: developers
--

CREATE FUNCTION doc.are_document_applications_exists(document_id integer, document_type_id integer) RETURNS boolean
    LANGUAGE sql STABLE
    AS $_$
	select 
		case 
		    when $2 = 2
		    then 
			(
				select
				distinct coalesce(snl.document_id, snfm.document_id)
				from doc.service_notes sn
				left join doc.service_note_file_metadata snfm on snfm.document_id = sn.id
				left join doc.service_note_links snl on snl.document_id = sn.id
				where sn.id = $1
			) is not null
		    else
		        case 
		            when $2 = 11 
		            then
		                (
					select
					distinct coalesce(pol.document_id, pofm.document_id)
					from doc.personnel_orders po
					left join doc.personnel_order_file_metadata pofm on pofm.document_id = po.id
					left join doc.personnel_order_links pol on pol.document_id = po.id
					where po.id = $1
				) is not null
			    else
				(
					select
					distinct coalesce(dl.document_id, dfm.document_id)
					from doc.documents d
					left join doc.document_file_metadata dfm on dfm.document_id = d.id
					left join doc.document_links dl on dl.document_id = d.id
					where d.id = $1
				) is not null
			end
		end;
				
$_$;


ALTER FUNCTION doc.are_document_applications_exists(document_id integer, document_type_id integer) OWNER TO developers;

--
-- Name: are_employees_secretaries_of_same_leader(integer[]); Type: FUNCTION; Schema: doc; Owner: developers
--

CREATE FUNCTION doc.are_employees_secretaries_of_same_leader(employee_ids integer[]) RETURNS boolean
    LANGUAGE sql STABLE
    AS $$

	select 
	(count(a.leader_id) = array_length(employee_ids, 1)) 
	and (count(distinct a.leader_id) = 1)
	and (count(distinct a.department_id) = 1)
	from doc.employees a
	join doc.employees d on d.id = a.leader_id
	join doc.employees_roles b on b.employee_id = a.id
	join doc.employees_roles c on c.employee_id = a.leader_id
	where (array[a.id] <@ employee_ids) and (b.role_id in (4, 6)) and c.role_id = 2
	and a.department_id = d.department_id
	
$$;


ALTER FUNCTION doc.are_employees_secretaries_of_same_leader(employee_ids integer[]) OWNER TO developers;

--
-- Name: are_employees_subleaders_of_same_leader(integer[]); Type: FUNCTION; Schema: doc; Owner: developers
--

CREATE FUNCTION doc.are_employees_subleaders_of_same_leader(employee_ids integer[]) RETURNS boolean
    LANGUAGE sql STABLE
    AS $$
	select 
	count(a.leader_id) = array_length(employee_ids, 1) 
	and count(distinct a.leader_id) = 1
	and count(distinct a.department_id) = 1
	from doc.employees a
	join doc.employees d on a.leader_id = d.id
	join doc.employees_roles b on b.employee_id = a.id
	join doc.employees_roles c on c.employee_id = a.leader_id
	where (array[a.id] <@ employee_ids) and (b.role_id in (3,6) and c.role_id = 2) and
		(a.department_id = d.department_id)
$$;


ALTER FUNCTION doc.are_employees_subleaders_of_same_leader(employee_ids integer[]) OWNER TO developers;

--
-- Name: are_employees_with_given_roles_of_same_leader(integer[], integer[]); Type: FUNCTION; Schema: doc; Owner: developers
--

CREATE FUNCTION doc.are_employees_with_given_roles_of_same_leader(employee_ids integer[], role_ids integer[]) RETURNS boolean
    LANGUAGE sql STABLE
    AS $$
	select 
	count(a.leader_id) = array_length(employee_ids, 1) and count(distinct leader_id) = 1
	from doc.employees a
	join doc.employees_roles b on b.employee_id = a.id
	join doc.employees_roles c on c.employee_id = a.leader_id
	where array[a.id] <@ employee_ids and array[b.role_id] <@ role_ids and c.role_id = 2
$$;


ALTER FUNCTION doc.are_employees_with_given_roles_of_same_leader(employee_ids integer[], role_ids integer[]) OWNER TO developers;

--
-- Name: assign_application_to_document_charge(integer, bigint, bigint); Type: FUNCTION; Schema: doc; Owner: developers
--

CREATE FUNCTION doc.assign_application_to_document_charge(document_type_id integer, application_id bigint, document_charge_id bigint) RETURNS void
    LANGUAGE plpgsql
    AS $_$
declare
	document_table_name varchar;
	assign_application_id_query_text varchar;
	check_that_charge_existing_query_text varchar;
	found_document_charge_id int;
begin

	if document_type_id = 2 then
		document_table_name = 'doc.service_note_receivers';

	else
		document_table_name = 'doc.document_receivers';
	end if;

	check_that_charge_existing_query_text = 
		'select id from ' || document_table_name || ' where id=$1';

	execute check_that_charge_existing_query_text into found_document_charge_id using document_charge_id;

	if found_document_charge_id is null then 
		raise exception 'Поручение с идентификатором % не найдено', document_charge_id;
	end if;
	
	assign_application_id_query_text = 
		'update ' || document_table_name || ' set application_id=$2 where id=$3';
	
	execute assign_application_id_query_text using document_table_name, application_id, document_charge_id;
	
	return;
end
$_$;


ALTER FUNCTION doc.assign_application_to_document_charge(document_type_id integer, application_id bigint, document_charge_id bigint) OWNER TO developers;

--
-- Name: FUNCTION assign_application_to_document_charge(document_type_id integer, application_id bigint, document_charge_id bigint); Type: COMMENT; Schema: doc; Owner: developers
--

COMMENT ON FUNCTION doc.assign_application_to_document_charge(document_type_id integer, application_id bigint, document_charge_id bigint) IS 'Назначение заявки на поручение по документу';


--
-- Name: assign_schema_objects_owner(character varying, character varying); Type: FUNCTION; Schema: doc; Owner: developers
--

CREATE FUNCTION doc.assign_schema_objects_owner(schema_name character varying, user_name character varying) RETURNS void
    LANGUAGE plpgsql
    AS $_$
declare
	alter_expr record;
begin
	for alter_expr in
			select
			q.* as value
			from (
			select
			'alter table ' || n.nspname || '.' || c.relname || ' owner to ' || $2 as value
			from pg_class c
			join pg_namespace n on n.oid = relnamespace
			where n.nspname ~* $1 and c.relkind = 'r' and relname !~* '^sd_'

			union

			select 
			'alter function ' || n.nspname || '.' || p.proname || '(' || coalesce((
				select 
				string_agg(q.arg_type_name, ', ')
				from (
				select 
				(select
				case when t.typarray = 0 then n.nspname || '.' || regexp_replace(t.typname, '^_', '') || '[]' else n.nspname || '.' || t.typname end as arg_type_name
				from pg_type as t
				left join pg_type as arr on arr.oid = t.typarray
				join pg_namespace as n on n.oid = t.typnamespace
				where t.oid = arg_type_ids.id
			 )
			 from unnest(p.proargtypes) as arg_type_ids(id)
			) q 
			), '') || ')' || ' owner to ' || $2 as value
			from pg_proc p
			join pg_namespace n on p.pronamespace = n.oid
			where n.nspname ~* $1 and p.proname !~* '^sd_'

			union

			select 
			'alter sequence ' || n.nspname || '.' || c.relname || ' owner to ' || $2 as value
			from pg_class c
			join pg_namespace n on n.oid = relnamespace
			where 
			n.nspname ~* $1 and 
			c.relkind = 'S' and relname !~* '^sd_'
			)q
			order by q.* loop

			execute alter_expr.value;
	end loop;

end
$_$;


ALTER FUNCTION doc.assign_schema_objects_owner(schema_name character varying, user_name character varying) OWNER TO developers;

--
-- Name: assign_test_roles(integer[], character varying[]); Type: FUNCTION; Schema: doc; Owner: developers
--

CREATE FUNCTION doc.assign_test_roles(employee_ids integer[], role_names character varying[]) RETURNS void
    LANGUAGE plpgsql
    AS $$
begin

	if cardinality(employee_ids) <> cardinality(role_names) then
		raise 'Array lengths aren''t equal';
	end if;
	
	update doc.employees e set login = role_names[array_position(employee_ids, emp.id)]
	from unnest(employee_ids) as emp(id) 
	where emp.id = e.id;
	
end
$$;


ALTER FUNCTION doc.assign_test_roles(employee_ids integer[], role_names character varying[]) OWNER TO developers;

--
-- Name: calc_head_kindred_department_for_employee_trigger_proc(); Type: FUNCTION; Schema: doc; Owner: developers
--

CREATE FUNCTION doc.calc_head_kindred_department_for_employee_trigger_proc() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
begin
	
	new.head_kindred_department_id = doc.find_head_kindred_department_for_inner(new.department_id);

	--raise exception '%', new.head_kindred_department_id;
	/*
	update doc.employees set head_kindred_department_id = null 
	where leader_id = new.id and exists(select 1 from doc.employees_roles where employee_id = new.id and role_id = 2);
	*/
	return new;
end
$$;


ALTER FUNCTION doc.calc_head_kindred_department_for_employee_trigger_proc() OWNER TO developers;

--
-- Name: create_short_full_name_from(character varying, character varying, character varying); Type: FUNCTION; Schema: doc; Owner: developers
--

CREATE FUNCTION doc.create_short_full_name_from(family character varying, name character varying, patronymic character varying) RETURNS character varying
    LANGUAGE sql
    AS $$
select initcap(family) || ' ' || upper(left(name, 1)) || '.' || upper(left(patronymic, 1)) || '.';
$$;


ALTER FUNCTION doc.create_short_full_name_from(family character varying, name character varying, patronymic character varying) OWNER TO developers;

--
-- Name: find_all_same_head_kindred_department_leaders_for_employee(integer); Type: FUNCTION; Schema: doc; Owner: developers
--

CREATE FUNCTION doc.find_all_same_head_kindred_department_leaders_for_employee(employee_id integer) RETURNS TABLE(id integer, name character varying, surname character varying, patronymic character varying, speciality character varying, personnel_number character varying, telephone_number character varying, is_foreign boolean, department_code character varying, department_short_name character varying, department_full_name character varying, leader_id integer, role_id integer, department_id integer, head_kindred_department_id integer)
    LANGUAGE sql STABLE
    AS $_$
with recursive
employee_leaders(
id,name,surname,patronymic,speciality,personnel_number,
telephone_number,is_foreign,department_id,department_code,department_short_name,department_full_name,leader_id,head_kindred_department_id
)
as (
select 
a.id,
a.name,
a.surname,
a.patronymic,
a.speciality,
a.personnel_number,
a.telephone_number,
a.is_foreign,
b.department_id,
a.department_code,
a.department_short_name,
a.department_full_name,
a.leader_id,
b.head_kindred_department_id
from doc.v_employees a
join doc.employees b on b.id = a.id
where a.id = $1
union
select 
b.id,
b.name,
b.surname,
b.patronymic,
b.speciality,
b.personnel_number,
b.telephone_number,
b.is_foreign,
c.department_id,
b.department_code,
b.department_short_name,
b.department_full_name,
b.leader_id,
c.head_kindred_department_id
from employee_leaders a
join doc.v_employees b on a.leader_id = b.id
join doc.employees c on c.id = b.id
),
get_leader as
(
select 
a.*,
b.role_id
from employee_leaders a
join doc.employees_roles b on a.id = b.employee_id
join doc.employees c on c.id = $1
where b.role_id = 2 and c.head_kindred_department_id = a.head_kindred_department_id
)
select 
id,
name,
surname,
patronymic,
speciality,
personnel_number,
telephone_number,
is_foreign,
department_code,
department_short_name,
department_full_name,
leader_id,
role_id, 
department_id,
head_kindred_department_id
from
(
select * from get_leader 
) get_signers
order by id
$_$;


ALTER FUNCTION doc.find_all_same_head_kindred_department_leaders_for_employee(employee_id integer) OWNER TO developers;

--
-- Name: find_employee_id_by_login(character varying); Type: FUNCTION; Schema: doc; Owner: developers
--

CREATE FUNCTION doc.find_employee_id_by_login(employee_login character varying) RETURNS integer
    LANGUAGE sql STABLE
    AS $_$
	select 
	id as id 
	from doc.employees 
	where login = $1 and
	was_dismissed = false and
	exists (select 1 from doc.employees_roles where employee_id = id);
$_$;


ALTER FUNCTION doc.find_employee_id_by_login(employee_login character varying) OWNER TO developers;

--
-- Name: find_head_kindred_department_for_inner(integer); Type: FUNCTION; Schema: doc; Owner: developers
--

CREATE FUNCTION doc.find_head_kindred_department_for_inner(inner_department_id integer) RETURNS integer
    LANGUAGE sql STABLE
    AS $_$
with recursive department_branch(department_id, top_level_department_id, is_top_level_department_kindred, level) as (
	select
	id as department_id,
	top_level_department_id,
	is_top_level_department_kindred,
	0 as level
	from doc.departments
	where id = $1
union
	select 
	a.id as department_id,
	a.top_level_department_id,
	a.is_top_level_department_kindred,
	b.level + 1 as level
	from doc.departments a
	join department_branch b on b.top_level_department_id = a.id
	where b.is_top_level_department_kindred 
)
select 
department_id
from department_branch 
where level = (select max(level) from department_branch)

$_$;


ALTER FUNCTION doc.find_head_kindred_department_for_inner(inner_department_id integer) OWNER TO developers;

--
-- Name: get_approveable_service_notes_for_employee(integer, character varying[]); Type: FUNCTION; Schema: doc; Owner: developers
--

CREATE FUNCTION doc.get_approveable_service_notes_for_employee(employee_id integer, stage_names character varying[] DEFAULT NULL::character varying[]) RETURNS TABLE(is_document_viewed boolean, id integer, base_document_id integer, type_id integer, name character varying, number character varying, document_date date, creation_date date, creation_date_year integer, creation_date_month integer, type_name character varying, current_work_cycle_stage_number integer, current_work_cycle_stage_name character varying, author_id integer, charges_stat character varying, author_short_name character varying, can_be_removed boolean, sender_department_name character varying, receiver_department_names character varying, are_applications_exists boolean, product_code character varying)
    LANGUAGE sql STABLE
    AS $_$

    select 
    distinct
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
    
    receiving_department_names,

    a.applications_exists,

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
    case when $2 is not null then array[c.stage_name] <@ $2 else true end
    and
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
$_$;


ALTER FUNCTION doc.get_approveable_service_notes_for_employee(employee_id integer, stage_names character varying[]) OWNER TO developers;

--
-- Name: get_approveable_service_notes_for_employee_by_ids(integer, integer[]); Type: FUNCTION; Schema: doc; Owner: developers
--

CREATE FUNCTION doc.get_approveable_service_notes_for_employee_by_ids(employee_id integer, document_ids integer[]) RETURNS TABLE(is_document_viewed boolean, id integer, base_document_id integer, type_id integer, name character varying, number character varying, document_date date, creation_date date, creation_date_year integer, creation_date_month integer, type_name character varying, current_work_cycle_stage_number integer, current_work_cycle_stage_name character varying, author_id integer, charges_stat character varying, author_short_name character varying, can_be_removed boolean, sender_department_name character varying, receiver_department_names character varying, are_applications_exists boolean, product_code character varying)
    LANGUAGE sql STABLE
    AS $_$


    select 
	distinct
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
$_$;


ALTER FUNCTION doc.get_approveable_service_notes_for_employee_by_ids(employee_id integer, document_ids integer[]) OWNER TO developers;

--
-- Name: FUNCTION get_approveable_service_notes_for_employee_by_ids(employee_id integer, document_ids integer[]); Type: COMMENT; Schema: doc; Owner: developers
--

COMMENT ON FUNCTION doc.get_approveable_service_notes_for_employee_by_ids(employee_id integer, document_ids integer[]) IS 'Возвращает согласуемые служебные записки, к которым имеет доступ сотрудник, по их идентификаторам';


--
-- Name: get_approveable_service_notes_for_employee_old(integer); Type: FUNCTION; Schema: doc; Owner: developers
--

CREATE FUNCTION doc.get_approveable_service_notes_for_employee_old(employee_id integer) RETURNS TABLE(is_document_viewed boolean, id integer, base_document_id integer, type_id integer, name character varying, number character varying, document_date date, creation_date date, creation_date_year integer, creation_date_month integer, type_name character varying, current_work_cycle_stage_number integer, current_work_cycle_stage_name character varying, author_id integer, charges_stat character varying, author_short_name character varying, can_be_removed boolean, sender_department_name character varying, receiver_department_names character varying, are_applications_exists boolean, product_code character varying)
    LANGUAGE sql STABLE
    AS $_$

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
$_$;


ALTER FUNCTION doc.get_approveable_service_notes_for_employee_old(employee_id integer) OWNER TO developers;

--
-- Name: FUNCTION get_approveable_service_notes_for_employee_old(employee_id integer); Type: COMMENT; Schema: doc; Owner: developers
--

COMMENT ON FUNCTION doc.get_approveable_service_notes_for_employee_old(employee_id integer) IS 'Возвращает согласуемые служебные записки, к которым имеет доступ сотрудник';


--
-- Name: get_approveable_service_notes_for_employee_old(integer, character varying[]); Type: FUNCTION; Schema: doc; Owner: developers
--

CREATE FUNCTION doc.get_approveable_service_notes_for_employee_old(employee_id integer, stage_names character varying[] DEFAULT NULL::character varying[]) RETURNS TABLE(is_document_viewed boolean, id integer, base_document_id integer, type_id integer, name character varying, number character varying, document_date date, creation_date date, creation_date_year integer, creation_date_month integer, type_name character varying, current_work_cycle_stage_number integer, current_work_cycle_stage_name character varying, author_id integer, charges_stat character varying, author_short_name character varying, can_be_removed boolean, sender_department_name character varying, receiver_department_names character varying, are_applications_exists boolean, product_code character varying)
    LANGUAGE sql STABLE
    AS $_$

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
    
    receiving_department_names,

    a.applications_exists,

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
    case when $2 is not null then array[c.stage_name] <@ $2 else true end
    and
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
$_$;


ALTER FUNCTION doc.get_approveable_service_notes_for_employee_old(employee_id integer, stage_names character varying[]) OWNER TO developers;

--
-- Name: FUNCTION get_approveable_service_notes_for_employee_old(employee_id integer, stage_names character varying[]); Type: COMMENT; Schema: doc; Owner: developers
--

COMMENT ON FUNCTION doc.get_approveable_service_notes_for_employee_old(employee_id integer, stage_names character varying[]) IS 'Возвращает согласуемые служебные записки, к которым имеет доступ сотрудник';


--
-- Name: get_approveable_service_notes_from_departments(bigint[]); Type: FUNCTION; Schema: doc; Owner: developers
--

CREATE FUNCTION doc.get_approveable_service_notes_from_departments(department_ids bigint[]) RETURNS TABLE(id integer, base_document_id integer, type_id integer, name character varying, number character varying, document_date date, creation_date date, creation_date_year integer, creation_date_month integer, type_name character varying, current_work_cycle_stage_number integer, current_work_cycle_stage_name character varying, author_id integer, author_short_name character varying, can_be_removed boolean, sender_department_name character varying, receiver_department_names character varying, product_code character varying)
    LANGUAGE sql STABLE
    AS $_$

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
	

$_$;


ALTER FUNCTION doc.get_approveable_service_notes_from_departments(department_ids bigint[]) OWNER TO developers;

--
-- Name: FUNCTION get_approveable_service_notes_from_departments(department_ids bigint[]); Type: COMMENT; Schema: doc; Owner: developers
--

COMMENT ON FUNCTION doc.get_approveable_service_notes_from_departments(department_ids bigint[]) IS 'Возвращает согласуемые служебные записки из подразделений';


--
-- Name: get_current_employee_id(); Type: FUNCTION; Schema: doc; Owner: developers
--

CREATE FUNCTION doc.get_current_employee_id() RETURNS integer
    LANGUAGE sql STABLE SECURITY DEFINER
    AS $$
select doc.find_employee_id_by_login(session_user::varchar) as id
$$;


ALTER FUNCTION doc.get_current_employee_id() OWNER TO developers;

--
-- Name: get_department_approveable_service_notes_by_ids(integer[]); Type: FUNCTION; Schema: doc; Owner: developers
--

CREATE FUNCTION doc.get_department_approveable_service_notes_by_ids(document_ids integer[]) RETURNS TABLE(id integer, base_document_id integer, type_id integer, name character varying, number character varying, document_date date, creation_date date, creation_date_year integer, creation_date_month integer, type_name character varying, current_work_cycle_stage_number integer, current_work_cycle_stage_name character varying, author_id integer, author_short_name character varying, can_be_removed boolean, sender_department_name character varying, receiver_department_names character varying)
    LANGUAGE sql STABLE
    AS $_$

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
    ) as receiver_department_names
    
    from doc.service_notes a 
    join doc.employees e on e.id = a.author_id 
    join doc.document_types b on a.type_id = b.id 
    join doc.document_type_work_cycle_stages c on c.id = a.current_work_cycle_stage_id 
    where 
	a.id = any($1)
	and exists(
		select 
		1 
		from doc.service_note_approvings sna
		where 
			document_id = a.id and 
			(cycle_number is not null or c.stage_number = 2)
	);

$_$;


ALTER FUNCTION doc.get_department_approveable_service_notes_by_ids(document_ids integer[]) OWNER TO developers;

--
-- Name: FUNCTION get_department_approveable_service_notes_by_ids(document_ids integer[]); Type: COMMENT; Schema: doc; Owner: developers
--

COMMENT ON FUNCTION doc.get_department_approveable_service_notes_by_ids(document_ids integer[]) IS 'Возвращает согласуемые служебные записки подразделений по их идентификаторам';


--
-- Name: get_department_incoming_service_notes_by_ids(integer[]); Type: FUNCTION; Schema: doc; Owner: developers
--

CREATE FUNCTION doc.get_department_incoming_service_notes_by_ids(document_ids integer[]) RETURNS TABLE(id integer, base_document_id integer, type_id integer, type_name character varying, number character varying, receipt_date date, outcomming_number character varying, name character varying, document_date date, creation_date date, creation_date_year integer, creation_date_month integer, current_work_cycle_stage_number integer, current_work_cycle_stage_name character varying, author_id integer, author_short_name character varying, department_name character varying, can_be_removed boolean)
    LANGUAGE sql STABLE
    AS $_$
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
    null::boolean as can_be_removed
   
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
	and snr.head_charge_sheet_id = any($1);

$_$;


ALTER FUNCTION doc.get_department_incoming_service_notes_by_ids(document_ids integer[]) OWNER TO developers;

--
-- Name: FUNCTION get_department_incoming_service_notes_by_ids(document_ids integer[]); Type: COMMENT; Schema: doc; Owner: developers
--

COMMENT ON FUNCTION doc.get_department_incoming_service_notes_by_ids(document_ids integer[]) IS 'Возвращает входящие служебные записки подразделений по их идентификаторам';


--
-- Name: get_department_outcoming_service_notes_by_ids(integer[]); Type: FUNCTION; Schema: doc; Owner: developers
--

CREATE FUNCTION doc.get_department_outcoming_service_notes_by_ids(document_ids integer[]) RETURNS TABLE(id integer, base_document_id integer, type_id integer, name character varying, number character varying, document_date date, creation_date date, creation_date_year integer, creation_date_month integer, type_name character varying, current_work_cycle_stage_number integer, current_work_cycle_stage_name character varying, author_id integer, is_self_registered boolean, author_short_name character varying, department_name character varying, can_be_removed boolean)
    LANGUAGE sql STABLE
    AS $_$
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
    (
	select 
	string_agg(distinct d.short_name, ', ')
	from doc.service_note_receivers snr 
	join doc.employees e on e.id = snr.performer_id
	join doc.departments d on d.id = e.department_id
	where snr.document_id = a.id and top_level_charge_sheet_id is null
    ) as department_name,
    null::boolean as can_be_removed
    from doc.service_notes a 
    join doc.employees e on e.id = a.author_id  
    join doc.document_types b on a.type_id = b.id 
    join doc.document_type_work_cycle_stages c on c.id = a.current_work_cycle_stage_id 
    where a.id = any($1);

$_$;


ALTER FUNCTION doc.get_department_outcoming_service_notes_by_ids(document_ids integer[]) OWNER TO developers;

--
-- Name: FUNCTION get_department_outcoming_service_notes_by_ids(document_ids integer[]); Type: COMMENT; Schema: doc; Owner: developers
--

COMMENT ON FUNCTION doc.get_department_outcoming_service_notes_by_ids(document_ids integer[]) IS 'Возвращает исходящие служебные записки подразделений по их идентификаторам';


--
-- Name: get_department_personnel_orders_by_ids(integer[]); Type: FUNCTION; Schema: doc; Owner: developers
--

CREATE FUNCTION doc.get_department_personnel_orders_by_ids(document_ids integer[]) RETURNS TABLE(id integer, base_document_id integer, type_id integer, sub_type_id integer, sub_type_name character varying, name character varying, number character varying, document_date date, creation_date date, creation_date_year integer, creation_date_month integer, type_name character varying, current_work_cycle_stage_number integer, current_work_cycle_stage_name character varying, author_id integer, author_short_name character varying, author_department_short_name character varying, can_be_removed boolean)
    LANGUAGE sql STABLE
    AS $_$

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
    null::boolean as can_be_removed 
    from doc.personnel_orders po 
    join doc.personnel_order_sub_kinds posk on posk.id = po.sub_type_id
    join doc.employees e on e.id = po.author_id  
    join doc.departments d on d.id = e.department_id
    join doc.document_types dt on po.type_id = dt.id 
    join doc.document_type_work_cycle_stages dtwcs on dtwcs.id = po.current_work_cycle_stage_id 
    where po.id = any($1);
    
$_$;


ALTER FUNCTION doc.get_department_personnel_orders_by_ids(document_ids integer[]) OWNER TO developers;

--
-- Name: get_department_tree_starting_with(integer); Type: FUNCTION; Schema: doc; Owner: developers
--

CREATE FUNCTION doc.get_department_tree_starting_with(start_department_id integer) RETURNS TABLE(id integer, code character varying, short_name character varying, full_name character varying)
    LANGUAGE sql STABLE
    AS $_$
	with recursive department_tree(id, code, short_name, full_name, level) as (

		select 
		id,
		code, 
		short_name,
		full_name,
		1 as level
		from doc.departments
		where id = $1

		union

		select 
		a.id,
		a.code,
		a.short_name,
		a.full_name,
		b.level + 1
		from doc.departments a
		join department_tree b on a.top_level_department_id = b.id
	)
	select 
	id,
	code,
	short_name,
	full_name
	from department_tree
	order by level; 
$_$;


ALTER FUNCTION doc.get_department_tree_starting_with(start_department_id integer) OWNER TO developers;

--
-- Name: get_employee_service_note_charge_sheets_performing_statistics(integer, integer, integer); Type: FUNCTION; Schema: doc; Owner: developers
--

CREATE FUNCTION doc.get_employee_service_note_charge_sheets_performing_statistics(document_id integer, employee_id integer, start_top_level_charge_sheet_id integer DEFAULT NULL::integer) RETURNS TABLE(performed_charge_count bigint, total_charge_count bigint, subordinate_charge_count bigint, subordinate_performed_charge_count bigint)
    LANGUAGE plpgsql STABLE
    AS $_$
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
	doc.service_note_receivers a
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
	from doc.service_note_receivers a
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
$_$;


ALTER FUNCTION doc.get_employee_service_note_charge_sheets_performing_statistics(document_id integer, employee_id integer, start_top_level_charge_sheet_id integer) OWNER TO developers;

--
-- Name: get_head_charge_sheet_for(integer); Type: FUNCTION; Schema: doc; Owner: developers
--

CREATE FUNCTION doc.get_head_charge_sheet_for(charge_sheet_id integer) RETURNS integer
    LANGUAGE sql STABLE
    AS $$
	with recursive head_charge_sheet_view (id, top_level_charge_sheet_id) as (
		select 
		id,
		top_level_charge_sheet_id
		from doc.service_note_receivers 
		where id = charge_sheet_id

		union

		select 
		snr.id,
		snr.top_level_charge_sheet_id
		from doc.service_note_receivers snr
		join head_charge_sheet_view t on t.top_level_charge_sheet_id = snr.id
		where t.top_level_charge_sheet_id is not null
	)
	select id from head_charge_sheet_view where top_level_charge_sheet_id is null;
$$;


ALTER FUNCTION doc.get_head_charge_sheet_for(charge_sheet_id integer) OWNER TO developers;

--
-- Name: get_incoming_service_note_performing_statistics_for_employee(integer, integer); Type: FUNCTION; Schema: doc; Owner: developers
--

CREATE FUNCTION doc.get_incoming_service_note_performing_statistics_for_employee(document_id integer, employee_id integer) RETURNS TABLE(performed_charge_count bigint, total_charge_count bigint, subordinate_charge_count bigint, subordinate_performed_charge_count bigint)
    LANGUAGE plpgsql STABLE
    AS $_$
begin
if document_id is null then 
	return query select 0::bigint as performed_charge_count, 0::bigint as total_charge_count, 0::bigint as subordinate_charge_count, 0::bigint as subordinate_performed_charge_count;

else  
	return query
	with recursive get_subordinate_document_performers (id, performing_date, top_level_charge_id) as
	(
	select 
	a.id,
	a.performing_date,
	null::integer as top_level_charge_id
	from 
	doc.service_note_receivers a
	where /*a.performing_date is null and*/ a.incoming_document_id = $1 and
		(a.outside_employee_id = $2 or doc.is_employee_acting_for_other_or_vice_versa($2, a.outside_employee_id))
	union
	select 
	a.id,
	a.performing_date,
	a.sender_id as top_level_charge_id	
	from doc.service_note_receivers a
	join get_subordinate_document_performers b on a.sender_id = b.id
	)
	select 
	count(distinct case when performing_date is not null then id else null end) as performed_charge_count,
	count(distinct id) as total_charge_count,
	count(distinct case when top_level_charge_id is not null then id else null end) as subordinate_charge_count,
	count(distinct case when top_level_charge_id is not null and performing_date is not null then id else null end) as subordinate_performed_charge_count
	from get_subordinate_document_performers;
	
end if;

end
$_$;


ALTER FUNCTION doc.get_incoming_service_note_performing_statistics_for_employee(document_id integer, employee_id integer) OWNER TO developers;

--
-- Name: get_incoming_service_notes_for_employee(integer, character varying[]); Type: FUNCTION; Schema: doc; Owner: developers
--

CREATE FUNCTION doc.get_incoming_service_notes_for_employee(employee_id integer, stage_names character varying[] DEFAULT NULL::character varying[]) RETURNS TABLE(own_charge boolean, type_id integer, type_name character varying, id integer, base_document_id integer, number character varying, receipt_date date, is_document_viewed boolean, outcomming_number character varying, name character varying, document_date date, creation_date date, creation_date_year integer, creation_date_month integer, author_id integer, author_short_name character varying, can_be_removed boolean, current_work_cycle_stage_number integer, current_work_cycle_stage_name character varying, department_name character varying, all_emp_charge_sheets_performed boolean, all_subord_charges_performed boolean, charges_stat character varying, are_applications_exists boolean, product_code character varying)
    LANGUAGE sql STABLE
    AS $_$

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
				then array[dtwcs.stage_name] <@ $2 
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
  
$_$;


ALTER FUNCTION doc.get_incoming_service_notes_for_employee(employee_id integer, stage_names character varying[]) OWNER TO developers;

--
-- Name: get_incoming_service_notes_for_employee_by_ids(integer, integer[]); Type: FUNCTION; Schema: doc; Owner: developers
--

CREATE FUNCTION doc.get_incoming_service_notes_for_employee_by_ids(employee_id integer, document_ids integer[]) RETURNS TABLE(own_charge boolean, type_id integer, type_name character varying, id integer, base_document_id integer, number character varying, receipt_date date, is_document_viewed boolean, outcomming_number character varying, name character varying, document_date date, creation_date date, creation_date_year integer, creation_date_month integer, author_id integer, author_short_name character varying, can_be_removed boolean, current_work_cycle_stage_number integer, current_work_cycle_stage_name character varying, department_name character varying, all_emp_charge_sheets_performed boolean, all_subord_charges_performed boolean, charges_stat character varying, are_applications_exists boolean, product_code character varying)
    LANGUAGE sql STABLE
    AS $_$

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
  
$_$;


ALTER FUNCTION doc.get_incoming_service_notes_for_employee_by_ids(employee_id integer, document_ids integer[]) OWNER TO developers;

--
-- Name: FUNCTION get_incoming_service_notes_for_employee_by_ids(employee_id integer, document_ids integer[]); Type: COMMENT; Schema: doc; Owner: developers
--

COMMENT ON FUNCTION doc.get_incoming_service_notes_for_employee_by_ids(employee_id integer, document_ids integer[]) IS 'Возвращает входящие служебные записки, к которым имеет доступ сотрудник, по их идентификаторам';


--
-- Name: get_incoming_service_notes_for_employee_old(integer, character varying[]); Type: FUNCTION; Schema: doc; Owner: developers
--

CREATE FUNCTION doc.get_incoming_service_notes_for_employee_old(employee_id integer, stage_names character varying[] DEFAULT NULL::character varying[]) RETURNS TABLE(own_charge boolean, type_id integer, type_name character varying, id integer, base_document_id integer, number character varying, receipt_date date, is_document_viewed boolean, outcomming_number character varying, name character varying, document_date date, creation_date date, creation_date_year integer, creation_date_month integer, author_id integer, author_short_name character varying, can_be_removed boolean, current_work_cycle_stage_number integer, current_work_cycle_stage_name character varying, department_name character varying, all_emp_charge_sheets_performed boolean, all_subord_charges_performed boolean, charges_stat character varying, are_applications_exists boolean, product_code character varying)
    LANGUAGE sql STABLE
    AS $_$

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
    and case when $2 is not null then array[dtwcs.stage_name] <@ $2 else true end
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
  
$_$;


ALTER FUNCTION doc.get_incoming_service_notes_for_employee_old(employee_id integer, stage_names character varying[]) OWNER TO developers;

--
-- Name: get_incoming_service_notes_for_employee_old1(integer, character varying[]); Type: FUNCTION; Schema: doc; Owner: developers
--

CREATE FUNCTION doc.get_incoming_service_notes_for_employee_old1(employee_id integer, stage_names character varying[] DEFAULT NULL::character varying[]) RETURNS TABLE(own_charge boolean, type_id integer, type_name character varying, id integer, base_document_id integer, number character varying, receipt_date date, is_document_viewed boolean, outcomming_number character varying, name character varying, document_date date, creation_date date, creation_date_year integer, creation_date_month integer, author_id integer, author_short_name character varying, can_be_removed boolean, current_work_cycle_stage_number integer, current_work_cycle_stage_name character varying, department_name character varying, all_emp_charge_sheets_performed boolean, all_subord_charges_performed boolean, charges_stat character varying, are_applications_exists boolean, product_code character varying)
    LANGUAGE sql STABLE
    AS $$

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
          when b.performer_id = 2574  
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
    join doc.employees cur_emp on cur_emp.id = 2574   
    join doc.document_type_work_cycle_stages dtwcs on dtwcs.document_type_id = c.id and dtwcs.service_stage_name = case when b.performing_date is not null then 'Performed' else 'IsPerforming' end 
    join doc.employees_roles cur_emp_role on cur_emp_role.employee_id = 2574  
    join lateral (select 2574 = b.performer_id or doc.is_employee_acting_for_other_or_vice_versa(2574, b.performer_id)) replacing(ok) on true
    where b.issuer_id is not null  
    and 
    	case 
			when null is not null 
				then array[dtwcs.stage_name] <@ null 
				else true 
		    end
    	and  
    (  
    b.performer_id = 2574   
    or   
    case  
    when cur_emp_role.role_id not in (5)  
    then doc.is_employee_workspace_includes_other_employee(2574 , b.performer_id)  
    else false end 
    or replacing.ok
    )
    )  
    select  

    case  
        when is_performer_replacing_ok   
        then  
      case   
          when isnc.performer_id = 2574    
          then true 
          else (
		((select count(*) from doc.employees e where leader_id = isnc.performer_id and not was_dismissed and exists (select 1 from doc.employees_roles where employee_id = e.id and role_id = 3)) = 1)
		and
		exists (select 1 from doc.employees_roles er where er.employee_id = 2574 and er.role_id = 3)
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
    where lsn.document_id = sn.id and lsn.looked_employee_id = 2574   
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
  
$$;


ALTER FUNCTION doc.get_incoming_service_notes_for_employee_old1(employee_id integer, stage_names character varying[]) OWNER TO developers;

--
-- Name: FUNCTION get_incoming_service_notes_for_employee_old1(employee_id integer, stage_names character varying[]); Type: COMMENT; Schema: doc; Owner: developers
--

COMMENT ON FUNCTION doc.get_incoming_service_notes_for_employee_old1(employee_id integer, stage_names character varying[]) IS 'Возвращает входящие служебные записки, к которым имеет доступ сотрудник';


--
-- Name: get_incoming_service_notes_for_employee_old_(integer, character varying[]); Type: FUNCTION; Schema: doc; Owner: developers
--

CREATE FUNCTION doc.get_incoming_service_notes_for_employee_old_(employee_id integer, stage_names character varying[] DEFAULT NULL::character varying[]) RETURNS TABLE(own_charge boolean, type_id integer, type_name character varying, id integer, base_document_id integer, number character varying, receipt_date date, is_document_viewed boolean, outcomming_number character varying, name character varying, document_date date, creation_date date, creation_date_year integer, creation_date_month integer, author_id integer, author_short_name character varying, can_be_removed boolean, current_work_cycle_stage_number integer, current_work_cycle_stage_name character varying, department_name character varying, all_emp_charge_sheets_performed boolean, all_subord_charges_performed boolean, charges_stat character varying, are_applications_exists boolean, product_code character varying)
    LANGUAGE sql STABLE
    AS $_$

    with incoming_service_notes_charges as (
	    with get_possible_incoming_service_notes as (
		select 
		distinct 
		snr.head_charge_sheet_id as id
		from doc.service_note_receivers snr
		join doc.employees own on own.id = $1
		join lateral (select * from doc.employees e where e.head_kindred_department_id =  own.head_kindred_department_id and not is_foreign) as leaders(id) on true
		left join doc.employees_employee_work_groups as eewg on eewg.employee_id = $1
		left join doc.employee_work_groups as ewg on ewg.id = eewg.work_group_id
		left join doc.employee_replacements er on er.deputy_id = $1

		where 

		(snr.issuer_id is not null)
		and (
		snr.performer_id = $1 
		or snr.performer_id = leaders.id
		or snr.performer_id = ewg.leader_id
		or snr.performer_id = replaceable_id and ((er.replacement_period_start <= now()) and (now() <= er.replacement_period_end)))
	    ) 
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
                  else 
                      case 
                          when b.top_level_charge_sheet_id is null
                          then 2
                          else 3
                      end
              end  
      end  
    ) as charge_number,  
      
    replacing.ok as is_performer_replacing_ok,
    total_charge_count,
    performed_charge_count,
    subordinate_charge_count,
    subordinate_performed_charge_count 
      
    from doc.service_note_receivers b  
    join get_possible_incoming_service_notes pisn on pisn.id = b.head_charge_sheet_id
    join doc.document_types c on c.id = b.incoming_document_type_id  
    join doc.employees cur_emp on cur_emp.id = $1   
    join doc.document_type_work_cycle_stages dtwcs on dtwcs.document_type_id = c.id and dtwcs.service_stage_name = case when b.performing_date is not null then 'Performed' else 'IsPerforming' end  
    join doc.employees_roles cur_emp_role on cur_emp_role.employee_id = $1  
    join lateral (select $1 = b.performer_id or doc.is_employee_acting_for_other_or_vice_versa($1, b.performer_id)) replacing(ok) on true
    where 
    b.issuer_id is not null
    and case when $2 is not null then array[dtwcs.stage_name] <@ $2 else true end 
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

    sn.applications_exists as are_applications_exists,

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
  
$_$;


ALTER FUNCTION doc.get_incoming_service_notes_for_employee_old_(employee_id integer, stage_names character varying[]) OWNER TO developers;

--
-- Name: FUNCTION get_incoming_service_notes_for_employee_old_(employee_id integer, stage_names character varying[]); Type: COMMENT; Schema: doc; Owner: developers
--

COMMENT ON FUNCTION doc.get_incoming_service_notes_for_employee_old_(employee_id integer, stage_names character varying[]) IS 'Возвращает согласуемые служебные записки, к которым имеет доступ сотрудник';


--
-- Name: get_incoming_service_notes_from_departments(bigint[]); Type: FUNCTION; Schema: doc; Owner: developers
--

CREATE FUNCTION doc.get_incoming_service_notes_from_departments(department_ids bigint[]) RETURNS TABLE(id integer, base_document_id integer, type_id integer, type_name character varying, number character varying, receipt_date date, outcomming_number character varying, name character varying, document_date date, creation_date date, creation_date_year integer, creation_date_month integer, current_work_cycle_stage_number integer, current_work_cycle_stage_name character varying, author_id integer, author_short_name character varying, department_name character varying, can_be_removed boolean, product_code character varying)
    LANGUAGE sql STABLE
    AS $_$
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

$_$;


ALTER FUNCTION doc.get_incoming_service_notes_from_departments(department_ids bigint[]) OWNER TO developers;

--
-- Name: FUNCTION get_incoming_service_notes_from_departments(department_ids bigint[]); Type: COMMENT; Schema: doc; Owner: developers
--

COMMENT ON FUNCTION doc.get_incoming_service_notes_from_departments(department_ids bigint[]) IS 'Возвращает входящие служебные записки из подразделений';


--
-- Name: get_kindred_department_tree_starting_with(integer); Type: FUNCTION; Schema: doc; Owner: developers
--

CREATE FUNCTION doc.get_kindred_department_tree_starting_with(start_department_id integer) RETURNS TABLE(id integer, code character varying, short_name character varying, full_name character varying)
    LANGUAGE sql STABLE
    AS $_$
	with recursive department_tree(id, code, short_name, full_name, is_top_level_department_kindred, level) as (

		select 
		id,
		code, 
		short_name,
		full_name,
		is_top_level_department_kindred,
		1 as level
		
		from doc.departments
		where id = $1

		union

		select 
		a.id,
		a.code,
		a.short_name,
		a.full_name,
		a.is_top_level_department_kindred,
		b.level + 1
		from doc.departments a
		join department_tree b on a.top_level_department_id = b.id
		where a.is_top_level_department_kindred
	)
	select 
	id,
	code,
	short_name,
	full_name
	from department_tree
	order by level; 
$_$;


ALTER FUNCTION doc.get_kindred_department_tree_starting_with(start_department_id integer) OWNER TO developers;

--
-- Name: get_new_status_for_request(integer); Type: FUNCTION; Schema: doc; Owner: developers
--

CREATE FUNCTION doc.get_new_status_for_request(request_id integer) RETURNS integer
    LANGUAGE sql STABLE
    AS $_$


with conts as (
	select * from exchange.postfix_res_request_contents prrc 
	where request_id = $1
)
select case 		
		when EXISTS(select 1 from conts where status_id = 4) and not EXISTS(select 1 from conts where status_id in (1,3)) then 4
		when EXISTS(select 1 from conts where status_id = 4) then 9		
		when EXISTS(select 1 from conts where status_id = 6) and not EXISTS(select 1 from conts where status_id <> 6) then 6
		when EXISTS(select 1 from conts where status_id = 6) then 10
		when EXISTS(select 1 from conts where status_id = 5) then 5
		when EXISTS(select 1 from conts where status_id = 7) then 7			
		when EXISTS(select 1 from conts where status_id = 1) and not EXISTS(select 1 from conts where status_id <> 1) then 1
		when EXISTS(select 1 from conts where status_id = 2) and not EXISTS(select 1 from conts where status_id <> 2 and status_id <> 3 and status_id <> 8) then 2
		when EXISTS(select 1 from conts where status_id = 3) then 3		
		when EXISTS(select 1 from conts where status_id = 8) then 8		
		when EXISTS(select 1 from conts where status_id = 10) then 10
		end as new_status


$_$;


ALTER FUNCTION doc.get_new_status_for_request(request_id integer) OWNER TO developers;

--
-- Name: FUNCTION get_new_status_for_request(request_id integer); Type: COMMENT; Schema: doc; Owner: developers
--

COMMENT ON FUNCTION doc.get_new_status_for_request(request_id integer) IS 'Возвращает новый статус для заявки на основе статусов её содержимого';


--
-- Name: get_not_kindred_inner_department_tree_for_department(integer); Type: FUNCTION; Schema: doc; Owner: developers
--

CREATE FUNCTION doc.get_not_kindred_inner_department_tree_for_department(start_department_id integer) RETURNS TABLE(id integer, code character varying, short_name character varying, full_name character varying)
    LANGUAGE plpgsql STABLE
    AS $_$
declare
	department_record record;
begin
	for department_record in select 
				 *
				 from doc.get_department_tree_starting_with($1) a
				 join doc.departments d on d.id = a.id
				 where (not d.is_top_level_department_kindred and $1 <> d.id)
	loop

		return query select * from doc.get_kindred_department_tree_starting_with(department_record.id);
		 
	end loop;
end
$_$;


ALTER FUNCTION doc.get_not_kindred_inner_department_tree_for_department(start_department_id integer) OWNER TO developers;

--
-- Name: get_not_performed_incoming_service_notes_report_data_for(integer, integer, date, date); Type: FUNCTION; Schema: doc; Owner: developers
--

CREATE FUNCTION doc.get_not_performed_incoming_service_notes_report_data_for(employee_id integer, department_id integer, period_start date DEFAULT NULL::date, period_end date DEFAULT NULL::date) RETURNS TABLE(number character varying, name character varying, content character varying, document_date date, creation_date date, leader_short_name character varying, incoming_number character varying, receipt_date date, performer_short_names character varying, department_short_name character varying)
    LANGUAGE sql STABLE
    AS $_$

with get_incoming_service_notes_performing as (
select

b.head_charge_sheet_id as incoming_document_id,

string_agg(
	performer.short_full_name || 
	case 
	    when b.performing_date is not null 
	    then ' (' || b.performing_date::date || ')' 
	    else '' 
	end,
	', '
) as performer_short_names,

bool_and(b.performing_date is not null) as all_charge_sheets_performed

from doc.service_notes a
join doc.service_note_receivers b on b.document_id = a.id
join doc.employees performer on performer.id = b.performer_id
join doc.employees cur_emp on cur_emp.id = $1
join doc.employees_roles cur_emp_role on cur_emp_role.employee_id = $1
 
where 
	b.issuer_id is not null
	and cur_emp.head_kindred_department_id = performer.head_kindred_department_id
	and (
		b.performer_id = $1
		or 
		case
		    when cur_emp_role.role_id not in (5)
	            then doc.is_employee_workspace_includes_other_employee($1, b.performer_id)
		    else doc.is_employee_replacing_for_other($1, b.performer_id)
		end
	)
	and doc.is_department_includes_other_department($2, performer.department_id)
group by b.head_charge_sheet_id
)
select 
sn.document_number as number,
sn.name,
sn.content,
sn.document_date::date,
sn.creation_date::date,

(
select 
signer.short_full_name
from doc.service_note_signings sns
join doc.employees signer on signer.id = sns.signer_id
where sns.document_id = sn.id
) as leader_short_name,

in_doc.input_number as incoming_number,
in_doc.input_number_date::date as receipt_date,

a.performer_short_names,

dep.short_name as department_short_name

from get_incoming_service_notes_performing a
join doc.service_note_receivers in_doc on in_doc.id = a.incoming_document_id
join doc.service_notes sn on sn.id = in_doc.document_id
join doc.departments dep on dep.id = $2
where 
	not a.all_charge_sheets_performed
	and 
	   case 
	       when period_start is not null and period_end is not null
	       then sn.creation_date::date between period_start and period_end
	       else
	           case 
	               when period_start is not null
	               then sn.creation_date::date >= period_start
	               else 
			   case 
			       when period_end is not null
			       then sn.creation_date::date <= period_end
			       else true
			   end
	           end
	   end

$_$;


ALTER FUNCTION doc.get_not_performed_incoming_service_notes_report_data_for(employee_id integer, department_id integer, period_start date, period_end date) OWNER TO developers;

--
-- Name: get_outcoming_correspondence_for_employee(integer); Type: FUNCTION; Schema: doc; Owner: developers
--

CREATE FUNCTION doc.get_outcoming_correspondence_for_employee(employee_id integer) RETURNS TABLE(is_document_viewed boolean, id integer, base_document_id integer, type_id integer, name character varying, number character varying, creation_date date, creation_date_year integer, creation_date_month integer, type_name character varying, current_work_cycle_stage_number integer, current_work_cycle_stage_name character varying, author_id integer, is_self_registered boolean, author_short_name character varying, can_be_removed boolean)
    LANGUAGE sql
    AS $_$
	select  
		exists( 
			select 1 
			from doc.looked_documents lsn 
			where lsn.document_id = a.id and lsn.looked_employee_id = $1  
		) as is_document_viewed, 
		a.id as id, 
		a.id as base_document_id,
		a.type_id, 
		a.name, 
		a.document_number as number, 
		a.creation_date::date, 
		date_part('year', a.creation_date)::integer as creation_date_year, 
		date_part('month', a.creation_date)::integer as creation_date_month, 
		b.short_full_name as type_name, 
		c.stage_number as current_work_cycle_stage_number, 
		c.stage_name as current_work_cycle_stage_name, 
		a.author_id, 
		a.is_self_registered,  
		(e.surname || ' ' || e.name || ' ' || e.patronymic)::varchar as author_short_name,		
		null::boolean as can_be_removed
		
	from doc.documents a 
		join doc.employees e on e.id = a.author_id  
		join doc.document_types b on a.type_id = b.id 
		join doc.document_type_work_cycle_stages c on c.id = a.current_work_cycle_stage_id 
		join doc.employees_roles er on er.employee_id = $1  
		join doc.employees e1 on e1.id = $1  
		left join doc.document_signings s on s.document_id = a.id 
		left join doc.employees signer on signer.id = s.signer_id 
	where(e.head_kindred_department_id = e1.head_kindred_department_id)  
		and  
		(  
			(a.author_id = $1)  
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
			or doc.is_employee_replacing_for_other($1, a.author_id)  
		) 																
		or  
		( 
			(a.is_sent_to_signing or c.stage_number in (6)) 
			and  
			doc.is_department_includes_other_department(e1.department_id, signer.department_id) 
			and  
			(s.signer_id = $1  or 
			 doc.is_employee_workspace_includes_other_employee($1 , s.signer_id) or  
			 doc.is_employee_replacing_for_other($1 , s.signer_id)) 
		);
$_$;


ALTER FUNCTION doc.get_outcoming_correspondence_for_employee(employee_id integer) OWNER TO developers;

--
-- Name: get_outcoming_correspondence_from_departments(bigint[]); Type: FUNCTION; Schema: doc; Owner: developers
--

CREATE FUNCTION doc.get_outcoming_correspondence_from_departments(department_ids bigint[]) RETURNS TABLE(id integer, base_document_id integer, employee_id integer, type_id integer, name character varying, number character varying, creation_date date, creation_date_year integer, creation_date_month integer, type_name character varying, current_work_cycle_stage_number integer, current_work_cycle_stage_name character varying, author_id integer, is_self_registered boolean, author_short_name character varying, can_be_removed boolean)
    LANGUAGE sql
    AS $_$
	select   
		distinct
		a.id as id, 
		a.id as base_document_id, 
		-1 as employee_id,  
		a.type_id, 
		a.name, 
		a.document_number as number, 
		a.creation_date::date, 
		date_part('year', a.creation_date)::integer as creation_date_year, 
		date_part('month', a.creation_date)::integer as creation_date_month, 
		b.short_full_name as type_name, 
		c.stage_number as current_work_cycle_stage_number, 
		c.stage_name as current_work_cycle_stage_name, 
		a.author_id, 
		a.is_self_registered,  
		(e.surname || ' '  || e.name || ' '  || e.patronymic)::varchar as author_short_name,     
		null::boolean as can_be_removed
    from doc.documents a 
    join doc.employees e on e.id = a.author_id  
    join doc.document_types b on a.type_id = b.id 
    join doc.document_type_work_cycle_stages c on c.id = a.current_work_cycle_stage_id 
    where e.department_id = any($1);

$_$;


ALTER FUNCTION doc.get_outcoming_correspondence_from_departments(department_ids bigint[]) OWNER TO developers;

--
-- Name: FUNCTION get_outcoming_correspondence_from_departments(department_ids bigint[]); Type: COMMENT; Schema: doc; Owner: developers
--

COMMENT ON FUNCTION doc.get_outcoming_correspondence_from_departments(department_ids bigint[]) IS 'Возвращает исходящую корреспонденцию из подразделений';


--
-- Name: get_outcoming_service_notes_for_employee(integer, character varying[]); Type: FUNCTION; Schema: doc; Owner: developers
--

CREATE FUNCTION doc.get_outcoming_service_notes_for_employee(employee_id integer, stage_names character varying[] DEFAULT NULL::character varying[]) RETURNS TABLE(is_document_viewed boolean, id integer, base_document_id integer, type_id integer, name character varying, number character varying, document_date date, creation_date date, creation_date_year integer, creation_date_month integer, type_name character varying, current_work_cycle_stage_number integer, current_work_cycle_stage_name character varying, author_id integer, is_self_registered boolean, author_short_name character varying, department_name character varying, can_be_removed boolean, charges_stat character varying, are_applications_exists boolean, product_code character varying)
    LANGUAGE sql STABLE
    AS $_$
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
    );
$_$;


ALTER FUNCTION doc.get_outcoming_service_notes_for_employee(employee_id integer, stage_names character varying[]) OWNER TO developers;

--
-- Name: FUNCTION get_outcoming_service_notes_for_employee(employee_id integer, stage_names character varying[]); Type: COMMENT; Schema: doc; Owner: developers
--

COMMENT ON FUNCTION doc.get_outcoming_service_notes_for_employee(employee_id integer, stage_names character varying[]) IS 'Возвращает согласуемые служебные записки, к которым имеет доступ сотрудник';


--
-- Name: get_outcoming_service_notes_for_employee_by_ids(integer, integer[]); Type: FUNCTION; Schema: doc; Owner: developers
--

CREATE FUNCTION doc.get_outcoming_service_notes_for_employee_by_ids(employee_id integer, document_ids integer[]) RETURNS TABLE(is_document_viewed boolean, id integer, base_document_id integer, type_id integer, name character varying, number character varying, document_date date, creation_date date, creation_date_year integer, creation_date_month integer, type_name character varying, current_work_cycle_stage_number integer, current_work_cycle_stage_name character varying, author_id integer, is_self_registered boolean, author_short_name character varying, department_name character varying, can_be_removed boolean, charges_stat character varying, are_applications_exists boolean, product_code character varying)
    LANGUAGE sql STABLE
    AS $_$
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
    );
$_$;


ALTER FUNCTION doc.get_outcoming_service_notes_for_employee_by_ids(employee_id integer, document_ids integer[]) OWNER TO developers;

--
-- Name: FUNCTION get_outcoming_service_notes_for_employee_by_ids(employee_id integer, document_ids integer[]); Type: COMMENT; Schema: doc; Owner: developers
--

COMMENT ON FUNCTION doc.get_outcoming_service_notes_for_employee_by_ids(employee_id integer, document_ids integer[]) IS 'Возвращает исходящие служебные записки, к которым имеет доступ сотрудник, по их идентификаторам';


--
-- Name: get_outcoming_service_notes_for_employee_old(integer); Type: FUNCTION; Schema: doc; Owner: developers
--

CREATE FUNCTION doc.get_outcoming_service_notes_for_employee_old(employee_id integer) RETURNS TABLE(is_document_viewed boolean, id integer, base_document_id integer, type_id integer, name character varying, number character varying, document_date date, creation_date date, creation_date_year integer, creation_date_month integer, type_name character varying, current_work_cycle_stage_number integer, current_work_cycle_stage_name character varying, author_id integer, is_self_registered boolean, author_short_name character varying, department_name character varying, can_be_removed boolean, charges_stat character varying, are_applications_exists boolean, product_code character varying)
    LANGUAGE sql STABLE
    AS $_$
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
$_$;


ALTER FUNCTION doc.get_outcoming_service_notes_for_employee_old(employee_id integer) OWNER TO developers;

--
-- Name: FUNCTION get_outcoming_service_notes_for_employee_old(employee_id integer); Type: COMMENT; Schema: doc; Owner: developers
--

COMMENT ON FUNCTION doc.get_outcoming_service_notes_for_employee_old(employee_id integer) IS 'Возвращает исходящие служебные записки, к которым имеет доступ сотрудник';


--
-- Name: get_outcoming_service_notes_from_departments(bigint[]); Type: FUNCTION; Schema: doc; Owner: developers
--

CREATE FUNCTION doc.get_outcoming_service_notes_from_departments(department_ids bigint[]) RETURNS TABLE(id integer, base_document_id integer, type_id integer, name character varying, number character varying, document_date date, creation_date date, creation_date_year integer, creation_date_month integer, type_name character varying, current_work_cycle_stage_number integer, current_work_cycle_stage_name character varying, author_id integer, is_self_registered boolean, author_short_name character varying, department_name character varying, can_be_removed boolean, product_code character varying)
    LANGUAGE sql STABLE
    AS $_$
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

$_$;


ALTER FUNCTION doc.get_outcoming_service_notes_from_departments(department_ids bigint[]) OWNER TO developers;

--
-- Name: FUNCTION get_outcoming_service_notes_from_departments(department_ids bigint[]); Type: COMMENT; Schema: doc; Owner: developers
--

COMMENT ON FUNCTION doc.get_outcoming_service_notes_from_departments(department_ids bigint[]) IS 'Возвращает исходящие служебные записки из подразделений';


--
-- Name: get_personnel_order_head_charge_sheet_for(integer); Type: FUNCTION; Schema: doc; Owner: developers
--

CREATE FUNCTION doc.get_personnel_order_head_charge_sheet_for(charge_sheet_id integer) RETURNS integer
    LANGUAGE sql STABLE
    AS $$
	with recursive head_charge_sheet_view (id, top_level_charge_sheet_id) as (
		select 
		id,
		top_level_charge_sheet_id
		from doc.personnel_order_charges 
		where id = charge_sheet_id

		union

		select 
		snr.id,
		snr.top_level_charge_sheet_id
		from doc.personnel_order_charges snr
		join head_charge_sheet_view t on t.top_level_charge_sheet_id = snr.id
		where t.top_level_charge_sheet_id is not null
	)
	select id from head_charge_sheet_view where top_level_charge_sheet_id is null;
$$;


ALTER FUNCTION doc.get_personnel_order_head_charge_sheet_for(charge_sheet_id integer) OWNER TO developers;

--
-- Name: get_personnel_orders_for_employee(integer); Type: FUNCTION; Schema: doc; Owner: developers
--

CREATE FUNCTION doc.get_personnel_orders_for_employee(employee_id integer) RETURNS TABLE(is_document_viewed boolean, id integer, base_document_id integer, type_id integer, sub_type_id integer, sub_type_name character varying, name character varying, number character varying, document_date date, creation_date date, creation_date_year integer, creation_date_month integer, type_name character varying, current_work_cycle_stage_number integer, current_work_cycle_stage_name character varying, author_id integer, author_short_name character varying, author_department_short_name character varying, can_be_removed boolean, are_applications_exists boolean, product_code character varying)
    LANGUAGE sql STABLE
    AS $_$

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
	left join doc.personnel_order_charges poc on poc.document_id = po.id
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
	or (
		poc.issuer_id is not null 
		and (
			$1 = poc.performer_id
			or
			case 
			    when er.role_id in (2, 3, 4, 6)
			    then doc.is_employee_workspace_includes_other_employee($1, poc.performer_id)
			    else false
			end
			or
			doc.is_employee_replacing_for_other($1, poc.performer_id)
	    )
	);
					
$_$;


ALTER FUNCTION doc.get_personnel_orders_for_employee(employee_id integer) OWNER TO developers;

--
-- Name: get_personnel_orders_for_employee_by_ids(integer, integer[]); Type: FUNCTION; Schema: doc; Owner: developers
--

CREATE FUNCTION doc.get_personnel_orders_for_employee_by_ids(employee_id integer, document_ids integer[]) RETURNS TABLE(is_document_viewed boolean, id integer, base_document_id integer, type_id integer, sub_type_id integer, sub_type_name character varying, name character varying, number character varying, document_date date, creation_date date, creation_date_year integer, creation_date_month integer, type_name character varying, current_work_cycle_stage_number integer, current_work_cycle_stage_name character varying, author_id integer, author_short_name character varying, author_department_short_name character varying, can_be_removed boolean, are_applications_exists boolean, product_code character varying)
    LANGUAGE sql STABLE
    AS $_$

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
	left join doc.personnel_order_charges poc on poc.document_id = po.id
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
	)
	or (
		poc.issuer_id is not null 
		and (
			$1 = poc.performer_id
			or
			case 
			    when er.role_id in (2, 3, 4, 6)
			    then doc.is_employee_workspace_includes_other_employee($1, poc.performer_id)
			    else false
			end
			or
			doc.is_employee_replacing_for_other($1, poc.performer_id)
	    )
	));
			
		
$_$;


ALTER FUNCTION doc.get_personnel_orders_for_employee_by_ids(employee_id integer, document_ids integer[]) OWNER TO developers;

--
-- Name: get_personnel_orders_from_departments(integer[]); Type: FUNCTION; Schema: doc; Owner: developers
--

CREATE FUNCTION doc.get_personnel_orders_from_departments(department_ids integer[]) RETURNS TABLE(id integer, base_document_id integer, type_id integer, sub_type_id integer, sub_type_name character varying, name character varying, number character varying, document_date date, creation_date date, creation_date_year integer, creation_date_month integer, type_name character varying, current_work_cycle_stage_number integer, current_work_cycle_stage_name character varying, author_id integer, author_short_name character varying, author_department_short_name character varying, can_be_removed boolean, product_code character varying)
    LANGUAGE sql STABLE
    AS $_$

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
    
$_$;


ALTER FUNCTION doc.get_personnel_orders_from_departments(department_ids integer[]) OWNER TO developers;

--
-- Name: get_resource_request_contents_for_employee(integer, integer); Type: FUNCTION; Schema: doc; Owner: developers
--

CREATE FUNCTION doc.get_resource_request_contents_for_employee(employee_id integer, request_id integer) RETURNS TABLE(id integer, request_id integer, res_id integer, access_id integer, status_id integer, note text, person_id_header integer, date_status timestamp without time zone, request_type text)
    LANGUAGE sql STABLE
    AS $_$


WITH target_person AS(
SELECT e.id, e.leader_id, r.role_id FROM doc.employees e
	JOIN doc.employees_roles r ON r.employee_id = e.id
	WHERE e.spr_person_id = $1 AND r.role_id <> 7
	AND e.was_dismissed = false
), replaced_persons AS (
-- все сотрудники, кого замещает выбранный сотрудник
SELECT e.id, e.leader_id, r.role_id FROM target_person 
	JOIN doc.employee_replacements repl ON repl.deputy_id = target_person.id
	JOIN doc.employees_roles r ON r.employee_id = repl.replaceable_id
	JOIN doc.employees e ON e.id = repl.replaceable_id
	WHERE (((repl.replacement_period_start <= now()) and (now() <= repl.replacement_period_end)) OR ((repl.replacement_period_start <= now()) and (repl.replacement_period_end IS NULL)))
	--AND r.role_id <> 5 
	AND r.role_id <> 7
	AND e.was_dismissed = false

), leaders AS (
-- все руководители выбранного сотрудника и замещаемых, исключая самих руководителей
SELECT e.id, e.leader_id, r.role_id FROM (SELECT * FROM target_person UNION SELECT * FROM replaced_persons) ps
	JOIN doc.employees e1 ON ps.id = e1.id AND ps.role_id <> 5
	JOIN doc.employees e ON e1.leader_id = e.id 
	JOIN doc.employees_roles r ON r.employee_id = e.id
	WHERE ps.role_id <> 2
	AND e.was_dismissed = false
), pers AS (
	SELECT * FROM (
		SELECT * FROM target_person 
		UNION 
		SELECT * FROM replaced_persons
		UNION 
		SELECT * FROM leaders) a
--	WHERE role_id <> 5


), persons_and_deps as (
-- связка сотрудников с их подразделениями(включая подчиненные)
	SELECT e.*, d.*, pers.role_id FROM pers
	JOIN doc.employees e ON e.id = pers.id
	LEFT JOIN doc.v_podr_departments d USINg(department_id)

),
resources AS (
-- выборка всех ресурсов, за котрые ответственны полученные сотрудники 
	SELECT r.* FROM uac.rols_in_job r
	JOIN persons_and_deps 
		ON ((r.podr_id = persons_and_deps.podr_id) and (r.owner_id IS NULL)) OR r.owner_id = persons_and_deps.spr_person_id

),
request_contents_by_res AS(
-- выбор содержимого заявки по нужным ресурсам
	SELECT c.*
	, 'owner' as request_type 
	FROM resources
		JOIN exchange.postfix_res_request_contents c ON c.res_id = resources.job_id AND c.access_id = resources.right_type and c.request_id = $2
		and c.status_id NOT IN (1,3,5)
		
),
request_contents_as_leader AS (
-- выбор содержимого заявки для руководителя
	SELECT c.*
	, 'header' as request_type 
	FROM persons_and_deps pd
		JOIN exchange.spr_person pers USING(podr_id)
		JOIN exchange.postfix_res_request r USING(tab_nbr)
		join exchange.postfix_res_request_contents c on c.request_id = r.id and c.request_id = $2
		
	where pd.role_id <> 5

--	AND not EXISTS(SELECT 1 FROM requests_by_res res WHERE res.id = r.id) -- и исключение дублей с выборкой по ресурсам
)

	SELECT * FROM 
	request_contents_by_res
	UNION SELECT * FROM 
	request_contents_as_leader
	

$_$;


ALTER FUNCTION doc.get_resource_request_contents_for_employee(employee_id integer, request_id integer) OWNER TO developers;

--
-- Name: FUNCTION get_resource_request_contents_for_employee(employee_id integer, request_id integer); Type: COMMENT; Schema: doc; Owner: developers
--

COMMENT ON FUNCTION doc.get_resource_request_contents_for_employee(employee_id integer, request_id integer) IS 'Возвращает содержимое заявки на ресурсы в зависимости от отношения сотрудника к этой заявке (владлец или руководитель) (идентификатор сотрудника из spr_person)';


--
-- Name: get_resource_requests_count_for_employee(integer); Type: FUNCTION; Schema: doc; Owner: developers
--

CREATE FUNCTION doc.get_resource_requests_count_for_employee(employee_id integer) RETURNS integer
    LANGUAGE sql STABLE
    AS $$


	select count(*) from doc.get_resource_requests_for_employee(employee_id) 
	where (request_type = 'owner' and status_id in (4,7,10)) or (request_type = 'header' and status_id in (1,5,9))  


$$;


ALTER FUNCTION doc.get_resource_requests_count_for_employee(employee_id integer) OWNER TO developers;

--
-- Name: FUNCTION get_resource_requests_count_for_employee(employee_id integer); Type: COMMENT; Schema: doc; Owner: developers
--

COMMENT ON FUNCTION doc.get_resource_requests_count_for_employee(employee_id integer) IS 'Возвращает количество заявок на ресурсы, с которыми сотруднику необходимо что то сделать (идентификатор из spr_person)';


--
-- Name: get_resource_requests_for_employee(integer); Type: FUNCTION; Schema: doc; Owner: developers
--

CREATE FUNCTION doc.get_resource_requests_for_employee(employee_id integer) RETURNS TABLE(id integer, tab_nbr character varying, request_body text, date_enter timestamp without time zone, note text, status_id integer, person_id_header integer, date_status timestamp without time zone, request_type text)
    LANGUAGE sql STABLE
    AS $_$


WITH target_person AS(
SELECT e.id, e.leader_id, r.role_id FROM doc.employees e
	JOIN doc.employees_roles r ON r.employee_id = e.id
	WHERE e.spr_person_id = $1 AND r.role_id <> 7
	AND e.was_dismissed = false
), replaced_persons AS (
-- все сотрудники, кого замещает выбранный сотрудник
SELECT e.id, e.leader_id, r.role_id FROM target_person 
	JOIN doc.employee_replacements repl ON repl.deputy_id = target_person.id
	JOIN doc.employees_roles r ON r.employee_id = repl.replaceable_id
	JOIN doc.employees e ON e.id = repl.replaceable_id
	WHERE (((repl.replacement_period_start <= now()) and (now() <= repl.replacement_period_end)) OR ((repl.replacement_period_start <= now()) and (repl.replacement_period_end IS NULL)))
	--AND r.role_id <> 5 
	AND r.role_id <> 7
	AND e.was_dismissed = false

), leaders AS (
-- все руководители выбранного сотрудника и замещаемых, исключая самих руководителей
SELECT e.id, e.leader_id, r.role_id FROM (SELECT * FROM target_person UNION SELECT * FROM replaced_persons) ps
	JOIN doc.employees e1 ON ps.id = e1.id AND ps.role_id <> 5
	JOIN doc.employees e ON e1.leader_id = e.id 
	JOIN doc.employees_roles r ON r.employee_id = e.id
	WHERE ps.role_id <> 2
	AND e.was_dismissed = false
), pers AS (
	SELECT * FROM (
		SELECT * FROM target_person 
		UNION 
		SELECT * FROM replaced_persons
		UNION 
		SELECT * FROM leaders) a
--	WHERE role_id <> 5


), persons_and_deps as (
-- связка сотрудников с их подразделениями(включая подчиненные)
	SELECT e.*, d.*, pers.role_id FROM pers
	JOIN doc.employees e ON e.id = pers.id
	left JOIN doc.v_podr_departments d USINg(department_id)

),
resources AS (
-- выборка всех ресурсов, за котрые ответственны полученные сотрудники 
	SELECT r.* FROM uac.rols_in_job r
	JOIN persons_and_deps 
		ON ((r.podr_id = persons_and_deps.podr_id) and (r.owner_id IS NULL)) OR r.owner_id = persons_and_deps.spr_person_id

),
requests_by_res AS(
-- выбор заявок по ресурсам
	SELECT r.*, 'owner' as request_type FROM resources
		JOIN exchange.postfix_res_request_contents c ON c.res_id = resources.job_id AND c.access_id = resources.right_type
		JOIN exchange.postfix_res_request r ON c.request_id = r.id and r.status_id NOT IN (1,3,5)
		
),
requests_as_leader AS (
-- выбор заявок всех заявок из выбранных подразделений
	SELECT r.*, 'header' as request_type FROM persons_and_deps pd
		JOIN exchange.spr_person pers USING(podr_id)
		JOIN exchange.postfix_res_request r USING(tab_nbr)
	where pd.role_id <> 5

	AND not EXISTS(SELECT 1 FROM requests_by_res res WHERE res.id = r.id) -- и исключение дублей с выборкой по ресурсам
)


	SELECT * FROM 
	requests_by_res
	UNION SELECT * FROM 
	requests_as_leader


$_$;


ALTER FUNCTION doc.get_resource_requests_for_employee(employee_id integer) OWNER TO developers;

--
-- Name: FUNCTION get_resource_requests_for_employee(employee_id integer); Type: COMMENT; Schema: doc; Owner: developers
--

COMMENT ON FUNCTION doc.get_resource_requests_for_employee(employee_id integer) IS 'Возвращает заявки на ресурсы, которые может просматривать сотрудник (идентификатор из spr_person)';


--
-- Name: get_service_note_performing_statistics(bigint); Type: FUNCTION; Schema: doc; Owner: developers
--

CREATE FUNCTION doc.get_service_note_performing_statistics(document_id bigint) RETURNS TABLE(total_charge_count bigint, performed_charge_count bigint)
    LANGUAGE plpgsql STABLE
    AS $_$
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
$_$;


ALTER FUNCTION doc.get_service_note_performing_statistics(document_id bigint) OWNER TO developers;

--
-- Name: FUNCTION get_service_note_performing_statistics(document_id bigint); Type: COMMENT; Schema: doc; Owner: developers
--

COMMENT ON FUNCTION doc.get_service_note_performing_statistics(document_id bigint) IS 'Возвращает статистику по исполнению поручений документа document_id в целом. Учитывается только первые непосредственные исполнители';


--
-- Name: get_service_note_subordinate_performing_statistics_for_employee(integer, integer); Type: FUNCTION; Schema: doc; Owner: developers
--

CREATE FUNCTION doc.get_service_note_subordinate_performing_statistics_for_employee(document_id integer, employee_id integer) RETURNS TABLE(performed_charge_count bigint, total_charge_count bigint)
    LANGUAGE plpgsql STABLE
    AS $_$
begin
if document_id is null then 
	return query select 0::bigint as performed_count, 0::bigint as total_performer_count;

else  
	return query
	with recursive get_subordinate_document_performers (id, performing_date) as
	(
	select 
	b.id,
	b.performing_date
	from 
	doc.service_note_receivers a
	join doc.service_note_receivers b on b.sender_id = a.id
	where a.performing_date is null and a.incoming_document_id = $1 and
		(a.outside_employee_id = $2 or doc.is_employee_acting_for_other_or_vice_versa($2, a.outside_employee_id))
	union
	select 
	a.id,
	a.performing_date		
	from doc.service_note_receivers a
	join get_subordinate_document_performers b on a.sender_id = b.id
	)
	select 
	count(case when performing_date is not null then id else null end) as performed_count,
	count(*) as total_performer_count
	from get_subordinate_document_performers;
	
end if;

end
$_$;


ALTER FUNCTION doc.get_service_note_subordinate_performing_statistics_for_employee(document_id integer, employee_id integer) OWNER TO developers;

--
-- Name: get_user_relation_access_rights_by_roles(character varying, text[]); Type: FUNCTION; Schema: doc; Owner: developers
--

CREATE FUNCTION doc.get_user_relation_access_rights_by_roles(relation character varying, userroles text[]) RETURNS SETOF character
    LANGUAGE plpgsql SECURITY DEFINER
    AS $$
declare 
	rel_access_rights_info text;
	role_access_rights text;
	user_access_rights text;
	is_insert_right_assigned boolean;
	is_select_right_assigned boolean;
	is_update_right_assigned boolean;
	is_delete_right_assigned boolean;
	result varchar;
begin

	is_insert_right_assigned = false; 
	is_select_right_assigned = false; 
	is_update_right_assigned = false;
	is_delete_right_assigned = false;
	
	foreach rel_access_rights_info in array (select relacl from pg_class where relname = relation)
	loop
		if array[split_part(rel_access_rights_info, '=', 1)] <@ userroles then
		
			role_access_rights = split_part(rel_access_rights_info, '=', 2);

			user_access_rights = split_part(role_access_rights, '/', 1);

			if (position('a' in user_access_rights) > 0) and (not is_insert_right_assigned) then
			 
				return next 'I';
				is_insert_right_assigned = true;
				
			end if;

			if (position('r' in user_access_rights) > 0) and (not is_select_right_assigned) then
			
				return next 'S';
				is_select_right_assigned = true;
				
			end if;

			if (position('w' in user_access_rights) > 0) and (not is_update_right_assigned) then
			
				return next 'U';
				is_update_right_assigned = true;
				
			end if;

			if (position('d' in user_access_rights) > 0) and (not is_delete_right_assigned) then
			
				return next 'D';
				is_delete_right_assigned = true;
				
			end if;

			
		end if;
		
	end loop;

	return;
end
$$;


ALTER FUNCTION doc.get_user_relation_access_rights_by_roles(relation character varying, userroles text[]) OWNER TO developers;

--
-- Name: FUNCTION get_user_relation_access_rights_by_roles(relation character varying, userroles text[]); Type: COMMENT; Schema: doc; Owner: developers
--

COMMENT ON FUNCTION doc.get_user_relation_access_rights_by_roles(relation character varying, userroles text[]) IS 'Функция получения прав доступа сотрудника к заданному отношению по его пользовательской роли';


--
-- Name: get_user_roles_by_reg_expr(character varying, character varying, boolean); Type: FUNCTION; Schema: doc; Owner: sup
--

CREATE FUNCTION doc.get_user_roles_by_reg_expr(username character varying, reg_expr character varying, use_recursive boolean DEFAULT false) RETURNS SETOF text
    LANGUAGE plpgsql STABLE SECURITY DEFINER
    AS $_$
begin
	if use_recursive then
		RETURN QUERY with recursive get_user_omo_roles (role_id, role_name) as
		(

		select b.oid as role_id, c.rolname::text as role_name

		from pg_auth_members a

			join pg_authid b on b.oid = a.member
			join pg_authid c on c.oid = a.roleid

		where b.rolname = $1 and c.rolname ~* $2

		union

			select

			c.oid as role_id, c.rolname::text as role_name

			from get_user_omo_roles a

				join pg_auth_members b on b.member = a.role_id
				join pg_authid c on c.oid = b.roleid

			where c.rolname ~* $2

		)
		select distinct(role_name) from get_user_omo_roles;
	else
		RETURN QUERY select c.rolname::text
				  from pg_auth_members a
				  join pg_authid b on b.oid = a.member
				  join pg_authid c on c.oid = a.roleid
				  where b.rolname = $1 and c.rolname ~ $2;		
	end if;
end
$_$;


ALTER FUNCTION doc.get_user_roles_by_reg_expr(username character varying, reg_expr character varying, use_recursive boolean) OWNER TO sup;

--
-- Name: incoming_service_note_charge_performing_stats_calc_trigger_func(); Type: FUNCTION; Schema: doc; Owner: developers
--

CREATE FUNCTION doc.incoming_service_note_charge_performing_stats_calc_trigger_func() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
declare
	current_charge_row record;
	charge_row record;
begin

	if TG_OP = 'DELETE' then
		current_charge_row = old;

	else current_charge_row = new;
	
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
			from doc.service_note_receivers snr
			where snr.id in (current_charge_row.id, current_charge_row.top_level_charge_sheet_id)

			union

			select
			snr.id,
			snr.performer_id,
			snr.top_level_charge_sheet_id
			from doc.service_note_receivers snr
			join get_upstream_charge_branch_for_current ucb on ucb.top_level_charge_sheet_id = snr.id
		)
		select 
		in_doc.id as incoming_document_id, ucb.performer_id, stats.* 
		from get_upstream_charge_branch_for_current ucb
		join (select id from get_upstream_charge_branch_for_current where top_level_charge_sheet_id is null) as in_doc on true  
		join doc.get_employee_service_note_charge_sheets_performing_statistics(current_charge_row.document_id, ucb.performer_id, ucb.id) stats on true
	loop

		if charge_row.total_charge_count = charge_row.performed_charge_count then
			charge_row.total_charge_count = null; 
			charge_row.performed_charge_count = null; 
			charge_row.subordinate_charge_count = null; 
			charge_row.subordinate_performed_charge_count = null; 
		end if;
		
		update doc.service_note_receivers 
		set total_charge_count = charge_row.total_charge_count,
		    performed_charge_count = charge_row.performed_charge_count,
		    subordinate_charge_count = charge_row.subordinate_charge_count,
		    subordinate_performed_charge_count = charge_row.subordinate_performed_charge_count
		where head_charge_sheet_id = charge_row.incoming_document_id and performer_id = charge_row.performer_id;
		
	end loop;

	return current_charge_row;
	
end
$$;


ALTER FUNCTION doc.incoming_service_note_charge_performing_stats_calc_trigger_func() OWNER TO developers;

--
-- Name: is_department_includes_other_department(integer, integer); Type: FUNCTION; Schema: doc; Owner: developers
--

CREATE FUNCTION doc.is_department_includes_other_department(target_department_id integer, other_department_id integer) RETURNS boolean
    LANGUAGE sql STABLE
    AS $_$
	with recursive department_branch(department_id, top_level_department_id) as (
		select 
		id as department_id,
		top_level_department_id
		from doc.departments
		where id = $2
		union 
		select
		a.id as department_id,
		a.top_level_department_id
		from 
		doc.departments a
		join department_branch b on a.id = b.top_level_department_id
	)
	select exists(select 1 from department_branch where department_id = $1)
		
$_$;


ALTER FUNCTION doc.is_department_includes_other_department(target_department_id integer, other_department_id integer) OWNER TO developers;

--
-- Name: FUNCTION is_department_includes_other_department(target_department_id integer, other_department_id integer); Type: COMMENT; Schema: doc; Owner: developers
--

COMMENT ON FUNCTION doc.is_department_includes_other_department(target_department_id integer, other_department_id integer) IS 'Проверяет, входит ли второе подразделение в первое';


--
-- Name: is_employee_acting_for_other_or_vice_versa(integer, integer); Type: FUNCTION; Schema: doc; Owner: developers
--

CREATE FUNCTION doc.is_employee_acting_for_other_or_vice_versa(supposed_acting_employee_id integer, employee_id integer) RETURNS boolean
    LANGUAGE sql STABLE
    AS $_$
select exists(
select  
1
from doc.employees a
join doc.employees b on a.leader_id = b.id
join doc.employees_roles c on c.employee_id = a.id
join doc.employees_roles d on d.employee_id = b.id
where (((a.id = $1 and b.id = $2) or
	(a.id = $2 and b.id = $1)) and (c.role_id in (3,6) and d.role_id = 2) and (a.department_id = b.department_id))) or
	exists(
		select 1 
		from doc.employee_replacements 
		where 
		((deputy_id = $1 and replaceable_id = $2)
			and (case when replacement_period_end is null 
			          then true 
			          else (replacement_period_start <= now()) and (now() <= replacement_period_end) end))
	)

as result
$_$;


ALTER FUNCTION doc.is_employee_acting_for_other_or_vice_versa(supposed_acting_employee_id integer, employee_id integer) OWNER TO developers;

--
-- Name: FUNCTION is_employee_acting_for_other_or_vice_versa(supposed_acting_employee_id integer, employee_id integer); Type: COMMENT; Schema: doc; Owner: developers
--

COMMENT ON FUNCTION doc.is_employee_acting_for_other_or_vice_versa(supposed_acting_employee_id integer, employee_id integer) IS 'Проверяет, является ли первый сотрудник замом или временно исполняющим обязанности для второго';


--
-- Name: is_employee_acting_for_others_or_vice_versa(integer, integer[]); Type: FUNCTION; Schema: doc; Owner: developers
--

CREATE FUNCTION doc.is_employee_acting_for_others_or_vice_versa(supposed_acting_employee_id integer, employee_ids integer[]) RETURNS boolean
    LANGUAGE sql STABLE
    AS $_$
select exists(
select  
1
from doc.employees a
join doc.employees b on a.leader_id = b.id
join doc.employees_roles c on c.employee_id = a.id
join doc.employees_roles d on d.employee_id = b.id
where (((a.id = $1 and b.id = any($2)) or
	(a.id = any($2) and b.id = $1)) and (c.role_id in (3,6) and d.role_id = 2) and (a.department_id = b.department_id))) or
	exists(
		select 1 
		from doc.employee_replacements 
		where 
		((deputy_id = $1 and replaceable_id = any($2))
			and (case when replacement_period_end is null 
			          then true 
			          else (replacement_period_start <= now()) and (now() <= replacement_period_end) end))
	)

as result
$_$;


ALTER FUNCTION doc.is_employee_acting_for_others_or_vice_versa(supposed_acting_employee_id integer, employee_ids integer[]) OWNER TO developers;

--
-- Name: is_employee_replacing_for_other(bigint, bigint); Type: FUNCTION; Schema: doc; Owner: developers
--

CREATE FUNCTION doc.is_employee_replacing_for_other(target_employee_id bigint, other_employee_id bigint) RETURNS boolean
    LANGUAGE sql STABLE
    AS $_$
select exists(
	select 
	1
	from doc.employee_replacements
	where replaceable_id = $2 and deputy_id = $1 and 
	case 
	    when replacement_period_end is null 
	    then true
	    else ((replacement_period_start <= now()) and (now() <= replacement_period_end))
	end
)
$_$;


ALTER FUNCTION doc.is_employee_replacing_for_other(target_employee_id bigint, other_employee_id bigint) OWNER TO developers;

--
-- Name: is_employee_replacing_for_others(bigint, bigint[]); Type: FUNCTION; Schema: doc; Owner: developers
--

CREATE FUNCTION doc.is_employee_replacing_for_others(target_employee_id bigint, other_employee_ids bigint[]) RETURNS boolean
    LANGUAGE sql STABLE
    AS $_$
select exists(
	select 
	1
	from doc.employee_replacements
	where replaceable_id = any($2) and deputy_id = $1 and 
	case 
	    when replacement_period_end is null 
	    then true
	    else ((replacement_period_start <= now()) and (now() <= replacement_period_end))
	end
)
$_$;


ALTER FUNCTION doc.is_employee_replacing_for_others(target_employee_id bigint, other_employee_ids bigint[]) OWNER TO developers;

--
-- Name: is_employee_secretary_for(integer, integer); Type: FUNCTION; Schema: doc; Owner: developers
--

CREATE FUNCTION doc.is_employee_secretary_for(supposed_secretary_id integer, employee_id integer) RETURNS boolean
    LANGUAGE sql STABLE
    AS $_$

select 
	exists(

		select 1
		from doc.employees a 
		join doc.employees b on b.id = a.leader_id
		join doc.employees_roles c on c.employee_id = a.id
		join doc.employees_roles d on d.employee_id = b.id
		where (a.id = $1 and b.id = $2) and (c.role_id in (4, 6) and d.role_id = 2)
	);
			
$_$;


ALTER FUNCTION doc.is_employee_secretary_for(supposed_secretary_id integer, employee_id integer) OWNER TO developers;

--
-- Name: FUNCTION is_employee_secretary_for(supposed_secretary_id integer, employee_id integer); Type: COMMENT; Schema: doc; Owner: developers
--

COMMENT ON FUNCTION doc.is_employee_secretary_for(supposed_secretary_id integer, employee_id integer) IS 'Проверяет, является первый сотрудник секретарём для второго';


--
-- Name: is_employee_secretary_for_other_or_vice_versa(integer, integer); Type: FUNCTION; Schema: doc; Owner: developers
--

CREATE FUNCTION doc.is_employee_secretary_for_other_or_vice_versa(supposed_secretary_id integer, employee_id integer) RETURNS boolean
    LANGUAGE sql STABLE
    AS $_$

select 
	exists(

		select 1
		from doc.employees a 
		join doc.employees b on b.id = a.leader_id
		join doc.employees_roles c on c.employee_id = a.id
		join doc.employees_roles d on d.employee_id = b.id
		where ((a.id = $1 and b.id = $2) or 
			(a.id = $2 and b.id = $1)) and
				(c.role_id in (4, 6) and d.role_id = 2)
	);
			
$_$;


ALTER FUNCTION doc.is_employee_secretary_for_other_or_vice_versa(supposed_secretary_id integer, employee_id integer) OWNER TO developers;

--
-- Name: FUNCTION is_employee_secretary_for_other_or_vice_versa(supposed_secretary_id integer, employee_id integer); Type: COMMENT; Schema: doc; Owner: developers
--

COMMENT ON FUNCTION doc.is_employee_secretary_for_other_or_vice_versa(supposed_secretary_id integer, employee_id integer) IS 'Проверяет, является первый сотрудник секретарём для второго, или, наоборот, второй для первого';


--
-- Name: is_employee_secretary_signer_for_other(integer, integer); Type: FUNCTION; Schema: doc; Owner: developers
--

CREATE FUNCTION doc.is_employee_secretary_signer_for_other(target_employee_id integer, other_employee_id integer) RETURNS boolean
    LANGUAGE sql STABLE
    AS $_$
select exists(
	select 1
	from doc.employees a
	join doc.employees d on d.id = a.leader_id
	join doc.employees_roles b on b.employee_id = a.id
	join doc.employees_roles c on c.employee_id = a.leader_id
	where 
	(a.id = $1 and d.id = $2) 
	and (a.department_id = d.department_id) 
	and b.role_id in (6) and c.role_id in (2)
)
$_$;


ALTER FUNCTION doc.is_employee_secretary_signer_for_other(target_employee_id integer, other_employee_id integer) OWNER TO developers;

--
-- Name: FUNCTION is_employee_secretary_signer_for_other(target_employee_id integer, other_employee_id integer); Type: COMMENT; Schema: doc; Owner: developers
--

COMMENT ON FUNCTION doc.is_employee_secretary_signer_for_other(target_employee_id integer, other_employee_id integer) IS 'Проверяет, является ли первый сотрудник секретарём-подписантом для второго';


--
-- Name: is_employee_subleader_for_other(integer, integer); Type: FUNCTION; Schema: doc; Owner: developers
--

CREATE FUNCTION doc.is_employee_subleader_for_other(target_employee_id integer, other_employee_id integer) RETURNS boolean
    LANGUAGE sql STABLE
    AS $_$
select exists(
	select 1
	from doc.employees a
	join doc.employees d on d.id = a.leader_id
	join doc.employees_roles b on b.employee_id = a.id
	join doc.employees_roles c on c.employee_id = a.leader_id
	where 
	(a.id = $1 and d.id = $2) 
	and (a.department_id = d.department_id) 
	and b.role_id in (3) and c.role_id in (2)
)
$_$;


ALTER FUNCTION doc.is_employee_subleader_for_other(target_employee_id integer, other_employee_id integer) OWNER TO developers;

--
-- Name: FUNCTION is_employee_subleader_for_other(target_employee_id integer, other_employee_id integer); Type: COMMENT; Schema: doc; Owner: developers
--

COMMENT ON FUNCTION doc.is_employee_subleader_for_other(target_employee_id integer, other_employee_id integer) IS 'Проверяет, является ли первый сотрудник заместителем для второго';


--
-- Name: is_employee_subleader_or_replacing_for_other(integer, integer); Type: FUNCTION; Schema: doc; Owner: developers
--

CREATE FUNCTION doc.is_employee_subleader_or_replacing_for_other(supposed_acting_employee_id integer, employee_id integer) RETURNS boolean
    LANGUAGE sql STABLE
    AS $_$
select exists(
select  
1
from doc.employees a
join doc.employees b on b.id = a.leader_id
join doc.employees_roles c on c.employee_id = a.id
join doc.employees_roles d on d.employee_id = a.leader_id
where (((a.id = $1 and b.id = $2) and (c.role_id in (3,6) and d.role_id = 2) and (a.department_id = b.department_id)))) or doc.is_employee_replacing_for_other($1, $2)
as result
$_$;


ALTER FUNCTION doc.is_employee_subleader_or_replacing_for_other(supposed_acting_employee_id integer, employee_id integer) OWNER TO developers;

--
-- Name: FUNCTION is_employee_subleader_or_replacing_for_other(supposed_acting_employee_id integer, employee_id integer); Type: COMMENT; Schema: doc; Owner: developers
--

COMMENT ON FUNCTION doc.is_employee_subleader_or_replacing_for_other(supposed_acting_employee_id integer, employee_id integer) IS 'Проверяет, является ли первый сотрудник заместителем или временно исполняющим обязанности для второго с вызовом дополнительной функции';


--
-- Name: is_employee_workspace_includes_other_employee(bigint, bigint); Type: FUNCTION; Schema: doc; Owner: developers
--

CREATE FUNCTION doc.is_employee_workspace_includes_other_employee(workspace_employee_id bigint, checkable_employee_id bigint) RETURNS boolean
    LANGUAGE sql STABLE
    AS $_$

select 
exists (
select
1
from doc.employees e1
join doc.employees_roles er1 on er1.employee_id = e1.id 
join doc.employees e2 on e2.id = $2
left join doc.employees leader on leader.id = e1.leader_id 
left join doc.employees_roles leader_role on leader_role.employee_id = leader.id
where 
e1.id = $1
and 
	case 
	 	when er1.role_id = 2 
	 	then row(e1.id::bigint, er1.role_id::bigint, e1.department_id::bigint, e1.head_kindred_department_id::bigint) = any (e2.leader_links)
	 	else 
	 		case 
	 			when er1.role_id not in (5) 
	 			then 
	 				row(leader.id::bigint, leader_role.role_id::bigint, leader.department_id::bigint, leader.head_kindred_department_id::bigint) = any (e2.leader_links)
	 			else false
	 		end

	end
)
$_$;


ALTER FUNCTION doc.is_employee_workspace_includes_other_employee(workspace_employee_id bigint, checkable_employee_id bigint) OWNER TO developers;

--
-- Name: is_employee_workspace_includes_other_employee_old(bigint, bigint); Type: FUNCTION; Schema: doc; Owner: developers
--

CREATE FUNCTION doc.is_employee_workspace_includes_other_employee_old(workspace_employee_id bigint, checkable_employee_id bigint) RETURNS boolean
    LANGUAGE sql STABLE
    AS $_$

select 
exists (
select
1
from doc.employees e1
join doc.employees_roles er1 on er1.employee_id = e1.id 
join doc.employees e2 on e2.id = $2
left join doc.employees leader on leader.id = e1.leader_id 
left join doc.employees_roles leader_role on leader_role.employee_id = leader.id
where 
e1.id = $1
and 
	case 
	 	when er1.role_id = 2
	 	then row(e1.id::bigint, er1.role_id::bigint, e1.department_id::bigint, e1.head_kindred_department_id::bigint) = any (e2.leader_links)
	 	else 
	 		case 
	 			when er1.role_id not in (5)
	 			then 
	 				row(leader.id::bigint, leader_role.role_id::bigint, leader.department_id::bigint, leader.head_kindred_department_id::bigint) = any (e2.leader_links)
	 				or e1.leader_id = $2
	 			else false
	 		end
	 		
	end
)
$_$;


ALTER FUNCTION doc.is_employee_workspace_includes_other_employee_old(workspace_employee_id bigint, checkable_employee_id bigint) OWNER TO developers;

--
-- Name: mark_document_charge_as_viewed(integer, bigint, timestamp without time zone); Type: FUNCTION; Schema: doc; Owner: developers
--

CREATE FUNCTION doc.mark_document_charge_as_viewed(document_type_id integer, document_charge_id bigint, view_date timestamp without time zone DEFAULT now()) RETURNS void
    LANGUAGE plpgsql
    AS $$
declare
	document_charges_table_name varchar;
	looked_documents_table_name varchar;
	looked_document_charges_table_name varchar;
	looked_employee_id int;
begin

	if document_type_id = 2 then
		document_charges_table_name = 'doc.service_note_receivers';
		looked_documents_table_name = 'doc.looked_service_notes';
		looked_document_charges_table_name = 'doc.looked_service_note_charges';
	else
		document_charges_table_name = 'doc.document_receivers';
		looked_documents_table_name = 'doc.looked_documents';
		looked_document_charges_table_name = 'doc.looked_document_charges';
	end if;
	
	looked_employee_id = doc.get_current_employee_id();
	
	execute 
		format(
			'insert into ' || looked_document_charges_table_name || ' (charge_id,employee_id,look_date) values (%s,%s,%s) on conflict do nothing',
			document_charge_id, looked_employee_id, quote_literal(view_date)
		);
	execute
		format(
			'insert into ' || looked_documents_table_name || ' (document_id,looked_employee_id,look_date) ' ||
			'values ((select document_id from ' || document_charges_table_name || ' where id = %s),%s,%s) on conflict do nothing',
			document_charge_id, looked_employee_id, quote_literal(view_date)
		);
	
	return;
end
$$;


ALTER FUNCTION doc.mark_document_charge_as_viewed(document_type_id integer, document_charge_id bigint, view_date timestamp without time zone) OWNER TO developers;

--
-- Name: FUNCTION mark_document_charge_as_viewed(document_type_id integer, document_charge_id bigint, view_date timestamp without time zone); Type: COMMENT; Schema: doc; Owner: developers
--

COMMENT ON FUNCTION doc.mark_document_charge_as_viewed(document_type_id integer, document_charge_id bigint, view_date timestamp without time zone) IS 'Пометка поручения по документу в качестве просмотренного на определенный момент времени';


--
-- Name: perform_charge(integer, bigint, character varying, timestamp without time zone); Type: FUNCTION; Schema: doc; Owner: developers
--

CREATE FUNCTION doc.perform_charge(document_type_id integer, charge_id bigint, comment character varying DEFAULT ''::character varying, performing_date timestamp without time zone DEFAULT now()) RETURNS void
    LANGUAGE sql
    AS $_$
with recursive get_charge_branch_by_application (charge_id, top_level_charge_id) as (
	select 
	id,
	top_level_charge_sheet_id as top_level_charge_id
	from doc.service_note_receivers 
	where id = $2

	union

	select
	a.id,
	top_level_charge_sheet_id as top_level_charge_id
	from doc.service_note_receivers a
	join get_charge_branch_by_application b on a.top_level_charge_sheet_id = b.charge_id
	where a.performing_date is not null
) 
update 
doc.service_note_receivers a

set comment = case when id = $2 then $3 else a.comment end,
    performing_date = $4
    
from get_charge_branch_by_application b
where b.charge_id = a.id

$_$;


ALTER FUNCTION doc.perform_charge(document_type_id integer, charge_id bigint, comment character varying, performing_date timestamp without time zone) OWNER TO developers;

--
-- Name: perform_charges_by_application(integer, bigint, character varying, timestamp without time zone); Type: FUNCTION; Schema: doc; Owner: developers
--

CREATE FUNCTION doc.perform_charges_by_application(document_type_id integer, application_id bigint, comment character varying DEFAULT ''::character varying, performing_date timestamp without time zone DEFAULT now()) RETURNS void
    LANGUAGE sql
    AS $_$
with recursive get_charge_branch_by_application (charge_id, top_level_charge_id) as (

	select 
	id,
	top_level_charge_sheet_id as top_level_charge_id
	from doc.service_note_receivers 
	where application_id = $2

	union

	select
	a.id,
	top_level_charge_sheet_id as top_level_charge_id
	from doc.service_note_receivers a
	join get_charge_branch_by_application b on a.top_level_charge_sheet_id = b.charge_id
	where a.performing_date is null

) 
update 
doc.service_note_receivers a

set comment = case when application_id is not null then $3 else a.comment end,
    performing_date = $4,
    actual_performer_id = doc.get_current_employee_id()
    
from get_charge_branch_by_application b
where b.charge_id = a.id

$_$;


ALTER FUNCTION doc.perform_charges_by_application(document_type_id integer, application_id bigint, comment character varying, performing_date timestamp without time zone) OWNER TO developers;

--
-- Name: FUNCTION perform_charges_by_application(document_type_id integer, application_id bigint, comment character varying, performing_date timestamp without time zone); Type: COMMENT; Schema: doc; Owner: developers
--

COMMENT ON FUNCTION doc.perform_charges_by_application(document_type_id integer, application_id bigint, comment character varying, performing_date timestamp without time zone) IS 'Выполнение неисполненных поручений по заявке';


--
-- Name: reassign_objects_owner(); Type: FUNCTION; Schema: doc; Owner: developers
--

CREATE FUNCTION doc.reassign_objects_owner() RETURNS void
    LANGUAGE plpgsql
    AS $$
declare
	alter_expr record;
begin
	for alter_expr in
		select
			q.* as value
		from (
			select	'alter table ' || n.nspname || '.' || c.relname || ' owner to developers;' as value, 1 as id
			from pg_class c
			join pg_namespace n on n.oid = relnamespace
			where n.nspname ~* 'doc' and c.relkind = 'r' and relname !~* '^sd_'

			union

			select 	'alter function ' || n.nspname || '.' || p.proname || '(' || coalesce((
				select 
					string_agg(q.arg_type_name, ', ')
				from (
					select (
						select
						case when t.typarray = 0 then n.nspname || '.' || regexp_replace(t.typname, '^_', '') || '[]' else n.nspname || '.' || t.typname end as arg_type_name
						from pg_type as t
						left join pg_type as arr on arr.oid = t.typarray
						join pg_namespace as n on n.oid = t.typnamespace
						where t.oid = arg_type_ids.id 
					)
					from unnest(p.proargtypes) as arg_type_ids(id)
				) q 
				), '') || ')' || ' owner to developers;' as value, 2 
			from pg_proc p
			join pg_namespace n on p.pronamespace = n.oid
			where n.nspname ~* 'doc' and p.proname !~* '^sd_' AND p.pronameNOT LIKE 'get_user_roles_by_reg_expr'

			union

			select 'alter sequence ' || n.nspname || '.' || c.relname || ' owner to developers;' as value, 3
			from pg_class c
			join pg_namespace n on n.oid = relnamespace
			where 
			n.nspname ~* 'doc' and 
			c.relkind = 'S' and relname !~* '^sd_'
			)q
			ORDER BY 2,1
		loop

			execute alter_expr.value;
	end loop;

end
$$;


ALTER FUNCTION doc.reassign_objects_owner() OWNER TO developers;

--
-- Name: res_request_contents_send_message_handler(); Type: FUNCTION; Schema: doc; Owner: developers
--

CREATE FUNCTION doc.res_request_contents_send_message_handler() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
declare 
_request record;
_email varchar;
_person_id integer;
begin
	
	select prr.* into _request from exchange.postfix_res_request_contents prrc  
		join exchange.postfix_res_request prr on prrc.request_id = prr.id
		where prrc.id = new.id;
	
	-- выборка руководителя для только созданных заявок на основе информации о заявке
	if new.status_id = 1 then
		
		with podr_ids as (
		select
			s.podr_code as podr_code,
			coalesce(d.id, coalesce(d1.id, d2.id)) as doc_podr_id
		from
			exchange.spr_person sp
		left join nsi.spr_podr s on
			s.id = sp.podr_id
		left join nsi.spr_podr sh on
			sh.id = sp.podr_id_head
		left join doc.departments d1 on
			d1.code ilike s.podr_code
			and d1.prizn_old is null
		left join doc.departments d2 on
			d2.code ilike sh.podr_code
			and d2.prizn_old is null
		left join doc.employees e on
			e.personnel_number = sp.tab_nbr
		left join doc.departments d on
			d.id = e.department_id
		where
			sp.dismissed = false
			and sp.tab_nbr = _request.tab_nbr),
		pers_id as (
		select
			case
				when podr_ids.podr_code = '0100' then (
				select
					coalesce(leader_id, id) as doc_id
				from
					doc.employees e
				where
					e.personnel_number = _request.tab_nbr)
				else (
				select
					id as doc_id
				from
					doc.employees e
				join doc.employees_roles l on
					e.id = l.employee_id
				where
					l.role_id = 2
					and e.was_dismissed = false
					and e.department_id = podr_ids.doc_podr_id)
			end
		from
			podr_ids )
		--select * from podr_ids
		 select
			spr_person_id into _person_id
		from
			pers_id pid
		join doc.employees e2 on
			e2.id = pid.doc_id;
		
		if _person_id is null then
			perform sys.sendemail_queue_add('vv.belanov.0900@ump.local', 'Ошибка при отправке сообщения из заявок ДО', 
				'Ошибка: не найден руководитель у пользователя с т/н '||_request.tab_nbr||' для заявки с Id '||_request.id||'.');
			return null;
		end if;
	
	-- выборка ответственного за ресурс и роль(если указан конкретный человек - то он, если не указан - то руководитель ответственного подразделения)
	elseif new.status_id = 4 then
		select
			coalesce(owner_id, 
			( 
				with podr as ( 
					select coalesce(d1.id, d2.id) as doc_podr_id 
					from nsi.spr_podr sp 
					left join nsi.spr_podr sh on sh.id = sp.podr_id_owner 
					left join doc.departments d1 on d1.code ilike sp.podr_code and d1.prizn_old is null 
					left join doc.departments d2 on d2.code ilike sh.podr_code and d2.prizn_old is null 
					where sp.id = rij.podr_id
				), leader as ( 
					select e.spr_person_id 
					from podr 
						join doc.employees e on e.department_id = podr.doc_podr_id
						join doc.employees_roles l on e.id = l.employee_id 
						where l.role_id = 2 and e.was_dismissed = false 
				) select * from leader )
			) into _person_id
		from
			uac.rols_in_job rij
		where
			job_id = new.res_id
			and right_type = new.access_id;
		
		if _person_id is null then
			perform sys.sendemail_queue_add('vv.belanov.0900@ump.local', 'Ошибка при отправке сообщения из заявок ДО', 
				'Ошибка: не найден ответственный за ресурс (id: '||new.res_id||', id роли доступа:'||new.access_id||') для заявки с Id '||_request.id||'.');
			return null;
		end if;
	
	else
		return null;	end if;
	
			
	select exchange.person_get_email(_person_id) into _email;
	
	if _email is null then
		perform sys.sendemail_queue_add('vv.belanov.0900@ump.local', 'Ошибка при отправке сообщения из заявок ДО', 
			'Ошибка: не найдена почта  у пользователя (Id - ' ||_person_id||') для заявки с Id '||_request.id||'.');
		return null;
	end if;		
	
	if not exists(select 1 from doc.res_requests_sended_messages where request_id = _request.id and email = _email and
		datei::date = now()::date	
	) then
		perform sys.sendemail_queue_add(_email, 'Заявки на ресурсы', 
			'Вам пришла новая заявка на ресурс от пользователя с т/н '||_request.tab_nbr||' от '||_request.date_enter||'.');
		insert into doc.res_requests_sended_messages(request_id, email) values (_request.id, _email);
	end if;
		
	return null;		


	 
end
$$;


ALTER FUNCTION doc.res_request_contents_send_message_handler() OWNER TO developers;

--
-- Name: sd_requests_portal_add(integer); Type: FUNCTION; Schema: doc; Owner: sup
--

CREATE FUNCTION doc.sd_requests_portal_add(p_req_content_id integer) RETURNS void
    LANGUAGE sql SECURITY DEFINER
    AS $_$
	with foo AS(   
		INSERT INTO doc.sd_serv_desc_requests (status,type_id,subtype_id, short_description,full_description,applicant_id,"number",responsible_laboratory_id)
		SELECT 2, 7, 12, 'Заявка с портала №'||c.request_id || '/' ||c.id, 'Предоставить доступ к ресурсу '||j.job_code||'('||j.job_name||'), роль - '||t.right_name, 
				exchange.person_get_id_by_tab_nbr(r.tab_nbr),(SELECT max("number")+1 FROM doc.sd_serv_desc_requests),coalesce(j.job_group_supporter_id, 6)
		FROM exchange.postfix_res_request_contents c
		JOIN exchange.postfix_res_request r ON r.id=c.request_id
		JOIN uac.is_job j ON c.res_id=j.id
		JOIN uac.spr_right_type t ON t.id=c.access_id
		WHERE c.id=$1
		UNION
		SELECT 2, 7, 14, 'Заявка с портала №'||c.request_id || '/' ||c.id||'.1', 
				'Предоставить доступ к ресурсу '||j.job_code||', роль - '||t.right_name||'. Группы домена - '||domen_group, 
				exchange.person_get_id_by_tab_nbr(r.tab_nbr),(SELECT max("number")+2 FROM doc.sd_serv_desc_requests),1
		FROM exchange.postfix_res_request_contents c
		JOIN exchange.postfix_res_request r ON r.id=c.request_id
		JOIN uac.is_job j ON c.res_id=j.id
		JOIN uac.spr_right_type t ON t.id=c.access_id
		WHERE c.id=$1 and domen_group<>'' AND NOT domen_group IS NULL
		RETURNING id
	)
	INSERT INTO exchange.postfix_res_sd_link(req_content_id, sd_request_id) SELECT $1, id from foo;
	
$_$;


ALTER FUNCTION doc.sd_requests_portal_add(p_req_content_id integer) OWNER TO sup;

--
-- Name: FUNCTION sd_requests_portal_add(p_req_content_id integer); Type: COMMENT; Schema: doc; Owner: sup
--

COMMENT ON FUNCTION doc.sd_requests_portal_add(p_req_content_id integer) IS 'Добавление заявок с портала';


--
-- Name: service_note_performing_stats_trigger_func(); Type: FUNCTION; Schema: doc; Owner: developers
--

CREATE FUNCTION doc.service_note_performing_stats_trigger_func() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
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
$$;


ALTER FUNCTION doc.service_note_performing_stats_trigger_func() OWNER TO developers;

--
-- Name: service_note_receiving_departments_trigger_func(); Type: FUNCTION; Schema: doc; Owner: developers
--

CREATE FUNCTION doc.service_note_receiving_departments_trigger_func() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
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
$$;


ALTER FUNCTION doc.service_note_receiving_departments_trigger_func() OWNER TO developers;

--
-- Name: service_note_signer_department_trigger_func(); Type: FUNCTION; Schema: doc; Owner: developers
--

CREATE FUNCTION doc.service_note_signer_department_trigger_func() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
   	begin 
   		if (select service_stage_name  from doc.document_type_work_cycle_stages dtwcs where id = new.current_work_cycle_stage_id) <> 'IsPerforming' then
   			return new;
   		end if;
   	
   		if new.is_self_registered then
			select short_name 
			into new.signer_department_short_name
			from doc.departments 
			where code = left(new.document_number, length(new.document_number) - position('/' in reverse(new.document_number))) and prizn_old is null;
   		else
   			select signer_dep.short_name  
   			into new.signer_department_short_name
		    from doc.service_note_signings sns  
		    join doc.employees signer on signer.id = sns.signer_id  
		    join doc.departments signer_dep on signer_dep.id = signer.head_kindred_department_id  
		    where document_id = new.id; 
		end if;
	
		return new;
   	end
   $$;


ALTER FUNCTION doc.service_note_signer_department_trigger_func() OWNER TO developers;

--
-- Name: set_head_charge_sheet_for_new_charge_sheet(); Type: FUNCTION; Schema: doc; Owner: developers
--

CREATE FUNCTION doc.set_head_charge_sheet_for_new_charge_sheet() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
begin

	update doc.service_note_receivers 
	set head_charge_sheet_id = doc.get_head_charge_sheet_for(new.id)
	where id = new.id;
	
	return new;
end
$$;


ALTER FUNCTION doc.set_head_charge_sheet_for_new_charge_sheet() OWNER TO developers;

--
-- Name: set_personnel_order_head_charge_sheet_for_new_charge_sheet(); Type: FUNCTION; Schema: doc; Owner: developers
--

CREATE FUNCTION doc.set_personnel_order_head_charge_sheet_for_new_charge_sheet() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
begin

	update doc.personnel_order_charges 
	set head_charge_sheet_id = doc.get_personnel_order_head_charge_sheet_for(new.id)
	where id = new.id;
	
	return new;
end
$$;


ALTER FUNCTION doc.set_personnel_order_head_charge_sheet_for_new_charge_sheet() OWNER TO developers;

--
-- Name: set_personnel_orders_test_data(); Type: FUNCTION; Schema: doc; Owner: u_59968
--

CREATE FUNCTION doc.set_personnel_orders_test_data() RETURNS void
    LANGUAGE plpgsql
    AS $$
declare 
	cg_ids int[];
begin
	with insert_control_groups_data as (
		insert into doc.personnel_order_control_groups (name) values ('c/g'), ('g') 
		returning id 
	)
	select array_agg(id) from insert_control_groups_data into cg_ids;
	
	insert into doc.personnel_order_control_groups__employees (control_group_id, employee_id) values (cg_ids[2], 1356), (cg_ids[1], 1356), (cg_ids[1], 1355), (cg_ids[2], 1355);

	insert into doc.personnel_order_control_groups__sub_kinds(control_group_id, personnel_order_sub_kind_id) values (cg_ids[1], 1), (cg_ids[1], 8), (cg_ids[2], 2), (cg_ids[2], 3);

	insert into doc.personnel_order_creating_access_employees (employee_id) values (1355), (1356), (12), (1206);

	insert into doc.personnel_order_sub_kinds__approvers (personnel_order_sub_kind_id, approver_id) values (1, 1372), (1, 1359), (2, 1196), (2, 12);

	insert into doc.personnel_order_signers (signer_id, is_default) values (12, true);

	update doc.employees set login = 'doc_performer3' where id = 12;
	update doc.employees set login = 'doc_performer4' where id = 1356;
	update doc.employees set login = 'doc_performer5' where id = 1361;
	update doc.employees set login = 'doc_performer6' where id = 1206;
	update doc.employees set login = 'doc_performer2' where id = 126;
	update doc.employees set login = 'doc_performer1' where id = 1332;
	
	update doc.document_types set is_presented = true where id = 11;
end
$$;


ALTER FUNCTION doc.set_personnel_orders_test_data() OWNER TO u_59968;

--
-- Name: trf_sd_request_upd_status(); Type: FUNCTION; Schema: doc; Owner: developers
--

CREATE FUNCTION doc.trf_sd_request_upd_status() RETURNS trigger
    LANGUAGE plpgsql SECURITY DEFINER
    AS $$
begin	
	IF NEW.status=4 THEN
		UPDATE exchange.postfix_res_sd_link  SET status_id=2 WHERE sd_request_id=NEW.id;
	END if;
	RETURN NULL;
end 
$$;


ALTER FUNCTION doc.trf_sd_request_upd_status() OWNER TO developers;

--
-- Name: FUNCTION trf_sd_request_upd_status(); Type: COMMENT; Schema: doc; Owner: developers
--

COMMENT ON FUNCTION doc.trf_sd_request_upd_status() IS 'Обновляем статус заявки с Портала при закрытии заявки в SD';


--
-- Name: update_department_employees_head_kindred_department_trigger_fun(); Type: FUNCTION; Schema: doc; Owner: developers
--

CREATE FUNCTION doc.update_department_employees_head_kindred_department_trigger_fun() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
begin
	update doc.employees e 
	set head_kindred_department_id = doc.find_head_kindred_department_for_inner(e.department_id)
	from doc.get_kindred_department_tree_starting_with(new.id) dep_tree(id)
	where e.department_id = dep_tree.id;

	return null; 
end
$$;


ALTER FUNCTION doc.update_department_employees_head_kindred_department_trigger_fun() OWNER TO developers;

--
-- Name: update_document_application_exists_column(bigint, character varying, character varying); Type: FUNCTION; Schema: doc; Owner: developers
--

CREATE FUNCTION doc.update_document_application_exists_column(document_id bigint, changes_source character varying, changes_type character varying) RETURNS void
    LANGUAGE plpgsql
    AS $_$
declare
	update_dest varchar;
	update_query_pattern varchar;
begin
	if ($2 = 'service_note_links') or ($2 = 'service_note_file_metadata')  then 
		update_dest = 'doc.service_notes';

	elsif ($2 = 'personnel_order_links') or ($2 = 'personnel_order_file_metadata') then
		update_dest = 'doc.personnel_orders';

	else update_dest = 'doc.documents';

	end if;

	if ($3 = 'UPDATE') or ($3 = 'INSERT') then
		update_query_pattern = 'UPDATE ' || update_dest || ' SET applications_exists = true WHERE id = $1';

	else update_query_pattern = 'UPDATE ' || update_dest || ' SET applications_exists = exists(SELECT 1 FROM doc.' || changes_source || ' WHERE document_id = $1) WHERE id = $1';

	end if;
	
	execute update_query_pattern using $1;
end
$_$;


ALTER FUNCTION doc.update_document_application_exists_column(document_id bigint, changes_source character varying, changes_type character varying) OWNER TO developers;

--
-- Name: update_document_application_exists_column_trigger_proc(); Type: FUNCTION; Schema: doc; Owner: developers
--

CREATE FUNCTION doc.update_document_application_exists_column_trigger_proc() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
declare 
	document_id bigint;
begin
	if TG_OP = 'INSERT' then
		document_id = new.document_id;

	else document_id = old.document_id;

	end if;
	
	perform doc.update_document_application_exists_column(document_id, TG_TABLE_NAME::varchar, TG_OP::varchar);
	
	return null;
end
$$;


ALTER FUNCTION doc.update_document_application_exists_column_trigger_proc() OWNER TO developers;

--
-- Name: update_leader_links_for_subordinates_of(bigint, boolean); Type: FUNCTION; Schema: doc; Owner: developers
--

CREATE FUNCTION doc.update_leader_links_for_subordinates_of(target_employee_id bigint, is_employee_new boolean DEFAULT false) RETURNS void
    LANGUAGE plpgsql
    AS $_$
begin
	with recursive get_subordinates(id, top_level_id, head_kindred_department_id) as (
		select
		e.id,
		e.leader_id,
		e.head_kindred_department_id
		from doc.employees as e
		where e.id = $1
		union

		select 
		e.id,
		e.leader_id,
		e.head_kindred_department_id
		from doc.employees as e
		join get_subordinates as s on e.leader_id = s.id
	)
	update doc.employees e
	set leader_links =
		(
		select 
			array_agg(
				row(id, role_id, department_id, head_kindred_department_id)::doc.employee_link
			)
		from doc.find_all_same_head_kindred_department_leaders_for_employee(s.id)
		)
	from get_subordinates s 
	where e.id = s.id;
end
$_$;


ALTER FUNCTION doc.update_leader_links_for_subordinates_of(target_employee_id bigint, is_employee_new boolean) OWNER TO developers;

--
-- Name: update_leader_links_for_subordinates_of__trigger_proc(); Type: FUNCTION; Schema: doc; Owner: developers
--

CREATE FUNCTION doc.update_leader_links_for_subordinates_of__trigger_proc() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
declare
	emp_id int;
	is_employee_new boolean;
begin

	if TG_OP = 'INSERT' then
		emp_id = new.id;
		is_employee_new = true;

	else 
		emp_id = old.id;
		is_employee_new = false;

	end if;

	perform doc.update_leader_links_for_subordinates_of(emp_id, is_employee_new);
	
	return null;
end
$$;


ALTER FUNCTION doc.update_leader_links_for_subordinates_of__trigger_proc() OWNER TO developers;

--
-- Name: update_leader_links_for_subordinates_of__trigger_proc2(); Type: FUNCTION; Schema: doc; Owner: developers
--

CREATE FUNCTION doc.update_leader_links_for_subordinates_of__trigger_proc2() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
declare
	emp_id int;
begin

	if TG_OP = 'INSERT' then
		emp_id = new.employee_id;

	else 
		emp_id = old.employee_id;

	end if;

	perform doc.update_leader_links_for_subordinates_of(emp_id);
	
	return null;
end
$$;


ALTER FUNCTION doc.update_leader_links_for_subordinates_of__trigger_proc2() OWNER TO developers;

SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- Name: acceptance_posting_kinds; Type: TABLE; Schema: doc; Owner: developers
--

CREATE TABLE doc.acceptance_posting_kinds (
    id integer NOT NULL,
    name character varying,
    description character varying,
    cod_sprav_ok integer,
    cod_sprav_ok_up integer,
    name_up character varying
);


ALTER TABLE doc.acceptance_posting_kinds OWNER TO developers;

--
-- Name: TABLE acceptance_posting_kinds; Type: COMMENT; Schema: doc; Owner: developers
--

COMMENT ON TABLE doc.acceptance_posting_kinds IS 'Виды приёмок/отправок документов';


--
-- Name: COLUMN acceptance_posting_kinds.name; Type: COMMENT; Schema: doc; Owner: developers
--

COMMENT ON COLUMN doc.acceptance_posting_kinds.name IS 'Наименование вида приёмки/отправки';


--
-- Name: COLUMN acceptance_posting_kinds.description; Type: COMMENT; Schema: doc; Owner: developers
--

COMMENT ON COLUMN doc.acceptance_posting_kinds.description IS 'Описание вида приёмки/отправки';


--
-- Name: acceptance_posting_kinds_id_seq; Type: SEQUENCE; Schema: doc; Owner: developers
--

CREATE SEQUENCE doc.acceptance_posting_kinds_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE doc.acceptance_posting_kinds_id_seq OWNER TO developers;

--
-- Name: acceptance_posting_kinds_id_seq; Type: SEQUENCE OWNED BY; Schema: doc; Owner: developers
--

ALTER SEQUENCE doc.acceptance_posting_kinds_id_seq OWNED BY doc.acceptance_posting_kinds.id;


--
-- Name: correspondence_creating_access_employee; Type: TABLE; Schema: doc; Owner: developers
--

CREATE TABLE doc.correspondence_creating_access_employee (
    employee_id integer NOT NULL
);


ALTER TABLE doc.correspondence_creating_access_employee OWNER TO developers;

--
-- Name: TABLE correspondence_creating_access_employee; Type: COMMENT; Schema: doc; Owner: developers
--

COMMENT ON TABLE doc.correspondence_creating_access_employee IS 'Сотрудники, которым доступна возможность создания корреспонденции';


--
-- Name: correspondents; Type: TABLE; Schema: doc; Owner: developers
--

CREATE TABLE doc.correspondents (
    cod_correspondent integer NOT NULL,
    cod_correspondent_ok integer NOT NULL,
    name_correspondent character varying NOT NULL,
    full_name_correspondent character varying NOT NULL,
    address_correspondent character varying,
    e_mail character varying,
    note character varying,
    old_code numeric,
    dat_modify date,
    name_user character varying,
    add_file_yn integer,
    pindex character varying,
    town character varying,
    street character varying,
    home character varying,
    inn character varying,
    tel character varying,
    fax character varying
);


ALTER TABLE doc.correspondents OWNER TO developers;

--
-- Name: correspondents_id_seq; Type: SEQUENCE; Schema: doc; Owner: developers
--

CREATE SEQUENCE doc.correspondents_id_seq
    START WITH 5571
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE doc.correspondents_id_seq OWNER TO developers;

--
-- Name: department_email; Type: TABLE; Schema: doc; Owner: developers
--

CREATE TABLE doc.department_email (
    id integer NOT NULL,
    department_id integer,
    email character varying
);


ALTER TABLE doc.department_email OWNER TO developers;

--
-- Name: TABLE department_email; Type: COMMENT; Schema: doc; Owner: developers
--

COMMENT ON TABLE doc.department_email IS 'email подразделений';


--
-- Name: COLUMN department_email.email; Type: COMMENT; Schema: doc; Owner: developers
--

COMMENT ON COLUMN doc.department_email.email IS 'Внешний почтовый адрес подразделения';


--
-- Name: department_email_id_seq; Type: SEQUENCE; Schema: doc; Owner: developers
--

CREATE SEQUENCE doc.department_email_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE doc.department_email_id_seq OWNER TO developers;

--
-- Name: department_email_id_seq; Type: SEQUENCE OWNED BY; Schema: doc; Owner: developers
--

ALTER SEQUENCE doc.department_email_id_seq OWNED BY doc.department_email.id;


--
-- Name: departments_outside_id_seq; Type: SEQUENCE; Schema: doc; Owner: developers
--

CREATE SEQUENCE doc.departments_outside_id_seq
    START WITH 770916
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE doc.departments_outside_id_seq OWNER TO developers;

--
-- Name: departments; Type: TABLE; Schema: doc; Owner: developers
--

CREATE TABLE doc.departments (
    id integer DEFAULT nextval('doc.departments_outside_id_seq'::regclass) NOT NULL,
    short_name character varying,
    full_name character varying,
    note character varying,
    is_activated boolean DEFAULT false,
    changing_user character varying DEFAULT "session_user"(),
    changing_date timestamp without time zone DEFAULT now(),
    type_podr integer,
    old_code bigint,
    prizn_old integer,
    prizn_lvs integer,
    code character varying,
    top_level_department_id integer,
    is_top_level_department_kindred boolean DEFAULT true NOT NULL
);


ALTER TABLE doc.departments OWNER TO developers;

--
-- Name: TABLE departments; Type: COMMENT; Schema: doc; Owner: developers
--

COMMENT ON TABLE doc.departments IS 'Справочник подразделений, участвующих в документообороте';


--
-- Name: COLUMN departments.short_name; Type: COMMENT; Schema: doc; Owner: developers
--

COMMENT ON COLUMN doc.departments.short_name IS 'Краткое наименование';


--
-- Name: COLUMN departments.full_name; Type: COMMENT; Schema: doc; Owner: developers
--

COMMENT ON COLUMN doc.departments.full_name IS 'Полное наименование';


--
-- Name: COLUMN departments.note; Type: COMMENT; Schema: doc; Owner: developers
--

COMMENT ON COLUMN doc.departments.note IS 'Примечание';


--
-- Name: COLUMN departments.is_activated; Type: COMMENT; Schema: doc; Owner: developers
--

COMMENT ON COLUMN doc.departments.is_activated IS 'Функционирует (в том смысле, что не прекратило свою деятельность окончательно) ли подразделение на данный момент';


--
-- Name: COLUMN departments.changing_user; Type: COMMENT; Schema: doc; Owner: developers
--

COMMENT ON COLUMN doc.departments.changing_user IS 'Пользователь, внёсший изменения';


--
-- Name: COLUMN departments.changing_date; Type: COMMENT; Schema: doc; Owner: developers
--

COMMENT ON COLUMN doc.departments.changing_date IS 'Дата внесения изменений';


--
-- Name: COLUMN departments.code; Type: COMMENT; Schema: doc; Owner: developers
--

COMMENT ON COLUMN doc.departments.code IS 'Код поразделения';


--
-- Name: COLUMN departments.top_level_department_id; Type: COMMENT; Schema: doc; Owner: developers
--

COMMENT ON COLUMN doc.departments.top_level_department_id IS 'Ссылка на родительское подразделение';


--
-- Name: COLUMN departments.is_top_level_department_kindred; Type: COMMENT; Schema: doc; Owner: developers
--

COMMENT ON COLUMN doc.departments.is_top_level_department_kindred IS 'Является ли вышестоящее подразделение родственным по отношению к данному';


--
-- Name: document_approving_results; Type: TABLE; Schema: doc; Owner: developers
--

CREATE TABLE doc.document_approving_results (
    id integer NOT NULL,
    result_name character varying NOT NULL,
    result_service_name character varying
);


ALTER TABLE doc.document_approving_results OWNER TO developers;

--
-- Name: TABLE document_approving_results; Type: COMMENT; Schema: doc; Owner: developers
--

COMMENT ON TABLE doc.document_approving_results IS 'Информация о результатах согласования документа';


--
-- Name: COLUMN document_approving_results.result_name; Type: COMMENT; Schema: doc; Owner: developers
--

COMMENT ON COLUMN doc.document_approving_results.result_name IS 'Название результата согласования';


--
-- Name: document_approving_results_id_seq; Type: SEQUENCE; Schema: doc; Owner: developers
--

CREATE SEQUENCE doc.document_approving_results_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE doc.document_approving_results_id_seq OWNER TO developers;

--
-- Name: document_approving_results_id_seq; Type: SEQUENCE OWNED BY; Schema: doc; Owner: developers
--

ALTER SEQUENCE doc.document_approving_results_id_seq OWNED BY doc.document_approving_results.id;


--
-- Name: document_approvings; Type: TABLE; Schema: doc; Owner: developers
--

CREATE TABLE doc.document_approvings (
    id integer NOT NULL,
    document_id integer NOT NULL,
    performing_date timestamp without time zone,
    performing_result_id integer NOT NULL,
    approver_id integer NOT NULL,
    actual_performed_employee_id integer,
    note character varying(8192),
    cycle_number integer,
    inserting_timestamp timestamp without time zone DEFAULT now(),
    inserted_user character varying DEFAULT "session_user"()
);


ALTER TABLE doc.document_approvings OWNER TO developers;

--
-- Name: TABLE document_approvings; Type: COMMENT; Schema: doc; Owner: developers
--

COMMENT ON TABLE doc.document_approvings IS 'Информация о согласованиях документов';


--
-- Name: COLUMN document_approvings.document_id; Type: COMMENT; Schema: doc; Owner: developers
--

COMMENT ON COLUMN doc.document_approvings.document_id IS 'id документа';


--
-- Name: COLUMN document_approvings.performing_date; Type: COMMENT; Schema: doc; Owner: developers
--

COMMENT ON COLUMN doc.document_approvings.performing_date IS 'Дата принятия участия в согласовании документа сотрудником actual_approved_employee_id';


--
-- Name: COLUMN document_approvings.performing_result_id; Type: COMMENT; Schema: doc; Owner: developers
--

COMMENT ON COLUMN doc.document_approvings.performing_result_id IS 'id результата согласования документа (согласовано, не согласовано)';


--
-- Name: COLUMN document_approvings.approver_id; Type: COMMENT; Schema: doc; Owner: developers
--

COMMENT ON COLUMN doc.document_approvings.approver_id IS 'id назначенного согласованта для документа';


--
-- Name: COLUMN document_approvings.actual_performed_employee_id; Type: COMMENT; Schema: doc; Owner: developers
--

COMMENT ON COLUMN doc.document_approvings.actual_performed_employee_id IS 'id фактически принявшего участие в согласовании документа сотрудника';


--
-- Name: COLUMN document_approvings.note; Type: COMMENT; Schema: doc; Owner: developers
--

COMMENT ON COLUMN doc.document_approvings.note IS 'примечания согласованта';


--
-- Name: COLUMN document_approvings.cycle_number; Type: COMMENT; Schema: doc; Owner: developers
--

COMMENT ON COLUMN doc.document_approvings.cycle_number IS 'номер цикла согласования документа. Данное поля заполняется в случае завершения цикла согласования. Отсутствие значения в данном поле свидетельствует о том, что согласование ещё не завершено.';


--
-- Name: document_approvings_id_seq; Type: SEQUENCE; Schema: doc; Owner: developers
--

CREATE SEQUENCE doc.document_approvings_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE doc.document_approvings_id_seq OWNER TO developers;

--
-- Name: document_approvings_id_seq; Type: SEQUENCE OWNED BY; Schema: doc; Owner: developers
--

ALTER SEQUENCE doc.document_approvings_id_seq OWNED BY doc.document_approvings.id;


--
-- Name: document_charge_types; Type: TABLE; Schema: doc; Owner: developers
--

CREATE TABLE doc.document_charge_types (
    id integer NOT NULL,
    name character varying NOT NULL,
    service_name character varying NOT NULL
);


ALTER TABLE doc.document_charge_types OWNER TO developers;

--
-- Name: document_charge_types_id_seq; Type: SEQUENCE; Schema: doc; Owner: developers
--

CREATE SEQUENCE doc.document_charge_types_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE doc.document_charge_types_id_seq OWNER TO developers;

--
-- Name: document_charge_types_id_seq; Type: SEQUENCE OWNED BY; Schema: doc; Owner: developers
--

ALTER SEQUENCE doc.document_charge_types_id_seq OWNED BY doc.document_charge_types.id;


--
-- Name: document_file_metadata; Type: TABLE; Schema: doc; Owner: developers
--

CREATE TABLE doc.document_file_metadata (
    id integer NOT NULL,
    id_for_search integer,
    document_id integer NOT NULL,
    file_path character varying,
    file_name character varying,
    note character varying,
    changing_date timestamp without time zone DEFAULT now(),
    changing_user character varying DEFAULT "session_user"()
);


ALTER TABLE doc.document_file_metadata OWNER TO developers;

--
-- Name: TABLE document_file_metadata; Type: COMMENT; Schema: doc; Owner: developers
--

COMMENT ON TABLE doc.document_file_metadata IS 'Метаданные файлов, прилагаемых к документам';


--
-- Name: COLUMN document_file_metadata.document_id; Type: COMMENT; Schema: doc; Owner: developers
--

COMMENT ON COLUMN doc.document_file_metadata.document_id IS 'Идентификатор записи документа из стороннего справочника';


--
-- Name: COLUMN document_file_metadata.file_path; Type: COMMENT; Schema: doc; Owner: developers
--

COMMENT ON COLUMN doc.document_file_metadata.file_path IS 'Путь к файлу в архиве';


--
-- Name: COLUMN document_file_metadata.file_name; Type: COMMENT; Schema: doc; Owner: developers
--

COMMENT ON COLUMN doc.document_file_metadata.file_name IS 'Название файла';


--
-- Name: COLUMN document_file_metadata.note; Type: COMMENT; Schema: doc; Owner: developers
--

COMMENT ON COLUMN doc.document_file_metadata.note IS 'Примечания';


--
-- Name: COLUMN document_file_metadata.changing_date; Type: COMMENT; Schema: doc; Owner: developers
--

COMMENT ON COLUMN doc.document_file_metadata.changing_date IS 'Дата внесения изменений';


--
-- Name: COLUMN document_file_metadata.changing_user; Type: COMMENT; Schema: doc; Owner: developers
--

COMMENT ON COLUMN doc.document_file_metadata.changing_user IS 'Пользователь, внёсший изменения';


--
-- Name: document_file_metadata_uit_id_seq; Type: SEQUENCE; Schema: doc; Owner: developers
--

CREATE SEQUENCE doc.document_file_metadata_uit_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE doc.document_file_metadata_uit_id_seq OWNER TO developers;

--
-- Name: document_file_metadata_uit_id_seq; Type: SEQUENCE OWNED BY; Schema: doc; Owner: developers
--

ALTER SEQUENCE doc.document_file_metadata_uit_id_seq OWNED BY doc.document_file_metadata.id;


--
-- Name: document_type_work_cycle_stages; Type: TABLE; Schema: doc; Owner: developers
--

CREATE TABLE doc.document_type_work_cycle_stages (
    id integer NOT NULL,
    document_type_id integer NOT NULL,
    stage_name character varying NOT NULL,
    stage_number integer,
    service_stage_name character varying NOT NULL
);


ALTER TABLE doc.document_type_work_cycle_stages OWNER TO developers;

--
-- Name: TABLE document_type_work_cycle_stages; Type: COMMENT; Schema: doc; Owner: developers
--

COMMENT ON TABLE doc.document_type_work_cycle_stages IS 'Стадии жизненного цикла типов документов';


--
-- Name: COLUMN document_type_work_cycle_stages.document_type_id; Type: COMMENT; Schema: doc; Owner: developers
--

COMMENT ON COLUMN doc.document_type_work_cycle_stages.document_type_id IS 'Ссылка на тип документа (служебные записки, приказы и т.д.)';


--
-- Name: COLUMN document_type_work_cycle_stages.stage_name; Type: COMMENT; Schema: doc; Owner: developers
--

COMMENT ON COLUMN doc.document_type_work_cycle_stages.stage_name IS 'Наименование стадии жизненного цикла для данного типа документов';


--
-- Name: document_life_cycle_stages_id_seq; Type: SEQUENCE; Schema: doc; Owner: developers
--

CREATE SEQUENCE doc.document_life_cycle_stages_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE doc.document_life_cycle_stages_id_seq OWNER TO developers;

--
-- Name: document_life_cycle_stages_id_seq; Type: SEQUENCE OWNED BY; Schema: doc; Owner: developers
--

ALTER SEQUENCE doc.document_life_cycle_stages_id_seq OWNED BY doc.document_type_work_cycle_stages.id;


--
-- Name: document_links; Type: TABLE; Schema: doc; Owner: developers
--

CREATE TABLE doc.document_links (
    id integer NOT NULL,
    document_id integer NOT NULL,
    related_document_id integer NOT NULL,
    changing_date timestamp without time zone DEFAULT now(),
    changing_user character varying DEFAULT "session_user"(),
    related_document_type_id integer NOT NULL
);


ALTER TABLE doc.document_links OWNER TO developers;

--
-- Name: TABLE document_links; Type: COMMENT; Schema: doc; Owner: developers
--

COMMENT ON TABLE doc.document_links IS 'Связи документов с вышестоящими и нижестоящими документами';


--
-- Name: COLUMN document_links.document_id; Type: COMMENT; Schema: doc; Owner: developers
--

COMMENT ON COLUMN doc.document_links.document_id IS 'Идентификатор записи документа из стороннего справочника';


--
-- Name: COLUMN document_links.related_document_id; Type: COMMENT; Schema: doc; Owner: developers
--

COMMENT ON COLUMN doc.document_links.related_document_id IS 'Идентификатор записи документа из стороннего справочника';


--
-- Name: COLUMN document_links.changing_date; Type: COMMENT; Schema: doc; Owner: developers
--

COMMENT ON COLUMN doc.document_links.changing_date IS 'Дата внесения изменений';


--
-- Name: COLUMN document_links.changing_user; Type: COMMENT; Schema: doc; Owner: developers
--

COMMENT ON COLUMN doc.document_links.changing_user IS 'Пользователь, внёсший изменения';


--
-- Name: document_links_uit_id_seq; Type: SEQUENCE; Schema: doc; Owner: developers
--

CREATE SEQUENCE doc.document_links_uit_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE doc.document_links_uit_id_seq OWNER TO developers;

--
-- Name: document_links_uit_id_seq; Type: SEQUENCE OWNED BY; Schema: doc; Owner: developers
--

ALTER SEQUENCE doc.document_links_uit_id_seq OWNED BY doc.document_links.id;


--
-- Name: document_numerators; Type: TABLE; Schema: doc; Owner: developers
--

CREATE TABLE doc.document_numerators (
    id integer NOT NULL,
    department_id integer,
    document_type_id integer NOT NULL,
    main_value bigint DEFAULT 0 NOT NULL,
    prefix_value character varying,
    postfix_value character varying,
    delimiter character varying DEFAULT '/'::character varying
);


ALTER TABLE doc.document_numerators OWNER TO developers;

--
-- Name: TABLE document_numerators; Type: COMMENT; Schema: doc; Owner: developers
--

COMMENT ON TABLE doc.document_numerators IS 'Нумераторы документов различных типов';


--
-- Name: COLUMN document_numerators.department_id; Type: COMMENT; Schema: doc; Owner: developers
--

COMMENT ON COLUMN doc.document_numerators.department_id IS 'Ссылка на подразделение, используемое для нумерация документов внутри данного подразделения';


--
-- Name: COLUMN document_numerators.document_type_id; Type: COMMENT; Schema: doc; Owner: developers
--

COMMENT ON COLUMN doc.document_numerators.document_type_id IS 'Ссылка на тип документа, используемый для нумерации документов';


--
-- Name: COLUMN document_numerators.main_value; Type: COMMENT; Schema: doc; Owner: developers
--

COMMENT ON COLUMN doc.document_numerators.main_value IS 'Основная составляющая номера документа, используемого для формирования номера следующего документа';


--
-- Name: COLUMN document_numerators.prefix_value; Type: COMMENT; Schema: doc; Owner: developers
--

COMMENT ON COLUMN doc.document_numerators.prefix_value IS 'Префиксная часть номера документа, используемая внутри подразделения';


--
-- Name: COLUMN document_numerators.postfix_value; Type: COMMENT; Schema: doc; Owner: developers
--

COMMENT ON COLUMN doc.document_numerators.postfix_value IS 'Постфиксная часть номера документа, используемая внутри подразделения';


--
-- Name: document_numerators_id_seq; Type: SEQUENCE; Schema: doc; Owner: developers
--

CREATE SEQUENCE doc.document_numerators_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE doc.document_numerators_id_seq OWNER TO developers;

--
-- Name: document_numerators_id_seq; Type: SEQUENCE OWNED BY; Schema: doc; Owner: developers
--

ALTER SEQUENCE doc.document_numerators_id_seq OWNED BY doc.document_numerators.id;


--
-- Name: document_receivers; Type: TABLE; Schema: doc; Owner: developers
--

CREATE TABLE doc.document_receivers (
    id integer NOT NULL,
    document_id integer NOT NULL,
    performer_id integer NOT NULL,
    performing_date timestamp without time zone,
    comment character varying,
    changing_date timestamp without time zone DEFAULT now(),
    changing_user character varying DEFAULT "session_user"(),
    top_level_charge_sheet_id integer,
    cod_type_document integer,
    isp_yn integer,
    actual_performer_id integer,
    charge character varying,
    document_type_id_for_receiver integer,
    charge_creation_date timestamp without time zone,
    charge_view_date timestamp without time zone,
    application_id integer,
    issuer_id integer,
    charge_period_start timestamp without time zone,
    charge_period_end timestamp without time zone,
    incoming_document_id integer,
    incoming_document_type_id integer,
    input_number character varying,
    input_number_date timestamp without time zone
);


ALTER TABLE doc.document_receivers OWNER TO developers;

--
-- Name: TABLE document_receivers; Type: COMMENT; Schema: doc; Owner: developers
--

COMMENT ON TABLE doc.document_receivers IS 'Получатели документов';


--
-- Name: COLUMN document_receivers.document_id; Type: COMMENT; Schema: doc; Owner: developers
--

COMMENT ON COLUMN doc.document_receivers.document_id IS 'Ссылка на документ, полученный из стороннего справочника';


--
-- Name: COLUMN document_receivers.performer_id; Type: COMMENT; Schema: doc; Owner: developers
--

COMMENT ON COLUMN doc.document_receivers.performer_id IS 'Ссылка на получившего документ сотрудника, полученная из стороннего справочника';


--
-- Name: COLUMN document_receivers.performing_date; Type: COMMENT; Schema: doc; Owner: developers
--

COMMENT ON COLUMN doc.document_receivers.performing_date IS 'Дата исполнения документа';


--
-- Name: COLUMN document_receivers.comment; Type: COMMENT; Schema: doc; Owner: developers
--

COMMENT ON COLUMN doc.document_receivers.comment IS 'Комментарий к исполнению';


--
-- Name: COLUMN document_receivers.changing_date; Type: COMMENT; Schema: doc; Owner: developers
--

COMMENT ON COLUMN doc.document_receivers.changing_date IS 'Дата внесения изменений';


--
-- Name: COLUMN document_receivers.changing_user; Type: COMMENT; Schema: doc; Owner: developers
--

COMMENT ON COLUMN doc.document_receivers.changing_user IS 'Пользователь, внёсший изменения';


--
-- Name: COLUMN document_receivers.top_level_charge_sheet_id; Type: COMMENT; Schema: doc; Owner: developers
--

COMMENT ON COLUMN doc.document_receivers.top_level_charge_sheet_id IS 'Ссылка на вышестояющий лист поручения';


--
-- Name: COLUMN document_receivers.actual_performer_id; Type: COMMENT; Schema: doc; Owner: developers
--

COMMENT ON COLUMN doc.document_receivers.actual_performer_id IS 'Фактически исполнивший документ сотрудник';


--
-- Name: COLUMN document_receivers.charge; Type: COMMENT; Schema: doc; Owner: developers
--

COMMENT ON COLUMN doc.document_receivers.charge IS 'Поручение по документу для конкретного получателя (исполнителя)';


--
-- Name: COLUMN document_receivers.document_type_id_for_receiver; Type: COMMENT; Schema: doc; Owner: developers
--

COMMENT ON COLUMN doc.document_receivers.document_type_id_for_receiver IS 'Ссылка на тип документа по отношению к получателю (исполнителю) (например, входящая служебная записка)';


--
-- Name: COLUMN document_receivers.charge_view_date; Type: COMMENT; Schema: doc; Owner: developers
--

COMMENT ON COLUMN doc.document_receivers.charge_view_date IS 'Дата просмотра поручения';


--
-- Name: COLUMN document_receivers.application_id; Type: COMMENT; Schema: doc; Owner: developers
--

COMMENT ON COLUMN doc.document_receivers.application_id IS 'Ссылка на заявку';


--
-- Name: document_receivers_uit_id_seq; Type: SEQUENCE; Schema: doc; Owner: developers
--

CREATE SEQUENCE doc.document_receivers_uit_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE doc.document_receivers_uit_id_seq OWNER TO developers;

--
-- Name: document_receivers_uit_id_seq; Type: SEQUENCE OWNED BY; Schema: doc; Owner: developers
--

ALTER SEQUENCE doc.document_receivers_uit_id_seq OWNED BY doc.document_receivers.id;


--
-- Name: document_signings; Type: TABLE; Schema: doc; Owner: developers
--

CREATE TABLE doc.document_signings (
    id integer NOT NULL,
    document_id bigint NOT NULL,
    signer_id bigint NOT NULL,
    actual_signed_id bigint,
    signing_date timestamp without time zone
);


ALTER TABLE doc.document_signings OWNER TO developers;

--
-- Name: document_signings_id_seq; Type: SEQUENCE; Schema: doc; Owner: developers
--

CREATE SEQUENCE doc.document_signings_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE doc.document_signings_id_seq OWNER TO developers;

--
-- Name: document_signings_id_seq; Type: SEQUENCE OWNED BY; Schema: doc; Owner: developers
--

ALTER SEQUENCE doc.document_signings_id_seq OWNED BY doc.document_signings.id;


--
-- Name: document_types; Type: TABLE; Schema: doc; Owner: developers
--

CREATE TABLE doc.document_types (
    id integer NOT NULL,
    name character varying NOT NULL,
    description character varying,
    parent_type_id integer,
    single_full_name character varying,
    short_full_name character varying,
    is_presented boolean DEFAULT true NOT NULL,
    is_domain boolean DEFAULT false NOT NULL,
    service_name character varying,
    is_serviced boolean DEFAULT false NOT NULL
);


ALTER TABLE doc.document_types OWNER TO developers;

--
-- Name: TABLE document_types; Type: COMMENT; Schema: doc; Owner: developers
--

COMMENT ON TABLE doc.document_types IS 'Типы документов (иерархическая организация)';


--
-- Name: COLUMN document_types.name; Type: COMMENT; Schema: doc; Owner: developers
--

COMMENT ON COLUMN doc.document_types.name IS 'Наименование типа документа';


--
-- Name: COLUMN document_types.description; Type: COMMENT; Schema: doc; Owner: developers
--

COMMENT ON COLUMN doc.document_types.description IS 'Описание типа документа';


--
-- Name: COLUMN document_types.parent_type_id; Type: COMMENT; Schema: doc; Owner: developers
--

COMMENT ON COLUMN doc.document_types.parent_type_id IS 'Ссылка на родительский тип';


--
-- Name: COLUMN document_types.single_full_name; Type: COMMENT; Schema: doc; Owner: developers
--

COMMENT ON COLUMN doc.document_types.single_full_name IS 'Полное имя типа документа (используется для отображения в программе)';


--
-- Name: document_types_allowable_document_charges_types; Type: TABLE; Schema: doc; Owner: developers
--

CREATE TABLE doc.document_types_allowable_document_charges_types (
    id integer NOT NULL,
    document_type_id integer NOT NULL,
    document_charge_type_id integer NOT NULL
);


ALTER TABLE doc.document_types_allowable_document_charges_types OWNER TO developers;

--
-- Name: document_types_allowable_document_charges_types_id_seq; Type: SEQUENCE; Schema: doc; Owner: developers
--

CREATE SEQUENCE doc.document_types_allowable_document_charges_types_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE doc.document_types_allowable_document_charges_types_id_seq OWNER TO developers;

--
-- Name: document_types_allowable_document_charges_types_id_seq; Type: SEQUENCE OWNED BY; Schema: doc; Owner: developers
--

ALTER SEQUENCE doc.document_types_allowable_document_charges_types_id_seq OWNED BY doc.document_types_allowable_document_charges_types.id;


--
-- Name: document_types_id_seq; Type: SEQUENCE; Schema: doc; Owner: developers
--

CREATE SEQUENCE doc.document_types_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE doc.document_types_id_seq OWNER TO developers;

--
-- Name: document_types_id_seq; Type: SEQUENCE OWNED BY; Schema: doc; Owner: developers
--

ALTER SEQUENCE doc.document_types_id_seq OWNED BY doc.document_types.id;


--
-- Name: documents; Type: TABLE; Schema: doc; Owner: developers
--

CREATE TABLE doc.documents (
    id integer NOT NULL,
    type_id integer NOT NULL,
    name character varying,
    document_number character varying NOT NULL,
    creation_date timestamp without time zone NOT NULL,
    note character varying,
    current_work_cycle_stage_id integer DEFAULT 1,
    content character varying,
    changing_date timestamp without time zone DEFAULT now(),
    changing_user character varying DEFAULT "session_user"(),
    author_id integer,
    performer_id integer,
    is_sent_to_signing boolean,
    is_self_registered boolean DEFAULT false,
    document_date timestamp without time zone,
    product_code character varying
);


ALTER TABLE doc.documents OWNER TO developers;

--
-- Name: TABLE documents; Type: COMMENT; Schema: doc; Owner: developers
--

COMMENT ON TABLE doc.documents IS 'Общая информация о документах различных типов';


--
-- Name: COLUMN documents.id; Type: COMMENT; Schema: doc; Owner: developers
--

COMMENT ON COLUMN doc.documents.id IS 'Идентификатор записи документа из стороннего справочника';


--
-- Name: COLUMN documents.type_id; Type: COMMENT; Schema: doc; Owner: developers
--

COMMENT ON COLUMN doc.documents.type_id IS 'Ссылка на тип документа';


--
-- Name: COLUMN documents.name; Type: COMMENT; Schema: doc; Owner: developers
--

COMMENT ON COLUMN doc.documents.name IS 'Название';


--
-- Name: COLUMN documents.document_number; Type: COMMENT; Schema: doc; Owner: developers
--

COMMENT ON COLUMN doc.documents.document_number IS 'Номер';


--
-- Name: COLUMN documents.creation_date; Type: COMMENT; Schema: doc; Owner: developers
--

COMMENT ON COLUMN doc.documents.creation_date IS 'Дата создания';


--
-- Name: COLUMN documents.note; Type: COMMENT; Schema: doc; Owner: developers
--

COMMENT ON COLUMN doc.documents.note IS 'Примечания';


--
-- Name: COLUMN documents.current_work_cycle_stage_id; Type: COMMENT; Schema: doc; Owner: developers
--

COMMENT ON COLUMN doc.documents.current_work_cycle_stage_id IS 'Ссылка на текущую стадию жизненного цикла документа';


--
-- Name: COLUMN documents.content; Type: COMMENT; Schema: doc; Owner: developers
--

COMMENT ON COLUMN doc.documents.content IS 'Содержимое';


--
-- Name: COLUMN documents.changing_date; Type: COMMENT; Schema: doc; Owner: developers
--

COMMENT ON COLUMN doc.documents.changing_date IS 'Дата внесения изменений';


--
-- Name: COLUMN documents.changing_user; Type: COMMENT; Schema: doc; Owner: developers
--

COMMENT ON COLUMN doc.documents.changing_user IS 'Пользователь, внёсший изменения';


--
-- Name: COLUMN documents.performer_id; Type: COMMENT; Schema: doc; Owner: developers
--

COMMENT ON COLUMN doc.documents.performer_id IS 'Ссылка на ответственного за данный документ';


--
-- Name: COLUMN documents.document_date; Type: COMMENT; Schema: doc; Owner: developers
--

COMMENT ON COLUMN doc.documents.document_date IS 'Дата документа';


--
-- Name: documents_view_access_rights; Type: TABLE; Schema: doc; Owner: developers
--

CREATE TABLE doc.documents_view_access_rights (
    id integer NOT NULL,
    subordinate_id integer NOT NULL,
    leader_id integer NOT NULL,
    changing_date timestamp without time zone DEFAULT now(),
    changing_user character varying DEFAULT "session_user"()
);


ALTER TABLE doc.documents_view_access_rights OWNER TO developers;

--
-- Name: TABLE documents_view_access_rights; Type: COMMENT; Schema: doc; Owner: developers
--

COMMENT ON TABLE doc.documents_view_access_rights IS 'Права сотрудников на просмотр документов';


--
-- Name: COLUMN documents_view_access_rights.subordinate_id; Type: COMMENT; Schema: doc; Owner: developers
--

COMMENT ON COLUMN doc.documents_view_access_rights.subordinate_id IS 'Ссылка на подчиненного сотрудника(зам, секретарь и т.д.) из стороннего справочника';


--
-- Name: COLUMN documents_view_access_rights.leader_id; Type: COMMENT; Schema: doc; Owner: developers
--

COMMENT ON COLUMN doc.documents_view_access_rights.leader_id IS 'Ссылка на руководителя из стороннего справочника';


--
-- Name: COLUMN documents_view_access_rights.changing_date; Type: COMMENT; Schema: doc; Owner: developers
--

COMMENT ON COLUMN doc.documents_view_access_rights.changing_date IS 'Дата внесения изменений';


--
-- Name: COLUMN documents_view_access_rights.changing_user; Type: COMMENT; Schema: doc; Owner: developers
--

COMMENT ON COLUMN doc.documents_view_access_rights.changing_user IS 'Пользователь, внёсший изменения';


--
-- Name: documents_view_access_rights_id_seq; Type: SEQUENCE; Schema: doc; Owner: developers
--

CREATE SEQUENCE doc.documents_view_access_rights_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE doc.documents_view_access_rights_id_seq OWNER TO developers;

--
-- Name: documents_view_access_rights_id_seq; Type: SEQUENCE OWNED BY; Schema: doc; Owner: developers
--

ALTER SEQUENCE doc.documents_view_access_rights_id_seq OWNED BY doc.documents_view_access_rights.id;


--
-- Name: employee_replacements; Type: TABLE; Schema: doc; Owner: developers
--

CREATE TABLE doc.employee_replacements (
    id integer NOT NULL,
    replaceable_id integer NOT NULL,
    deputy_id integer NOT NULL,
    replacement_period_start timestamp without time zone,
    replacement_period_end timestamp without time zone
);


ALTER TABLE doc.employee_replacements OWNER TO developers;

--
-- Name: TABLE employee_replacements; Type: COMMENT; Schema: doc; Owner: developers
--

COMMENT ON TABLE doc.employee_replacements IS 'Информация о замещениях сотрудников';


--
-- Name: COLUMN employee_replacements.replaceable_id; Type: COMMENT; Schema: doc; Owner: developers
--

COMMENT ON COLUMN doc.employee_replacements.replaceable_id IS 'Ссылка на замещаемого сотрудника';


--
-- Name: COLUMN employee_replacements.deputy_id; Type: COMMENT; Schema: doc; Owner: developers
--

COMMENT ON COLUMN doc.employee_replacements.deputy_id IS 'Ссылка на замещающего сотрудника';


--
-- Name: COLUMN employee_replacements.replacement_period_start; Type: COMMENT; Schema: doc; Owner: developers
--

COMMENT ON COLUMN doc.employee_replacements.replacement_period_start IS 'Начало периода замещения (0 - замещение постоянное)';


--
-- Name: COLUMN employee_replacements.replacement_period_end; Type: COMMENT; Schema: doc; Owner: developers
--

COMMENT ON COLUMN doc.employee_replacements.replacement_period_end IS 'Конец периода замещения (0 - замещение постоянное)';


--
-- Name: employee_replacements_id_seq; Type: SEQUENCE; Schema: doc; Owner: developers
--

CREATE SEQUENCE doc.employee_replacements_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE doc.employee_replacements_id_seq OWNER TO developers;

--
-- Name: employee_replacements_id_seq; Type: SEQUENCE OWNED BY; Schema: doc; Owner: developers
--

ALTER SEQUENCE doc.employee_replacements_id_seq OWNED BY doc.employee_replacements.id;


--
-- Name: employee_work_groups; Type: TABLE; Schema: doc; Owner: developers
--

CREATE TABLE doc.employee_work_groups (
    id integer NOT NULL,
    name character varying,
    leader_id integer NOT NULL
);


ALTER TABLE doc.employee_work_groups OWNER TO developers;

--
-- Name: TABLE employee_work_groups; Type: COMMENT; Schema: doc; Owner: developers
--

COMMENT ON TABLE doc.employee_work_groups IS 'Рабочие группы сотрудников ЭДО';


--
-- Name: COLUMN employee_work_groups.name; Type: COMMENT; Schema: doc; Owner: developers
--

COMMENT ON COLUMN doc.employee_work_groups.name IS 'Наименование рабочей группы';


--
-- Name: COLUMN employee_work_groups.leader_id; Type: COMMENT; Schema: doc; Owner: developers
--

COMMENT ON COLUMN doc.employee_work_groups.leader_id IS 'Ссылка на лидера рабочей группы';


--
-- Name: employee_work_groups_id_seq; Type: SEQUENCE; Schema: doc; Owner: developers
--

CREATE SEQUENCE doc.employee_work_groups_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE doc.employee_work_groups_id_seq OWNER TO developers;

--
-- Name: employee_work_groups_id_seq; Type: SEQUENCE OWNED BY; Schema: doc; Owner: developers
--

ALTER SEQUENCE doc.employee_work_groups_id_seq OWNED BY doc.employee_work_groups.id;


--
-- Name: employees; Type: TABLE; Schema: doc; Owner: developers
--

CREATE TABLE doc.employees (
    id integer NOT NULL,
    id_for_search integer,
    department_id integer,
    short_full_name character varying,
    full_name character varying,
    speciality character varying,
    note character varying,
    personnel_number character varying,
    telephone_number character varying,
    changing_user character varying DEFAULT "session_user"(),
    changing_date timestamp without time zone DEFAULT now(),
    name_podr character varying,
    old_code character varying,
    prizn_lvs integer,
    cod_person integer,
    was_dismissed_ integer,
    was_dismissed boolean DEFAULT false,
    name character varying,
    surname character varying,
    patronymic character varying,
    leader_id integer,
    login character varying,
    spr_person_id integer,
    is_foreign boolean DEFAULT false NOT NULL,
    head_kindred_department_id integer,
    receiving_notifications_enabled boolean DEFAULT true,
    is_sd_user boolean DEFAULT false,
    leader_documents_notifications_receiving_enabled boolean DEFAULT false,
    leader_links doc.employee_link[],
    prev_position_id integer
);


ALTER TABLE doc.employees OWNER TO developers;

--
-- Name: TABLE employees; Type: COMMENT; Schema: doc; Owner: developers
--

COMMENT ON TABLE doc.employees IS 'Справочник сотрудников, имеющих доступ к функциональности системы документооборота';


--
-- Name: COLUMN employees.id; Type: COMMENT; Schema: doc; Owner: developers
--

COMMENT ON COLUMN doc.employees.id IS 'Индентификатор записи сотрудника из стороннего справочника';


--
-- Name: COLUMN employees.department_id; Type: COMMENT; Schema: doc; Owner: developers
--

COMMENT ON COLUMN doc.employees.department_id IS 'Ссылка на подразделение по коду, к которому принадлежит сотрудник';


--
-- Name: COLUMN employees.short_full_name; Type: COMMENT; Schema: doc; Owner: developers
--

COMMENT ON COLUMN doc.employees.short_full_name IS 'Краткое полное имя (фамилия + инициалы)';


--
-- Name: COLUMN employees.full_name; Type: COMMENT; Schema: doc; Owner: developers
--

COMMENT ON COLUMN doc.employees.full_name IS 'Полное имя';


--
-- Name: COLUMN employees.speciality; Type: COMMENT; Schema: doc; Owner: developers
--

COMMENT ON COLUMN doc.employees.speciality IS 'Должность';


--
-- Name: COLUMN employees.note; Type: COMMENT; Schema: doc; Owner: developers
--

COMMENT ON COLUMN doc.employees.note IS 'Примечания';


--
-- Name: COLUMN employees.personnel_number; Type: COMMENT; Schema: doc; Owner: developers
--

COMMENT ON COLUMN doc.employees.personnel_number IS 'Табельный номер';


--
-- Name: COLUMN employees.changing_user; Type: COMMENT; Schema: doc; Owner: developers
--

COMMENT ON COLUMN doc.employees.changing_user IS 'Пользователь, внёсший изменения';


--
-- Name: COLUMN employees.changing_date; Type: COMMENT; Schema: doc; Owner: developers
--

COMMENT ON COLUMN doc.employees.changing_date IS 'Дата внесения изменений';


--
-- Name: COLUMN employees.was_dismissed_; Type: COMMENT; Schema: doc; Owner: developers
--

COMMENT ON COLUMN doc.employees.was_dismissed_ IS 'Был ли уволен';


--
-- Name: COLUMN employees.was_dismissed; Type: COMMENT; Schema: doc; Owner: developers
--

COMMENT ON COLUMN doc.employees.was_dismissed IS 'Был ли уволен';


--
-- Name: COLUMN employees.spr_person_id; Type: COMMENT; Schema: doc; Owner: developers
--

COMMENT ON COLUMN doc.employees.spr_person_id IS 'Ссылка на соответствующую запись в exchange.spr_person';


--
-- Name: COLUMN employees.is_foreign; Type: COMMENT; Schema: doc; Owner: developers
--

COMMENT ON COLUMN doc.employees.is_foreign IS 'Сотрудник является внешним по отношению к ЭДО, т.е. он не имеет возможности использовать ЭДО по каким-либо причинам';


--
-- Name: COLUMN employees.is_sd_user; Type: COMMENT; Schema: doc; Owner: developers
--

COMMENT ON COLUMN doc.employees.is_sd_user IS 'Пользователь SD программы';


--
-- Name: employees_employee_work_groups; Type: TABLE; Schema: doc; Owner: developers
--

CREATE TABLE doc.employees_employee_work_groups (
    id integer NOT NULL,
    employee_id integer NOT NULL,
    work_group_id integer NOT NULL
);


ALTER TABLE doc.employees_employee_work_groups OWNER TO developers;

--
-- Name: TABLE employees_employee_work_groups; Type: COMMENT; Schema: doc; Owner: developers
--

COMMENT ON TABLE doc.employees_employee_work_groups IS 'Таблица соответствий сотрудников рабочим группам';


--
-- Name: employees_employee_work_groups_id_seq; Type: SEQUENCE; Schema: doc; Owner: developers
--

CREATE SEQUENCE doc.employees_employee_work_groups_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE doc.employees_employee_work_groups_id_seq OWNER TO developers;

--
-- Name: employees_employee_work_groups_id_seq; Type: SEQUENCE OWNED BY; Schema: doc; Owner: developers
--

ALTER SEQUENCE doc.employees_employee_work_groups_id_seq OWNED BY doc.employees_employee_work_groups.id;


--
-- Name: employees_outside_id_seq; Type: SEQUENCE; Schema: doc; Owner: developers
--

CREATE SEQUENCE doc.employees_outside_id_seq
    START WITH 1354
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE doc.employees_outside_id_seq OWNER TO developers;

--
-- Name: employees_outside_id_seq; Type: SEQUENCE OWNED BY; Schema: doc; Owner: developers
--

ALTER SEQUENCE doc.employees_outside_id_seq OWNED BY doc.employees.id;


--
-- Name: employees_roles; Type: TABLE; Schema: doc; Owner: developers
--

CREATE TABLE doc.employees_roles (
    employee_id integer NOT NULL,
    role_id integer NOT NULL
);


ALTER TABLE doc.employees_roles OWNER TO developers;

--
-- Name: TABLE employees_roles; Type: COMMENT; Schema: doc; Owner: developers
--

COMMENT ON TABLE doc.employees_roles IS 'Таблица соответствий сотрудников должностным ролям';


--
-- Name: COLUMN employees_roles.employee_id; Type: COMMENT; Schema: doc; Owner: developers
--

COMMENT ON COLUMN doc.employees_roles.employee_id IS 'Ссылка на сотрудника';


--
-- Name: COLUMN employees_roles.role_id; Type: COMMENT; Schema: doc; Owner: developers
--

COMMENT ON COLUMN doc.employees_roles.role_id IS 'Ссылка на должностную роль';


--
-- Name: employees_system_roles; Type: TABLE; Schema: doc; Owner: developers
--

CREATE TABLE doc.employees_system_roles (
    employee_id integer NOT NULL,
    system_role_id integer NOT NULL
);


ALTER TABLE doc.employees_system_roles OWNER TO developers;

--
-- Name: TABLE employees_system_roles; Type: COMMENT; Schema: doc; Owner: developers
--

COMMENT ON TABLE doc.employees_system_roles IS 'Таблица ролей администраторов системы';


--
-- Name: looked_document_charges; Type: TABLE; Schema: doc; Owner: developers
--

CREATE TABLE doc.looked_document_charges (
    charge_id bigint NOT NULL,
    employee_id integer NOT NULL,
    look_date timestamp without time zone DEFAULT now()
);


ALTER TABLE doc.looked_document_charges OWNER TO developers;

--
-- Name: TABLE looked_document_charges; Type: COMMENT; Schema: doc; Owner: developers
--

COMMENT ON TABLE doc.looked_document_charges IS 'Таблица просмотра поручений по документам (кроме служебных записок)';


--
-- Name: COLUMN looked_document_charges.charge_id; Type: COMMENT; Schema: doc; Owner: developers
--

COMMENT ON COLUMN doc.looked_document_charges.charge_id IS 'Ссылка на просмотренное поручение';


--
-- Name: COLUMN looked_document_charges.employee_id; Type: COMMENT; Schema: doc; Owner: developers
--

COMMENT ON COLUMN doc.looked_document_charges.employee_id IS 'Ссылка на просмотревшего поручение сотрудника';


--
-- Name: COLUMN looked_document_charges.look_date; Type: COMMENT; Schema: doc; Owner: developers
--

COMMENT ON COLUMN doc.looked_document_charges.look_date IS 'Дата и время просмотра поручения';


--
-- Name: looked_documents; Type: TABLE; Schema: doc; Owner: developers
--

CREATE TABLE doc.looked_documents (
    document_id bigint NOT NULL,
    looked_employee_id integer NOT NULL,
    look_date timestamp without time zone DEFAULT now(),
    id integer NOT NULL
);


ALTER TABLE doc.looked_documents OWNER TO developers;

--
-- Name: TABLE looked_documents; Type: COMMENT; Schema: doc; Owner: developers
--

COMMENT ON TABLE doc.looked_documents IS 'Просмотренные документы';


--
-- Name: COLUMN looked_documents.document_id; Type: COMMENT; Schema: doc; Owner: developers
--

COMMENT ON COLUMN doc.looked_documents.document_id IS 'Ссылка на документ, полученная из стороннего справочника';


--
-- Name: COLUMN looked_documents.looked_employee_id; Type: COMMENT; Schema: doc; Owner: developers
--

COMMENT ON COLUMN doc.looked_documents.looked_employee_id IS 'Ссылка на просмотревшего документ сотрудника, полученная из стороннего справочника';


--
-- Name: COLUMN looked_documents.look_date; Type: COMMENT; Schema: doc; Owner: developers
--

COMMENT ON COLUMN doc.looked_documents.look_date IS 'Дата просмотра документа';


--
-- Name: looked_documents_id_seq; Type: SEQUENCE; Schema: doc; Owner: developers
--

CREATE SEQUENCE doc.looked_documents_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE doc.looked_documents_id_seq OWNER TO developers;

--
-- Name: looked_documents_id_seq; Type: SEQUENCE OWNED BY; Schema: doc; Owner: developers
--

ALTER SEQUENCE doc.looked_documents_id_seq OWNED BY doc.looked_documents.id;


--
-- Name: looked_personnel_orders; Type: TABLE; Schema: doc; Owner: developers
--

CREATE TABLE doc.looked_personnel_orders (
    id integer NOT NULL,
    document_id integer NOT NULL,
    looked_employee_id integer NOT NULL,
    look_date timestamp without time zone DEFAULT now()
);


ALTER TABLE doc.looked_personnel_orders OWNER TO developers;

--
-- Name: TABLE looked_personnel_orders; Type: COMMENT; Schema: doc; Owner: developers
--

COMMENT ON TABLE doc.looked_personnel_orders IS 'Просмотренные кадровые приказы';


--
-- Name: COLUMN looked_personnel_orders.document_id; Type: COMMENT; Schema: doc; Owner: developers
--

COMMENT ON COLUMN doc.looked_personnel_orders.document_id IS 'Ссылка на просмотренный кадровый приказ';


--
-- Name: COLUMN looked_personnel_orders.looked_employee_id; Type: COMMENT; Schema: doc; Owner: developers
--

COMMENT ON COLUMN doc.looked_personnel_orders.looked_employee_id IS 'Ссылка на сотрудника, просмотревшего кадровый приказ';


--
-- Name: COLUMN looked_personnel_orders.look_date; Type: COMMENT; Schema: doc; Owner: developers
--

COMMENT ON COLUMN doc.looked_personnel_orders.look_date IS 'Дата просмотра кадрового приказа';


--
-- Name: looked_personnel_orders_id_seq; Type: SEQUENCE; Schema: doc; Owner: developers
--

CREATE SEQUENCE doc.looked_personnel_orders_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE doc.looked_personnel_orders_id_seq OWNER TO developers;

--
-- Name: looked_personnel_orders_id_seq; Type: SEQUENCE OWNED BY; Schema: doc; Owner: developers
--

ALTER SEQUENCE doc.looked_personnel_orders_id_seq OWNED BY doc.looked_personnel_orders.id;


--
-- Name: looked_service_note_charges; Type: TABLE; Schema: doc; Owner: developers
--

CREATE TABLE doc.looked_service_note_charges (
    charge_id bigint NOT NULL,
    employee_id integer NOT NULL,
    look_date timestamp without time zone DEFAULT now()
);


ALTER TABLE doc.looked_service_note_charges OWNER TO developers;

--
-- Name: TABLE looked_service_note_charges; Type: COMMENT; Schema: doc; Owner: developers
--

COMMENT ON TABLE doc.looked_service_note_charges IS 'Таблица просмотра поручений по служебным запискам';


--
-- Name: COLUMN looked_service_note_charges.charge_id; Type: COMMENT; Schema: doc; Owner: developers
--

COMMENT ON COLUMN doc.looked_service_note_charges.charge_id IS 'Ссылка на просмотренное поручение';


--
-- Name: COLUMN looked_service_note_charges.employee_id; Type: COMMENT; Schema: doc; Owner: developers
--

COMMENT ON COLUMN doc.looked_service_note_charges.employee_id IS 'Ссылка на просмотревшего поручение сотрудника';


--
-- Name: COLUMN looked_service_note_charges.look_date; Type: COMMENT; Schema: doc; Owner: developers
--

COMMENT ON COLUMN doc.looked_service_note_charges.look_date IS 'Дата и время просмотра поручения';


--
-- Name: looked_service_notes; Type: TABLE; Schema: doc; Owner: developers
--

CREATE TABLE doc.looked_service_notes (
    id integer NOT NULL,
    document_id bigint NOT NULL,
    looked_employee_id integer NOT NULL,
    look_date timestamp without time zone DEFAULT now()
);


ALTER TABLE doc.looked_service_notes OWNER TO developers;

--
-- Name: TABLE looked_service_notes; Type: COMMENT; Schema: doc; Owner: developers
--

COMMENT ON TABLE doc.looked_service_notes IS 'Просмотренные служебные записки';


--
-- Name: COLUMN looked_service_notes.document_id; Type: COMMENT; Schema: doc; Owner: developers
--

COMMENT ON COLUMN doc.looked_service_notes.document_id IS 'Ссылка на просмотренную служебную записку, полученная из стороннего справочника';


--
-- Name: COLUMN looked_service_notes.looked_employee_id; Type: COMMENT; Schema: doc; Owner: developers
--

COMMENT ON COLUMN doc.looked_service_notes.looked_employee_id IS 'Ссылка на просмотревшего служебную записку сотрудника, полученная из стороннего справочника';


--
-- Name: COLUMN looked_service_notes.look_date; Type: COMMENT; Schema: doc; Owner: developers
--

COMMENT ON COLUMN doc.looked_service_notes.look_date IS 'Дата просмотра служебной записки';


--
-- Name: looked_service_notes_id_seq; Type: SEQUENCE; Schema: doc; Owner: developers
--

CREATE SEQUENCE doc.looked_service_notes_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE doc.looked_service_notes_id_seq OWNER TO developers;

--
-- Name: looked_service_notes_id_seq; Type: SEQUENCE OWNED BY; Schema: doc; Owner: developers
--

ALTER SEQUENCE doc.looked_service_notes_id_seq OWNED BY doc.looked_service_notes.id;


--
-- Name: personnel_order_approvings; Type: TABLE; Schema: doc; Owner: developers
--

CREATE TABLE doc.personnel_order_approvings (
    id integer NOT NULL,
    document_id integer NOT NULL,
    performing_date timestamp without time zone,
    performing_result_id integer NOT NULL,
    approver_id integer NOT NULL,
    actual_performed_employee_id integer,
    note character varying(8192),
    cycle_number integer,
    inserting_date timestamp without time zone DEFAULT now(),
    inserted_user character varying DEFAULT "session_user"()
);


ALTER TABLE doc.personnel_order_approvings OWNER TO developers;

--
-- Name: TABLE personnel_order_approvings; Type: COMMENT; Schema: doc; Owner: developers
--

COMMENT ON TABLE doc.personnel_order_approvings IS 'Согласования кадровых приказов';


--
-- Name: COLUMN personnel_order_approvings.document_id; Type: COMMENT; Schema: doc; Owner: developers
--

COMMENT ON COLUMN doc.personnel_order_approvings.document_id IS 'Ссылка на документ';


--
-- Name: COLUMN personnel_order_approvings.performing_date; Type: COMMENT; Schema: doc; Owner: developers
--

COMMENT ON COLUMN doc.personnel_order_approvings.performing_date IS 'Дата принятия участия в согласовании документа сотрудником actual_approved_employee_id';


--
-- Name: COLUMN personnel_order_approvings.performing_result_id; Type: COMMENT; Schema: doc; Owner: developers
--

COMMENT ON COLUMN doc.personnel_order_approvings.performing_result_id IS 'id результата согласования документа (согласовано, не согласовано)';


--
-- Name: COLUMN personnel_order_approvings.approver_id; Type: COMMENT; Schema: doc; Owner: developers
--

COMMENT ON COLUMN doc.personnel_order_approvings.approver_id IS 'id назначенного согласованта для документа';


--
-- Name: COLUMN personnel_order_approvings.actual_performed_employee_id; Type: COMMENT; Schema: doc; Owner: developers
--

COMMENT ON COLUMN doc.personnel_order_approvings.actual_performed_employee_id IS 'id фактически принявшего участие в согласовании документа сотрудника';


--
-- Name: COLUMN personnel_order_approvings.note; Type: COMMENT; Schema: doc; Owner: developers
--

COMMENT ON COLUMN doc.personnel_order_approvings.note IS 'примечания согласованта';


--
-- Name: COLUMN personnel_order_approvings.cycle_number; Type: COMMENT; Schema: doc; Owner: developers
--

COMMENT ON COLUMN doc.personnel_order_approvings.cycle_number IS 'номер цикла согласования документа. Данное поля заполняется в случае завершения цикла согласования. Отсутствие значения в данном поле свидетельствует о том, что согласование ещё не завершено.';


--
-- Name: personnel_order_approvings_id_seq; Type: SEQUENCE; Schema: doc; Owner: developers
--

CREATE SEQUENCE doc.personnel_order_approvings_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE doc.personnel_order_approvings_id_seq OWNER TO developers;

--
-- Name: personnel_order_approvings_id_seq; Type: SEQUENCE OWNED BY; Schema: doc; Owner: developers
--

ALTER SEQUENCE doc.personnel_order_approvings_id_seq OWNED BY doc.personnel_order_approvings.id;


--
-- Name: personnel_order_charges; Type: TABLE; Schema: doc; Owner: developers
--

CREATE TABLE doc.personnel_order_charges (
    id integer NOT NULL,
    document_id integer NOT NULL,
    performing_date timestamp without time zone,
    comment character varying,
    inserting_date timestamp without time zone DEFAULT now(),
    inserted_user character varying DEFAULT "session_user"(),
    top_level_charge_sheet_id integer,
    charge character varying,
    performer_id integer NOT NULL,
    actual_performer_id integer,
    issuer_id integer,
    charge_period_start timestamp without time zone,
    charge_period_end timestamp without time zone,
    head_charge_sheet_id integer,
    is_for_acquaitance boolean DEFAULT false,
    issuing_datetime timestamp without time zone,
    total_charge_count integer,
    performed_charge_count integer,
    subordinate_charge_count integer,
    subordinate_performed_charge_count integer,
    kind_id integer NOT NULL,
    document_kind_id integer
);


ALTER TABLE doc.personnel_order_charges OWNER TO developers;

--
-- Name: TABLE personnel_order_charges; Type: COMMENT; Schema: doc; Owner: developers
--

COMMENT ON TABLE doc.personnel_order_charges IS 'Поручения и листы поручений по кадровым приказам';


--
-- Name: COLUMN personnel_order_charges.document_id; Type: COMMENT; Schema: doc; Owner: developers
--

COMMENT ON COLUMN doc.personnel_order_charges.document_id IS 'Ссылка на кадровый приказ';


--
-- Name: COLUMN personnel_order_charges.performing_date; Type: COMMENT; Schema: doc; Owner: developers
--

COMMENT ON COLUMN doc.personnel_order_charges.performing_date IS 'Дата исполнения поручения';


--
-- Name: COLUMN personnel_order_charges.comment; Type: COMMENT; Schema: doc; Owner: developers
--

COMMENT ON COLUMN doc.personnel_order_charges.comment IS 'Комментарий к исполнению';


--
-- Name: COLUMN personnel_order_charges.inserting_date; Type: COMMENT; Schema: doc; Owner: developers
--

COMMENT ON COLUMN doc.personnel_order_charges.inserting_date IS 'Дата добавления записи';


--
-- Name: COLUMN personnel_order_charges.inserted_user; Type: COMMENT; Schema: doc; Owner: developers
--

COMMENT ON COLUMN doc.personnel_order_charges.inserted_user IS 'Пользователь, добавивший запись';


--
-- Name: COLUMN personnel_order_charges.top_level_charge_sheet_id; Type: COMMENT; Schema: doc; Owner: developers
--

COMMENT ON COLUMN doc.personnel_order_charges.top_level_charge_sheet_id IS 'Ссылка на вышестояющий лист поручения';


--
-- Name: COLUMN personnel_order_charges.charge; Type: COMMENT; Schema: doc; Owner: developers
--

COMMENT ON COLUMN doc.personnel_order_charges.charge IS 'Текст поручения (листа поручения)';


--
-- Name: COLUMN personnel_order_charges.performer_id; Type: COMMENT; Schema: doc; Owner: developers
--

COMMENT ON COLUMN doc.personnel_order_charges.performer_id IS 'Ссылка на исполнителя поручения (листа поручения)';


--
-- Name: COLUMN personnel_order_charges.actual_performer_id; Type: COMMENT; Schema: doc; Owner: developers
--

COMMENT ON COLUMN doc.personnel_order_charges.actual_performer_id IS 'Фактически исполнивший поручение (лист поручения) сотрудник';


--
-- Name: personnel_order_charges_id_seq; Type: SEQUENCE; Schema: doc; Owner: developers
--

CREATE SEQUENCE doc.personnel_order_charges_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE doc.personnel_order_charges_id_seq OWNER TO developers;

--
-- Name: personnel_order_charges_id_seq; Type: SEQUENCE OWNED BY; Schema: doc; Owner: developers
--

ALTER SEQUENCE doc.personnel_order_charges_id_seq OWNED BY doc.personnel_order_charges.id;


--
-- Name: personnel_order_control_groups; Type: TABLE; Schema: doc; Owner: developers
--

CREATE TABLE doc.personnel_order_control_groups (
    id integer NOT NULL,
    name character varying NOT NULL
);


ALTER TABLE doc.personnel_order_control_groups OWNER TO developers;

--
-- Name: TABLE personnel_order_control_groups; Type: COMMENT; Schema: doc; Owner: developers
--

COMMENT ON TABLE doc.personnel_order_control_groups IS 'Группы сотрудников, ответсвенные за контроль кадровых приказов';


--
-- Name: personnel_order_control_groups__employees; Type: TABLE; Schema: doc; Owner: developers
--

CREATE TABLE doc.personnel_order_control_groups__employees (
    id integer NOT NULL,
    control_group_id integer NOT NULL,
    employee_id integer NOT NULL
);


ALTER TABLE doc.personnel_order_control_groups__employees OWNER TO developers;

--
-- Name: TABLE personnel_order_control_groups__employees; Type: COMMENT; Schema: doc; Owner: developers
--

COMMENT ON TABLE doc.personnel_order_control_groups__employees IS 'Соответствия групп и сотрудников, ответственных за контроль кадровых приказов';


--
-- Name: personnel_order_control_groups__employees_id_seq; Type: SEQUENCE; Schema: doc; Owner: developers
--

CREATE SEQUENCE doc.personnel_order_control_groups__employees_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE doc.personnel_order_control_groups__employees_id_seq OWNER TO developers;

--
-- Name: personnel_order_control_groups__employees_id_seq; Type: SEQUENCE OWNED BY; Schema: doc; Owner: developers
--

ALTER SEQUENCE doc.personnel_order_control_groups__employees_id_seq OWNED BY doc.personnel_order_control_groups__employees.id;


--
-- Name: personnel_order_control_groups__sub_kinds; Type: TABLE; Schema: doc; Owner: developers
--

CREATE TABLE doc.personnel_order_control_groups__sub_kinds (
    id integer NOT NULL,
    control_group_id integer NOT NULL,
    personnel_order_sub_kind_id integer NOT NULL
);


ALTER TABLE doc.personnel_order_control_groups__sub_kinds OWNER TO developers;

--
-- Name: TABLE personnel_order_control_groups__sub_kinds; Type: COMMENT; Schema: doc; Owner: developers
--

COMMENT ON TABLE doc.personnel_order_control_groups__sub_kinds IS 'Соответствия групп сотрудников, ответственных за контроль кадровых приказов, и подтипов кадровых приказов';


--
-- Name: personnel_order_control_groups__sub_kinds_id_seq; Type: SEQUENCE; Schema: doc; Owner: developers
--

CREATE SEQUENCE doc.personnel_order_control_groups__sub_kinds_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE doc.personnel_order_control_groups__sub_kinds_id_seq OWNER TO developers;

--
-- Name: personnel_order_control_groups__sub_kinds_id_seq; Type: SEQUENCE OWNED BY; Schema: doc; Owner: developers
--

ALTER SEQUENCE doc.personnel_order_control_groups__sub_kinds_id_seq OWNED BY doc.personnel_order_control_groups__sub_kinds.id;


--
-- Name: personnel_order_control_groups_id_seq; Type: SEQUENCE; Schema: doc; Owner: developers
--

CREATE SEQUENCE doc.personnel_order_control_groups_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE doc.personnel_order_control_groups_id_seq OWNER TO developers;

--
-- Name: personnel_order_control_groups_id_seq; Type: SEQUENCE OWNED BY; Schema: doc; Owner: developers
--

ALTER SEQUENCE doc.personnel_order_control_groups_id_seq OWNED BY doc.personnel_order_control_groups.id;


--
-- Name: personnel_order_creating_access_employees; Type: TABLE; Schema: doc; Owner: developers
--

CREATE TABLE doc.personnel_order_creating_access_employees (
    employee_id integer NOT NULL
);


ALTER TABLE doc.personnel_order_creating_access_employees OWNER TO developers;

--
-- Name: TABLE personnel_order_creating_access_employees; Type: COMMENT; Schema: doc; Owner: developers
--

COMMENT ON TABLE doc.personnel_order_creating_access_employees IS 'Сотрудники, которым доступна возможность создания кадровых приказов';


--
-- Name: personnel_order_file_metadata; Type: TABLE; Schema: doc; Owner: developers
--

CREATE TABLE doc.personnel_order_file_metadata (
    id integer NOT NULL,
    document_id integer NOT NULL,
    file_path character varying,
    file_name character varying,
    inserting_date timestamp without time zone DEFAULT now(),
    inserted_user character varying DEFAULT "session_user"()
);


ALTER TABLE doc.personnel_order_file_metadata OWNER TO developers;

--
-- Name: TABLE personnel_order_file_metadata; Type: COMMENT; Schema: doc; Owner: developers
--

COMMENT ON TABLE doc.personnel_order_file_metadata IS 'Метаданные файлов, прилагаемых к кадровым приказам';


--
-- Name: COLUMN personnel_order_file_metadata.document_id; Type: COMMENT; Schema: doc; Owner: developers
--

COMMENT ON COLUMN doc.personnel_order_file_metadata.document_id IS 'Ссылка на кадровый приказ';


--
-- Name: COLUMN personnel_order_file_metadata.file_path; Type: COMMENT; Schema: doc; Owner: developers
--

COMMENT ON COLUMN doc.personnel_order_file_metadata.file_path IS 'Путь к файлу служебной записки в архиве';


--
-- Name: COLUMN personnel_order_file_metadata.file_name; Type: COMMENT; Schema: doc; Owner: developers
--

COMMENT ON COLUMN doc.personnel_order_file_metadata.file_name IS 'Название файла служебной записки';


--
-- Name: COLUMN personnel_order_file_metadata.inserting_date; Type: COMMENT; Schema: doc; Owner: developers
--

COMMENT ON COLUMN doc.personnel_order_file_metadata.inserting_date IS 'Дата добавления записи';


--
-- Name: COLUMN personnel_order_file_metadata.inserted_user; Type: COMMENT; Schema: doc; Owner: developers
--

COMMENT ON COLUMN doc.personnel_order_file_metadata.inserted_user IS 'Пользователь, добавивший запись';


--
-- Name: personnel_order_file_metadata_id_seq; Type: SEQUENCE; Schema: doc; Owner: developers
--

CREATE SEQUENCE doc.personnel_order_file_metadata_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE doc.personnel_order_file_metadata_id_seq OWNER TO developers;

--
-- Name: personnel_order_file_metadata_id_seq; Type: SEQUENCE OWNED BY; Schema: doc; Owner: developers
--

ALTER SEQUENCE doc.personnel_order_file_metadata_id_seq OWNED BY doc.personnel_order_file_metadata.id;


--
-- Name: personnel_order_links; Type: TABLE; Schema: doc; Owner: developers
--

CREATE TABLE doc.personnel_order_links (
    id integer NOT NULL,
    document_id integer NOT NULL,
    related_document_id integer,
    related_document_type_id integer NOT NULL,
    inserting_date timestamp without time zone DEFAULT now(),
    inserted_user character varying DEFAULT "session_user"()
);


ALTER TABLE doc.personnel_order_links OWNER TO developers;

--
-- Name: TABLE personnel_order_links; Type: COMMENT; Schema: doc; Owner: developers
--

COMMENT ON TABLE doc.personnel_order_links IS 'Связи кадровых приказов с другими видами документов';


--
-- Name: COLUMN personnel_order_links.document_id; Type: COMMENT; Schema: doc; Owner: developers
--

COMMENT ON COLUMN doc.personnel_order_links.document_id IS 'Ссылка на кадровый приказ';


--
-- Name: COLUMN personnel_order_links.related_document_id; Type: COMMENT; Schema: doc; Owner: developers
--

COMMENT ON COLUMN doc.personnel_order_links.related_document_id IS 'Ссылка на связанный документ';


--
-- Name: COLUMN personnel_order_links.related_document_type_id; Type: COMMENT; Schema: doc; Owner: developers
--

COMMENT ON COLUMN doc.personnel_order_links.related_document_type_id IS 'Ссылка на тип связанного документа';


--
-- Name: personnel_order_links_id_seq; Type: SEQUENCE; Schema: doc; Owner: developers
--

CREATE SEQUENCE doc.personnel_order_links_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE doc.personnel_order_links_id_seq OWNER TO developers;

--
-- Name: personnel_order_links_id_seq; Type: SEQUENCE OWNED BY; Schema: doc; Owner: developers
--

ALTER SEQUENCE doc.personnel_order_links_id_seq OWNED BY doc.personnel_order_links.id;


--
-- Name: personnel_order_signers; Type: TABLE; Schema: doc; Owner: developers
--

CREATE TABLE doc.personnel_order_signers (
    signer_id integer NOT NULL,
    is_default boolean DEFAULT false NOT NULL
);


ALTER TABLE doc.personnel_order_signers OWNER TO developers;

--
-- Name: TABLE personnel_order_signers; Type: COMMENT; Schema: doc; Owner: developers
--

COMMENT ON TABLE doc.personnel_order_signers IS 'Подписанты кадровых приказов';


--
-- Name: COLUMN personnel_order_signers.signer_id; Type: COMMENT; Schema: doc; Owner: developers
--

COMMENT ON COLUMN doc.personnel_order_signers.signer_id IS 'Ссылка на имеющего возможность подписи кадровых приказов сотрудника';


--
-- Name: personnel_order_signings; Type: TABLE; Schema: doc; Owner: developers
--

CREATE TABLE doc.personnel_order_signings (
    id integer NOT NULL,
    document_id bigint NOT NULL,
    signer_id bigint NOT NULL,
    actual_signed_id bigint,
    signing_date timestamp without time zone
);


ALTER TABLE doc.personnel_order_signings OWNER TO developers;

--
-- Name: personnel_order_signings_id_seq; Type: SEQUENCE; Schema: doc; Owner: developers
--

CREATE SEQUENCE doc.personnel_order_signings_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE doc.personnel_order_signings_id_seq OWNER TO developers;

--
-- Name: personnel_order_signings_id_seq; Type: SEQUENCE OWNED BY; Schema: doc; Owner: developers
--

ALTER SEQUENCE doc.personnel_order_signings_id_seq OWNED BY doc.personnel_order_signings.id;


--
-- Name: personnel_order_sub_kinds; Type: TABLE; Schema: doc; Owner: developers
--

CREATE TABLE doc.personnel_order_sub_kinds (
    id integer NOT NULL,
    name character varying NOT NULL
);


ALTER TABLE doc.personnel_order_sub_kinds OWNER TO developers;

--
-- Name: TABLE personnel_order_sub_kinds; Type: COMMENT; Schema: doc; Owner: developers
--

COMMENT ON TABLE doc.personnel_order_sub_kinds IS 'Подтипы кадрового приказа';


--
-- Name: COLUMN personnel_order_sub_kinds.name; Type: COMMENT; Schema: doc; Owner: developers
--

COMMENT ON COLUMN doc.personnel_order_sub_kinds.name IS 'Наименование подтипа';


--
-- Name: personnel_order_sub_kinds__approvers; Type: TABLE; Schema: doc; Owner: developers
--

CREATE TABLE doc.personnel_order_sub_kinds__approvers (
    id integer NOT NULL,
    personnel_order_sub_kind_id integer NOT NULL,
    approver_id integer NOT NULL
);


ALTER TABLE doc.personnel_order_sub_kinds__approvers OWNER TO developers;

--
-- Name: TABLE personnel_order_sub_kinds__approvers; Type: COMMENT; Schema: doc; Owner: developers
--

COMMENT ON TABLE doc.personnel_order_sub_kinds__approvers IS 'Соответствия подвидов кадрового приказа сотрудникам, 
которые по умолчанию являются согласовантами конкретных подвидов';


--
-- Name: personnel_order_sub_kinds__approvers_id_seq; Type: SEQUENCE; Schema: doc; Owner: developers
--

CREATE SEQUENCE doc.personnel_order_sub_kinds__approvers_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE doc.personnel_order_sub_kinds__approvers_id_seq OWNER TO developers;

--
-- Name: personnel_order_sub_kinds__approvers_id_seq; Type: SEQUENCE OWNED BY; Schema: doc; Owner: developers
--

ALTER SEQUENCE doc.personnel_order_sub_kinds__approvers_id_seq OWNED BY doc.personnel_order_sub_kinds__approvers.id;


--
-- Name: personnel_order_sub_kinds_id_seq; Type: SEQUENCE; Schema: doc; Owner: developers
--

CREATE SEQUENCE doc.personnel_order_sub_kinds_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE doc.personnel_order_sub_kinds_id_seq OWNER TO developers;

--
-- Name: personnel_order_sub_kinds_id_seq; Type: SEQUENCE OWNED BY; Schema: doc; Owner: developers
--

ALTER SEQUENCE doc.personnel_order_sub_kinds_id_seq OWNED BY doc.personnel_order_sub_kinds.id;


--
-- Name: service_notes_id_seq; Type: SEQUENCE; Schema: doc; Owner: developers
--

CREATE SEQUENCE doc.service_notes_id_seq
    START WITH 84
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE doc.service_notes_id_seq OWNER TO developers;

--
-- Name: personnel_orders; Type: TABLE; Schema: doc; Owner: developers
--

CREATE TABLE doc.personnel_orders (
    id integer DEFAULT nextval('doc.service_notes_id_seq'::regclass) NOT NULL,
    type_id integer NOT NULL,
    sub_type_id integer NOT NULL,
    name character varying NOT NULL,
    document_number character varying,
    document_date timestamp without time zone,
    creation_date timestamp without time zone NOT NULL,
    note character varying,
    current_work_cycle_stage_id integer DEFAULT 1,
    content character varying(8192),
    inserting_date timestamp without time zone DEFAULT now(),
    inserted_user character varying DEFAULT "session_user"(),
    author_id integer NOT NULL,
    performer_id integer NOT NULL,
    is_sent_to_signing boolean,
    product_code character varying,
    receiving_department_names character varying,
    applications_exists boolean DEFAULT false,
    full_name character varying
);


ALTER TABLE doc.personnel_orders OWNER TO developers;

--
-- Name: TABLE personnel_orders; Type: COMMENT; Schema: doc; Owner: developers
--

COMMENT ON TABLE doc.personnel_orders IS 'Кадровые приказы';


--
-- Name: COLUMN personnel_orders.id; Type: COMMENT; Schema: doc; Owner: developers
--

COMMENT ON COLUMN doc.personnel_orders.id IS 'Идентификатор записи';


--
-- Name: COLUMN personnel_orders.type_id; Type: COMMENT; Schema: doc; Owner: developers
--

COMMENT ON COLUMN doc.personnel_orders.type_id IS 'Ссылка на общий тип';


--
-- Name: COLUMN personnel_orders.sub_type_id; Type: COMMENT; Schema: doc; Owner: developers
--

COMMENT ON COLUMN doc.personnel_orders.sub_type_id IS 'Ссылка на подтип кадрового приказа';


--
-- Name: COLUMN personnel_orders.name; Type: COMMENT; Schema: doc; Owner: developers
--

COMMENT ON COLUMN doc.personnel_orders.name IS 'Название';


--
-- Name: COLUMN personnel_orders.document_number; Type: COMMENT; Schema: doc; Owner: developers
--

COMMENT ON COLUMN doc.personnel_orders.document_number IS 'Номер';


--
-- Name: COLUMN personnel_orders.document_date; Type: COMMENT; Schema: doc; Owner: developers
--

COMMENT ON COLUMN doc.personnel_orders.document_date IS 'Дата документа';


--
-- Name: COLUMN personnel_orders.creation_date; Type: COMMENT; Schema: doc; Owner: developers
--

COMMENT ON COLUMN doc.personnel_orders.creation_date IS 'Дата создания';


--
-- Name: COLUMN personnel_orders.note; Type: COMMENT; Schema: doc; Owner: developers
--

COMMENT ON COLUMN doc.personnel_orders.note IS 'Примечания';


--
-- Name: COLUMN personnel_orders.current_work_cycle_stage_id; Type: COMMENT; Schema: doc; Owner: developers
--

COMMENT ON COLUMN doc.personnel_orders.current_work_cycle_stage_id IS 'Ссылка на текущую стадию жизненного цикла документа';


--
-- Name: COLUMN personnel_orders.content; Type: COMMENT; Schema: doc; Owner: developers
--

COMMENT ON COLUMN doc.personnel_orders.content IS 'Содержимое';


--
-- Name: COLUMN personnel_orders.inserting_date; Type: COMMENT; Schema: doc; Owner: developers
--

COMMENT ON COLUMN doc.personnel_orders.inserting_date IS 'Дата добавления записи';


--
-- Name: COLUMN personnel_orders.inserted_user; Type: COMMENT; Schema: doc; Owner: developers
--

COMMENT ON COLUMN doc.personnel_orders.inserted_user IS 'Пользователь, добавивший запись';


--
-- Name: COLUMN personnel_orders.performer_id; Type: COMMENT; Schema: doc; Owner: developers
--

COMMENT ON COLUMN doc.personnel_orders.performer_id IS 'Ссылка на ответственного за данный документ';


--
-- Name: plant_structure_access_employees; Type: TABLE; Schema: doc; Owner: developers
--

CREATE TABLE doc.plant_structure_access_employees (
    id integer NOT NULL,
    employee_id integer NOT NULL
);


ALTER TABLE doc.plant_structure_access_employees OWNER TO developers;

--
-- Name: plant_structure_access_employees_id_seq; Type: SEQUENCE; Schema: doc; Owner: developers
--

CREATE SEQUENCE doc.plant_structure_access_employees_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE doc.plant_structure_access_employees_id_seq OWNER TO developers;

--
-- Name: plant_structure_access_employees_id_seq; Type: SEQUENCE OWNED BY; Schema: doc; Owner: developers
--

ALTER SEQUENCE doc.plant_structure_access_employees_id_seq OWNED BY doc.plant_structure_access_employees.id;


--
-- Name: res_requests_sended_messages; Type: TABLE; Schema: doc; Owner: developers
--

CREATE TABLE doc.res_requests_sended_messages (
    request_id integer,
    email character varying,
    datei timestamp without time zone DEFAULT now()
);


ALTER TABLE doc.res_requests_sended_messages OWNER TO developers;

--
-- Name: TABLE res_requests_sended_messages; Type: COMMENT; Schema: doc; Owner: developers
--

COMMENT ON TABLE doc.res_requests_sended_messages IS 'Список отправленных сообщений по заявкам на ресурсы для избежания дублирования писем';


--
-- Name: role_rights; Type: TABLE; Schema: doc; Owner: developers
--

CREATE TABLE doc.role_rights (
    id integer NOT NULL,
    name character varying NOT NULL,
    description character varying NOT NULL
);


ALTER TABLE doc.role_rights OWNER TO developers;

--
-- Name: TABLE role_rights; Type: COMMENT; Schema: doc; Owner: developers
--

COMMENT ON TABLE doc.role_rights IS 'Набор прав доступа, единый для каждой должностной роли';


--
-- Name: COLUMN role_rights.name; Type: COMMENT; Schema: doc; Owner: developers
--

COMMENT ON COLUMN doc.role_rights.name IS 'Наименование права доступа (для прикладных операций)';


--
-- Name: COLUMN role_rights.description; Type: COMMENT; Schema: doc; Owner: developers
--

COMMENT ON COLUMN doc.role_rights.description IS 'Описание права доступа (отображаемое наименование для пользователей)';


--
-- Name: role_rights_id_seq; Type: SEQUENCE; Schema: doc; Owner: developers
--

CREATE SEQUENCE doc.role_rights_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE doc.role_rights_id_seq OWNER TO developers;

--
-- Name: role_rights_id_seq; Type: SEQUENCE OWNED BY; Schema: doc; Owner: developers
--

ALTER SEQUENCE doc.role_rights_id_seq OWNED BY doc.role_rights.id;


--
-- Name: roles; Type: TABLE; Schema: doc; Owner: developers
--

CREATE TABLE doc.roles (
    id integer NOT NULL,
    name character varying NOT NULL,
    description character varying NOT NULL
);


ALTER TABLE doc.roles OWNER TO developers;

--
-- Name: TABLE roles; Type: COMMENT; Schema: doc; Owner: developers
--

COMMENT ON TABLE doc.roles IS 'Должностные роли';


--
-- Name: COLUMN roles.name; Type: COMMENT; Schema: doc; Owner: developers
--

COMMENT ON COLUMN doc.roles.name IS 'Название роли (для прикладных операций)';


--
-- Name: COLUMN roles.description; Type: COMMENT; Schema: doc; Owner: developers
--

COMMENT ON COLUMN doc.roles.description IS 'Описание роли (отображаемое название роли)';


--
-- Name: roles_id_seq; Type: SEQUENCE; Schema: doc; Owner: developers
--

CREATE SEQUENCE doc.roles_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE doc.roles_id_seq OWNER TO developers;

--
-- Name: roles_id_seq; Type: SEQUENCE OWNED BY; Schema: doc; Owner: developers
--

ALTER SEQUENCE doc.roles_id_seq OWNED BY doc.roles.id;


--
-- Name: roles_role_rights; Type: TABLE; Schema: doc; Owner: developers
--

CREATE TABLE doc.roles_role_rights (
    role_id integer NOT NULL,
    role_right_id integer NOT NULL,
    is_allowed boolean
);


ALTER TABLE doc.roles_role_rights OWNER TO developers;

--
-- Name: TABLE roles_role_rights; Type: COMMENT; Schema: doc; Owner: developers
--

COMMENT ON TABLE doc.roles_role_rights IS 'Таблица соответствий должностных ролей правам доступа';


--
-- Name: COLUMN roles_role_rights.role_id; Type: COMMENT; Schema: doc; Owner: developers
--

COMMENT ON COLUMN doc.roles_role_rights.role_id IS 'Ссылка на роль';


--
-- Name: COLUMN roles_role_rights.role_right_id; Type: COMMENT; Schema: doc; Owner: developers
--

COMMENT ON COLUMN doc.roles_role_rights.role_right_id IS 'Ссылка на право доступа';


--
-- Name: COLUMN roles_role_rights.is_allowed; Type: COMMENT; Schema: doc; Owner: developers
--

COMMENT ON COLUMN doc.roles_role_rights.is_allowed IS 'Разрешено ли роли пользоваться данным правом';


--
-- Name: sd_database_system_names; Type: TABLE; Schema: doc; Owner: sup
--

CREATE TABLE doc.sd_database_system_names (
    id integer NOT NULL,
    name character varying NOT NULL
);


ALTER TABLE doc.sd_database_system_names OWNER TO sup;

--
-- Name: TABLE sd_database_system_names; Type: COMMENT; Schema: doc; Owner: sup
--

COMMENT ON TABLE doc.sd_database_system_names IS 'Названия СУБД';


--
-- Name: sd_database_system_names_id_seq; Type: SEQUENCE; Schema: doc; Owner: sup
--

CREATE SEQUENCE doc.sd_database_system_names_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE doc.sd_database_system_names_id_seq OWNER TO sup;

--
-- Name: sd_database_system_names_id_seq; Type: SEQUENCE OWNED BY; Schema: doc; Owner: sup
--

ALTER SEQUENCE doc.sd_database_system_names_id_seq OWNED BY doc.sd_database_system_names.id;


--
-- Name: sd_development_environment_names; Type: TABLE; Schema: doc; Owner: sup
--

CREATE TABLE doc.sd_development_environment_names (
    id integer NOT NULL,
    name character varying NOT NULL
);


ALTER TABLE doc.sd_development_environment_names OWNER TO sup;

--
-- Name: TABLE sd_development_environment_names; Type: COMMENT; Schema: doc; Owner: sup
--

COMMENT ON TABLE doc.sd_development_environment_names IS 'Названия сред программирования';


--
-- Name: sd_development_environment_names_id_seq; Type: SEQUENCE; Schema: doc; Owner: sup
--

CREATE SEQUENCE doc.sd_development_environment_names_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE doc.sd_development_environment_names_id_seq OWNER TO sup;

--
-- Name: sd_development_environment_names_id_seq; Type: SEQUENCE OWNED BY; Schema: doc; Owner: sup
--

ALTER SEQUENCE doc.sd_development_environment_names_id_seq OWNED BY doc.sd_development_environment_names.id;


--
-- Name: sd_equipment_types; Type: TABLE; Schema: doc; Owner: sup
--

CREATE TABLE doc.sd_equipment_types (
    id integer NOT NULL,
    name character varying NOT NULL
);


ALTER TABLE doc.sd_equipment_types OWNER TO sup;

--
-- Name: TABLE sd_equipment_types; Type: COMMENT; Schema: doc; Owner: sup
--

COMMENT ON TABLE doc.sd_equipment_types IS 'Типы оборудования';


--
-- Name: sd_equipment_types_id_seq; Type: SEQUENCE; Schema: doc; Owner: sup
--

CREATE SEQUENCE doc.sd_equipment_types_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE doc.sd_equipment_types_id_seq OWNER TO sup;

--
-- Name: sd_equipment_types_id_seq; Type: SEQUENCE OWNED BY; Schema: doc; Owner: sup
--

ALTER SEQUENCE doc.sd_equipment_types_id_seq OWNED BY doc.sd_equipment_types.id;


--
-- Name: sd_ip_adresses; Type: TABLE; Schema: doc; Owner: sup
--

CREATE TABLE doc.sd_ip_adresses (
    id integer NOT NULL,
    network_name character varying,
    note character varying,
    ip_adr_1 integer,
    ip_adr_2 integer,
    ip_adr_3 integer,
    ip_adr_4 integer,
    location character varying,
    note_number character varying,
    inventory_number character varying,
    person_id integer,
    type_id integer,
    useri character varying DEFAULT "session_user"(),
    datei timestamp without time zone DEFAULT now()
);


ALTER TABLE doc.sd_ip_adresses OWNER TO sup;

--
-- Name: TABLE sd_ip_adresses; Type: COMMENT; Schema: doc; Owner: sup
--

COMMENT ON TABLE doc.sd_ip_adresses IS 'База IP адресов';


--
-- Name: sd_ip_adresses_id_seq; Type: SEQUENCE; Schema: doc; Owner: sup
--

CREATE SEQUENCE doc.sd_ip_adresses_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE doc.sd_ip_adresses_id_seq OWNER TO sup;

--
-- Name: sd_ip_adresses_id_seq; Type: SEQUENCE OWNED BY; Schema: doc; Owner: sup
--

ALTER SEQUENCE doc.sd_ip_adresses_id_seq OWNED BY doc.sd_ip_adresses.id;


--
-- Name: sd_request_portal; Type: SEQUENCE; Schema: doc; Owner: sup
--

CREATE SEQUENCE doc.sd_request_portal
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE doc.sd_request_portal OWNER TO sup;

--
-- Name: SEQUENCE sd_request_portal; Type: COMMENT; Schema: doc; Owner: sup
--

COMMENT ON SEQUENCE doc.sd_request_portal IS 'Последовательность для подсчёта заявок с портала';


--
-- Name: sd_resource_statuses; Type: TABLE; Schema: doc; Owner: sup
--

CREATE TABLE doc.sd_resource_statuses (
    id integer NOT NULL,
    name character varying NOT NULL
);


ALTER TABLE doc.sd_resource_statuses OWNER TO sup;

--
-- Name: TABLE sd_resource_statuses; Type: COMMENT; Schema: doc; Owner: sup
--

COMMENT ON TABLE doc.sd_resource_statuses IS 'Статусы ресурсов';


--
-- Name: sd_resource_statuses_id_seq; Type: SEQUENCE; Schema: doc; Owner: sup
--

CREATE SEQUENCE doc.sd_resource_statuses_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE doc.sd_resource_statuses_id_seq OWNER TO sup;

--
-- Name: sd_resource_statuses_id_seq; Type: SEQUENCE OWNED BY; Schema: doc; Owner: sup
--

ALTER SEQUENCE doc.sd_resource_statuses_id_seq OWNED BY doc.sd_resource_statuses.id;


--
-- Name: sd_resources_access_rights; Type: TABLE; Schema: doc; Owner: sup
--

CREATE TABLE doc.sd_resources_access_rights (
    id integer NOT NULL,
    resource_id integer NOT NULL,
    right_type_id integer NOT NULL,
    podr_id integer NOT NULL
);


ALTER TABLE doc.sd_resources_access_rights OWNER TO sup;

--
-- Name: TABLE sd_resources_access_rights; Type: COMMENT; Schema: doc; Owner: sup
--

COMMENT ON TABLE doc.sd_resources_access_rights IS 'Соответствие ролей и владельцев для ресурсов';


--
-- Name: sd_resources_access_rights_id_seq; Type: SEQUENCE; Schema: doc; Owner: sup
--

CREATE SEQUENCE doc.sd_resources_access_rights_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE doc.sd_resources_access_rights_id_seq OWNER TO sup;

--
-- Name: sd_resources_access_rights_id_seq; Type: SEQUENCE OWNED BY; Schema: doc; Owner: sup
--

ALTER SEQUENCE doc.sd_resources_access_rights_id_seq OWNED BY doc.sd_resources_access_rights.id;


--
-- Name: sd_serv_desc_requests; Type: TABLE; Schema: doc; Owner: sup
--

CREATE TABLE doc.sd_serv_desc_requests (
    id integer NOT NULL,
    number integer,
    req_date timestamp without time zone DEFAULT now(),
    status integer NOT NULL,
    type_id integer NOT NULL,
    subtype_id integer NOT NULL,
    short_description character varying,
    full_description character varying,
    responsible_laboratory_id integer,
    who_finished_request character varying,
    when_finished_request timestamp without time zone,
    applicant_id integer,
    applicant_inventory_num character varying,
    date_of_execution date
);


ALTER TABLE doc.sd_serv_desc_requests OWNER TO sup;

--
-- Name: TABLE sd_serv_desc_requests; Type: COMMENT; Schema: doc; Owner: sup
--

COMMENT ON TABLE doc.sd_serv_desc_requests IS 'Справочник заявок для ServiceDesk';


--
-- Name: COLUMN sd_serv_desc_requests.status; Type: COMMENT; Schema: doc; Owner: sup
--

COMMENT ON COLUMN doc.sd_serv_desc_requests.status IS 'Статус заявки';


--
-- Name: COLUMN sd_serv_desc_requests.type_id; Type: COMMENT; Schema: doc; Owner: sup
--

COMMENT ON COLUMN doc.sd_serv_desc_requests.type_id IS 'Ссылка на тип заявки';


--
-- Name: COLUMN sd_serv_desc_requests.subtype_id; Type: COMMENT; Schema: doc; Owner: sup
--

COMMENT ON COLUMN doc.sd_serv_desc_requests.subtype_id IS 'Ссылка на подтип';


--
-- Name: COLUMN sd_serv_desc_requests.short_description; Type: COMMENT; Schema: doc; Owner: sup
--

COMMENT ON COLUMN doc.sd_serv_desc_requests.short_description IS 'Краткое описание';


--
-- Name: COLUMN sd_serv_desc_requests.full_description; Type: COMMENT; Schema: doc; Owner: sup
--

COMMENT ON COLUMN doc.sd_serv_desc_requests.full_description IS 'Полное описание';


--
-- Name: COLUMN sd_serv_desc_requests.responsible_laboratory_id; Type: COMMENT; Schema: doc; Owner: sup
--

COMMENT ON COLUMN doc.sd_serv_desc_requests.responsible_laboratory_id IS 'Ссылка на ответственную лабраторию';


--
-- Name: COLUMN sd_serv_desc_requests.applicant_id; Type: COMMENT; Schema: doc; Owner: sup
--

COMMENT ON COLUMN doc.sd_serv_desc_requests.applicant_id IS 'Id заявителя';


--
-- Name: COLUMN sd_serv_desc_requests.applicant_inventory_num; Type: COMMENT; Schema: doc; Owner: sup
--

COMMENT ON COLUMN doc.sd_serv_desc_requests.applicant_inventory_num IS 'Инвентарный номер ПК заявителя';


--
-- Name: sd_serv_desc_requests_id_seq; Type: SEQUENCE; Schema: doc; Owner: sup
--

CREATE SEQUENCE doc.sd_serv_desc_requests_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE doc.sd_serv_desc_requests_id_seq OWNER TO sup;

--
-- Name: sd_serv_desc_requests_id_seq; Type: SEQUENCE OWNED BY; Schema: doc; Owner: sup
--

ALTER SEQUENCE doc.sd_serv_desc_requests_id_seq OWNED BY doc.sd_serv_desc_requests.id;


--
-- Name: sd_serv_desc_resp_for_exec_requests; Type: TABLE; Schema: doc; Owner: sup
--

CREATE TABLE doc.sd_serv_desc_resp_for_exec_requests (
    id integer NOT NULL,
    request_id integer NOT NULL,
    laboratory_id integer,
    person_id integer,
    datei timestamp without time zone DEFAULT now(),
    comment character varying
);


ALTER TABLE doc.sd_serv_desc_resp_for_exec_requests OWNER TO sup;

--
-- Name: TABLE sd_serv_desc_resp_for_exec_requests; Type: COMMENT; Schema: doc; Owner: sup
--

COMMENT ON TABLE doc.sd_serv_desc_resp_for_exec_requests IS 'Ответственные за заявки в serviceDesc';


--
-- Name: sd_serv_desc_resp_for_exec_requests_id_seq; Type: SEQUENCE; Schema: doc; Owner: sup
--

CREATE SEQUENCE doc.sd_serv_desc_resp_for_exec_requests_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE doc.sd_serv_desc_resp_for_exec_requests_id_seq OWNER TO sup;

--
-- Name: sd_serv_desc_resp_for_exec_requests_id_seq; Type: SEQUENCE OWNED BY; Schema: doc; Owner: sup
--

ALTER SEQUENCE doc.sd_serv_desc_resp_for_exec_requests_id_seq OWNED BY doc.sd_serv_desc_resp_for_exec_requests.id;


--
-- Name: sd_serv_desk_request_statuses; Type: TABLE; Schema: doc; Owner: sup
--

CREATE TABLE doc.sd_serv_desk_request_statuses (
    id integer NOT NULL,
    name character varying
);


ALTER TABLE doc.sd_serv_desk_request_statuses OWNER TO sup;

--
-- Name: sd_serv_desk_request_statuses_id_seq; Type: SEQUENCE; Schema: doc; Owner: sup
--

CREATE SEQUENCE doc.sd_serv_desk_request_statuses_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE doc.sd_serv_desk_request_statuses_id_seq OWNER TO sup;

--
-- Name: sd_serv_desk_request_statuses_id_seq; Type: SEQUENCE OWNED BY; Schema: doc; Owner: sup
--

ALTER SEQUENCE doc.sd_serv_desk_request_statuses_id_seq OWNED BY doc.sd_serv_desk_request_statuses.id;


--
-- Name: sd_serv_desk_request_subtypes; Type: TABLE; Schema: doc; Owner: sup
--

CREATE TABLE doc.sd_serv_desk_request_subtypes (
    id integer NOT NULL,
    type_id integer,
    name character varying
);


ALTER TABLE doc.sd_serv_desk_request_subtypes OWNER TO sup;

--
-- Name: sd_serv_desk_request_subtypes_id_seq; Type: SEQUENCE; Schema: doc; Owner: sup
--

CREATE SEQUENCE doc.sd_serv_desk_request_subtypes_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE doc.sd_serv_desk_request_subtypes_id_seq OWNER TO sup;

--
-- Name: sd_serv_desk_request_subtypes_id_seq; Type: SEQUENCE OWNED BY; Schema: doc; Owner: sup
--

ALTER SEQUENCE doc.sd_serv_desk_request_subtypes_id_seq OWNED BY doc.sd_serv_desk_request_subtypes.id;


--
-- Name: sd_serv_desk_request_types; Type: TABLE; Schema: doc; Owner: sup
--

CREATE TABLE doc.sd_serv_desk_request_types (
    id integer NOT NULL,
    name character varying,
    laboratory_id integer
);


ALTER TABLE doc.sd_serv_desk_request_types OWNER TO sup;

--
-- Name: COLUMN sd_serv_desk_request_types.laboratory_id; Type: COMMENT; Schema: doc; Owner: sup
--

COMMENT ON COLUMN doc.sd_serv_desk_request_types.laboratory_id IS 'Ссылка на приоритетную лабораторию для этого типа';


--
-- Name: sd_serv_desk_request_types_id_seq; Type: SEQUENCE; Schema: doc; Owner: sup
--

CREATE SEQUENCE doc.sd_serv_desk_request_types_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE doc.sd_serv_desk_request_types_id_seq OWNER TO sup;

--
-- Name: sd_serv_desk_request_types_id_seq; Type: SEQUENCE OWNED BY; Schema: doc; Owner: sup
--

ALTER SEQUENCE doc.sd_serv_desk_request_types_id_seq OWNED BY doc.sd_serv_desk_request_types.id;


--
-- Name: sd_spr_equipment; Type: TABLE; Schema: doc; Owner: sup
--

CREATE TABLE doc.sd_spr_equipment (
    id integer NOT NULL,
    podr_id integer,
    inventory_number character varying,
    name character varying,
    owner character varying,
    additional_info character varying,
    person_id integer
);


ALTER TABLE doc.sd_spr_equipment OWNER TO sup;

--
-- Name: TABLE sd_spr_equipment; Type: COMMENT; Schema: doc; Owner: sup
--

COMMENT ON TABLE doc.sd_spr_equipment IS 'Справочник устройств (ПК, МФУ, сканеров и т.д)';


--
-- Name: sd_spr_equipment_id_seq; Type: SEQUENCE; Schema: doc; Owner: sup
--

CREATE SEQUENCE doc.sd_spr_equipment_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE doc.sd_spr_equipment_id_seq OWNER TO sup;

--
-- Name: sd_spr_equipment_id_seq; Type: SEQUENCE OWNED BY; Schema: doc; Owner: sup
--

ALTER SEQUENCE doc.sd_spr_equipment_id_seq OWNED BY doc.sd_spr_equipment.id;


--
-- Name: sd_spr_laboratories; Type: TABLE; Schema: doc; Owner: sup
--

CREATE TABLE doc.sd_spr_laboratories (
    id integer NOT NULL,
    short_name character varying NOT NULL,
    full_name character varying
);


ALTER TABLE doc.sd_spr_laboratories OWNER TO sup;

--
-- Name: TABLE sd_spr_laboratories; Type: COMMENT; Schema: doc; Owner: sup
--

COMMENT ON TABLE doc.sd_spr_laboratories IS 'Справочник лабораторий';


--
-- Name: sd_spr_laboratories_id_seq; Type: SEQUENCE; Schema: doc; Owner: sup
--

CREATE SEQUENCE doc.sd_spr_laboratories_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE doc.sd_spr_laboratories_id_seq OWNER TO sup;

--
-- Name: sd_spr_laboratories_id_seq; Type: SEQUENCE OWNED BY; Schema: doc; Owner: sup
--

ALTER SEQUENCE doc.sd_spr_laboratories_id_seq OWNED BY doc.sd_spr_laboratories.id;


--
-- Name: sd_spr_persons_in_laboratories; Type: TABLE; Schema: doc; Owner: sup
--

CREATE TABLE doc.sd_spr_persons_in_laboratories (
    laboratory_id integer NOT NULL,
    person_id integer NOT NULL
);


ALTER TABLE doc.sd_spr_persons_in_laboratories OWNER TO sup;

--
-- Name: TABLE sd_spr_persons_in_laboratories; Type: COMMENT; Schema: doc; Owner: sup
--

COMMENT ON TABLE doc.sd_spr_persons_in_laboratories IS 'Сотрудники в лабораториях';


--
-- Name: sd_spr_resources; Type: TABLE; Schema: doc; Owner: sup
--

CREATE TABLE doc.sd_spr_resources (
    id integer NOT NULL,
    code character varying NOT NULL,
    year_of_development integer,
    full_name character varying,
    short_name character varying,
    description text,
    developer_person_id integer,
    implementer_id integer,
    domain_group character varying,
    network_solution boolean,
    status_id integer,
    development_environment_id integer,
    database_system_id integer,
    use_in_portal boolean,
    use_in_postgres boolean
);


ALTER TABLE doc.sd_spr_resources OWNER TO sup;

--
-- Name: TABLE sd_spr_resources; Type: COMMENT; Schema: doc; Owner: sup
--

COMMENT ON TABLE doc.sd_spr_resources IS 'Справочник ресурсов';


--
-- Name: COLUMN sd_spr_resources.code; Type: COMMENT; Schema: doc; Owner: sup
--

COMMENT ON COLUMN doc.sd_spr_resources.code IS 'код ресурса';


--
-- Name: COLUMN sd_spr_resources.year_of_development; Type: COMMENT; Schema: doc; Owner: sup
--

COMMENT ON COLUMN doc.sd_spr_resources.year_of_development IS 'год разработки';


--
-- Name: COLUMN sd_spr_resources.full_name; Type: COMMENT; Schema: doc; Owner: sup
--

COMMENT ON COLUMN doc.sd_spr_resources.full_name IS 'полное название';


--
-- Name: COLUMN sd_spr_resources.short_name; Type: COMMENT; Schema: doc; Owner: sup
--

COMMENT ON COLUMN doc.sd_spr_resources.short_name IS 'краткое название';


--
-- Name: COLUMN sd_spr_resources.description; Type: COMMENT; Schema: doc; Owner: sup
--

COMMENT ON COLUMN doc.sd_spr_resources.description IS 'описание';


--
-- Name: COLUMN sd_spr_resources.developer_person_id; Type: COMMENT; Schema: doc; Owner: sup
--

COMMENT ON COLUMN doc.sd_spr_resources.developer_person_id IS 'ссылка на разработчика';


--
-- Name: COLUMN sd_spr_resources.implementer_id; Type: COMMENT; Schema: doc; Owner: sup
--

COMMENT ON COLUMN doc.sd_spr_resources.implementer_id IS 'ссылка на лабораторию-исполнителя';


--
-- Name: COLUMN sd_spr_resources.domain_group; Type: COMMENT; Schema: doc; Owner: sup
--

COMMENT ON COLUMN doc.sd_spr_resources.domain_group IS 'доменная группа';


--
-- Name: COLUMN sd_spr_resources.network_solution; Type: COMMENT; Schema: doc; Owner: sup
--

COMMENT ON COLUMN doc.sd_spr_resources.network_solution IS 'сетевое решение';


--
-- Name: COLUMN sd_spr_resources.status_id; Type: COMMENT; Schema: doc; Owner: sup
--

COMMENT ON COLUMN doc.sd_spr_resources.status_id IS 'ссылка на статус ресурса';


--
-- Name: COLUMN sd_spr_resources.development_environment_id; Type: COMMENT; Schema: doc; Owner: sup
--

COMMENT ON COLUMN doc.sd_spr_resources.development_environment_id IS 'ссылка на среду разработки';


--
-- Name: COLUMN sd_spr_resources.database_system_id; Type: COMMENT; Schema: doc; Owner: sup
--

COMMENT ON COLUMN doc.sd_spr_resources.database_system_id IS 'ссылка на субд';


--
-- Name: sd_spr_resources_id_seq; Type: SEQUENCE; Schema: doc; Owner: sup
--

CREATE SEQUENCE doc.sd_spr_resources_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE doc.sd_spr_resources_id_seq OWNER TO sup;

--
-- Name: sd_spr_resources_id_seq; Type: SEQUENCE OWNED BY; Schema: doc; Owner: sup
--

ALTER SEQUENCE doc.sd_spr_resources_id_seq OWNED BY doc.sd_spr_resources.id;


--
-- Name: service_note_approvings; Type: TABLE; Schema: doc; Owner: developers
--

CREATE TABLE doc.service_note_approvings (
    id integer NOT NULL,
    document_id integer NOT NULL,
    performing_date timestamp without time zone,
    performing_result_id integer NOT NULL,
    approver_id integer NOT NULL,
    actual_performed_employee_id integer,
    note character varying(8192),
    cycle_number integer,
    inserting_timestamp timestamp without time zone DEFAULT now(),
    inserted_user character varying DEFAULT "session_user"()
);


ALTER TABLE doc.service_note_approvings OWNER TO developers;

--
-- Name: TABLE service_note_approvings; Type: COMMENT; Schema: doc; Owner: developers
--

COMMENT ON TABLE doc.service_note_approvings IS 'Информация о согласованиях документов';


--
-- Name: COLUMN service_note_approvings.document_id; Type: COMMENT; Schema: doc; Owner: developers
--

COMMENT ON COLUMN doc.service_note_approvings.document_id IS 'id документа';


--
-- Name: COLUMN service_note_approvings.performing_date; Type: COMMENT; Schema: doc; Owner: developers
--

COMMENT ON COLUMN doc.service_note_approvings.performing_date IS 'Дата принятия участия в согласовании документа сотрудником actual_approved_employee_id';


--
-- Name: COLUMN service_note_approvings.performing_result_id; Type: COMMENT; Schema: doc; Owner: developers
--

COMMENT ON COLUMN doc.service_note_approvings.performing_result_id IS 'id результата согласования документа (согласовано, не согласовано)';


--
-- Name: COLUMN service_note_approvings.approver_id; Type: COMMENT; Schema: doc; Owner: developers
--

COMMENT ON COLUMN doc.service_note_approvings.approver_id IS 'id назначенного согласованта для документа';


--
-- Name: COLUMN service_note_approvings.actual_performed_employee_id; Type: COMMENT; Schema: doc; Owner: developers
--

COMMENT ON COLUMN doc.service_note_approvings.actual_performed_employee_id IS 'id фактически принявшего участие в согласовании документа сотрудника';


--
-- Name: COLUMN service_note_approvings.note; Type: COMMENT; Schema: doc; Owner: developers
--

COMMENT ON COLUMN doc.service_note_approvings.note IS 'примечания согласованта';


--
-- Name: COLUMN service_note_approvings.cycle_number; Type: COMMENT; Schema: doc; Owner: developers
--

COMMENT ON COLUMN doc.service_note_approvings.cycle_number IS 'номер цикла согласования документа. Данное поля заполняется в случае завершения цикла согласования. Отсутствие значения в данном поле свидетельствует о том, что согласование ещё не завершено.';


--
-- Name: service_note_approvings_id_seq; Type: SEQUENCE; Schema: doc; Owner: developers
--

CREATE SEQUENCE doc.service_note_approvings_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE doc.service_note_approvings_id_seq OWNER TO developers;

--
-- Name: service_note_approvings_id_seq; Type: SEQUENCE OWNED BY; Schema: doc; Owner: developers
--

ALTER SEQUENCE doc.service_note_approvings_id_seq OWNED BY doc.service_note_approvings.id;


--
-- Name: service_note_file_metadata_id_seq; Type: SEQUENCE; Schema: doc; Owner: developers
--

CREATE SEQUENCE doc.service_note_file_metadata_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE doc.service_note_file_metadata_id_seq OWNER TO developers;

--
-- Name: service_note_file_metadata; Type: TABLE; Schema: doc; Owner: developers
--

CREATE TABLE doc.service_note_file_metadata (
    id integer DEFAULT nextval('doc.service_note_file_metadata_id_seq'::regclass) NOT NULL,
    id_for_search integer,
    document_id integer NOT NULL,
    file_path character varying,
    file_name character varying,
    note character varying,
    changing_date timestamp without time zone DEFAULT now(),
    changing_user character varying DEFAULT "session_user"()
);


ALTER TABLE doc.service_note_file_metadata OWNER TO developers;

--
-- Name: TABLE service_note_file_metadata; Type: COMMENT; Schema: doc; Owner: developers
--

COMMENT ON TABLE doc.service_note_file_metadata IS 'Метаданные файлов, прилагаемых к служебным запискам';


--
-- Name: COLUMN service_note_file_metadata.document_id; Type: COMMENT; Schema: doc; Owner: developers
--

COMMENT ON COLUMN doc.service_note_file_metadata.document_id IS 'Идентификатор записи служебной записки, полученный из стороннего справочника';


--
-- Name: COLUMN service_note_file_metadata.file_path; Type: COMMENT; Schema: doc; Owner: developers
--

COMMENT ON COLUMN doc.service_note_file_metadata.file_path IS 'Путь к файлу служебной записки в архиве';


--
-- Name: COLUMN service_note_file_metadata.file_name; Type: COMMENT; Schema: doc; Owner: developers
--

COMMENT ON COLUMN doc.service_note_file_metadata.file_name IS 'Название файла служебной записки';


--
-- Name: COLUMN service_note_file_metadata.note; Type: COMMENT; Schema: doc; Owner: developers
--

COMMENT ON COLUMN doc.service_note_file_metadata.note IS 'Примечания к служебной записке';


--
-- Name: COLUMN service_note_file_metadata.changing_date; Type: COMMENT; Schema: doc; Owner: developers
--

COMMENT ON COLUMN doc.service_note_file_metadata.changing_date IS 'Дата внесения изменений';


--
-- Name: COLUMN service_note_file_metadata.changing_user; Type: COMMENT; Schema: doc; Owner: developers
--

COMMENT ON COLUMN doc.service_note_file_metadata.changing_user IS 'Пользователь, внёсший изменения';


--
-- Name: service_note_links_id_seq; Type: SEQUENCE; Schema: doc; Owner: developers
--

CREATE SEQUENCE doc.service_note_links_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE doc.service_note_links_id_seq OWNER TO developers;

--
-- Name: service_note_links; Type: TABLE; Schema: doc; Owner: developers
--

CREATE TABLE doc.service_note_links (
    id integer DEFAULT nextval('doc.service_note_links_id_seq'::regclass) NOT NULL,
    document_id integer NOT NULL,
    related_document_id integer NOT NULL,
    changing_date timestamp without time zone DEFAULT now(),
    changing_user character varying DEFAULT "session_user"(),
    related_document_type_id integer
);


ALTER TABLE doc.service_note_links OWNER TO developers;

--
-- Name: TABLE service_note_links; Type: COMMENT; Schema: doc; Owner: developers
--

COMMENT ON TABLE doc.service_note_links IS 'Связи служебных записок с вышестоящими служебными записками и вышестоящими документами';


--
-- Name: COLUMN service_note_links.document_id; Type: COMMENT; Schema: doc; Owner: developers
--

COMMENT ON COLUMN doc.service_note_links.document_id IS 'Идентификатор записи служебной записки, полученный из стороннего справочника';


--
-- Name: COLUMN service_note_links.related_document_id; Type: COMMENT; Schema: doc; Owner: developers
--

COMMENT ON COLUMN doc.service_note_links.related_document_id IS 'Идентификатор записи вышестоящего документа, полученный из стороннего справочника';


--
-- Name: COLUMN service_note_links.changing_date; Type: COMMENT; Schema: doc; Owner: developers
--

COMMENT ON COLUMN doc.service_note_links.changing_date IS 'Дата внесения изменений';


--
-- Name: COLUMN service_note_links.changing_user; Type: COMMENT; Schema: doc; Owner: developers
--

COMMENT ON COLUMN doc.service_note_links.changing_user IS 'Пользователь, внёсший изменения';


--
-- Name: COLUMN service_note_links.related_document_type_id; Type: COMMENT; Schema: doc; Owner: developers
--

COMMENT ON COLUMN doc.service_note_links.related_document_type_id IS 'Ссылка на тип вышестоящего связанного документа';


--
-- Name: service_note_receivers_id_seq; Type: SEQUENCE; Schema: doc; Owner: developers
--

CREATE SEQUENCE doc.service_note_receivers_id_seq
    START WITH 84
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE doc.service_note_receivers_id_seq OWNER TO developers;

--
-- Name: service_note_receivers; Type: TABLE; Schema: doc; Owner: developers
--

CREATE TABLE doc.service_note_receivers (
    id integer DEFAULT nextval('doc.service_note_receivers_id_seq'::regclass) NOT NULL,
    document_id integer NOT NULL,
    performer_id integer NOT NULL,
    performing_date timestamp without time zone,
    comment character varying,
    changing_date timestamp without time zone DEFAULT now(),
    changing_user character varying DEFAULT "session_user"(),
    input_number_date timestamp without time zone,
    top_level_charge_sheet_id integer,
    cod_type_document integer,
    isp_yn integer,
    input_number character varying,
    charge character varying,
    actual_performer_id integer,
    charge_view_date timestamp without time zone,
    application_id integer,
    issuer_id integer,
    charge_period_start timestamp without time zone,
    charge_period_end timestamp without time zone,
    head_charge_sheet_id integer,
    incoming_document_type_id integer DEFAULT 3,
    is_for_acquaitance boolean DEFAULT false,
    issuing_datetime timestamp without time zone,
    total_charge_count integer,
    performed_charge_count integer,
    subordinate_charge_count integer,
    subordinate_performed_charge_count integer,
    kind_id integer NOT NULL,
    document_kind_id integer
);


ALTER TABLE doc.service_note_receivers OWNER TO developers;

--
-- Name: TABLE service_note_receivers; Type: COMMENT; Schema: doc; Owner: developers
--

COMMENT ON TABLE doc.service_note_receivers IS 'Получатели служебных записок';


--
-- Name: COLUMN service_note_receivers.document_id; Type: COMMENT; Schema: doc; Owner: developers
--

COMMENT ON COLUMN doc.service_note_receivers.document_id IS 'Ссылка на служебную записку, полученная из внешнего справочника';


--
-- Name: COLUMN service_note_receivers.performer_id; Type: COMMENT; Schema: doc; Owner: developers
--

COMMENT ON COLUMN doc.service_note_receivers.performer_id IS 'Ссылка на получившего сотрудника, полученная из внешнего справочника';


--
-- Name: COLUMN service_note_receivers.performing_date; Type: COMMENT; Schema: doc; Owner: developers
--

COMMENT ON COLUMN doc.service_note_receivers.performing_date IS 'Дата исполнения служебной записки';


--
-- Name: COLUMN service_note_receivers.comment; Type: COMMENT; Schema: doc; Owner: developers
--

COMMENT ON COLUMN doc.service_note_receivers.comment IS 'Комментарий к исполнению';


--
-- Name: COLUMN service_note_receivers.changing_date; Type: COMMENT; Schema: doc; Owner: developers
--

COMMENT ON COLUMN doc.service_note_receivers.changing_date IS 'Дата внесения изменений';


--
-- Name: COLUMN service_note_receivers.changing_user; Type: COMMENT; Schema: doc; Owner: developers
--

COMMENT ON COLUMN doc.service_note_receivers.changing_user IS 'Пользователь, внёсший изменения';


--
-- Name: COLUMN service_note_receivers.input_number_date; Type: COMMENT; Schema: doc; Owner: developers
--

COMMENT ON COLUMN doc.service_note_receivers.input_number_date IS 'Дата проставления входящего номера служебной записки для данного сотрудника';


--
-- Name: COLUMN service_note_receivers.top_level_charge_sheet_id; Type: COMMENT; Schema: doc; Owner: developers
--

COMMENT ON COLUMN doc.service_note_receivers.top_level_charge_sheet_id IS 'Ссылка на вышестояющий лист поручения';


--
-- Name: COLUMN service_note_receivers.input_number; Type: COMMENT; Schema: doc; Owner: developers
--

COMMENT ON COLUMN doc.service_note_receivers.input_number IS 'Входящий номер документа для данного сотрудника';


--
-- Name: COLUMN service_note_receivers.charge; Type: COMMENT; Schema: doc; Owner: developers
--

COMMENT ON COLUMN doc.service_note_receivers.charge IS 'Поручение по данной служебной записке (для подчиненных исполнителей)';


--
-- Name: COLUMN service_note_receivers.actual_performer_id; Type: COMMENT; Schema: doc; Owner: developers
--

COMMENT ON COLUMN doc.service_note_receivers.actual_performer_id IS 'Фактически исполнивший документ сотрудник';


--
-- Name: COLUMN service_note_receivers.charge_view_date; Type: COMMENT; Schema: doc; Owner: developers
--

COMMENT ON COLUMN doc.service_note_receivers.charge_view_date IS 'Дата просмотра поручения';


--
-- Name: COLUMN service_note_receivers.application_id; Type: COMMENT; Schema: doc; Owner: developers
--

COMMENT ON COLUMN doc.service_note_receivers.application_id IS 'Ссылка на заявку';


--
-- Name: service_note_signings; Type: TABLE; Schema: doc; Owner: developers
--

CREATE TABLE doc.service_note_signings (
    id integer NOT NULL,
    document_id integer NOT NULL,
    signer_id integer NOT NULL,
    actual_signed_id integer,
    signing_date timestamp without time zone
);


ALTER TABLE doc.service_note_signings OWNER TO developers;

--
-- Name: service_note_signings_id_seq; Type: SEQUENCE; Schema: doc; Owner: developers
--

CREATE SEQUENCE doc.service_note_signings_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE doc.service_note_signings_id_seq OWNER TO developers;

--
-- Name: service_note_signings_id_seq; Type: SEQUENCE OWNED BY; Schema: doc; Owner: developers
--

ALTER SEQUENCE doc.service_note_signings_id_seq OWNED BY doc.service_note_signings.id;


--
-- Name: service_notes_outside_id_seq; Type: SEQUENCE; Schema: doc; Owner: developers
--

CREATE SEQUENCE doc.service_notes_outside_id_seq
    START WITH 227150
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE doc.service_notes_outside_id_seq OWNER TO developers;

--
-- Name: service_notes; Type: TABLE; Schema: doc; Owner: developers
--

CREATE TABLE doc.service_notes (
    id integer DEFAULT nextval('doc.service_notes_outside_id_seq'::regclass) NOT NULL,
    type_id integer DEFAULT 2 NOT NULL,
    name character varying,
    document_number character varying NOT NULL,
    creation_date timestamp without time zone NOT NULL,
    note character varying,
    current_work_cycle_stage_id integer DEFAULT 1,
    content character varying(8192),
    changing_date timestamp without time zone DEFAULT now(),
    changing_user character varying DEFAULT "session_user"(),
    performer_id integer,
    author_id integer,
    is_sent_to_signing boolean,
    is_self_registered boolean DEFAULT false,
    total_charge_count integer,
    performed_charge_count integer,
    receiving_department_names character varying,
    document_date timestamp without time zone,
    product_code character varying,
    applications_exists boolean DEFAULT false,
    signer_department_short_name character varying,
    full_name character varying
);


ALTER TABLE doc.service_notes OWNER TO developers;

--
-- Name: TABLE service_notes; Type: COMMENT; Schema: doc; Owner: developers
--

COMMENT ON TABLE doc.service_notes IS 'Служебные записки';


--
-- Name: COLUMN service_notes.id; Type: COMMENT; Schema: doc; Owner: developers
--

COMMENT ON COLUMN doc.service_notes.id IS 'Идентификатор записи служебной записки из стороннего справочника';


--
-- Name: COLUMN service_notes.type_id; Type: COMMENT; Schema: doc; Owner: developers
--

COMMENT ON COLUMN doc.service_notes.type_id IS 'Ссылка на тип служебной записки (входящая - 3, исходящая - 2)';


--
-- Name: COLUMN service_notes.name; Type: COMMENT; Schema: doc; Owner: developers
--

COMMENT ON COLUMN doc.service_notes.name IS 'Название';


--
-- Name: COLUMN service_notes.document_number; Type: COMMENT; Schema: doc; Owner: developers
--

COMMENT ON COLUMN doc.service_notes.document_number IS 'Номер';


--
-- Name: COLUMN service_notes.creation_date; Type: COMMENT; Schema: doc; Owner: developers
--

COMMENT ON COLUMN doc.service_notes.creation_date IS 'Дата создания';


--
-- Name: COLUMN service_notes.note; Type: COMMENT; Schema: doc; Owner: developers
--

COMMENT ON COLUMN doc.service_notes.note IS 'Примечания';


--
-- Name: COLUMN service_notes.current_work_cycle_stage_id; Type: COMMENT; Schema: doc; Owner: developers
--

COMMENT ON COLUMN doc.service_notes.current_work_cycle_stage_id IS 'Ссылка на текущую стадию жизненного служебной записки';


--
-- Name: COLUMN service_notes.content; Type: COMMENT; Schema: doc; Owner: developers
--

COMMENT ON COLUMN doc.service_notes.content IS 'Содержимое';


--
-- Name: COLUMN service_notes.changing_date; Type: COMMENT; Schema: doc; Owner: developers
--

COMMENT ON COLUMN doc.service_notes.changing_date IS 'Дата внесения изменений';


--
-- Name: COLUMN service_notes.changing_user; Type: COMMENT; Schema: doc; Owner: developers
--

COMMENT ON COLUMN doc.service_notes.changing_user IS 'Пользователь, внёсший изменения';


--
-- Name: COLUMN service_notes.performer_id; Type: COMMENT; Schema: doc; Owner: developers
--

COMMENT ON COLUMN doc.service_notes.performer_id IS 'Ссылка на ответственного за данный документ';


--
-- Name: COLUMN service_notes.document_date; Type: COMMENT; Schema: doc; Owner: developers
--

COMMENT ON COLUMN doc.service_notes.document_date IS 'Дата документа';


--
-- Name: system_roles; Type: TABLE; Schema: doc; Owner: developers
--

CREATE TABLE doc.system_roles (
    id integer NOT NULL,
    name character varying NOT NULL,
    description character varying
);


ALTER TABLE doc.system_roles OWNER TO developers;

--
-- Name: system_roles_id_seq; Type: SEQUENCE; Schema: doc; Owner: developers
--

CREATE SEQUENCE doc.system_roles_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE doc.system_roles_id_seq OWNER TO developers;

--
-- Name: system_roles_id_seq; Type: SEQUENCE OWNED BY; Schema: doc; Owner: developers
--

ALTER SEQUENCE doc.system_roles_id_seq OWNED BY doc.system_roles.id;


--
-- Name: users_for_which_permissible_receiving_notification_to_others; Type: TABLE; Schema: doc; Owner: developers
--

CREATE TABLE doc.users_for_which_permissible_receiving_notification_to_others (
    user_id_for_which_receiving_permissible bigint NOT NULL,
    for_other_receiving_user_id bigint NOT NULL
);


ALTER TABLE doc.users_for_which_permissible_receiving_notification_to_others OWNER TO developers;

--
-- Name: TABLE users_for_which_permissible_receiving_notification_to_others; Type: COMMENT; Schema: doc; Owner: developers
--

COMMENT ON TABLE doc.users_for_which_permissible_receiving_notification_to_others IS 'Сопоставления одних пользователей с другими пользователями, которые могут получать какие-либо уведомления за первых';


--
-- Name: COLUMN users_for_which_permissible_receiving_notification_to_others.user_id_for_which_receiving_permissible; Type: COMMENT; Schema: doc; Owner: developers
--

COMMENT ON COLUMN doc.users_for_which_permissible_receiving_notification_to_others.user_id_for_which_receiving_permissible IS 'id пользователя, за которого может получать какие-либо уведомления for_other_receiving_user_id';


--
-- Name: COLUMN users_for_which_permissible_receiving_notification_to_others.for_other_receiving_user_id; Type: COMMENT; Schema: doc; Owner: developers
--

COMMENT ON COLUMN doc.users_for_which_permissible_receiving_notification_to_others.for_other_receiving_user_id IS 'id пользователя, который может получать какие-либо уведомления за user_id_for_which_receiving_permissible';


--
-- Name: v_working_employees; Type: VIEW; Schema: doc; Owner: u_57791
--

CREATE VIEW doc.v_working_employees AS
 SELECT a.id,
    a.personnel_number,
    a.name,
    a.surname,
    a.patronymic,
    a.speciality,
    a.leader_id,
    a.department_id,
    a.is_foreign,
    b.code AS department_code,
    b.short_name AS department_short_name,
    b.full_name AS department_full_name,
    c.telephone_number
   FROM ((doc.employees a
     JOIN doc.departments b ON ((b.id = a.department_id)))
     LEFT JOIN exchange.spr_person_telephone_numbers c ON ((c.person_id = a.spr_person_id)))
  WHERE ((NOT a.was_dismissed) AND b.is_activated)
  ORDER BY a.surname, a.name, a.patronymic;


ALTER TABLE doc.v_working_employees OWNER TO u_57791;

--
-- Name: v_all_possible_service_note_performers; Type: VIEW; Schema: doc; Owner: u_57791
--

CREATE VIEW doc.v_all_possible_service_note_performers AS
 SELECT v_working_employees.id,
    v_working_employees.personnel_number,
    v_working_employees.name,
    v_working_employees.surname,
    v_working_employees.patronymic,
    v_working_employees.speciality,
    v_working_employees.telephone_number,
    v_working_employees.leader_id,
    v_working_employees.department_id,
    v_working_employees.is_foreign,
    v_working_employees.department_code,
    v_working_employees.department_short_name,
    v_working_employees.department_full_name
   FROM doc.v_working_employees;


ALTER TABLE doc.v_all_possible_service_note_performers OWNER TO u_57791;

--
-- Name: v_departments_for_1c; Type: VIEW; Schema: doc; Owner: sup
--

CREATE VIEW doc.v_departments_for_1c AS
 SELECT d.short_name,
    d.full_name,
    d.code,
    p.code AS parent_code,
    e.personnel_number,
    e.short_full_name
   FROM ((doc.departments d
     LEFT JOIN doc.departments p ON (((d.top_level_department_id = p.id) AND (p.is_activated = true) AND (p.prizn_old IS NULL))))
     LEFT JOIN ( SELECT e_1.department_id,
            e_1.personnel_number,
            e_1.short_full_name
           FROM (doc.employees e_1
             JOIN doc.employees_roles l ON (((e_1.id = l.employee_id) AND (l.role_id = 2))))
          WHERE (e_1.was_dismissed = false)) e ON ((e.department_id = d.id)))
  WHERE ((d.is_activated = true) AND (d.prizn_old IS NULL))
  ORDER BY d.code;


ALTER TABLE doc.v_departments_for_1c OWNER TO sup;

--
-- Name: v_document_charges; Type: VIEW; Schema: doc; Owner: u_55536
--

CREATE VIEW doc.v_document_charges AS
 SELECT a.id,
    a.document_id,
    sn.type_id AS document_type_id,
    a.charge,
    a.changing_date AS charge_creation_date,
    b.spr_person_id AS performer_id,
    actual_performer.spr_person_id AS actual_performed_id,
    issuer.spr_person_id AS sender_id,
    issuer_dep.id AS sender_dep_id,
    issuer_dep.code AS sender_dep_code,
    issuer_dep.short_name AS sender_dep_short_name,
    a.application_id,
    f.look_date AS charge_view_date,
    a.top_level_charge_sheet_id AS top_level_charge_id,
    a.comment,
    sn.performer_id AS responsible_id,
    ( SELECT employees.short_full_name
           FROM doc.employees
          WHERE (employees.id = a.issuer_id)) AS real_charge_sender_name
   FROM (((((((doc.service_note_receivers a
     JOIN doc.service_notes sn ON ((sn.id = a.document_id)))
     JOIN doc.employees b ON ((a.performer_id = b.id)))
     LEFT JOIN doc.employees actual_performer ON ((actual_performer.id = a.actual_performer_id)))
     LEFT JOIN doc.employees issuer ON ((issuer.id = a.issuer_id)))
     LEFT JOIN doc.departments issuer_dep ON ((issuer_dep.id =
        CASE
            WHEN sn.is_self_registered THEN ( SELECT departments.id
               FROM doc.departments
              WHERE (((departments.code)::text = "left"((sn.document_number)::text, (length((sn.document_number)::text) - "position"(reverse((sn.document_number)::text), ''::text)))) AND (departments.prizn_old IS NULL)))
            ELSE ( SELECT signer.head_kindred_department_id
               FROM (doc.service_note_signings sns
                 JOIN doc.employees signer ON ((signer.id = sns.signer_id)))
              WHERE (sns.document_id = sn.id))
        END)))
     JOIN doc.employees cur_user ON ((cur_user.id = doc.get_current_employee_id())))
     LEFT JOIN doc.looked_service_note_charges f ON (((f.charge_id = a.id) AND (f.employee_id = cur_user.id))))
  WHERE ((cur_user.head_kindred_department_id = b.head_kindred_department_id) AND (a.issuer_id IS NOT NULL))
UNION
 SELECT a.id,
    a.document_id,
    doc.type_id AS document_type_id,
    a.charge,
    a.changing_date AS charge_creation_date,
    b.spr_person_id AS performer_id,
    actual_performer.spr_person_id AS actual_performed_id,
    issuer.spr_person_id AS sender_id,
    issuer_dep.id AS sender_dep_id,
    issuer_dep.code AS sender_dep_code,
    issuer_dep.short_name AS sender_dep_short_name,
    a.application_id,
    f.look_date AS charge_view_date,
    a.top_level_charge_sheet_id AS top_level_charge_id,
    a.comment,
    doc.performer_id AS responsible_id,
    ( SELECT employees.short_full_name
           FROM doc.employees
          WHERE (employees.id = a.issuer_id)) AS real_charge_sender_name
   FROM (((((((doc.document_receivers a
     JOIN doc.documents doc ON ((doc.id = a.document_id)))
     JOIN doc.employees b ON ((b.id = a.performer_id)))
     LEFT JOIN doc.employees actual_performer ON ((actual_performer.id = a.actual_performer_id)))
     LEFT JOIN doc.employees issuer ON ((issuer.id = a.issuer_id)))
     LEFT JOIN doc.departments issuer_dep ON ((issuer_dep.id =
        CASE
            WHEN doc.is_self_registered THEN ( SELECT departments.id
               FROM doc.departments
              WHERE (((departments.code)::text = "left"((doc.document_number)::text, (length((doc.document_number)::text) - "position"(reverse((doc.document_number)::text), ''::text)))) AND (departments.prizn_old IS NULL)))
            ELSE ( SELECT signer.head_kindred_department_id
               FROM (doc.service_note_signings sns
                 JOIN doc.employees signer ON ((signer.id = sns.signer_id)))
              WHERE (sns.document_id = doc.id))
        END)))
     JOIN doc.employees cur_user ON ((cur_user.id = doc.get_current_employee_id())))
     LEFT JOIN doc.looked_document_charges f ON (((f.charge_id = a.id) AND (f.employee_id = doc.get_current_employee_id()))))
  WHERE ((cur_user.head_kindred_department_id = b.head_kindred_department_id) AND (a.issuer_id IS NOT NULL));


ALTER TABLE doc.v_document_charges OWNER TO u_55536;

--
-- Name: v_document_files; Type: VIEW; Schema: doc; Owner: sup
--

CREATE VIEW doc.v_document_files AS
 SELECT a.id,
    b.id AS document_id,
    b.type_id AS document_type_id,
    a.file_name,
    (public.concat('\\\\srv-doc\\Doc_Oborot\\umz_doc\\'::text, (a.file_path)::text))::character varying AS file_path,
    a.file_path AS relative_file_path,
    '\\\\srv-doc\\Doc_Oborot\\umz_doc\\'::text AS base_file_folder_path
   FROM (doc.service_note_file_metadata a
     JOIN doc.service_notes b ON ((a.document_id = b.id)))
UNION
 SELECT a.id,
    b.id AS document_id,
    b.type_id AS document_type_id,
    a.file_name,
    (public.concat('\\\\srv-doc\\Doc_Oborot\\umz_doc\\'::text, (a.file_path)::text))::character varying AS file_path,
    a.file_path AS relative_file_path,
    '\\\\srv-doc\\Doc_Oborot\\umz_doc\\'::text AS base_file_folder_path
   FROM (doc.document_file_metadata a
     JOIN doc.documents b ON ((a.document_id = b.id)));


ALTER TABLE doc.v_document_files OWNER TO sup;

--
-- Name: v_document_numerators; Type: VIEW; Schema: doc; Owner: u_55536
--

CREATE VIEW doc.v_document_numerators AS
 SELECT n.id,
    n.department_id,
    n.document_type_id,
    n.main_value,
    n.prefix_value,
    n.postfix_value,
    n.delimiter,
    t.short_full_name AS doc_type,
    d.short_name AS podr
   FROM ((doc.document_numerators n
     JOIN doc.document_types t ON ((n.document_type_id = t.id)))
     JOIN doc.departments d ON ((n.department_id = d.id)));


ALTER TABLE doc.v_document_numerators OWNER TO u_55536;

--
-- Name: v_documents; Type: VIEW; Schema: doc; Owner: u_57791
--

CREATE VIEW doc.v_documents AS
 SELECT a.id,
    a.type_id,
    a.document_number,
    a.name,
    a.creation_date,
    a.content,
    a.note,
    a.performer_id AS responsible_id,
    sptn.telephone_number AS responsible_telephone,
    c.id AS sending_podr_id
   FROM (((doc.service_notes a
     JOIN exchange.spr_person b ON ((b.id = a.performer_id)))
     LEFT JOIN exchange.spr_person_telephone_numbers sptn ON ((sptn.person_id = b.id)))
     JOIN nsi.spr_podr c ON ((c.id = b.podr_id)))
UNION
 SELECT a.id,
    a.type_id,
    a.document_number,
    a.name,
    a.creation_date,
    a.content,
    a.note,
    a.performer_id AS responsible_id,
    sptn.telephone_number AS responsible_telephone,
    c.id AS sending_podr_id
   FROM (((doc.documents a
     JOIN exchange.spr_person b ON ((b.id = a.performer_id)))
     LEFT JOIN exchange.spr_person_telephone_numbers sptn ON ((sptn.person_id = b.id)))
     JOIN nsi.spr_podr c ON ((c.id = b.podr_id)));


ALTER TABLE doc.v_documents OWNER TO u_57791;

--
-- Name: v_employees; Type: VIEW; Schema: doc; Owner: u_57791
--

CREATE VIEW doc.v_employees AS
 SELECT a.id,
    a.personnel_number,
    a.name,
    a.surname,
    a.patronymic,
    a.speciality,
    a.leader_id,
    a.department_id,
    a.is_foreign,
    b.code AS department_code,
    b.short_name AS department_short_name,
    b.full_name AS department_full_name,
    c.telephone_number,
    a.was_dismissed
   FROM ((doc.employees a
     JOIN doc.departments b ON ((b.id = a.department_id)))
     LEFT JOIN exchange.spr_person_telephone_numbers c ON ((c.person_id = a.spr_person_id)))
  WHERE b.is_activated
  ORDER BY a.surname, a.name, a.patronymic;


ALTER TABLE doc.v_employees OWNER TO u_57791;

--
-- Name: v_podr_departments; Type: VIEW; Schema: doc; Owner: sup
--

CREATE VIEW doc.v_podr_departments AS
 WITH a AS (
         WITH RECURSIVE foo AS (
                 SELECT p.id AS podr_id,
                    p.podr_code,
                    p.podr_short_name,
                    p.podr_id_owner,
                    d.id,
                    1 AS ord
                   FROM (nsi.spr_podr p
                     LEFT JOIN doc.departments d ON ((((d.code)::text = (p.podr_code)::text) AND (d.prizn_old IS NULL))))
                  WHERE ((p.end_isp_dt > now()) AND (p.sklad_flag = 0))
                UNION
                 SELECT foo_1.podr_id,
                    foo_1.podr_code,
                    foo_1.podr_short_name,
                    p.podr_id_owner,
                    d.id,
                    (foo_1.ord + 1)
                   FROM ((foo foo_1
                     LEFT JOIN nsi.spr_podr p ON ((foo_1.podr_id_owner = p.id)))
                     LEFT JOIN doc.departments d ON ((((d.code)::text = (p.podr_code)::text) AND (d.prizn_old IS NULL))))
                  WHERE ((p.end_isp_dt > now()) AND (foo_1.id IS NULL))
                )
         SELECT foo.podr_id,
            foo.podr_code,
            foo.podr_short_name,
            foo.podr_id_owner,
            foo.id,
            foo.ord,
            max(foo.ord) OVER (PARTITION BY foo.podr_id) AS m_ord
           FROM foo
        ), b AS (
         SELECT r.employee_id,
            e.department_id
           FROM (doc.employees_roles r
             LEFT JOIN doc.employees e ON ((r.employee_id = e.id)))
          WHERE (r.role_id = 2)
        )
 SELECT a.podr_id,
    a.podr_code,
    a.podr_short_name,
    a.podr_id_owner,
    a.id AS department_id,
    b.employee_id AS podr_leader_id
   FROM (a
     LEFT JOIN b ON ((a.id = b.department_id)))
  WHERE (a.id IS NOT NULL)
  ORDER BY a.podr_code;


ALTER TABLE doc.v_podr_departments OWNER TO sup;

--
-- Name: VIEW v_podr_departments; Type: COMMENT; Schema: doc; Owner: sup
--

COMMENT ON VIEW doc.v_podr_departments IS 'Сопоставление справочника подразделений предприятия со справочником подразделений ДО';


--
-- Name: v_sd_equipment; Type: VIEW; Schema: doc; Owner: sup
--

CREATE VIEW doc.v_sd_equipment AS
 SELECT a.id,
    a.podr_id,
    a.inventory_number,
    a.name,
    a.owner,
    a.additional_info,
    a.person_id,
    b.podr_code,
    b.podr_short_name,
    b.podr_name,
    b.begin_isp_dt,
    b.end_isp_dt,
    c.tab_nbr,
    c.family,
    c.name AS person_name,
    c.patronymic,
    c.job,
    c.date_birth,
    c.birth_place,
    c.dismissed,
    d.telephone_number,
    (((((initcap((c.family)::text) || ' '::text) || initcap((c.name)::text)) || ' '::text) || initcap((c.patronymic)::text)))::character varying AS person_full_name,
    nsi.podr_get_linked_name(c.podr_id) AS podr_names
   FROM (((doc.sd_spr_equipment a
     LEFT JOIN nsi.spr_podr b ON ((b.id = a.podr_id)))
     LEFT JOIN exchange.spr_person c ON ((c.id = a.person_id)))
     LEFT JOIN exchange.spr_person_telephone_numbers d ON ((d.person_id = c.id)))
  ORDER BY a.id;


ALTER TABLE doc.v_sd_equipment OWNER TO sup;

--
-- Name: v_sd_ip_adresses; Type: VIEW; Schema: doc; Owner: sup
--

CREATE VIEW doc.v_sd_ip_adresses AS
 SELECT a.id,
    a.network_name,
    (a.note)::text AS note,
    a.ip_adr_1,
    a.ip_adr_2,
    a.ip_adr_3,
    a.ip_adr_4,
    (a.location)::text AS location,
    (a.note_number)::text AS note_number,
    a.inventory_number,
    a.person_id,
    a.type_id,
    a.useri,
    a.datei,
    b.name,
    ((((a.ip_adr_1 || '.'::text) || a.ip_adr_2) ||
        CASE
            WHEN (a.ip_adr_3 IS NOT NULL) THEN ('.'::text || a.ip_adr_3)
            ELSE ''::text
        END) ||
        CASE
            WHEN ((a.ip_adr_3 IS NOT NULL) AND (a.ip_adr_4 IS NOT NULL)) THEN ('.'::text || a.ip_adr_4)
            ELSE ''::text
        END) AS full_ip,
    (((((initcap((p.family)::text) || ' '::text) || initcap((p.name)::text)) || ' '::text) || initcap((p.patronymic)::text)))::character varying AS person_full_name,
    p.family AS person_family,
    p.name AS person_name,
    p.patronymic AS person_patronymic,
    p.tab_nbr AS person_tab_nbr,
    p.job AS person_job,
    p.date_birth AS person_birth_date,
    (p.birth_place)::text AS person_birth_place,
    p.dismissed,
    p.podr_id,
    c.podr_name,
    c.podr_code,
    nsi.podr_get_linked_name(p.podr_id) AS podr_names,
    d.telephone_number
   FROM ((((doc.sd_ip_adresses a
     LEFT JOIN doc.sd_equipment_types b ON ((b.id = a.type_id)))
     LEFT JOIN exchange.spr_person p ON ((p.id = a.person_id)))
     LEFT JOIN nsi.spr_podr c ON ((p.podr_id_head = c.id)))
     LEFT JOIN exchange.spr_person_telephone_numbers d ON ((d.person_id = p.id)))
  ORDER BY a.datei;


ALTER TABLE doc.v_sd_ip_adresses OWNER TO sup;

--
-- Name: v_sd_resources_and_sections; Type: VIEW; Schema: doc; Owner: sup
--

CREATE VIEW doc.v_sd_resources_and_sections AS
 SELECT (("substring"((a.code)::text, '[^.]+'::text) || ' '::text) || (( SELECT COALESCE(sd_spr_resources.full_name, ''::character varying) AS "coalesce"
           FROM doc.sd_spr_resources
          WHERE ((sd_spr_resources.code)::text ~~ "substring"((a.code)::text, '[^.]+'::text))))::text) AS section,
    (("substring"((a.code)::text, '[^.]+.[^.]+'::text) || ' '::text) || (( SELECT COALESCE(sd_spr_resources.full_name, ''::character varying) AS "coalesce"
           FROM doc.sd_spr_resources
          WHERE ((sd_spr_resources.code)::text ~~ "substring"((a.code)::text, '[^.]+.[^.]+'::text))))::text) AS subsection,
    ( SELECT sd_spr_resources.full_name
           FROM doc.sd_spr_resources
          WHERE ((sd_spr_resources.code)::text ~~ "substring"((a.code)::text, '[^.]+'::text))) AS section_name,
    ( SELECT sd_spr_resources.code
           FROM doc.sd_spr_resources
          WHERE ((sd_spr_resources.code)::text ~~ "substring"((a.code)::text, '[^.]+'::text))) AS section_code,
    ( SELECT sd_spr_resources.id
           FROM doc.sd_spr_resources
          WHERE ((sd_spr_resources.code)::text ~~ "substring"((a.code)::text, '[^.]+'::text))) AS section_id,
    ( SELECT sd_spr_resources.full_name
           FROM doc.sd_spr_resources
          WHERE ((sd_spr_resources.code)::text ~~ "substring"((a.code)::text, '[^.]+.[^.]+'::text))) AS subsection_name,
    ( SELECT sd_spr_resources.code
           FROM doc.sd_spr_resources
          WHERE ((sd_spr_resources.code)::text ~~ "substring"((a.code)::text, '[^.]+.[^.]+'::text))) AS subsection_code,
    ( SELECT sd_spr_resources.id
           FROM doc.sd_spr_resources
          WHERE ((sd_spr_resources.code)::text ~~ "substring"((a.code)::text, '[^.]+.[^.]+'::text))) AS subsection_id,
    a.id,
    a.code,
    a.year_of_development,
    a.full_name,
    a.short_name,
    a.description,
    a.developer_person_id,
    a.implementer_id,
    a.domain_group,
    a.network_solution,
    a.status_id,
    a.development_environment_id,
    a.database_system_id,
    a.use_in_portal,
    a.use_in_postgres,
    (( SELECT string_agg((foo.podr_short_name)::text, '; '::text) AS string_agg
           FROM ( SELECT DISTINCT foo_b.podr_short_name
                   FROM (doc.sd_resources_access_rights foo_a
                     JOIN nsi.spr_podr foo_b ON ((foo_b.id = foo_a.podr_id)))
                  WHERE (foo_a.resource_id = a.id)) foo))::character varying AS owner_names,
    b.name AS status_name,
    c.name AS development_environment_name,
    d.name AS database_system_name,
    e.short_name AS implementer_short_name,
    e.full_name AS implementer_full_name,
    f.tab_nbr,
    f.family,
    f.name AS developer_name,
    f.patronymic,
    f.job,
    f.date_birth AS person_birth_date,
    (f.birth_place)::text AS person_birth_place,
    f.dismissed,
    f.podr_id,
    g.telephone_number,
    ((((initcap((f.family)::text) || ' '::text) || COALESCE((substr((f.name)::text, 1, 1) || '. '::text), ''::text)) || COALESCE((substr((f.patronymic)::text, 1, 1) || '.'::text), ''::text)))::character varying AS person_full_name
   FROM ((((((doc.sd_spr_resources a
     LEFT JOIN doc.sd_resource_statuses b ON ((b.id = a.status_id)))
     LEFT JOIN doc.sd_development_environment_names c ON ((c.id = a.development_environment_id)))
     LEFT JOIN doc.sd_database_system_names d ON ((d.id = a.database_system_id)))
     LEFT JOIN doc.sd_spr_laboratories e ON ((e.id = a.implementer_id)))
     LEFT JOIN exchange.spr_person f ON ((f.id = a.developer_person_id)))
     LEFT JOIN exchange.spr_person_telephone_numbers g ON ((g.person_id = f.id)))
  ORDER BY a.code;


ALTER TABLE doc.v_sd_resources_and_sections OWNER TO sup;

--
-- Name: v_sd_resources; Type: VIEW; Schema: doc; Owner: sup
--

CREATE VIEW doc.v_sd_resources AS
 SELECT a.section,
    a.subsection,
    a.section_name,
    a.section_code,
    a.section_id,
    a.subsection_name,
    a.subsection_code,
    a.subsection_id,
    a.id,
    a.code,
    a.year_of_development,
    a.full_name,
    a.short_name,
    a.description,
    a.developer_person_id,
    a.implementer_id,
    a.domain_group,
    a.network_solution,
    a.status_id,
    a.development_environment_id,
    a.database_system_id,
    a.use_in_portal,
    a.use_in_postgres,
    a.owner_names,
    a.status_name,
    a.development_environment_name,
    a.database_system_name,
    a.implementer_short_name,
    a.implementer_full_name,
    a.tab_nbr,
    a.family,
    a.developer_name,
    a.patronymic,
    a.job,
    a.person_birth_date,
    a.person_birth_place,
    a.dismissed,
    a.podr_id,
    a.telephone_number,
    a.person_full_name
   FROM doc.v_sd_resources_and_sections a
  WHERE (NOT (EXISTS ( SELECT 1
           FROM doc.sd_spr_resources a1
          WHERE ((a1.code)::text ~~ ((a.code)::text || '.%'::text)))))
  ORDER BY a.code;


ALTER TABLE doc.v_sd_resources OWNER TO sup;

--
-- Name: v_sd_resources_access_rights; Type: VIEW; Schema: doc; Owner: sup
--

CREATE VIEW doc.v_sd_resources_access_rights AS
 SELECT a.id,
    a.resource_id,
    a.right_type_id,
    a.podr_id,
    b.right_name,
    c.podr_code,
    c.podr_short_name,
    c.podr_name,
    c.begin_isp_dt,
    c.end_isp_dt
   FROM ((doc.sd_resources_access_rights a
     JOIN uac.spr_right_type b ON ((b.id = a.right_type_id)))
     JOIN nsi.spr_podr c ON ((c.id = a.podr_id)));


ALTER TABLE doc.v_sd_resources_access_rights OWNER TO sup;

--
-- Name: v_sd_serv_desk_requests; Type: VIEW; Schema: doc; Owner: sup
--

CREATE VIEW doc.v_sd_serv_desk_requests AS
 SELECT a.id,
    a.number,
    a.req_date,
    a.status,
    a.type_id,
    a.subtype_id,
    (a.short_description)::text AS short_description,
    (a.full_description)::text AS full_description,
    a.responsible_laboratory_id,
    a.who_finished_request,
    a.when_finished_request,
    a.applicant_id,
    a.applicant_inventory_num,
    b.name AS status_name,
    c.short_name AS lab_short_name,
    c.full_name AS lab_full_name,
    d.name AS type_name,
    d.laboratory_id AS type_laboratory_id,
    e.type_id AS subtype_type_id,
    e.name AS subtype_name,
    exchange.person_get_fio_by_login(a.who_finished_request) AS who_finished_request_name,
    (((((initcap((p.family)::text) || ' '::text) || initcap((p.name)::text)) || ' '::text) || initcap((p.patronymic)::text)))::character varying AS applicant_full_name,
    ((((initcap((p.family)::text) || ' '::text) || COALESCE((substr((p.name)::text, 1, 1) || '. '::text), ''::text)) || COALESCE((substr((p.patronymic)::text, 1, 1) || '.'::text), ''::text)))::character varying AS applicant_short_name,
    p.family AS applicant_family,
    p.name AS applicant_name,
    p.patronymic AS applicant_patronymic,
    p.tab_nbr AS applicant_tab_nbr,
    p.job AS applicant_job,
    p.date_birth AS applicant_birth_date,
    (p.birth_place)::text AS applicant_birth_place,
    p.dismissed,
    p.podr_id,
    podr.podr_name,
    podr.podr_code,
    nsi.podr_get_linked_name(p.podr_id) AS podr_names,
    tel.telephone_number,
    (((podr.podr_code)::text || ' - '::text) || (podr.podr_name)::text) AS applicant_podr,
    a.date_of_execution,
        CASE
            WHEN ((a.status = 1) OR (a.status = 4)) THEN false
            WHEN (a.date_of_execution IS NULL) THEN ((now())::date > ((a.req_date + '13 days'::interval))::date)
            ELSE ((now())::date > a.date_of_execution)
        END AS is_expired
   FROM (((((((doc.sd_serv_desc_requests a
     LEFT JOIN doc.sd_serv_desk_request_statuses b ON ((b.id = a.status)))
     LEFT JOIN doc.sd_spr_laboratories c ON ((c.id = a.responsible_laboratory_id)))
     LEFT JOIN doc.sd_serv_desk_request_types d ON ((d.id = a.type_id)))
     LEFT JOIN doc.sd_serv_desk_request_subtypes e ON ((e.id = a.subtype_id)))
     LEFT JOIN exchange.spr_person p ON ((p.id = a.applicant_id)))
     LEFT JOIN nsi.spr_podr podr ON ((p.podr_id = podr.id)))
     LEFT JOIN exchange.spr_person_telephone_numbers tel ON ((tel.person_id = p.id)))
  ORDER BY a.id;


ALTER TABLE doc.v_sd_serv_desk_requests OWNER TO sup;

--
-- Name: v_sd_serv_desk_resp_persons_for_exec_req; Type: VIEW; Schema: doc; Owner: sup
--

CREATE VIEW doc.v_sd_serv_desk_resp_persons_for_exec_req AS
 SELECT a.id,
    a.request_id,
    a.laboratory_id,
    a.person_id,
    a.datei,
    a.comment,
    ((((initcap((p.family)::text) || ' '::text) || COALESCE((substr((p.name)::text, 1, 1) || '. '::text), ''::text)) || COALESCE((substr((p.patronymic)::text, 1, 1) || '.'::text), ''::text)))::character varying AS person_full_name,
    p.family AS person_family,
    p.name AS person_name,
    p.patronymic AS person_patronymic,
    p.tab_nbr AS person_tab_nbr,
    p.job AS person_job,
    p.date_birth AS person_birth_date,
    (p.birth_place)::text AS person_birth_place,
    p.dismissed,
    p.podr_id,
    c.podr_name,
    c.podr_code,
    t.telephone_number,
    l.short_name AS lab_short_name,
    l.full_name AS lab_full_name
   FROM ((((doc.sd_serv_desc_resp_for_exec_requests a
     LEFT JOIN exchange.spr_person p ON ((p.id = a.person_id)))
     LEFT JOIN nsi.spr_podr c ON ((p.podr_id_head = c.id)))
     LEFT JOIN exchange.spr_person_telephone_numbers t ON ((t.person_id = p.id)))
     LEFT JOIN doc.sd_spr_laboratories l ON ((l.id = a.laboratory_id)))
  ORDER BY a.id;


ALTER TABLE doc.v_sd_serv_desk_resp_persons_for_exec_req OWNER TO sup;

--
-- Name: versions_info; Type: TABLE; Schema: doc; Owner: developers
--

CREATE TABLE doc.versions_info (
    id integer NOT NULL,
    version_nbr character varying,
    version_date timestamp without time zone DEFAULT now(),
    description text,
    file_path character varying,
    is_visible boolean DEFAULT false,
    useri character varying DEFAULT SESSION_USER,
    datei timestamp without time zone DEFAULT now()
);


ALTER TABLE doc.versions_info OWNER TO developers;

--
-- Name: TABLE versions_info; Type: COMMENT; Schema: doc; Owner: developers
--

COMMENT ON TABLE doc.versions_info IS 'История версий с описанием';


--
-- Name: COLUMN versions_info.id; Type: COMMENT; Schema: doc; Owner: developers
--

COMMENT ON COLUMN doc.versions_info.id IS 'Идентификатор версии';


--
-- Name: COLUMN versions_info.version_nbr; Type: COMMENT; Schema: doc; Owner: developers
--

COMMENT ON COLUMN doc.versions_info.version_nbr IS 'Номер версии';


--
-- Name: COLUMN versions_info.version_date; Type: COMMENT; Schema: doc; Owner: developers
--

COMMENT ON COLUMN doc.versions_info.version_date IS 'Дата версии';


--
-- Name: COLUMN versions_info.description; Type: COMMENT; Schema: doc; Owner: developers
--

COMMENT ON COLUMN doc.versions_info.description IS 'Описание';


--
-- Name: COLUMN versions_info.file_path; Type: COMMENT; Schema: doc; Owner: developers
--

COMMENT ON COLUMN doc.versions_info.file_path IS 'Путь к файлу с инструкцией';


--
-- Name: versions_info_id_seq; Type: SEQUENCE; Schema: doc; Owner: developers
--

CREATE SEQUENCE doc.versions_info_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE doc.versions_info_id_seq OWNER TO developers;

--
-- Name: versions_info_id_seq; Type: SEQUENCE OWNED BY; Schema: doc; Owner: developers
--

ALTER SEQUENCE doc.versions_info_id_seq OWNED BY doc.versions_info.id;


--
-- Name: acceptance_posting_kinds id; Type: DEFAULT; Schema: doc; Owner: developers
--

ALTER TABLE ONLY doc.acceptance_posting_kinds ALTER COLUMN id SET DEFAULT nextval('doc.acceptance_posting_kinds_id_seq'::regclass);


--
-- Name: department_email id; Type: DEFAULT; Schema: doc; Owner: developers
--

ALTER TABLE ONLY doc.department_email ALTER COLUMN id SET DEFAULT nextval('doc.department_email_id_seq'::regclass);


--
-- Name: document_approving_results id; Type: DEFAULT; Schema: doc; Owner: developers
--

ALTER TABLE ONLY doc.document_approving_results ALTER COLUMN id SET DEFAULT nextval('doc.document_approving_results_id_seq'::regclass);


--
-- Name: document_approvings id; Type: DEFAULT; Schema: doc; Owner: developers
--

ALTER TABLE ONLY doc.document_approvings ALTER COLUMN id SET DEFAULT nextval('doc.document_approvings_id_seq'::regclass);


--
-- Name: document_charge_types id; Type: DEFAULT; Schema: doc; Owner: developers
--

ALTER TABLE ONLY doc.document_charge_types ALTER COLUMN id SET DEFAULT nextval('doc.document_charge_types_id_seq'::regclass);


--
-- Name: document_file_metadata id; Type: DEFAULT; Schema: doc; Owner: developers
--

ALTER TABLE ONLY doc.document_file_metadata ALTER COLUMN id SET DEFAULT nextval('doc.document_file_metadata_uit_id_seq'::regclass);


--
-- Name: document_links id; Type: DEFAULT; Schema: doc; Owner: developers
--

ALTER TABLE ONLY doc.document_links ALTER COLUMN id SET DEFAULT nextval('doc.document_links_uit_id_seq'::regclass);


--
-- Name: document_numerators id; Type: DEFAULT; Schema: doc; Owner: developers
--

ALTER TABLE ONLY doc.document_numerators ALTER COLUMN id SET DEFAULT nextval('doc.document_numerators_id_seq'::regclass);


--
-- Name: document_receivers id; Type: DEFAULT; Schema: doc; Owner: developers
--

ALTER TABLE ONLY doc.document_receivers ALTER COLUMN id SET DEFAULT nextval('doc.document_receivers_uit_id_seq'::regclass);


--
-- Name: document_signings id; Type: DEFAULT; Schema: doc; Owner: developers
--

ALTER TABLE ONLY doc.document_signings ALTER COLUMN id SET DEFAULT nextval('doc.document_signings_id_seq'::regclass);


--
-- Name: document_type_work_cycle_stages id; Type: DEFAULT; Schema: doc; Owner: developers
--

ALTER TABLE ONLY doc.document_type_work_cycle_stages ALTER COLUMN id SET DEFAULT nextval('doc.document_life_cycle_stages_id_seq'::regclass);


--
-- Name: document_types id; Type: DEFAULT; Schema: doc; Owner: developers
--

ALTER TABLE ONLY doc.document_types ALTER COLUMN id SET DEFAULT nextval('doc.document_types_id_seq'::regclass);


--
-- Name: document_types_allowable_document_charges_types id; Type: DEFAULT; Schema: doc; Owner: developers
--

ALTER TABLE ONLY doc.document_types_allowable_document_charges_types ALTER COLUMN id SET DEFAULT nextval('doc.document_types_allowable_document_charges_types_id_seq'::regclass);


--
-- Name: documents_view_access_rights id; Type: DEFAULT; Schema: doc; Owner: developers
--

ALTER TABLE ONLY doc.documents_view_access_rights ALTER COLUMN id SET DEFAULT nextval('doc.documents_view_access_rights_id_seq'::regclass);


--
-- Name: employee_replacements id; Type: DEFAULT; Schema: doc; Owner: developers
--

ALTER TABLE ONLY doc.employee_replacements ALTER COLUMN id SET DEFAULT nextval('doc.employee_replacements_id_seq'::regclass);


--
-- Name: employee_work_groups id; Type: DEFAULT; Schema: doc; Owner: developers
--

ALTER TABLE ONLY doc.employee_work_groups ALTER COLUMN id SET DEFAULT nextval('doc.employee_work_groups_id_seq'::regclass);


--
-- Name: employees id; Type: DEFAULT; Schema: doc; Owner: developers
--

ALTER TABLE ONLY doc.employees ALTER COLUMN id SET DEFAULT nextval('doc.employees_outside_id_seq'::regclass);


--
-- Name: employees_employee_work_groups id; Type: DEFAULT; Schema: doc; Owner: developers
--

ALTER TABLE ONLY doc.employees_employee_work_groups ALTER COLUMN id SET DEFAULT nextval('doc.employees_employee_work_groups_id_seq'::regclass);


--
-- Name: looked_documents id; Type: DEFAULT; Schema: doc; Owner: developers
--

ALTER TABLE ONLY doc.looked_documents ALTER COLUMN id SET DEFAULT nextval('doc.looked_documents_id_seq'::regclass);


--
-- Name: looked_personnel_orders id; Type: DEFAULT; Schema: doc; Owner: developers
--

ALTER TABLE ONLY doc.looked_personnel_orders ALTER COLUMN id SET DEFAULT nextval('doc.looked_personnel_orders_id_seq'::regclass);


--
-- Name: looked_service_notes id; Type: DEFAULT; Schema: doc; Owner: developers
--

ALTER TABLE ONLY doc.looked_service_notes ALTER COLUMN id SET DEFAULT nextval('doc.looked_service_notes_id_seq'::regclass);


--
-- Name: personnel_order_approvings id; Type: DEFAULT; Schema: doc; Owner: developers
--

ALTER TABLE ONLY doc.personnel_order_approvings ALTER COLUMN id SET DEFAULT nextval('doc.personnel_order_approvings_id_seq'::regclass);


--
-- Name: personnel_order_charges id; Type: DEFAULT; Schema: doc; Owner: developers
--

ALTER TABLE ONLY doc.personnel_order_charges ALTER COLUMN id SET DEFAULT nextval('doc.personnel_order_charges_id_seq'::regclass);


--
-- Name: personnel_order_control_groups id; Type: DEFAULT; Schema: doc; Owner: developers
--

ALTER TABLE ONLY doc.personnel_order_control_groups ALTER COLUMN id SET DEFAULT nextval('doc.personnel_order_control_groups_id_seq'::regclass);


--
-- Name: personnel_order_control_groups__employees id; Type: DEFAULT; Schema: doc; Owner: developers
--

ALTER TABLE ONLY doc.personnel_order_control_groups__employees ALTER COLUMN id SET DEFAULT nextval('doc.personnel_order_control_groups__employees_id_seq'::regclass);


--
-- Name: personnel_order_control_groups__sub_kinds id; Type: DEFAULT; Schema: doc; Owner: developers
--

ALTER TABLE ONLY doc.personnel_order_control_groups__sub_kinds ALTER COLUMN id SET DEFAULT nextval('doc.personnel_order_control_groups__sub_kinds_id_seq'::regclass);


--
-- Name: personnel_order_file_metadata id; Type: DEFAULT; Schema: doc; Owner: developers
--

ALTER TABLE ONLY doc.personnel_order_file_metadata ALTER COLUMN id SET DEFAULT nextval('doc.personnel_order_file_metadata_id_seq'::regclass);


--
-- Name: personnel_order_links id; Type: DEFAULT; Schema: doc; Owner: developers
--

ALTER TABLE ONLY doc.personnel_order_links ALTER COLUMN id SET DEFAULT nextval('doc.personnel_order_links_id_seq'::regclass);


--
-- Name: personnel_order_signings id; Type: DEFAULT; Schema: doc; Owner: developers
--

ALTER TABLE ONLY doc.personnel_order_signings ALTER COLUMN id SET DEFAULT nextval('doc.personnel_order_signings_id_seq'::regclass);


--
-- Name: personnel_order_sub_kinds id; Type: DEFAULT; Schema: doc; Owner: developers
--

ALTER TABLE ONLY doc.personnel_order_sub_kinds ALTER COLUMN id SET DEFAULT nextval('doc.personnel_order_sub_kinds_id_seq'::regclass);


--
-- Name: personnel_order_sub_kinds__approvers id; Type: DEFAULT; Schema: doc; Owner: developers
--

ALTER TABLE ONLY doc.personnel_order_sub_kinds__approvers ALTER COLUMN id SET DEFAULT nextval('doc.personnel_order_sub_kinds__approvers_id_seq'::regclass);


--
-- Name: plant_structure_access_employees id; Type: DEFAULT; Schema: doc; Owner: developers
--

ALTER TABLE ONLY doc.plant_structure_access_employees ALTER COLUMN id SET DEFAULT nextval('doc.plant_structure_access_employees_id_seq'::regclass);


--
-- Name: role_rights id; Type: DEFAULT; Schema: doc; Owner: developers
--

ALTER TABLE ONLY doc.role_rights ALTER COLUMN id SET DEFAULT nextval('doc.role_rights_id_seq'::regclass);


--
-- Name: roles id; Type: DEFAULT; Schema: doc; Owner: developers
--

ALTER TABLE ONLY doc.roles ALTER COLUMN id SET DEFAULT nextval('doc.roles_id_seq'::regclass);


--
-- Name: sd_database_system_names id; Type: DEFAULT; Schema: doc; Owner: sup
--

ALTER TABLE ONLY doc.sd_database_system_names ALTER COLUMN id SET DEFAULT nextval('doc.sd_database_system_names_id_seq'::regclass);


--
-- Name: sd_development_environment_names id; Type: DEFAULT; Schema: doc; Owner: sup
--

ALTER TABLE ONLY doc.sd_development_environment_names ALTER COLUMN id SET DEFAULT nextval('doc.sd_development_environment_names_id_seq'::regclass);


--
-- Name: sd_equipment_types id; Type: DEFAULT; Schema: doc; Owner: sup
--

ALTER TABLE ONLY doc.sd_equipment_types ALTER COLUMN id SET DEFAULT nextval('doc.sd_equipment_types_id_seq'::regclass);


--
-- Name: sd_ip_adresses id; Type: DEFAULT; Schema: doc; Owner: sup
--

ALTER TABLE ONLY doc.sd_ip_adresses ALTER COLUMN id SET DEFAULT nextval('doc.sd_ip_adresses_id_seq'::regclass);


--
-- Name: sd_resource_statuses id; Type: DEFAULT; Schema: doc; Owner: sup
--

ALTER TABLE ONLY doc.sd_resource_statuses ALTER COLUMN id SET DEFAULT nextval('doc.sd_resource_statuses_id_seq'::regclass);


--
-- Name: sd_resources_access_rights id; Type: DEFAULT; Schema: doc; Owner: sup
--

ALTER TABLE ONLY doc.sd_resources_access_rights ALTER COLUMN id SET DEFAULT nextval('doc.sd_resources_access_rights_id_seq'::regclass);


--
-- Name: sd_serv_desc_requests id; Type: DEFAULT; Schema: doc; Owner: sup
--

ALTER TABLE ONLY doc.sd_serv_desc_requests ALTER COLUMN id SET DEFAULT nextval('doc.sd_serv_desc_requests_id_seq'::regclass);


--
-- Name: sd_serv_desc_resp_for_exec_requests id; Type: DEFAULT; Schema: doc; Owner: sup
--

ALTER TABLE ONLY doc.sd_serv_desc_resp_for_exec_requests ALTER COLUMN id SET DEFAULT nextval('doc.sd_serv_desc_resp_for_exec_requests_id_seq'::regclass);


--
-- Name: sd_serv_desk_request_statuses id; Type: DEFAULT; Schema: doc; Owner: sup
--

ALTER TABLE ONLY doc.sd_serv_desk_request_statuses ALTER COLUMN id SET DEFAULT nextval('doc.sd_serv_desk_request_statuses_id_seq'::regclass);


--
-- Name: sd_serv_desk_request_subtypes id; Type: DEFAULT; Schema: doc; Owner: sup
--

ALTER TABLE ONLY doc.sd_serv_desk_request_subtypes ALTER COLUMN id SET DEFAULT nextval('doc.sd_serv_desk_request_subtypes_id_seq'::regclass);


--
-- Name: sd_serv_desk_request_types id; Type: DEFAULT; Schema: doc; Owner: sup
--

ALTER TABLE ONLY doc.sd_serv_desk_request_types ALTER COLUMN id SET DEFAULT nextval('doc.sd_serv_desk_request_types_id_seq'::regclass);


--
-- Name: sd_spr_equipment id; Type: DEFAULT; Schema: doc; Owner: sup
--

ALTER TABLE ONLY doc.sd_spr_equipment ALTER COLUMN id SET DEFAULT nextval('doc.sd_spr_equipment_id_seq'::regclass);


--
-- Name: sd_spr_laboratories id; Type: DEFAULT; Schema: doc; Owner: sup
--

ALTER TABLE ONLY doc.sd_spr_laboratories ALTER COLUMN id SET DEFAULT nextval('doc.sd_spr_laboratories_id_seq'::regclass);


--
-- Name: sd_spr_resources id; Type: DEFAULT; Schema: doc; Owner: sup
--

ALTER TABLE ONLY doc.sd_spr_resources ALTER COLUMN id SET DEFAULT nextval('doc.sd_spr_resources_id_seq'::regclass);


--
-- Name: service_note_approvings id; Type: DEFAULT; Schema: doc; Owner: developers
--

ALTER TABLE ONLY doc.service_note_approvings ALTER COLUMN id SET DEFAULT nextval('doc.service_note_approvings_id_seq'::regclass);


--
-- Name: service_note_signings id; Type: DEFAULT; Schema: doc; Owner: developers
--

ALTER TABLE ONLY doc.service_note_signings ALTER COLUMN id SET DEFAULT nextval('doc.service_note_signings_id_seq'::regclass);


--
-- Name: system_roles id; Type: DEFAULT; Schema: doc; Owner: developers
--

ALTER TABLE ONLY doc.system_roles ALTER COLUMN id SET DEFAULT nextval('doc.system_roles_id_seq'::regclass);


--
-- Name: versions_info id; Type: DEFAULT; Schema: doc; Owner: developers
--

ALTER TABLE ONLY doc.versions_info ALTER COLUMN id SET DEFAULT nextval('doc.versions_info_id_seq'::regclass);


--
-- Name: acceptance_posting_kinds acceptance_posting_kinds_pkey; Type: CONSTRAINT; Schema: doc; Owner: developers
--

ALTER TABLE ONLY doc.acceptance_posting_kinds
    ADD CONSTRAINT acceptance_posting_kinds_pkey PRIMARY KEY (id);


--
-- Name: correspondence_creating_access_employee correspondence_creating_access_employee_pkey; Type: CONSTRAINT; Schema: doc; Owner: developers
--

ALTER TABLE ONLY doc.correspondence_creating_access_employee
    ADD CONSTRAINT correspondence_creating_access_employee_pkey PRIMARY KEY (employee_id);


--
-- Name: correspondents correspondents_pk; Type: CONSTRAINT; Schema: doc; Owner: developers
--

ALTER TABLE ONLY doc.correspondents
    ADD CONSTRAINT correspondents_pk PRIMARY KEY (cod_correspondent);


--
-- Name: departments departments_pkey; Type: CONSTRAINT; Schema: doc; Owner: developers
--

ALTER TABLE ONLY doc.departments
    ADD CONSTRAINT departments_pkey PRIMARY KEY (id);


--
-- Name: document_approving_results document_approving_results_pkey; Type: CONSTRAINT; Schema: doc; Owner: developers
--

ALTER TABLE ONLY doc.document_approving_results
    ADD CONSTRAINT document_approving_results_pkey PRIMARY KEY (id);


--
-- Name: document_approvings document_approvings_pkey; Type: CONSTRAINT; Schema: doc; Owner: developers
--

ALTER TABLE ONLY doc.document_approvings
    ADD CONSTRAINT document_approvings_pkey PRIMARY KEY (id);


--
-- Name: document_charge_types document_charge_types_pkey; Type: CONSTRAINT; Schema: doc; Owner: developers
--

ALTER TABLE ONLY doc.document_charge_types
    ADD CONSTRAINT document_charge_types_pkey PRIMARY KEY (id);


--
-- Name: document_file_metadata document_file_metadata_uit_pkey; Type: CONSTRAINT; Schema: doc; Owner: developers
--

ALTER TABLE ONLY doc.document_file_metadata
    ADD CONSTRAINT document_file_metadata_uit_pkey PRIMARY KEY (id);


--
-- Name: document_type_work_cycle_stages document_life_cycle_stages_pkey; Type: CONSTRAINT; Schema: doc; Owner: developers
--

ALTER TABLE ONLY doc.document_type_work_cycle_stages
    ADD CONSTRAINT document_life_cycle_stages_pkey PRIMARY KEY (id);


--
-- Name: document_links document_links_uit_pkey; Type: CONSTRAINT; Schema: doc; Owner: developers
--

ALTER TABLE ONLY doc.document_links
    ADD CONSTRAINT document_links_uit_pkey PRIMARY KEY (id);


--
-- Name: document_numerators document_numerators_pkey; Type: CONSTRAINT; Schema: doc; Owner: developers
--

ALTER TABLE ONLY doc.document_numerators
    ADD CONSTRAINT document_numerators_pkey PRIMARY KEY (id);


--
-- Name: document_receivers document_receivers_uit_pkey; Type: CONSTRAINT; Schema: doc; Owner: developers
--

ALTER TABLE ONLY doc.document_receivers
    ADD CONSTRAINT document_receivers_uit_pkey PRIMARY KEY (id);


--
-- Name: document_signings document_signings_pkey; Type: CONSTRAINT; Schema: doc; Owner: developers
--

ALTER TABLE ONLY doc.document_signings
    ADD CONSTRAINT document_signings_pkey PRIMARY KEY (id);


--
-- Name: document_types document_type_name_and_parent_type_id_unique; Type: CONSTRAINT; Schema: doc; Owner: developers
--

ALTER TABLE ONLY doc.document_types
    ADD CONSTRAINT document_type_name_and_parent_type_id_unique UNIQUE (name, parent_type_id);


--
-- Name: document_types_allowable_document_charges_types document_types_allowable_document_charges_types_pkey; Type: CONSTRAINT; Schema: doc; Owner: developers
--

ALTER TABLE ONLY doc.document_types_allowable_document_charges_types
    ADD CONSTRAINT document_types_allowable_document_charges_types_pkey PRIMARY KEY (id);


--
-- Name: document_types document_types_pkey; Type: CONSTRAINT; Schema: doc; Owner: developers
--

ALTER TABLE ONLY doc.document_types
    ADD CONSTRAINT document_types_pkey PRIMARY KEY (id);


--
-- Name: documents documents_pkey; Type: CONSTRAINT; Schema: doc; Owner: developers
--

ALTER TABLE ONLY doc.documents
    ADD CONSTRAINT documents_pkey PRIMARY KEY (id);


--
-- Name: documents_view_access_rights documents_view_access_rights_pkey; Type: CONSTRAINT; Schema: doc; Owner: developers
--

ALTER TABLE ONLY doc.documents_view_access_rights
    ADD CONSTRAINT documents_view_access_rights_pkey PRIMARY KEY (id);


--
-- Name: employee_replacements employee_replacements_pkey; Type: CONSTRAINT; Schema: doc; Owner: developers
--

ALTER TABLE ONLY doc.employee_replacements
    ADD CONSTRAINT employee_replacements_pkey PRIMARY KEY (id);


--
-- Name: employee_replacements employee_replacements_unique; Type: CONSTRAINT; Schema: doc; Owner: developers
--

ALTER TABLE ONLY doc.employee_replacements
    ADD CONSTRAINT employee_replacements_unique UNIQUE (replaceable_id, deputy_id);


--
-- Name: employees_employee_work_groups employee_work_group_unique; Type: CONSTRAINT; Schema: doc; Owner: developers
--

ALTER TABLE ONLY doc.employees_employee_work_groups
    ADD CONSTRAINT employee_work_group_unique UNIQUE (employee_id, work_group_id);


--
-- Name: employee_work_groups employee_work_groups_pkey; Type: CONSTRAINT; Schema: doc; Owner: developers
--

ALTER TABLE ONLY doc.employee_work_groups
    ADD CONSTRAINT employee_work_groups_pkey PRIMARY KEY (id);


--
-- Name: employees_employee_work_groups employees_employee_work_groups_pkey; Type: CONSTRAINT; Schema: doc; Owner: developers
--

ALTER TABLE ONLY doc.employees_employee_work_groups
    ADD CONSTRAINT employees_employee_work_groups_pkey PRIMARY KEY (id);


--
-- Name: employees employees_pkey; Type: CONSTRAINT; Schema: doc; Owner: developers
--

ALTER TABLE ONLY doc.employees
    ADD CONSTRAINT employees_pkey PRIMARY KEY (id);


--
-- Name: employees_roles employees_roles_pkey; Type: CONSTRAINT; Schema: doc; Owner: developers
--

ALTER TABLE ONLY doc.employees_roles
    ADD CONSTRAINT employees_roles_pkey PRIMARY KEY (employee_id, role_id);


--
-- Name: employees_system_roles employees_system_roles_pkey; Type: CONSTRAINT; Schema: doc; Owner: developers
--

ALTER TABLE ONLY doc.employees_system_roles
    ADD CONSTRAINT employees_system_roles_pkey PRIMARY KEY (employee_id, system_role_id);


--
-- Name: sd_equipment_types equipment_types_pkey; Type: CONSTRAINT; Schema: doc; Owner: sup
--

ALTER TABLE ONLY doc.sd_equipment_types
    ADD CONSTRAINT equipment_types_pkey PRIMARY KEY (id);


--
-- Name: sd_ip_adresses inventory_number_unique; Type: CONSTRAINT; Schema: doc; Owner: sup
--

ALTER TABLE ONLY doc.sd_ip_adresses
    ADD CONSTRAINT inventory_number_unique UNIQUE (inventory_number);


--
-- Name: sd_ip_adresses ip_adresses_pkey; Type: CONSTRAINT; Schema: doc; Owner: sup
--

ALTER TABLE ONLY doc.sd_ip_adresses
    ADD CONSTRAINT ip_adresses_pkey PRIMARY KEY (id);


--
-- Name: sd_ip_adresses ip_unique; Type: CONSTRAINT; Schema: doc; Owner: sup
--

ALTER TABLE ONLY doc.sd_ip_adresses
    ADD CONSTRAINT ip_unique UNIQUE (ip_adr_1, ip_adr_2, ip_adr_3, ip_adr_4);


--
-- Name: looked_document_charges looked_document_charges_pkey; Type: CONSTRAINT; Schema: doc; Owner: developers
--

ALTER TABLE ONLY doc.looked_document_charges
    ADD CONSTRAINT looked_document_charges_pkey PRIMARY KEY (charge_id, employee_id);


--
-- Name: looked_documents looked_documents_pkey; Type: CONSTRAINT; Schema: doc; Owner: developers
--

ALTER TABLE ONLY doc.looked_documents
    ADD CONSTRAINT looked_documents_pkey PRIMARY KEY (id);


--
-- Name: looked_service_note_charges looked_service_note_charges_pkey; Type: CONSTRAINT; Schema: doc; Owner: developers
--

ALTER TABLE ONLY doc.looked_service_note_charges
    ADD CONSTRAINT looked_service_note_charges_pkey PRIMARY KEY (charge_id, employee_id);


--
-- Name: looked_service_notes looked_service_notes_pkey; Type: CONSTRAINT; Schema: doc; Owner: developers
--

ALTER TABLE ONLY doc.looked_service_notes
    ADD CONSTRAINT looked_service_notes_pkey PRIMARY KEY (id);


--
-- Name: personnel_order_charges personnel_order_charges_pkey; Type: CONSTRAINT; Schema: doc; Owner: developers
--

ALTER TABLE ONLY doc.personnel_order_charges
    ADD CONSTRAINT personnel_order_charges_pkey PRIMARY KEY (id);


--
-- Name: personnel_order_control_groups__employees personnel_order_control_groups__employees_pkey; Type: CONSTRAINT; Schema: doc; Owner: developers
--

ALTER TABLE ONLY doc.personnel_order_control_groups__employees
    ADD CONSTRAINT personnel_order_control_groups__employees_pkey PRIMARY KEY (id);


--
-- Name: personnel_order_control_groups__sub_kinds personnel_order_control_groups__sub_kinds_pkey; Type: CONSTRAINT; Schema: doc; Owner: developers
--

ALTER TABLE ONLY doc.personnel_order_control_groups__sub_kinds
    ADD CONSTRAINT personnel_order_control_groups__sub_kinds_pkey PRIMARY KEY (id);


--
-- Name: personnel_order_control_groups personnel_order_control_groups_name_key; Type: CONSTRAINT; Schema: doc; Owner: developers
--

ALTER TABLE ONLY doc.personnel_order_control_groups
    ADD CONSTRAINT personnel_order_control_groups_name_key UNIQUE (name);


--
-- Name: personnel_order_control_groups personnel_order_control_groups_pkey; Type: CONSTRAINT; Schema: doc; Owner: developers
--

ALTER TABLE ONLY doc.personnel_order_control_groups
    ADD CONSTRAINT personnel_order_control_groups_pkey PRIMARY KEY (id);


--
-- Name: personnel_order_creating_access_employees personnel_order_creating_access_employees_pkey; Type: CONSTRAINT; Schema: doc; Owner: developers
--

ALTER TABLE ONLY doc.personnel_order_creating_access_employees
    ADD CONSTRAINT personnel_order_creating_access_employees_pkey PRIMARY KEY (employee_id);


--
-- Name: personnel_order_file_metadata personnel_order_file_metadata_pkey; Type: CONSTRAINT; Schema: doc; Owner: developers
--

ALTER TABLE ONLY doc.personnel_order_file_metadata
    ADD CONSTRAINT personnel_order_file_metadata_pkey PRIMARY KEY (id);


--
-- Name: personnel_order_links personnel_order_links_pkey; Type: CONSTRAINT; Schema: doc; Owner: developers
--

ALTER TABLE ONLY doc.personnel_order_links
    ADD CONSTRAINT personnel_order_links_pkey PRIMARY KEY (id);


--
-- Name: personnel_order_signers personnel_order_signers_pkey; Type: CONSTRAINT; Schema: doc; Owner: developers
--

ALTER TABLE ONLY doc.personnel_order_signers
    ADD CONSTRAINT personnel_order_signers_pkey PRIMARY KEY (signer_id);


--
-- Name: personnel_order_signings personnel_order_signings_pkey; Type: CONSTRAINT; Schema: doc; Owner: developers
--

ALTER TABLE ONLY doc.personnel_order_signings
    ADD CONSTRAINT personnel_order_signings_pkey PRIMARY KEY (id);


--
-- Name: personnel_order_sub_kinds__approvers personnel_order_sub_kinds__approvers_pkey; Type: CONSTRAINT; Schema: doc; Owner: developers
--

ALTER TABLE ONLY doc.personnel_order_sub_kinds__approvers
    ADD CONSTRAINT personnel_order_sub_kinds__approvers_pkey PRIMARY KEY (id);


--
-- Name: personnel_order_sub_kinds personnel_order_sub_kinds_name_key; Type: CONSTRAINT; Schema: doc; Owner: developers
--

ALTER TABLE ONLY doc.personnel_order_sub_kinds
    ADD CONSTRAINT personnel_order_sub_kinds_name_key UNIQUE (name);


--
-- Name: personnel_order_sub_kinds personnel_order_sub_kinds_pkey; Type: CONSTRAINT; Schema: doc; Owner: developers
--

ALTER TABLE ONLY doc.personnel_order_sub_kinds
    ADD CONSTRAINT personnel_order_sub_kinds_pkey PRIMARY KEY (id);


--
-- Name: personnel_orders personnel_orders_pkey; Type: CONSTRAINT; Schema: doc; Owner: developers
--

ALTER TABLE ONLY doc.personnel_orders
    ADD CONSTRAINT personnel_orders_pkey PRIMARY KEY (id);


--
-- Name: department_email pk_department_email; Type: CONSTRAINT; Schema: doc; Owner: developers
--

ALTER TABLE ONLY doc.department_email
    ADD CONSTRAINT pk_department_email PRIMARY KEY (id);


--
-- Name: plant_structure_access_employees pk_plant_structure_access_empl; Type: CONSTRAINT; Schema: doc; Owner: developers
--

ALTER TABLE ONLY doc.plant_structure_access_employees
    ADD CONSTRAINT pk_plant_structure_access_empl PRIMARY KEY (id);


--
-- Name: roles_role_rights primary_key_constraint; Type: CONSTRAINT; Schema: doc; Owner: developers
--

ALTER TABLE ONLY doc.roles_role_rights
    ADD CONSTRAINT primary_key_constraint PRIMARY KEY (role_id, role_right_id);


--
-- Name: role_rights role_rights_pkey; Type: CONSTRAINT; Schema: doc; Owner: developers
--

ALTER TABLE ONLY doc.role_rights
    ADD CONSTRAINT role_rights_pkey PRIMARY KEY (id);


--
-- Name: roles roles_pkey; Type: CONSTRAINT; Schema: doc; Owner: developers
--

ALTER TABLE ONLY doc.roles
    ADD CONSTRAINT roles_pkey PRIMARY KEY (id);


--
-- Name: roles roles_unique_name; Type: CONSTRAINT; Schema: doc; Owner: developers
--

ALTER TABLE ONLY doc.roles
    ADD CONSTRAINT roles_unique_name UNIQUE (name);


--
-- Name: sd_database_system_names sd_database_system_names_pkey; Type: CONSTRAINT; Schema: doc; Owner: sup
--

ALTER TABLE ONLY doc.sd_database_system_names
    ADD CONSTRAINT sd_database_system_names_pkey PRIMARY KEY (id);


--
-- Name: sd_development_environment_names sd_development_environment_names_pkey; Type: CONSTRAINT; Schema: doc; Owner: sup
--

ALTER TABLE ONLY doc.sd_development_environment_names
    ADD CONSTRAINT sd_development_environment_names_pkey PRIMARY KEY (id);


--
-- Name: sd_resource_statuses sd_resource_statuses_pkey; Type: CONSTRAINT; Schema: doc; Owner: sup
--

ALTER TABLE ONLY doc.sd_resource_statuses
    ADD CONSTRAINT sd_resource_statuses_pkey PRIMARY KEY (id);


--
-- Name: sd_resources_access_rights sd_resources_access_rights_pkey; Type: CONSTRAINT; Schema: doc; Owner: sup
--

ALTER TABLE ONLY doc.sd_resources_access_rights
    ADD CONSTRAINT sd_resources_access_rights_pkey PRIMARY KEY (id);


--
-- Name: sd_serv_desc_requests sd_serv_desc_requests_pkey; Type: CONSTRAINT; Schema: doc; Owner: sup
--

ALTER TABLE ONLY doc.sd_serv_desc_requests
    ADD CONSTRAINT sd_serv_desc_requests_pkey PRIMARY KEY (id);


--
-- Name: sd_serv_desc_resp_for_exec_requests sd_serv_desc_resp_for_exec_requests_pkey; Type: CONSTRAINT; Schema: doc; Owner: sup
--

ALTER TABLE ONLY doc.sd_serv_desc_resp_for_exec_requests
    ADD CONSTRAINT sd_serv_desc_resp_for_exec_requests_pkey PRIMARY KEY (id);


--
-- Name: sd_serv_desk_request_statuses sd_serv_desk_request_statuses_pkey; Type: CONSTRAINT; Schema: doc; Owner: sup
--

ALTER TABLE ONLY doc.sd_serv_desk_request_statuses
    ADD CONSTRAINT sd_serv_desk_request_statuses_pkey PRIMARY KEY (id);


--
-- Name: sd_serv_desk_request_subtypes sd_serv_desk_request_subtypes_pkey; Type: CONSTRAINT; Schema: doc; Owner: sup
--

ALTER TABLE ONLY doc.sd_serv_desk_request_subtypes
    ADD CONSTRAINT sd_serv_desk_request_subtypes_pkey PRIMARY KEY (id);


--
-- Name: sd_serv_desk_request_types sd_serv_desk_request_types_pkey; Type: CONSTRAINT; Schema: doc; Owner: sup
--

ALTER TABLE ONLY doc.sd_serv_desk_request_types
    ADD CONSTRAINT sd_serv_desk_request_types_pkey PRIMARY KEY (id);


--
-- Name: sd_spr_laboratories sd_spr_laboratories_pkey; Type: CONSTRAINT; Schema: doc; Owner: sup
--

ALTER TABLE ONLY doc.sd_spr_laboratories
    ADD CONSTRAINT sd_spr_laboratories_pkey PRIMARY KEY (id);


--
-- Name: sd_spr_persons_in_laboratories sd_spr_persons_in_laboratories_pkey; Type: CONSTRAINT; Schema: doc; Owner: sup
--

ALTER TABLE ONLY doc.sd_spr_persons_in_laboratories
    ADD CONSTRAINT sd_spr_persons_in_laboratories_pkey PRIMARY KEY (laboratory_id, person_id);


--
-- Name: sd_spr_resources sd_spr_resources_pkey; Type: CONSTRAINT; Schema: doc; Owner: sup
--

ALTER TABLE ONLY doc.sd_spr_resources
    ADD CONSTRAINT sd_spr_resources_pkey PRIMARY KEY (id);


--
-- Name: service_note_approvings service_note_approvings_pkey; Type: CONSTRAINT; Schema: doc; Owner: developers
--

ALTER TABLE ONLY doc.service_note_approvings
    ADD CONSTRAINT service_note_approvings_pkey PRIMARY KEY (id);


--
-- Name: service_note_file_metadata service_note_file_metadata_uit_pkey; Type: CONSTRAINT; Schema: doc; Owner: developers
--

ALTER TABLE ONLY doc.service_note_file_metadata
    ADD CONSTRAINT service_note_file_metadata_uit_pkey PRIMARY KEY (id);


--
-- Name: service_note_links service_note_links_uit_pkey; Type: CONSTRAINT; Schema: doc; Owner: developers
--

ALTER TABLE ONLY doc.service_note_links
    ADD CONSTRAINT service_note_links_uit_pkey PRIMARY KEY (id);


--
-- Name: service_note_receivers service_note_pkey; Type: CONSTRAINT; Schema: doc; Owner: developers
--

ALTER TABLE ONLY doc.service_note_receivers
    ADD CONSTRAINT service_note_pkey PRIMARY KEY (id);


--
-- Name: service_note_signings service_note_signings_pkey; Type: CONSTRAINT; Schema: doc; Owner: developers
--

ALTER TABLE ONLY doc.service_note_signings
    ADD CONSTRAINT service_note_signings_pkey PRIMARY KEY (id);


--
-- Name: service_notes service_notes_pkey; Type: CONSTRAINT; Schema: doc; Owner: developers
--

ALTER TABLE ONLY doc.service_notes
    ADD CONSTRAINT service_notes_pkey PRIMARY KEY (id);


--
-- Name: sd_spr_equipment spr_equipment_inventory_number_unique; Type: CONSTRAINT; Schema: doc; Owner: sup
--

ALTER TABLE ONLY doc.sd_spr_equipment
    ADD CONSTRAINT spr_equipment_inventory_number_unique UNIQUE (inventory_number);


--
-- Name: sd_spr_equipment spr_equipment_pkey; Type: CONSTRAINT; Schema: doc; Owner: sup
--

ALTER TABLE ONLY doc.sd_spr_equipment
    ADD CONSTRAINT spr_equipment_pkey PRIMARY KEY (id);


--
-- Name: system_roles system_roles_pkey; Type: CONSTRAINT; Schema: doc; Owner: developers
--

ALTER TABLE ONLY doc.system_roles
    ADD CONSTRAINT system_roles_pkey PRIMARY KEY (id);


--
-- Name: department_email uniq_department_email; Type: CONSTRAINT; Schema: doc; Owner: developers
--

ALTER TABLE ONLY doc.department_email
    ADD CONSTRAINT uniq_department_email UNIQUE (department_id);


--
-- Name: users_for_which_permissible_receiving_notification_to_others users_notification_receiving_for_which_permissible_pk; Type: CONSTRAINT; Schema: doc; Owner: developers
--

ALTER TABLE ONLY doc.users_for_which_permissible_receiving_notification_to_others
    ADD CONSTRAINT users_notification_receiving_for_which_permissible_pk PRIMARY KEY (user_id_for_which_receiving_permissible, for_other_receiving_user_id);


--
-- Name: versions_info version_infos_pkey; Type: CONSTRAINT; Schema: doc; Owner: developers
--

ALTER TABLE ONLY doc.versions_info
    ADD CONSTRAINT version_infos_pkey PRIMARY KEY (id);


--
-- Name: application_id_index; Type: INDEX; Schema: doc; Owner: developers
--

CREATE INDEX application_id_index ON doc.service_note_receivers USING btree (application_id);


--
-- Name: document_numerators_index_for_document_type_and_department; Type: INDEX; Schema: doc; Owner: developers
--

CREATE UNIQUE INDEX document_numerators_index_for_document_type_and_department ON doc.document_numerators USING btree (department_id, document_type_id);


--
-- Name: employees calc_head_kindred_department_for_employee_trigger; Type: TRIGGER; Schema: doc; Owner: developers
--

CREATE TRIGGER calc_head_kindred_department_for_employee_trigger BEFORE INSERT OR UPDATE OF department_id ON doc.employees FOR EACH ROW EXECUTE FUNCTION doc.calc_head_kindred_department_for_employee_trigger_proc();


--
-- Name: service_note_receivers incoming_service_note_charge_performing_stats_calc_trigger; Type: TRIGGER; Schema: doc; Owner: developers
--

CREATE TRIGGER incoming_service_note_charge_performing_stats_calc_trigger AFTER INSERT OR DELETE OR UPDATE OF top_level_charge_sheet_id, performing_date, performer_id, issuer_id, document_id ON doc.service_note_receivers FOR EACH ROW EXECUTE FUNCTION doc.incoming_service_note_charge_performing_stats_calc_trigger_func();


--
-- Name: service_note_receivers service_note_performing_stats_trigger; Type: TRIGGER; Schema: doc; Owner: developers
--

CREATE TRIGGER service_note_performing_stats_trigger AFTER DELETE OR UPDATE ON doc.service_note_receivers FOR EACH ROW EXECUTE FUNCTION doc.service_note_performing_stats_trigger_func();


--
-- Name: service_note_receivers service_note_receiving_departments_trigger; Type: TRIGGER; Schema: doc; Owner: developers
--

CREATE TRIGGER service_note_receiving_departments_trigger AFTER DELETE OR UPDATE ON doc.service_note_receivers FOR EACH ROW EXECUTE FUNCTION doc.service_note_receiving_departments_trigger_func();


--
-- Name: service_notes service_note_signer_department_trigger; Type: TRIGGER; Schema: doc; Owner: developers
--

CREATE TRIGGER service_note_signer_department_trigger BEFORE UPDATE OF current_work_cycle_stage_id ON doc.service_notes FOR EACH ROW EXECUTE FUNCTION doc.service_note_signer_department_trigger_func();


--
-- Name: service_note_receivers set_head_charge_sheet_for_new_charge_sheet_trigger; Type: TRIGGER; Schema: doc; Owner: developers
--

CREATE TRIGGER set_head_charge_sheet_for_new_charge_sheet_trigger AFTER INSERT OR UPDATE ON doc.service_note_receivers FOR EACH ROW WHEN (((new.head_charge_sheet_id IS NULL) AND (new.issuer_id IS NOT NULL))) EXECUTE FUNCTION doc.set_head_charge_sheet_for_new_charge_sheet();


--
-- Name: personnel_order_charges set_personnel_order_head_charge_sheet_for_new_charge_sheet; Type: TRIGGER; Schema: doc; Owner: developers
--

CREATE TRIGGER set_personnel_order_head_charge_sheet_for_new_charge_sheet AFTER INSERT OR UPDATE ON doc.personnel_order_charges FOR EACH ROW WHEN (((new.head_charge_sheet_id IS NULL) AND (new.performing_date IS NOT NULL))) EXECUTE FUNCTION doc.set_head_charge_sheet_for_new_charge_sheet();


--
-- Name: sd_serv_desc_requests tr_sd_request_upd_status; Type: TRIGGER; Schema: doc; Owner: sup
--

CREATE TRIGGER tr_sd_request_upd_status AFTER UPDATE ON doc.sd_serv_desc_requests FOR EACH ROW WHEN (((new.status = 4) AND (new.subtype_id = ANY (ARRAY[12, 14])))) EXECUTE FUNCTION doc.trf_sd_request_upd_status();


--
-- Name: departments update_department_employees_head_kindred_department_trigger; Type: TRIGGER; Schema: doc; Owner: developers
--

CREATE TRIGGER update_department_employees_head_kindred_department_trigger AFTER UPDATE OF is_top_level_department_kindred, top_level_department_id ON doc.departments FOR EACH ROW EXECUTE FUNCTION doc.update_department_employees_head_kindred_department_trigger_fun();


--
-- Name: personnel_order_file_metadata update_document_application_exists_column_trigger; Type: TRIGGER; Schema: doc; Owner: developers
--

CREATE TRIGGER update_document_application_exists_column_trigger AFTER INSERT OR DELETE OR UPDATE ON doc.personnel_order_file_metadata FOR EACH ROW EXECUTE FUNCTION doc.update_document_application_exists_column_trigger_proc();


--
-- Name: personnel_order_links update_document_application_exists_column_trigger; Type: TRIGGER; Schema: doc; Owner: developers
--

CREATE TRIGGER update_document_application_exists_column_trigger AFTER INSERT OR DELETE OR UPDATE ON doc.personnel_order_links FOR EACH ROW EXECUTE FUNCTION doc.update_document_application_exists_column_trigger_proc();


--
-- Name: service_note_file_metadata update_document_application_exists_column_trigger; Type: TRIGGER; Schema: doc; Owner: developers
--

CREATE TRIGGER update_document_application_exists_column_trigger AFTER INSERT OR DELETE OR UPDATE ON doc.service_note_file_metadata FOR EACH ROW EXECUTE FUNCTION doc.update_document_application_exists_column_trigger_proc();


--
-- Name: service_note_links update_document_application_exists_column_trigger; Type: TRIGGER; Schema: doc; Owner: developers
--

CREATE TRIGGER update_document_application_exists_column_trigger AFTER INSERT OR DELETE OR UPDATE ON doc.service_note_links FOR EACH ROW EXECUTE FUNCTION doc.update_document_application_exists_column_trigger_proc();


--
-- Name: employees update_leader_links_for_subordinates_of__trigger; Type: TRIGGER; Schema: doc; Owner: developers
--

CREATE TRIGGER update_leader_links_for_subordinates_of__trigger AFTER INSERT OR DELETE OR UPDATE OF leader_id, department_id ON doc.employees FOR EACH ROW EXECUTE FUNCTION doc.update_leader_links_for_subordinates_of__trigger_proc();


--
-- Name: employees_roles update_leader_links_for_subordinates_of__trigger; Type: TRIGGER; Schema: doc; Owner: developers
--

CREATE TRIGGER update_leader_links_for_subordinates_of__trigger AFTER INSERT OR DELETE OR UPDATE ON doc.employees_roles FOR EACH ROW EXECUTE FUNCTION doc.update_leader_links_for_subordinates_of__trigger_proc2();


--
-- Name: correspondence_creating_access_employee correspondence_creating_access_employee_employee_id_fkey; Type: FK CONSTRAINT; Schema: doc; Owner: developers
--

ALTER TABLE ONLY doc.correspondence_creating_access_employee
    ADD CONSTRAINT correspondence_creating_access_employee_employee_id_fkey FOREIGN KEY (employee_id) REFERENCES doc.employees(id);


--
-- Name: departments departments_top_level_department_id_fkey; Type: FK CONSTRAINT; Schema: doc; Owner: developers
--

ALTER TABLE ONLY doc.departments
    ADD CONSTRAINT departments_top_level_department_id_fkey FOREIGN KEY (top_level_department_id) REFERENCES doc.departments(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: document_approvings document_approvings_actual_performed_employee_id_fkey; Type: FK CONSTRAINT; Schema: doc; Owner: developers
--

ALTER TABLE ONLY doc.document_approvings
    ADD CONSTRAINT document_approvings_actual_performed_employee_id_fkey FOREIGN KEY (actual_performed_employee_id) REFERENCES doc.employees(id);


--
-- Name: document_approvings document_approvings_approver_id_fkey; Type: FK CONSTRAINT; Schema: doc; Owner: developers
--

ALTER TABLE ONLY doc.document_approvings
    ADD CONSTRAINT document_approvings_approver_id_fkey FOREIGN KEY (approver_id) REFERENCES doc.employees(id);


--
-- Name: document_approvings document_approvings_document_id_fkey; Type: FK CONSTRAINT; Schema: doc; Owner: developers
--

ALTER TABLE ONLY doc.document_approvings
    ADD CONSTRAINT document_approvings_document_id_fkey FOREIGN KEY (document_id) REFERENCES doc.documents(id);


--
-- Name: document_approvings document_approvings_performing_result_id_fkey; Type: FK CONSTRAINT; Schema: doc; Owner: developers
--

ALTER TABLE ONLY doc.document_approvings
    ADD CONSTRAINT document_approvings_performing_result_id_fkey FOREIGN KEY (performing_result_id) REFERENCES doc.document_approving_results(id);


--
-- Name: document_file_metadata document_file_metadata_uit_outside_document_id_fkey; Type: FK CONSTRAINT; Schema: doc; Owner: developers
--

ALTER TABLE ONLY doc.document_file_metadata
    ADD CONSTRAINT document_file_metadata_uit_outside_document_id_fkey FOREIGN KEY (document_id) REFERENCES doc.documents(id);


--
-- Name: document_type_work_cycle_stages document_life_cycle_stages_document_type_id_fkey; Type: FK CONSTRAINT; Schema: doc; Owner: developers
--

ALTER TABLE ONLY doc.document_type_work_cycle_stages
    ADD CONSTRAINT document_life_cycle_stages_document_type_id_fkey FOREIGN KEY (document_type_id) REFERENCES doc.document_types(id);


--
-- Name: document_links document_links_top_level_document_type_id_fkey; Type: FK CONSTRAINT; Schema: doc; Owner: developers
--

ALTER TABLE ONLY doc.document_links
    ADD CONSTRAINT document_links_top_level_document_type_id_fkey FOREIGN KEY (related_document_type_id) REFERENCES doc.document_types(id);


--
-- Name: document_links document_links_uit_old_document_id_fkey; Type: FK CONSTRAINT; Schema: doc; Owner: developers
--

ALTER TABLE ONLY doc.document_links
    ADD CONSTRAINT document_links_uit_old_document_id_fkey FOREIGN KEY (document_id) REFERENCES doc.documents(id);


--
-- Name: document_links document_links_uit_old_top_level_document_id_fkey; Type: FK CONSTRAINT; Schema: doc; Owner: developers
--

ALTER TABLE ONLY doc.document_links
    ADD CONSTRAINT document_links_uit_old_top_level_document_id_fkey FOREIGN KEY (related_document_id) REFERENCES doc.documents(id);


--
-- Name: document_numerators document_numerators_department_id_fkey; Type: FK CONSTRAINT; Schema: doc; Owner: developers
--

ALTER TABLE ONLY doc.document_numerators
    ADD CONSTRAINT document_numerators_department_id_fkey FOREIGN KEY (department_id) REFERENCES doc.departments(id);


--
-- Name: document_numerators document_numerators_document_type_id_fkey; Type: FK CONSTRAINT; Schema: doc; Owner: developers
--

ALTER TABLE ONLY doc.document_numerators
    ADD CONSTRAINT document_numerators_document_type_id_fkey FOREIGN KEY (document_type_id) REFERENCES doc.document_types(id);


--
-- Name: document_receivers document_receivers_actual_performer_id_fkey; Type: FK CONSTRAINT; Schema: doc; Owner: developers
--

ALTER TABLE ONLY doc.document_receivers
    ADD CONSTRAINT document_receivers_actual_performer_id_fkey FOREIGN KEY (actual_performer_id) REFERENCES doc.employees(id);


--
-- Name: document_receivers document_receivers_document_type_id_for_receiver_fkey; Type: FK CONSTRAINT; Schema: doc; Owner: developers
--

ALTER TABLE ONLY doc.document_receivers
    ADD CONSTRAINT document_receivers_document_type_id_for_receiver_fkey FOREIGN KEY (document_type_id_for_receiver) REFERENCES doc.document_types(id);


--
-- Name: document_receivers document_receivers_incoming_document_id_fkey; Type: FK CONSTRAINT; Schema: doc; Owner: developers
--

ALTER TABLE ONLY doc.document_receivers
    ADD CONSTRAINT document_receivers_incoming_document_id_fkey FOREIGN KEY (incoming_document_id) REFERENCES doc.document_receivers(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: document_receivers document_receivers_incoming_document_type_id_fkey; Type: FK CONSTRAINT; Schema: doc; Owner: developers
--

ALTER TABLE ONLY doc.document_receivers
    ADD CONSTRAINT document_receivers_incoming_document_type_id_fkey FOREIGN KEY (incoming_document_type_id) REFERENCES doc.document_types(id);


--
-- Name: document_receivers document_receivers_real_sender_employee_id_fkey; Type: FK CONSTRAINT; Schema: doc; Owner: developers
--

ALTER TABLE ONLY doc.document_receivers
    ADD CONSTRAINT document_receivers_real_sender_employee_id_fkey FOREIGN KEY (issuer_id) REFERENCES doc.employees(id);


--
-- Name: document_receivers document_receivers_sender_employee_id_fkey; Type: FK CONSTRAINT; Schema: doc; Owner: developers
--

ALTER TABLE ONLY doc.document_receivers
    ADD CONSTRAINT document_receivers_sender_employee_id_fkey FOREIGN KEY (top_level_charge_sheet_id) REFERENCES doc.document_receivers(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: document_receivers document_receivers_uit_outside_document_id_fkey; Type: FK CONSTRAINT; Schema: doc; Owner: developers
--

ALTER TABLE ONLY doc.document_receivers
    ADD CONSTRAINT document_receivers_uit_outside_document_id_fkey FOREIGN KEY (document_id) REFERENCES doc.documents(id);


--
-- Name: document_receivers document_receivers_uit_outside_employee_id_fkey; Type: FK CONSTRAINT; Schema: doc; Owner: developers
--

ALTER TABLE ONLY doc.document_receivers
    ADD CONSTRAINT document_receivers_uit_outside_employee_id_fkey FOREIGN KEY (performer_id) REFERENCES doc.employees(id);


--
-- Name: document_signings document_signings_actual_signed_id_fkey; Type: FK CONSTRAINT; Schema: doc; Owner: developers
--

ALTER TABLE ONLY doc.document_signings
    ADD CONSTRAINT document_signings_actual_signed_id_fkey FOREIGN KEY (actual_signed_id) REFERENCES doc.employees(id);


--
-- Name: document_signings document_signings_document_id_fkey; Type: FK CONSTRAINT; Schema: doc; Owner: developers
--

ALTER TABLE ONLY doc.document_signings
    ADD CONSTRAINT document_signings_document_id_fkey FOREIGN KEY (document_id) REFERENCES doc.documents(id);


--
-- Name: document_signings document_signings_signer_id_fkey; Type: FK CONSTRAINT; Schema: doc; Owner: developers
--

ALTER TABLE ONLY doc.document_signings
    ADD CONSTRAINT document_signings_signer_id_fkey FOREIGN KEY (signer_id) REFERENCES doc.employees(id);


--
-- Name: document_types_allowable_document_charges_types document_types_allowable_document__document_charge_type_id_fkey; Type: FK CONSTRAINT; Schema: doc; Owner: developers
--

ALTER TABLE ONLY doc.document_types_allowable_document_charges_types
    ADD CONSTRAINT document_types_allowable_document__document_charge_type_id_fkey FOREIGN KEY (document_charge_type_id) REFERENCES doc.document_charge_types(id);


--
-- Name: document_types_allowable_document_charges_types document_types_allowable_document_charges_document_type_id_fkey; Type: FK CONSTRAINT; Schema: doc; Owner: developers
--

ALTER TABLE ONLY doc.document_types_allowable_document_charges_types
    ADD CONSTRAINT document_types_allowable_document_charges_document_type_id_fkey FOREIGN KEY (document_type_id) REFERENCES doc.document_types(id);


--
-- Name: document_types document_types_parent_type_fkey; Type: FK CONSTRAINT; Schema: doc; Owner: developers
--

ALTER TABLE ONLY doc.document_types
    ADD CONSTRAINT document_types_parent_type_fkey FOREIGN KEY (parent_type_id) REFERENCES doc.document_types(id);


--
-- Name: documents documents_performer_id_fkey; Type: FK CONSTRAINT; Schema: doc; Owner: developers
--

ALTER TABLE ONLY doc.documents
    ADD CONSTRAINT documents_performer_id_fkey FOREIGN KEY (performer_id) REFERENCES exchange.spr_person(id);


--
-- Name: documents documents_uit_type_fkey; Type: FK CONSTRAINT; Schema: doc; Owner: developers
--

ALTER TABLE ONLY doc.documents
    ADD CONSTRAINT documents_uit_type_fkey FOREIGN KEY (type_id) REFERENCES doc.document_types(id);


--
-- Name: documents_view_access_rights documents_view_access_rights_outside_leader_id_fkey; Type: FK CONSTRAINT; Schema: doc; Owner: developers
--

ALTER TABLE ONLY doc.documents_view_access_rights
    ADD CONSTRAINT documents_view_access_rights_outside_leader_id_fkey FOREIGN KEY (leader_id) REFERENCES doc.employees(id);


--
-- Name: documents_view_access_rights documents_view_access_rights_outside_subordinate_id_fkey; Type: FK CONSTRAINT; Schema: doc; Owner: developers
--

ALTER TABLE ONLY doc.documents_view_access_rights
    ADD CONSTRAINT documents_view_access_rights_outside_subordinate_id_fkey FOREIGN KEY (subordinate_id) REFERENCES doc.employees(id);


--
-- Name: employee_replacements employee_replacements_deputy_id_fkey; Type: FK CONSTRAINT; Schema: doc; Owner: developers
--

ALTER TABLE ONLY doc.employee_replacements
    ADD CONSTRAINT employee_replacements_deputy_id_fkey FOREIGN KEY (deputy_id) REFERENCES doc.employees(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: employee_replacements employee_replacements_replaceable_id_fkey; Type: FK CONSTRAINT; Schema: doc; Owner: developers
--

ALTER TABLE ONLY doc.employee_replacements
    ADD CONSTRAINT employee_replacements_replaceable_id_fkey FOREIGN KEY (replaceable_id) REFERENCES doc.employees(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: employee_work_groups employee_work_groups_leader_id_fkey; Type: FK CONSTRAINT; Schema: doc; Owner: developers
--

ALTER TABLE ONLY doc.employee_work_groups
    ADD CONSTRAINT employee_work_groups_leader_id_fkey FOREIGN KEY (leader_id) REFERENCES doc.employees(id);


--
-- Name: employees employees_department_id_fkey; Type: FK CONSTRAINT; Schema: doc; Owner: developers
--

ALTER TABLE ONLY doc.employees
    ADD CONSTRAINT employees_department_id_fkey FOREIGN KEY (department_id) REFERENCES doc.departments(id);


--
-- Name: employees_employee_work_groups employees_employee_work_groups_employee_id_fkey; Type: FK CONSTRAINT; Schema: doc; Owner: developers
--

ALTER TABLE ONLY doc.employees_employee_work_groups
    ADD CONSTRAINT employees_employee_work_groups_employee_id_fkey FOREIGN KEY (employee_id) REFERENCES doc.employees(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: employees_employee_work_groups employees_employee_work_groups_work_group_id_fkey; Type: FK CONSTRAINT; Schema: doc; Owner: developers
--

ALTER TABLE ONLY doc.employees_employee_work_groups
    ADD CONSTRAINT employees_employee_work_groups_work_group_id_fkey FOREIGN KEY (work_group_id) REFERENCES doc.employee_work_groups(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: employees employees_head_department_id_fkey; Type: FK CONSTRAINT; Schema: doc; Owner: developers
--

ALTER TABLE ONLY doc.employees
    ADD CONSTRAINT employees_head_department_id_fkey FOREIGN KEY (head_kindred_department_id) REFERENCES doc.departments(id);


--
-- Name: employees employees_leader_id_fkey; Type: FK CONSTRAINT; Schema: doc; Owner: developers
--

ALTER TABLE ONLY doc.employees
    ADD CONSTRAINT employees_leader_id_fkey FOREIGN KEY (leader_id) REFERENCES doc.employees(id);


--
-- Name: employees employees_prev_position_id_fkey; Type: FK CONSTRAINT; Schema: doc; Owner: developers
--

ALTER TABLE ONLY doc.employees
    ADD CONSTRAINT employees_prev_position_id_fkey FOREIGN KEY (prev_position_id) REFERENCES doc.employees(id);


--
-- Name: employees_roles employees_roles_employee_id_fkey; Type: FK CONSTRAINT; Schema: doc; Owner: developers
--

ALTER TABLE ONLY doc.employees_roles
    ADD CONSTRAINT employees_roles_employee_id_fkey FOREIGN KEY (employee_id) REFERENCES doc.employees(id);


--
-- Name: employees_roles employees_roles_role_id_fkey; Type: FK CONSTRAINT; Schema: doc; Owner: developers
--

ALTER TABLE ONLY doc.employees_roles
    ADD CONSTRAINT employees_roles_role_id_fkey FOREIGN KEY (role_id) REFERENCES doc.roles(id);


--
-- Name: employees employees_spr_person_id_fkey; Type: FK CONSTRAINT; Schema: doc; Owner: developers
--

ALTER TABLE ONLY doc.employees
    ADD CONSTRAINT employees_spr_person_id_fkey FOREIGN KEY (spr_person_id) REFERENCES exchange.spr_person(id);


--
-- Name: employees_system_roles employees_system_roles_employee_id_fkey; Type: FK CONSTRAINT; Schema: doc; Owner: developers
--

ALTER TABLE ONLY doc.employees_system_roles
    ADD CONSTRAINT employees_system_roles_employee_id_fkey FOREIGN KEY (employee_id) REFERENCES doc.employees(id);


--
-- Name: employees_system_roles employees_system_roles_system_role_id_fkey; Type: FK CONSTRAINT; Schema: doc; Owner: developers
--

ALTER TABLE ONLY doc.employees_system_roles
    ADD CONSTRAINT employees_system_roles_system_role_id_fkey FOREIGN KEY (system_role_id) REFERENCES doc.system_roles(id);


--
-- Name: sd_ip_adresses ip_adresses_person_id_fkey; Type: FK CONSTRAINT; Schema: doc; Owner: sup
--

ALTER TABLE ONLY doc.sd_ip_adresses
    ADD CONSTRAINT ip_adresses_person_id_fkey FOREIGN KEY (person_id) REFERENCES exchange.spr_person(id);


--
-- Name: sd_ip_adresses ip_adresses_type_fkey; Type: FK CONSTRAINT; Schema: doc; Owner: sup
--

ALTER TABLE ONLY doc.sd_ip_adresses
    ADD CONSTRAINT ip_adresses_type_fkey FOREIGN KEY (type_id) REFERENCES doc.sd_equipment_types(id);


--
-- Name: looked_document_charges looked_document_charges_charge_id_fkey; Type: FK CONSTRAINT; Schema: doc; Owner: developers
--

ALTER TABLE ONLY doc.looked_document_charges
    ADD CONSTRAINT looked_document_charges_charge_id_fkey FOREIGN KEY (charge_id) REFERENCES doc.document_receivers(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: looked_document_charges looked_document_charges_employee_id_fkey; Type: FK CONSTRAINT; Schema: doc; Owner: developers
--

ALTER TABLE ONLY doc.looked_document_charges
    ADD CONSTRAINT looked_document_charges_employee_id_fkey FOREIGN KEY (employee_id) REFERENCES doc.employees(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: looked_service_notes looked_documents_outside_document_id_fkey; Type: FK CONSTRAINT; Schema: doc; Owner: developers
--

ALTER TABLE ONLY doc.looked_service_notes
    ADD CONSTRAINT looked_documents_outside_document_id_fkey FOREIGN KEY (document_id) REFERENCES doc.service_notes(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: looked_documents looked_documents_outside_document_id_fkey; Type: FK CONSTRAINT; Schema: doc; Owner: developers
--

ALTER TABLE ONLY doc.looked_documents
    ADD CONSTRAINT looked_documents_outside_document_id_fkey FOREIGN KEY (document_id) REFERENCES doc.documents(id);


--
-- Name: looked_service_notes looked_documents_outside_looked_employee_id_fkey; Type: FK CONSTRAINT; Schema: doc; Owner: developers
--

ALTER TABLE ONLY doc.looked_service_notes
    ADD CONSTRAINT looked_documents_outside_looked_employee_id_fkey FOREIGN KEY (document_id) REFERENCES doc.service_notes(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: looked_documents looked_documents_outside_looked_employee_id_fkey; Type: FK CONSTRAINT; Schema: doc; Owner: developers
--

ALTER TABLE ONLY doc.looked_documents
    ADD CONSTRAINT looked_documents_outside_looked_employee_id_fkey FOREIGN KEY (looked_employee_id) REFERENCES doc.employees(id);


--
-- Name: looked_personnel_orders looked_personnel_orders_document_id_fkey; Type: FK CONSTRAINT; Schema: doc; Owner: developers
--

ALTER TABLE ONLY doc.looked_personnel_orders
    ADD CONSTRAINT looked_personnel_orders_document_id_fkey FOREIGN KEY (document_id) REFERENCES doc.personnel_orders(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: looked_personnel_orders looked_personnel_orders_looked_employee_id_fkey; Type: FK CONSTRAINT; Schema: doc; Owner: developers
--

ALTER TABLE ONLY doc.looked_personnel_orders
    ADD CONSTRAINT looked_personnel_orders_looked_employee_id_fkey FOREIGN KEY (looked_employee_id) REFERENCES doc.employees(id);


--
-- Name: looked_service_note_charges looked_service_note_charges_charge_id_fkey; Type: FK CONSTRAINT; Schema: doc; Owner: developers
--

ALTER TABLE ONLY doc.looked_service_note_charges
    ADD CONSTRAINT looked_service_note_charges_charge_id_fkey FOREIGN KEY (charge_id) REFERENCES doc.service_note_receivers(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: looked_service_note_charges looked_service_note_charges_employee_id_fkey; Type: FK CONSTRAINT; Schema: doc; Owner: developers
--

ALTER TABLE ONLY doc.looked_service_note_charges
    ADD CONSTRAINT looked_service_note_charges_employee_id_fkey FOREIGN KEY (employee_id) REFERENCES doc.employees(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: service_notes performer_id_fkey; Type: FK CONSTRAINT; Schema: doc; Owner: developers
--

ALTER TABLE ONLY doc.service_notes
    ADD CONSTRAINT performer_id_fkey FOREIGN KEY (performer_id) REFERENCES exchange.spr_person(id);


--
-- Name: documents performer_id_fkey; Type: FK CONSTRAINT; Schema: doc; Owner: developers
--

ALTER TABLE ONLY doc.documents
    ADD CONSTRAINT performer_id_fkey FOREIGN KEY (performer_id) REFERENCES exchange.spr_person(id);


--
-- Name: personnel_orders performer_id_fkey; Type: FK CONSTRAINT; Schema: doc; Owner: developers
--

ALTER TABLE ONLY doc.personnel_orders
    ADD CONSTRAINT performer_id_fkey FOREIGN KEY (performer_id) REFERENCES exchange.spr_person(id);


--
-- Name: personnel_order_approvings personnel_order_approvings_actual_performed_employee_id_fkey; Type: FK CONSTRAINT; Schema: doc; Owner: developers
--

ALTER TABLE ONLY doc.personnel_order_approvings
    ADD CONSTRAINT personnel_order_approvings_actual_performed_employee_id_fkey FOREIGN KEY (actual_performed_employee_id) REFERENCES doc.employees(id);


--
-- Name: personnel_order_approvings personnel_order_approvings_approver_id_fkey; Type: FK CONSTRAINT; Schema: doc; Owner: developers
--

ALTER TABLE ONLY doc.personnel_order_approvings
    ADD CONSTRAINT personnel_order_approvings_approver_id_fkey FOREIGN KEY (approver_id) REFERENCES doc.employees(id);


--
-- Name: personnel_order_approvings personnel_order_approvings_document_id_fkey; Type: FK CONSTRAINT; Schema: doc; Owner: developers
--

ALTER TABLE ONLY doc.personnel_order_approvings
    ADD CONSTRAINT personnel_order_approvings_document_id_fkey FOREIGN KEY (document_id) REFERENCES doc.personnel_orders(id);


--
-- Name: personnel_order_approvings personnel_order_approvings_performing_result_id_fkey; Type: FK CONSTRAINT; Schema: doc; Owner: developers
--

ALTER TABLE ONLY doc.personnel_order_approvings
    ADD CONSTRAINT personnel_order_approvings_performing_result_id_fkey FOREIGN KEY (performing_result_id) REFERENCES doc.document_approving_results(id);


--
-- Name: personnel_order_charges personnel_order_charges_actual_performer_id_fkey; Type: FK CONSTRAINT; Schema: doc; Owner: developers
--

ALTER TABLE ONLY doc.personnel_order_charges
    ADD CONSTRAINT personnel_order_charges_actual_performer_id_fkey FOREIGN KEY (actual_performer_id) REFERENCES doc.employees(id);


--
-- Name: personnel_order_charges personnel_order_charges_document_id_fkey; Type: FK CONSTRAINT; Schema: doc; Owner: developers
--

ALTER TABLE ONLY doc.personnel_order_charges
    ADD CONSTRAINT personnel_order_charges_document_id_fkey FOREIGN KEY (document_id) REFERENCES doc.personnel_orders(id);


--
-- Name: personnel_order_charges personnel_order_charges_document_kind_id_fkey; Type: FK CONSTRAINT; Schema: doc; Owner: developers
--

ALTER TABLE ONLY doc.personnel_order_charges
    ADD CONSTRAINT personnel_order_charges_document_kind_id_fkey FOREIGN KEY (document_kind_id) REFERENCES doc.document_types(id);


--
-- Name: personnel_order_charges personnel_order_charges_head_charge_sheet_id_fkey; Type: FK CONSTRAINT; Schema: doc; Owner: developers
--

ALTER TABLE ONLY doc.personnel_order_charges
    ADD CONSTRAINT personnel_order_charges_head_charge_sheet_id_fkey FOREIGN KEY (head_charge_sheet_id) REFERENCES doc.personnel_order_charges(id);


--
-- Name: personnel_order_charges personnel_order_charges_issuer_id_fkey; Type: FK CONSTRAINT; Schema: doc; Owner: developers
--

ALTER TABLE ONLY doc.personnel_order_charges
    ADD CONSTRAINT personnel_order_charges_issuer_id_fkey FOREIGN KEY (issuer_id) REFERENCES doc.employees(id);


--
-- Name: personnel_order_charges personnel_order_charges_kind_id_fkey; Type: FK CONSTRAINT; Schema: doc; Owner: developers
--

ALTER TABLE ONLY doc.personnel_order_charges
    ADD CONSTRAINT personnel_order_charges_kind_id_fkey FOREIGN KEY (kind_id) REFERENCES doc.document_charge_types(id);


--
-- Name: personnel_order_charges personnel_order_charges_performer_id_fkey; Type: FK CONSTRAINT; Schema: doc; Owner: developers
--

ALTER TABLE ONLY doc.personnel_order_charges
    ADD CONSTRAINT personnel_order_charges_performer_id_fkey FOREIGN KEY (performer_id) REFERENCES doc.employees(id);


--
-- Name: personnel_order_charges personnel_order_charges_top_level_charge_sheet_id_fkey; Type: FK CONSTRAINT; Schema: doc; Owner: developers
--

ALTER TABLE ONLY doc.personnel_order_charges
    ADD CONSTRAINT personnel_order_charges_top_level_charge_sheet_id_fkey FOREIGN KEY (top_level_charge_sheet_id) REFERENCES doc.personnel_order_charges(id);


--
-- Name: personnel_order_control_groups__employees personnel_order_control_groups__employees_control_group_id_fkey; Type: FK CONSTRAINT; Schema: doc; Owner: developers
--

ALTER TABLE ONLY doc.personnel_order_control_groups__employees
    ADD CONSTRAINT personnel_order_control_groups__employees_control_group_id_fkey FOREIGN KEY (control_group_id) REFERENCES doc.personnel_order_control_groups(id);


--
-- Name: personnel_order_control_groups__employees personnel_order_control_groups__employees_employee_id_fkey; Type: FK CONSTRAINT; Schema: doc; Owner: developers
--

ALTER TABLE ONLY doc.personnel_order_control_groups__employees
    ADD CONSTRAINT personnel_order_control_groups__employees_employee_id_fkey FOREIGN KEY (employee_id) REFERENCES doc.employees(id);


--
-- Name: personnel_order_control_groups__sub_kinds personnel_order_control_groups__sub_kinds_control_group_id_fkey; Type: FK CONSTRAINT; Schema: doc; Owner: developers
--

ALTER TABLE ONLY doc.personnel_order_control_groups__sub_kinds
    ADD CONSTRAINT personnel_order_control_groups__sub_kinds_control_group_id_fkey FOREIGN KEY (control_group_id) REFERENCES doc.personnel_order_control_groups(id);


--
-- Name: personnel_order_control_groups__sub_kinds personnel_order_control_groups_personnel_order_sub_kind_id_fkey; Type: FK CONSTRAINT; Schema: doc; Owner: developers
--

ALTER TABLE ONLY doc.personnel_order_control_groups__sub_kinds
    ADD CONSTRAINT personnel_order_control_groups_personnel_order_sub_kind_id_fkey FOREIGN KEY (personnel_order_sub_kind_id) REFERENCES doc.personnel_order_sub_kinds(id);


--
-- Name: personnel_order_creating_access_employees personnel_order_creating_access_employees_employee_id_fkey; Type: FK CONSTRAINT; Schema: doc; Owner: developers
--

ALTER TABLE ONLY doc.personnel_order_creating_access_employees
    ADD CONSTRAINT personnel_order_creating_access_employees_employee_id_fkey FOREIGN KEY (employee_id) REFERENCES doc.employees(id);


--
-- Name: personnel_order_file_metadata personnel_order_file_metadata_document_id_fkey; Type: FK CONSTRAINT; Schema: doc; Owner: developers
--

ALTER TABLE ONLY doc.personnel_order_file_metadata
    ADD CONSTRAINT personnel_order_file_metadata_document_id_fkey FOREIGN KEY (document_id) REFERENCES doc.personnel_orders(id);


--
-- Name: personnel_order_links personnel_order_links_document_id_fkey; Type: FK CONSTRAINT; Schema: doc; Owner: developers
--

ALTER TABLE ONLY doc.personnel_order_links
    ADD CONSTRAINT personnel_order_links_document_id_fkey FOREIGN KEY (document_id) REFERENCES doc.personnel_orders(id);


--
-- Name: personnel_order_links personnel_order_links_related_document_type_id_fkey; Type: FK CONSTRAINT; Schema: doc; Owner: developers
--

ALTER TABLE ONLY doc.personnel_order_links
    ADD CONSTRAINT personnel_order_links_related_document_type_id_fkey FOREIGN KEY (related_document_type_id) REFERENCES doc.document_types(id);


--
-- Name: personnel_order_signers personnel_order_signers_signer_id_fkey; Type: FK CONSTRAINT; Schema: doc; Owner: developers
--

ALTER TABLE ONLY doc.personnel_order_signers
    ADD CONSTRAINT personnel_order_signers_signer_id_fkey FOREIGN KEY (signer_id) REFERENCES doc.employees(id);


--
-- Name: personnel_order_signings personnel_order_signings_actual_signed_id_fkey; Type: FK CONSTRAINT; Schema: doc; Owner: developers
--

ALTER TABLE ONLY doc.personnel_order_signings
    ADD CONSTRAINT personnel_order_signings_actual_signed_id_fkey FOREIGN KEY (actual_signed_id) REFERENCES doc.employees(id);


--
-- Name: personnel_order_signings personnel_order_signings_document_id_fkey; Type: FK CONSTRAINT; Schema: doc; Owner: developers
--

ALTER TABLE ONLY doc.personnel_order_signings
    ADD CONSTRAINT personnel_order_signings_document_id_fkey FOREIGN KEY (document_id) REFERENCES doc.personnel_orders(id);


--
-- Name: personnel_order_signings personnel_order_signings_signer_id_fkey; Type: FK CONSTRAINT; Schema: doc; Owner: developers
--

ALTER TABLE ONLY doc.personnel_order_signings
    ADD CONSTRAINT personnel_order_signings_signer_id_fkey FOREIGN KEY (signer_id) REFERENCES doc.employees(id);


--
-- Name: personnel_order_sub_kinds__approvers personnel_order_sub_kinds__app_personnel_order_sub_kind_id_fkey; Type: FK CONSTRAINT; Schema: doc; Owner: developers
--

ALTER TABLE ONLY doc.personnel_order_sub_kinds__approvers
    ADD CONSTRAINT personnel_order_sub_kinds__app_personnel_order_sub_kind_id_fkey FOREIGN KEY (personnel_order_sub_kind_id) REFERENCES doc.personnel_order_sub_kinds(id);


--
-- Name: personnel_order_sub_kinds__approvers personnel_order_sub_kinds__approvers_approver_id_fkey; Type: FK CONSTRAINT; Schema: doc; Owner: developers
--

ALTER TABLE ONLY doc.personnel_order_sub_kinds__approvers
    ADD CONSTRAINT personnel_order_sub_kinds__approvers_approver_id_fkey FOREIGN KEY (approver_id) REFERENCES doc.employees(id);


--
-- Name: personnel_orders personnel_orders_author_id_fkey; Type: FK CONSTRAINT; Schema: doc; Owner: developers
--

ALTER TABLE ONLY doc.personnel_orders
    ADD CONSTRAINT personnel_orders_author_id_fkey FOREIGN KEY (author_id) REFERENCES doc.employees(id);


--
-- Name: personnel_orders personnel_orders_performer_id_fkey; Type: FK CONSTRAINT; Schema: doc; Owner: developers
--

ALTER TABLE ONLY doc.personnel_orders
    ADD CONSTRAINT personnel_orders_performer_id_fkey FOREIGN KEY (performer_id) REFERENCES exchange.spr_person(id);


--
-- Name: personnel_orders personnel_orders_sub_type_id_fkey; Type: FK CONSTRAINT; Schema: doc; Owner: developers
--

ALTER TABLE ONLY doc.personnel_orders
    ADD CONSTRAINT personnel_orders_sub_type_id_fkey FOREIGN KEY (sub_type_id) REFERENCES doc.personnel_order_sub_kinds(id);


--
-- Name: personnel_orders personnel_orders_type_id_fkey; Type: FK CONSTRAINT; Schema: doc; Owner: developers
--

ALTER TABLE ONLY doc.personnel_orders
    ADD CONSTRAINT personnel_orders_type_id_fkey FOREIGN KEY (type_id) REFERENCES doc.document_types(id);


--
-- Name: plant_structure_access_employees plant_structure_access_employees_employee_id_fkey; Type: FK CONSTRAINT; Schema: doc; Owner: developers
--

ALTER TABLE ONLY doc.plant_structure_access_employees
    ADD CONSTRAINT plant_structure_access_employees_employee_id_fkey FOREIGN KEY (employee_id) REFERENCES doc.employees(id);


--
-- Name: res_requests_sended_messages res_req_emails_req_id_fkey; Type: FK CONSTRAINT; Schema: doc; Owner: developers
--

ALTER TABLE ONLY doc.res_requests_sended_messages
    ADD CONSTRAINT res_req_emails_req_id_fkey FOREIGN KEY (request_id) REFERENCES exchange.postfix_res_request(id);


--
-- Name: roles_role_rights roles_role_rights_role_id_fkey; Type: FK CONSTRAINT; Schema: doc; Owner: developers
--

ALTER TABLE ONLY doc.roles_role_rights
    ADD CONSTRAINT roles_role_rights_role_id_fkey FOREIGN KEY (role_id) REFERENCES doc.roles(id);


--
-- Name: roles_role_rights roles_role_rights_role_right_id_fkey; Type: FK CONSTRAINT; Schema: doc; Owner: developers
--

ALTER TABLE ONLY doc.roles_role_rights
    ADD CONSTRAINT roles_role_rights_role_right_id_fkey FOREIGN KEY (role_right_id) REFERENCES doc.role_rights(id);


--
-- Name: sd_resources_access_rights sd_res_access_rights_podr_id_fkey; Type: FK CONSTRAINT; Schema: doc; Owner: sup
--

ALTER TABLE ONLY doc.sd_resources_access_rights
    ADD CONSTRAINT sd_res_access_rights_podr_id_fkey FOREIGN KEY (podr_id) REFERENCES nsi.spr_podr(id);


--
-- Name: sd_resources_access_rights sd_res_access_rights_res_id_fkey; Type: FK CONSTRAINT; Schema: doc; Owner: sup
--

ALTER TABLE ONLY doc.sd_resources_access_rights
    ADD CONSTRAINT sd_res_access_rights_res_id_fkey FOREIGN KEY (resource_id) REFERENCES doc.sd_spr_resources(id) ON DELETE CASCADE;


--
-- Name: sd_resources_access_rights sd_res_access_rights_right_type_id_fkey; Type: FK CONSTRAINT; Schema: doc; Owner: sup
--

ALTER TABLE ONLY doc.sd_resources_access_rights
    ADD CONSTRAINT sd_res_access_rights_right_type_id_fkey FOREIGN KEY (right_type_id) REFERENCES uac.spr_right_type(id);


--
-- Name: sd_serv_desc_requests sd_serv_desc_requests_applicant_id_fkey; Type: FK CONSTRAINT; Schema: doc; Owner: sup
--

ALTER TABLE ONLY doc.sd_serv_desc_requests
    ADD CONSTRAINT sd_serv_desc_requests_applicant_id_fkey FOREIGN KEY (applicant_id) REFERENCES exchange.spr_person(id);


--
-- Name: sd_serv_desc_requests sd_serv_desc_requests_responsible_lab_id_fkey; Type: FK CONSTRAINT; Schema: doc; Owner: sup
--

ALTER TABLE ONLY doc.sd_serv_desc_requests
    ADD CONSTRAINT sd_serv_desc_requests_responsible_lab_id_fkey FOREIGN KEY (responsible_laboratory_id) REFERENCES doc.sd_spr_laboratories(id);


--
-- Name: sd_serv_desc_requests sd_serv_desc_requests_status_fkey; Type: FK CONSTRAINT; Schema: doc; Owner: sup
--

ALTER TABLE ONLY doc.sd_serv_desc_requests
    ADD CONSTRAINT sd_serv_desc_requests_status_fkey FOREIGN KEY (status) REFERENCES doc.sd_serv_desk_request_statuses(id);


--
-- Name: sd_serv_desc_requests sd_serv_desc_requests_subtype_id_fkey; Type: FK CONSTRAINT; Schema: doc; Owner: sup
--

ALTER TABLE ONLY doc.sd_serv_desc_requests
    ADD CONSTRAINT sd_serv_desc_requests_subtype_id_fkey FOREIGN KEY (subtype_id) REFERENCES doc.sd_serv_desk_request_subtypes(id);


--
-- Name: sd_serv_desc_requests sd_serv_desc_requests_type_id_fkey; Type: FK CONSTRAINT; Schema: doc; Owner: sup
--

ALTER TABLE ONLY doc.sd_serv_desc_requests
    ADD CONSTRAINT sd_serv_desc_requests_type_id_fkey FOREIGN KEY (type_id) REFERENCES doc.sd_serv_desk_request_types(id);


--
-- Name: sd_serv_desc_resp_for_exec_requests sd_serv_desc_resp_for_exec_requests_laboratory_id_fkey; Type: FK CONSTRAINT; Schema: doc; Owner: sup
--

ALTER TABLE ONLY doc.sd_serv_desc_resp_for_exec_requests
    ADD CONSTRAINT sd_serv_desc_resp_for_exec_requests_laboratory_id_fkey FOREIGN KEY (laboratory_id) REFERENCES doc.sd_spr_laboratories(id) ON DELETE RESTRICT;


--
-- Name: sd_serv_desc_resp_for_exec_requests sd_serv_desc_resp_for_exec_requests_person_id_fkey; Type: FK CONSTRAINT; Schema: doc; Owner: sup
--

ALTER TABLE ONLY doc.sd_serv_desc_resp_for_exec_requests
    ADD CONSTRAINT sd_serv_desc_resp_for_exec_requests_person_id_fkey FOREIGN KEY (person_id) REFERENCES exchange.spr_person(id);


--
-- Name: sd_serv_desc_resp_for_exec_requests sd_serv_desc_resp_for_exec_requests_request_id_fkey; Type: FK CONSTRAINT; Schema: doc; Owner: sup
--

ALTER TABLE ONLY doc.sd_serv_desc_resp_for_exec_requests
    ADD CONSTRAINT sd_serv_desc_resp_for_exec_requests_request_id_fkey FOREIGN KEY (request_id) REFERENCES doc.sd_serv_desc_requests(id) ON DELETE CASCADE;


--
-- Name: sd_serv_desk_request_subtypes sd_serv_desk_request_subtypes_type_id_fkey; Type: FK CONSTRAINT; Schema: doc; Owner: sup
--

ALTER TABLE ONLY doc.sd_serv_desk_request_subtypes
    ADD CONSTRAINT sd_serv_desk_request_subtypes_type_id_fkey FOREIGN KEY (type_id) REFERENCES doc.sd_serv_desk_request_types(id) ON DELETE CASCADE;


--
-- Name: sd_serv_desk_request_types sd_serv_desk_request_types_lab_id_fkey; Type: FK CONSTRAINT; Schema: doc; Owner: sup
--

ALTER TABLE ONLY doc.sd_serv_desk_request_types
    ADD CONSTRAINT sd_serv_desk_request_types_lab_id_fkey FOREIGN KEY (laboratory_id) REFERENCES doc.sd_spr_laboratories(id);


--
-- Name: sd_spr_persons_in_laboratories sd_spr_pers_in_labs_laboratory_id_fkey; Type: FK CONSTRAINT; Schema: doc; Owner: sup
--

ALTER TABLE ONLY doc.sd_spr_persons_in_laboratories
    ADD CONSTRAINT sd_spr_pers_in_labs_laboratory_id_fkey FOREIGN KEY (laboratory_id) REFERENCES doc.sd_spr_laboratories(id) ON DELETE CASCADE;


--
-- Name: sd_spr_persons_in_laboratories sd_spr_pers_in_labs_person_id_fkey; Type: FK CONSTRAINT; Schema: doc; Owner: sup
--

ALTER TABLE ONLY doc.sd_spr_persons_in_laboratories
    ADD CONSTRAINT sd_spr_pers_in_labs_person_id_fkey FOREIGN KEY (person_id) REFERENCES exchange.spr_person(id);


--
-- Name: sd_spr_resources sd_spr_resources_db_sys_id_fkey; Type: FK CONSTRAINT; Schema: doc; Owner: sup
--

ALTER TABLE ONLY doc.sd_spr_resources
    ADD CONSTRAINT sd_spr_resources_db_sys_id_fkey FOREIGN KEY (database_system_id) REFERENCES doc.sd_database_system_names(id);


--
-- Name: sd_spr_resources sd_spr_resources_dev_env_id_fkey; Type: FK CONSTRAINT; Schema: doc; Owner: sup
--

ALTER TABLE ONLY doc.sd_spr_resources
    ADD CONSTRAINT sd_spr_resources_dev_env_id_fkey FOREIGN KEY (development_environment_id) REFERENCES doc.sd_development_environment_names(id);


--
-- Name: sd_spr_resources sd_spr_resources_developer_id_fkey; Type: FK CONSTRAINT; Schema: doc; Owner: sup
--

ALTER TABLE ONLY doc.sd_spr_resources
    ADD CONSTRAINT sd_spr_resources_developer_id_fkey FOREIGN KEY (developer_person_id) REFERENCES exchange.spr_person(id);


--
-- Name: sd_spr_resources sd_spr_resources_implementer_id_fkey; Type: FK CONSTRAINT; Schema: doc; Owner: sup
--

ALTER TABLE ONLY doc.sd_spr_resources
    ADD CONSTRAINT sd_spr_resources_implementer_id_fkey FOREIGN KEY (implementer_id) REFERENCES doc.sd_spr_laboratories(id) ON DELETE RESTRICT;


--
-- Name: sd_spr_resources sd_spr_resources_status_id_fkey; Type: FK CONSTRAINT; Schema: doc; Owner: sup
--

ALTER TABLE ONLY doc.sd_spr_resources
    ADD CONSTRAINT sd_spr_resources_status_id_fkey FOREIGN KEY (status_id) REFERENCES doc.sd_resource_statuses(id);


--
-- Name: service_note_approvings service_note_approvings_actual_performed_employee_id_fkey; Type: FK CONSTRAINT; Schema: doc; Owner: developers
--

ALTER TABLE ONLY doc.service_note_approvings
    ADD CONSTRAINT service_note_approvings_actual_performed_employee_id_fkey FOREIGN KEY (actual_performed_employee_id) REFERENCES doc.employees(id);


--
-- Name: service_note_approvings service_note_approvings_approver_id_fkey; Type: FK CONSTRAINT; Schema: doc; Owner: developers
--

ALTER TABLE ONLY doc.service_note_approvings
    ADD CONSTRAINT service_note_approvings_approver_id_fkey FOREIGN KEY (approver_id) REFERENCES doc.employees(id);


--
-- Name: service_note_approvings service_note_approvings_document_id_fkey; Type: FK CONSTRAINT; Schema: doc; Owner: developers
--

ALTER TABLE ONLY doc.service_note_approvings
    ADD CONSTRAINT service_note_approvings_document_id_fkey FOREIGN KEY (document_id) REFERENCES doc.service_notes(id);


--
-- Name: service_note_approvings service_note_approvings_performing_result_id_fkey; Type: FK CONSTRAINT; Schema: doc; Owner: developers
--

ALTER TABLE ONLY doc.service_note_approvings
    ADD CONSTRAINT service_note_approvings_performing_result_id_fkey FOREIGN KEY (performing_result_id) REFERENCES doc.document_approving_results(id);


--
-- Name: service_note_file_metadata service_note_file_metadata_uit_outside_document_id_fkey; Type: FK CONSTRAINT; Schema: doc; Owner: developers
--

ALTER TABLE ONLY doc.service_note_file_metadata
    ADD CONSTRAINT service_note_file_metadata_uit_outside_document_id_fkey FOREIGN KEY (document_id) REFERENCES doc.service_notes(id);


--
-- Name: service_note_links service_note_links_top_level_document_type_id_fkey; Type: FK CONSTRAINT; Schema: doc; Owner: developers
--

ALTER TABLE ONLY doc.service_note_links
    ADD CONSTRAINT service_note_links_top_level_document_type_id_fkey FOREIGN KEY (related_document_type_id) REFERENCES doc.document_types(id);


--
-- Name: service_note_links service_note_links_uit_old_document_id_fkey; Type: FK CONSTRAINT; Schema: doc; Owner: developers
--

ALTER TABLE ONLY doc.service_note_links
    ADD CONSTRAINT service_note_links_uit_old_document_id_fkey FOREIGN KEY (document_id) REFERENCES doc.service_notes(id);


--
-- Name: service_note_receivers service_note_receivers_actual_performer_id_fkey; Type: FK CONSTRAINT; Schema: doc; Owner: developers
--

ALTER TABLE ONLY doc.service_note_receivers
    ADD CONSTRAINT service_note_receivers_actual_performer_id_fkey FOREIGN KEY (actual_performer_id) REFERENCES doc.employees(id);


--
-- Name: service_note_receivers service_note_receivers_document_kind_id_fkey; Type: FK CONSTRAINT; Schema: doc; Owner: developers
--

ALTER TABLE ONLY doc.service_note_receivers
    ADD CONSTRAINT service_note_receivers_document_kind_id_fkey FOREIGN KEY (document_kind_id) REFERENCES doc.document_types(id);


--
-- Name: service_note_receivers service_note_receivers_incoming_document_id_fkey; Type: FK CONSTRAINT; Schema: doc; Owner: developers
--

ALTER TABLE ONLY doc.service_note_receivers
    ADD CONSTRAINT service_note_receivers_incoming_document_id_fkey FOREIGN KEY (head_charge_sheet_id) REFERENCES doc.service_note_receivers(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: service_note_receivers service_note_receivers_incoming_document_type_id_fkey; Type: FK CONSTRAINT; Schema: doc; Owner: developers
--

ALTER TABLE ONLY doc.service_note_receivers
    ADD CONSTRAINT service_note_receivers_incoming_document_type_id_fkey FOREIGN KEY (incoming_document_type_id) REFERENCES doc.document_types(id);


--
-- Name: service_note_receivers service_note_receivers_kind_id_fkey; Type: FK CONSTRAINT; Schema: doc; Owner: developers
--

ALTER TABLE ONLY doc.service_note_receivers
    ADD CONSTRAINT service_note_receivers_kind_id_fkey FOREIGN KEY (kind_id) REFERENCES doc.document_charge_types(id);


--
-- Name: service_note_receivers service_note_receivers_real_sender_employee_id_fkey; Type: FK CONSTRAINT; Schema: doc; Owner: developers
--

ALTER TABLE ONLY doc.service_note_receivers
    ADD CONSTRAINT service_note_receivers_real_sender_employee_id_fkey FOREIGN KEY (issuer_id) REFERENCES doc.employees(id);


--
-- Name: service_note_receivers service_note_receivers_sender_employee_id_fkey; Type: FK CONSTRAINT; Schema: doc; Owner: developers
--

ALTER TABLE ONLY doc.service_note_receivers
    ADD CONSTRAINT service_note_receivers_sender_employee_id_fkey FOREIGN KEY (top_level_charge_sheet_id) REFERENCES doc.service_note_receivers(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: service_note_receivers service_note_receivers_uit_outside_document_id_fkey; Type: FK CONSTRAINT; Schema: doc; Owner: developers
--

ALTER TABLE ONLY doc.service_note_receivers
    ADD CONSTRAINT service_note_receivers_uit_outside_document_id_fkey FOREIGN KEY (document_id) REFERENCES doc.service_notes(id);


--
-- Name: service_note_receivers service_note_receivers_uit_outside_employee_id_fkey; Type: FK CONSTRAINT; Schema: doc; Owner: developers
--

ALTER TABLE ONLY doc.service_note_receivers
    ADD CONSTRAINT service_note_receivers_uit_outside_employee_id_fkey FOREIGN KEY (performer_id) REFERENCES doc.employees(id);


--
-- Name: service_note_signings service_note_signings_actual_signed_id_fkey; Type: FK CONSTRAINT; Schema: doc; Owner: developers
--

ALTER TABLE ONLY doc.service_note_signings
    ADD CONSTRAINT service_note_signings_actual_signed_id_fkey FOREIGN KEY (actual_signed_id) REFERENCES doc.employees(id);


--
-- Name: service_note_signings service_note_signings_document_id_fkey; Type: FK CONSTRAINT; Schema: doc; Owner: developers
--

ALTER TABLE ONLY doc.service_note_signings
    ADD CONSTRAINT service_note_signings_document_id_fkey FOREIGN KEY (document_id) REFERENCES doc.service_notes(id);


--
-- Name: service_note_signings service_note_signings_signer_id_fkey; Type: FK CONSTRAINT; Schema: doc; Owner: developers
--

ALTER TABLE ONLY doc.service_note_signings
    ADD CONSTRAINT service_note_signings_signer_id_fkey FOREIGN KEY (signer_id) REFERENCES doc.employees(id);


--
-- Name: service_notes service_notes_type_id_fkey; Type: FK CONSTRAINT; Schema: doc; Owner: developers
--

ALTER TABLE ONLY doc.service_notes
    ADD CONSTRAINT service_notes_type_id_fkey FOREIGN KEY (type_id) REFERENCES doc.document_types(id);


--
-- Name: sd_spr_equipment spr_equipment_person_id_fkey; Type: FK CONSTRAINT; Schema: doc; Owner: sup
--

ALTER TABLE ONLY doc.sd_spr_equipment
    ADD CONSTRAINT spr_equipment_person_id_fkey FOREIGN KEY (person_id) REFERENCES exchange.spr_person(id);


--
-- Name: sd_spr_equipment spr_equipment_podr_id_fkey; Type: FK CONSTRAINT; Schema: doc; Owner: sup
--

ALTER TABLE ONLY doc.sd_spr_equipment
    ADD CONSTRAINT spr_equipment_podr_id_fkey FOREIGN KEY (podr_id) REFERENCES nsi.spr_podr(id);


--
-- Name: users_for_which_permissible_receiving_notification_to_others users_for_which_permissible_r_user_id_for_which_receiving__fkey; Type: FK CONSTRAINT; Schema: doc; Owner: developers
--

ALTER TABLE ONLY doc.users_for_which_permissible_receiving_notification_to_others
    ADD CONSTRAINT users_for_which_permissible_r_user_id_for_which_receiving__fkey FOREIGN KEY (user_id_for_which_receiving_permissible) REFERENCES doc.employees(id);


--
-- Name: users_for_which_permissible_receiving_notification_to_others users_for_which_permissible_re_for_other_receiving_user_id_fkey; Type: FK CONSTRAINT; Schema: doc; Owner: developers
--

ALTER TABLE ONLY doc.users_for_which_permissible_receiving_notification_to_others
    ADD CONSTRAINT users_for_which_permissible_re_for_other_receiving_user_id_fkey FOREIGN KEY (for_other_receiving_user_id) REFERENCES doc.employees(id);


--
-- Name: SCHEMA doc; Type: ACL; Schema: -; Owner: sup
--

GRANT USAGE ON SCHEMA doc TO employees;
GRANT USAGE ON SCHEMA doc TO umz_doc_edit;
GRANT USAGE ON SCHEMA doc TO sd_ip_read;
GRANT USAGE ON SCHEMA doc TO sd_ip_edit;
GRANT ALL ON SCHEMA doc TO developers;
GRANT USAGE ON SCHEMA doc TO service_update_person;
GRANT ALL ON SCHEMA doc TO service_postfix_person_recipient;


--
-- Name: FUNCTION add_new_department(code character varying, short_name character varying, full_name character varying, top_level_department_id integer); Type: ACL; Schema: doc; Owner: developers
--

GRANT ALL ON FUNCTION doc.add_new_department(code character varying, short_name character varying, full_name character varying, top_level_department_id integer) TO umz_doc_edit;


--
-- Name: FUNCTION add_new_employee(department_id integer, short_full_name character varying, speciality character varying, personnel_number character varying, name character varying, surname character varying, patronymic character varying, leader_id integer, login character varying, spr_person_id integer, role_id integer, is_foreign boolean, is_sd_user boolean); Type: ACL; Schema: doc; Owner: developers
--

REVOKE ALL ON FUNCTION doc.add_new_employee(department_id integer, short_full_name character varying, speciality character varying, personnel_number character varying, name character varying, surname character varying, patronymic character varying, leader_id integer, login character varying, spr_person_id integer, role_id integer, is_foreign boolean, is_sd_user boolean) FROM PUBLIC;
GRANT ALL ON FUNCTION doc.add_new_employee(department_id integer, short_full_name character varying, speciality character varying, personnel_number character varying, name character varying, surname character varying, patronymic character varying, leader_id integer, login character varying, spr_person_id integer, role_id integer, is_foreign boolean, is_sd_user boolean) TO umz_doc_edit;


--
-- Name: FUNCTION are_document_applications_exists(document_id integer, document_type_id integer); Type: ACL; Schema: doc; Owner: developers
--

REVOKE ALL ON FUNCTION doc.are_document_applications_exists(document_id integer, document_type_id integer) FROM PUBLIC;
GRANT ALL ON FUNCTION doc.are_document_applications_exists(document_id integer, document_type_id integer) TO umz_doc_edit;


--
-- Name: FUNCTION are_employees_secretaries_of_same_leader(employee_ids integer[]); Type: ACL; Schema: doc; Owner: developers
--

REVOKE ALL ON FUNCTION doc.are_employees_secretaries_of_same_leader(employee_ids integer[]) FROM PUBLIC;
GRANT ALL ON FUNCTION doc.are_employees_secretaries_of_same_leader(employee_ids integer[]) TO umz_doc_edit;


--
-- Name: FUNCTION are_employees_subleaders_of_same_leader(employee_ids integer[]); Type: ACL; Schema: doc; Owner: developers
--

REVOKE ALL ON FUNCTION doc.are_employees_subleaders_of_same_leader(employee_ids integer[]) FROM PUBLIC;
GRANT ALL ON FUNCTION doc.are_employees_subleaders_of_same_leader(employee_ids integer[]) TO umz_doc_edit;


--
-- Name: FUNCTION are_employees_with_given_roles_of_same_leader(employee_ids integer[], role_ids integer[]); Type: ACL; Schema: doc; Owner: developers
--

REVOKE ALL ON FUNCTION doc.are_employees_with_given_roles_of_same_leader(employee_ids integer[], role_ids integer[]) FROM PUBLIC;
GRANT ALL ON FUNCTION doc.are_employees_with_given_roles_of_same_leader(employee_ids integer[], role_ids integer[]) TO umz_doc_edit;


--
-- Name: FUNCTION assign_application_to_document_charge(document_type_id integer, application_id bigint, document_charge_id bigint); Type: ACL; Schema: doc; Owner: developers
--

GRANT ALL ON FUNCTION doc.assign_application_to_document_charge(document_type_id integer, application_id bigint, document_charge_id bigint) TO request_edit;
GRANT ALL ON FUNCTION doc.assign_application_to_document_charge(document_type_id integer, application_id bigint, document_charge_id bigint) TO request_view;
GRANT ALL ON FUNCTION doc.assign_application_to_document_charge(document_type_id integer, application_id bigint, document_charge_id bigint) TO umz_doc_edit;
GRANT ALL ON FUNCTION doc.assign_application_to_document_charge(document_type_id integer, application_id bigint, document_charge_id bigint) TO u_53917;


--
-- Name: FUNCTION calc_head_kindred_department_for_employee_trigger_proc(); Type: ACL; Schema: doc; Owner: developers
--

REVOKE ALL ON FUNCTION doc.calc_head_kindred_department_for_employee_trigger_proc() FROM PUBLIC;
GRANT ALL ON FUNCTION doc.calc_head_kindred_department_for_employee_trigger_proc() TO umz_doc_edit;


--
-- Name: FUNCTION create_short_full_name_from(family character varying, name character varying, patronymic character varying); Type: ACL; Schema: doc; Owner: developers
--

REVOKE ALL ON FUNCTION doc.create_short_full_name_from(family character varying, name character varying, patronymic character varying) FROM PUBLIC;
GRANT ALL ON FUNCTION doc.create_short_full_name_from(family character varying, name character varying, patronymic character varying) TO umz_doc_edit;


--
-- Name: FUNCTION find_all_same_head_kindred_department_leaders_for_employee(employee_id integer); Type: ACL; Schema: doc; Owner: developers
--

REVOKE ALL ON FUNCTION doc.find_all_same_head_kindred_department_leaders_for_employee(employee_id integer) FROM PUBLIC;
GRANT ALL ON FUNCTION doc.find_all_same_head_kindred_department_leaders_for_employee(employee_id integer) TO umz_doc_edit;


--
-- Name: FUNCTION find_employee_id_by_login(employee_login character varying); Type: ACL; Schema: doc; Owner: developers
--

REVOKE ALL ON FUNCTION doc.find_employee_id_by_login(employee_login character varying) FROM PUBLIC;
GRANT ALL ON FUNCTION doc.find_employee_id_by_login(employee_login character varying) TO umz_doc_edit;


--
-- Name: FUNCTION find_head_kindred_department_for_inner(inner_department_id integer); Type: ACL; Schema: doc; Owner: developers
--

REVOKE ALL ON FUNCTION doc.find_head_kindred_department_for_inner(inner_department_id integer) FROM PUBLIC;
GRANT ALL ON FUNCTION doc.find_head_kindred_department_for_inner(inner_department_id integer) TO umz_doc_edit;


--
-- Name: FUNCTION get_approveable_service_notes_for_employee(employee_id integer, stage_names character varying[]); Type: ACL; Schema: doc; Owner: developers
--

REVOKE ALL ON FUNCTION doc.get_approveable_service_notes_for_employee(employee_id integer, stage_names character varying[]) FROM PUBLIC;
GRANT ALL ON FUNCTION doc.get_approveable_service_notes_for_employee(employee_id integer, stage_names character varying[]) TO umz_doc_edit;


--
-- Name: FUNCTION get_approveable_service_notes_for_employee_by_ids(employee_id integer, document_ids integer[]); Type: ACL; Schema: doc; Owner: developers
--

REVOKE ALL ON FUNCTION doc.get_approveable_service_notes_for_employee_by_ids(employee_id integer, document_ids integer[]) FROM PUBLIC;
GRANT ALL ON FUNCTION doc.get_approveable_service_notes_for_employee_by_ids(employee_id integer, document_ids integer[]) TO umz_doc_edit;


--
-- Name: FUNCTION get_approveable_service_notes_for_employee_old(employee_id integer); Type: ACL; Schema: doc; Owner: developers
--

REVOKE ALL ON FUNCTION doc.get_approveable_service_notes_for_employee_old(employee_id integer) FROM PUBLIC;
GRANT ALL ON FUNCTION doc.get_approveable_service_notes_for_employee_old(employee_id integer) TO umz_doc_edit;


--
-- Name: FUNCTION get_approveable_service_notes_for_employee_old(employee_id integer, stage_names character varying[]); Type: ACL; Schema: doc; Owner: developers
--

REVOKE ALL ON FUNCTION doc.get_approveable_service_notes_for_employee_old(employee_id integer, stage_names character varying[]) FROM PUBLIC;
GRANT ALL ON FUNCTION doc.get_approveable_service_notes_for_employee_old(employee_id integer, stage_names character varying[]) TO umz_doc_edit;


--
-- Name: FUNCTION get_approveable_service_notes_from_departments(department_ids bigint[]); Type: ACL; Schema: doc; Owner: developers
--

REVOKE ALL ON FUNCTION doc.get_approveable_service_notes_from_departments(department_ids bigint[]) FROM PUBLIC;
GRANT ALL ON FUNCTION doc.get_approveable_service_notes_from_departments(department_ids bigint[]) TO umz_doc_edit;


--
-- Name: FUNCTION get_current_employee_id(); Type: ACL; Schema: doc; Owner: developers
--

REVOKE ALL ON FUNCTION doc.get_current_employee_id() FROM PUBLIC;
GRANT ALL ON FUNCTION doc.get_current_employee_id() TO umz_doc_edit;
GRANT ALL ON FUNCTION doc.get_current_employee_id() TO request_view;


--
-- Name: FUNCTION get_department_approveable_service_notes_by_ids(document_ids integer[]); Type: ACL; Schema: doc; Owner: developers
--

REVOKE ALL ON FUNCTION doc.get_department_approveable_service_notes_by_ids(document_ids integer[]) FROM PUBLIC;
GRANT ALL ON FUNCTION doc.get_department_approveable_service_notes_by_ids(document_ids integer[]) TO umz_doc_edit;


--
-- Name: FUNCTION get_department_incoming_service_notes_by_ids(document_ids integer[]); Type: ACL; Schema: doc; Owner: developers
--

REVOKE ALL ON FUNCTION doc.get_department_incoming_service_notes_by_ids(document_ids integer[]) FROM PUBLIC;
GRANT ALL ON FUNCTION doc.get_department_incoming_service_notes_by_ids(document_ids integer[]) TO umz_doc_edit;


--
-- Name: FUNCTION get_department_outcoming_service_notes_by_ids(document_ids integer[]); Type: ACL; Schema: doc; Owner: developers
--

REVOKE ALL ON FUNCTION doc.get_department_outcoming_service_notes_by_ids(document_ids integer[]) FROM PUBLIC;
GRANT ALL ON FUNCTION doc.get_department_outcoming_service_notes_by_ids(document_ids integer[]) TO umz_doc_edit;


--
-- Name: FUNCTION get_department_personnel_orders_by_ids(document_ids integer[]); Type: ACL; Schema: doc; Owner: developers
--

REVOKE ALL ON FUNCTION doc.get_department_personnel_orders_by_ids(document_ids integer[]) FROM PUBLIC;
GRANT ALL ON FUNCTION doc.get_department_personnel_orders_by_ids(document_ids integer[]) TO umz_doc_edit;


--
-- Name: FUNCTION get_department_tree_starting_with(start_department_id integer); Type: ACL; Schema: doc; Owner: developers
--

REVOKE ALL ON FUNCTION doc.get_department_tree_starting_with(start_department_id integer) FROM PUBLIC;
GRANT ALL ON FUNCTION doc.get_department_tree_starting_with(start_department_id integer) TO sup;
GRANT ALL ON FUNCTION doc.get_department_tree_starting_with(start_department_id integer) TO umz_doc_edit;


--
-- Name: FUNCTION get_employee_service_note_charge_sheets_performing_statistics(document_id integer, employee_id integer, start_top_level_charge_sheet_id integer); Type: ACL; Schema: doc; Owner: developers
--

REVOKE ALL ON FUNCTION doc.get_employee_service_note_charge_sheets_performing_statistics(document_id integer, employee_id integer, start_top_level_charge_sheet_id integer) FROM PUBLIC;
GRANT ALL ON FUNCTION doc.get_employee_service_note_charge_sheets_performing_statistics(document_id integer, employee_id integer, start_top_level_charge_sheet_id integer) TO umz_doc_edit;


--
-- Name: FUNCTION get_head_charge_sheet_for(charge_sheet_id integer); Type: ACL; Schema: doc; Owner: developers
--

REVOKE ALL ON FUNCTION doc.get_head_charge_sheet_for(charge_sheet_id integer) FROM PUBLIC;
GRANT ALL ON FUNCTION doc.get_head_charge_sheet_for(charge_sheet_id integer) TO umz_doc_edit;


--
-- Name: FUNCTION get_incoming_service_note_performing_statistics_for_employee(document_id integer, employee_id integer); Type: ACL; Schema: doc; Owner: developers
--

GRANT ALL ON FUNCTION doc.get_incoming_service_note_performing_statistics_for_employee(document_id integer, employee_id integer) TO umz_doc_edit;


--
-- Name: FUNCTION get_incoming_service_notes_for_employee_by_ids(employee_id integer, document_ids integer[]); Type: ACL; Schema: doc; Owner: developers
--

REVOKE ALL ON FUNCTION doc.get_incoming_service_notes_for_employee_by_ids(employee_id integer, document_ids integer[]) FROM PUBLIC;
GRANT ALL ON FUNCTION doc.get_incoming_service_notes_for_employee_by_ids(employee_id integer, document_ids integer[]) TO umz_doc_edit;


--
-- Name: FUNCTION get_incoming_service_notes_for_employee_old1(employee_id integer, stage_names character varying[]); Type: ACL; Schema: doc; Owner: developers
--

REVOKE ALL ON FUNCTION doc.get_incoming_service_notes_for_employee_old1(employee_id integer, stage_names character varying[]) FROM PUBLIC;
GRANT ALL ON FUNCTION doc.get_incoming_service_notes_for_employee_old1(employee_id integer, stage_names character varying[]) TO umz_doc_edit;


--
-- Name: FUNCTION get_incoming_service_notes_for_employee_old_(employee_id integer, stage_names character varying[]); Type: ACL; Schema: doc; Owner: developers
--

REVOKE ALL ON FUNCTION doc.get_incoming_service_notes_for_employee_old_(employee_id integer, stage_names character varying[]) FROM PUBLIC;
GRANT ALL ON FUNCTION doc.get_incoming_service_notes_for_employee_old_(employee_id integer, stage_names character varying[]) TO umz_doc_edit;


--
-- Name: FUNCTION get_incoming_service_notes_from_departments(department_ids bigint[]); Type: ACL; Schema: doc; Owner: developers
--

REVOKE ALL ON FUNCTION doc.get_incoming_service_notes_from_departments(department_ids bigint[]) FROM PUBLIC;
GRANT ALL ON FUNCTION doc.get_incoming_service_notes_from_departments(department_ids bigint[]) TO umz_doc_edit;


--
-- Name: FUNCTION get_kindred_department_tree_starting_with(start_department_id integer); Type: ACL; Schema: doc; Owner: developers
--

REVOKE ALL ON FUNCTION doc.get_kindred_department_tree_starting_with(start_department_id integer) FROM PUBLIC;
GRANT ALL ON FUNCTION doc.get_kindred_department_tree_starting_with(start_department_id integer) TO umz_doc_edit;


--
-- Name: FUNCTION get_new_status_for_request(request_id integer); Type: ACL; Schema: doc; Owner: developers
--

REVOKE ALL ON FUNCTION doc.get_new_status_for_request(request_id integer) FROM PUBLIC;
GRANT ALL ON FUNCTION doc.get_new_status_for_request(request_id integer) TO umz_doc_edit;


--
-- Name: FUNCTION get_not_kindred_inner_department_tree_for_department(start_department_id integer); Type: ACL; Schema: doc; Owner: developers
--

REVOKE ALL ON FUNCTION doc.get_not_kindred_inner_department_tree_for_department(start_department_id integer) FROM PUBLIC;
GRANT ALL ON FUNCTION doc.get_not_kindred_inner_department_tree_for_department(start_department_id integer) TO sup;
GRANT ALL ON FUNCTION doc.get_not_kindred_inner_department_tree_for_department(start_department_id integer) TO umz_doc_edit;


--
-- Name: FUNCTION get_not_performed_incoming_service_notes_report_data_for(employee_id integer, department_id integer, period_start date, period_end date); Type: ACL; Schema: doc; Owner: developers
--

REVOKE ALL ON FUNCTION doc.get_not_performed_incoming_service_notes_report_data_for(employee_id integer, department_id integer, period_start date, period_end date) FROM PUBLIC;
GRANT ALL ON FUNCTION doc.get_not_performed_incoming_service_notes_report_data_for(employee_id integer, department_id integer, period_start date, period_end date) TO umz_doc_edit;


--
-- Name: FUNCTION get_outcoming_correspondence_for_employee(employee_id integer); Type: ACL; Schema: doc; Owner: developers
--

REVOKE ALL ON FUNCTION doc.get_outcoming_correspondence_for_employee(employee_id integer) FROM PUBLIC;
GRANT ALL ON FUNCTION doc.get_outcoming_correspondence_for_employee(employee_id integer) TO umz_doc_edit;


--
-- Name: FUNCTION get_outcoming_correspondence_from_departments(department_ids bigint[]); Type: ACL; Schema: doc; Owner: developers
--

REVOKE ALL ON FUNCTION doc.get_outcoming_correspondence_from_departments(department_ids bigint[]) FROM PUBLIC;
GRANT ALL ON FUNCTION doc.get_outcoming_correspondence_from_departments(department_ids bigint[]) TO umz_doc_edit;


--
-- Name: FUNCTION get_outcoming_service_notes_for_employee(employee_id integer, stage_names character varying[]); Type: ACL; Schema: doc; Owner: developers
--

REVOKE ALL ON FUNCTION doc.get_outcoming_service_notes_for_employee(employee_id integer, stage_names character varying[]) FROM PUBLIC;
GRANT ALL ON FUNCTION doc.get_outcoming_service_notes_for_employee(employee_id integer, stage_names character varying[]) TO umz_doc_edit;


--
-- Name: FUNCTION get_outcoming_service_notes_for_employee_by_ids(employee_id integer, document_ids integer[]); Type: ACL; Schema: doc; Owner: developers
--

REVOKE ALL ON FUNCTION doc.get_outcoming_service_notes_for_employee_by_ids(employee_id integer, document_ids integer[]) FROM PUBLIC;
GRANT ALL ON FUNCTION doc.get_outcoming_service_notes_for_employee_by_ids(employee_id integer, document_ids integer[]) TO umz_doc_edit;


--
-- Name: FUNCTION get_outcoming_service_notes_for_employee_old(employee_id integer); Type: ACL; Schema: doc; Owner: developers
--

REVOKE ALL ON FUNCTION doc.get_outcoming_service_notes_for_employee_old(employee_id integer) FROM PUBLIC;
GRANT ALL ON FUNCTION doc.get_outcoming_service_notes_for_employee_old(employee_id integer) TO umz_doc_edit;


--
-- Name: FUNCTION get_outcoming_service_notes_from_departments(department_ids bigint[]); Type: ACL; Schema: doc; Owner: developers
--

REVOKE ALL ON FUNCTION doc.get_outcoming_service_notes_from_departments(department_ids bigint[]) FROM PUBLIC;
GRANT ALL ON FUNCTION doc.get_outcoming_service_notes_from_departments(department_ids bigint[]) TO umz_doc_edit;


--
-- Name: FUNCTION get_personnel_orders_for_employee(employee_id integer); Type: ACL; Schema: doc; Owner: developers
--

REVOKE ALL ON FUNCTION doc.get_personnel_orders_for_employee(employee_id integer) FROM PUBLIC;
GRANT ALL ON FUNCTION doc.get_personnel_orders_for_employee(employee_id integer) TO umz_doc_edit;


--
-- Name: FUNCTION get_personnel_orders_for_employee_by_ids(employee_id integer, document_ids integer[]); Type: ACL; Schema: doc; Owner: developers
--

REVOKE ALL ON FUNCTION doc.get_personnel_orders_for_employee_by_ids(employee_id integer, document_ids integer[]) FROM PUBLIC;
GRANT ALL ON FUNCTION doc.get_personnel_orders_for_employee_by_ids(employee_id integer, document_ids integer[]) TO umz_doc_edit;


--
-- Name: FUNCTION get_personnel_orders_from_departments(department_ids integer[]); Type: ACL; Schema: doc; Owner: developers
--

REVOKE ALL ON FUNCTION doc.get_personnel_orders_from_departments(department_ids integer[]) FROM PUBLIC;
GRANT ALL ON FUNCTION doc.get_personnel_orders_from_departments(department_ids integer[]) TO umz_doc_edit;


--
-- Name: FUNCTION get_resource_request_contents_for_employee(employee_id integer, request_id integer); Type: ACL; Schema: doc; Owner: developers
--

REVOKE ALL ON FUNCTION doc.get_resource_request_contents_for_employee(employee_id integer, request_id integer) FROM PUBLIC;
GRANT ALL ON FUNCTION doc.get_resource_request_contents_for_employee(employee_id integer, request_id integer) TO umz_doc_edit;


--
-- Name: FUNCTION get_resource_requests_count_for_employee(employee_id integer); Type: ACL; Schema: doc; Owner: developers
--

REVOKE ALL ON FUNCTION doc.get_resource_requests_count_for_employee(employee_id integer) FROM PUBLIC;
GRANT ALL ON FUNCTION doc.get_resource_requests_count_for_employee(employee_id integer) TO umz_doc_edit;


--
-- Name: FUNCTION get_resource_requests_for_employee(employee_id integer); Type: ACL; Schema: doc; Owner: developers
--

REVOKE ALL ON FUNCTION doc.get_resource_requests_for_employee(employee_id integer) FROM PUBLIC;
GRANT ALL ON FUNCTION doc.get_resource_requests_for_employee(employee_id integer) TO umz_doc_edit;


--
-- Name: FUNCTION get_service_note_performing_statistics(document_id bigint); Type: ACL; Schema: doc; Owner: developers
--

REVOKE ALL ON FUNCTION doc.get_service_note_performing_statistics(document_id bigint) FROM PUBLIC;
GRANT ALL ON FUNCTION doc.get_service_note_performing_statistics(document_id bigint) TO umz_doc_edit;


--
-- Name: FUNCTION get_service_note_subordinate_performing_statistics_for_employee(document_id integer, employee_id integer); Type: ACL; Schema: doc; Owner: developers
--

GRANT ALL ON FUNCTION doc.get_service_note_subordinate_performing_statistics_for_employee(document_id integer, employee_id integer) TO umz_doc_edit;


--
-- Name: FUNCTION get_user_relation_access_rights_by_roles(relation character varying, userroles text[]); Type: ACL; Schema: doc; Owner: developers
--

REVOKE ALL ON FUNCTION doc.get_user_relation_access_rights_by_roles(relation character varying, userroles text[]) FROM PUBLIC;
GRANT ALL ON FUNCTION doc.get_user_relation_access_rights_by_roles(relation character varying, userroles text[]) TO umz_doc_edit;
GRANT ALL ON FUNCTION doc.get_user_relation_access_rights_by_roles(relation character varying, userroles text[]) TO sd_read;


--
-- Name: FUNCTION get_user_roles_by_reg_expr(username character varying, reg_expr character varying, use_recursive boolean); Type: ACL; Schema: doc; Owner: sup
--

REVOKE ALL ON FUNCTION doc.get_user_roles_by_reg_expr(username character varying, reg_expr character varying, use_recursive boolean) FROM PUBLIC;
GRANT ALL ON FUNCTION doc.get_user_roles_by_reg_expr(username character varying, reg_expr character varying, use_recursive boolean) TO sd_read;
GRANT ALL ON FUNCTION doc.get_user_roles_by_reg_expr(username character varying, reg_expr character varying, use_recursive boolean) TO umz_doc_edit;
GRANT ALL ON FUNCTION doc.get_user_roles_by_reg_expr(username character varying, reg_expr character varying, use_recursive boolean) TO developers;


--
-- Name: FUNCTION is_department_includes_other_department(target_department_id integer, other_department_id integer); Type: ACL; Schema: doc; Owner: developers
--

REVOKE ALL ON FUNCTION doc.is_department_includes_other_department(target_department_id integer, other_department_id integer) FROM PUBLIC;
GRANT ALL ON FUNCTION doc.is_department_includes_other_department(target_department_id integer, other_department_id integer) TO umz_doc_edit;


--
-- Name: FUNCTION is_employee_acting_for_other_or_vice_versa(supposed_acting_employee_id integer, employee_id integer); Type: ACL; Schema: doc; Owner: developers
--

REVOKE ALL ON FUNCTION doc.is_employee_acting_for_other_or_vice_versa(supposed_acting_employee_id integer, employee_id integer) FROM PUBLIC;
GRANT ALL ON FUNCTION doc.is_employee_acting_for_other_or_vice_versa(supposed_acting_employee_id integer, employee_id integer) TO umz_doc_edit;


--
-- Name: FUNCTION is_employee_replacing_for_other(target_employee_id bigint, other_employee_id bigint); Type: ACL; Schema: doc; Owner: developers
--

REVOKE ALL ON FUNCTION doc.is_employee_replacing_for_other(target_employee_id bigint, other_employee_id bigint) FROM PUBLIC;
GRANT ALL ON FUNCTION doc.is_employee_replacing_for_other(target_employee_id bigint, other_employee_id bigint) TO umz_doc_edit;


--
-- Name: FUNCTION is_employee_secretary_for(supposed_secretary_id integer, employee_id integer); Type: ACL; Schema: doc; Owner: developers
--

REVOKE ALL ON FUNCTION doc.is_employee_secretary_for(supposed_secretary_id integer, employee_id integer) FROM PUBLIC;
GRANT ALL ON FUNCTION doc.is_employee_secretary_for(supposed_secretary_id integer, employee_id integer) TO umz_doc_edit;


--
-- Name: FUNCTION is_employee_secretary_for_other_or_vice_versa(supposed_secretary_id integer, employee_id integer); Type: ACL; Schema: doc; Owner: developers
--

REVOKE ALL ON FUNCTION doc.is_employee_secretary_for_other_or_vice_versa(supposed_secretary_id integer, employee_id integer) FROM PUBLIC;
GRANT ALL ON FUNCTION doc.is_employee_secretary_for_other_or_vice_versa(supposed_secretary_id integer, employee_id integer) TO umz_doc_edit;


--
-- Name: FUNCTION is_employee_secretary_signer_for_other(target_employee_id integer, other_employee_id integer); Type: ACL; Schema: doc; Owner: developers
--

REVOKE ALL ON FUNCTION doc.is_employee_secretary_signer_for_other(target_employee_id integer, other_employee_id integer) FROM PUBLIC;
GRANT ALL ON FUNCTION doc.is_employee_secretary_signer_for_other(target_employee_id integer, other_employee_id integer) TO umz_doc_edit;


--
-- Name: FUNCTION is_employee_subleader_for_other(target_employee_id integer, other_employee_id integer); Type: ACL; Schema: doc; Owner: developers
--

REVOKE ALL ON FUNCTION doc.is_employee_subleader_for_other(target_employee_id integer, other_employee_id integer) FROM PUBLIC;
GRANT ALL ON FUNCTION doc.is_employee_subleader_for_other(target_employee_id integer, other_employee_id integer) TO umz_doc_edit;


--
-- Name: FUNCTION is_employee_subleader_or_replacing_for_other(supposed_acting_employee_id integer, employee_id integer); Type: ACL; Schema: doc; Owner: developers
--

REVOKE ALL ON FUNCTION doc.is_employee_subleader_or_replacing_for_other(supposed_acting_employee_id integer, employee_id integer) FROM PUBLIC;
GRANT ALL ON FUNCTION doc.is_employee_subleader_or_replacing_for_other(supposed_acting_employee_id integer, employee_id integer) TO umz_doc_edit;


--
-- Name: FUNCTION mark_document_charge_as_viewed(document_type_id integer, document_charge_id bigint, view_date timestamp without time zone); Type: ACL; Schema: doc; Owner: developers
--

REVOKE ALL ON FUNCTION doc.mark_document_charge_as_viewed(document_type_id integer, document_charge_id bigint, view_date timestamp without time zone) FROM PUBLIC;
GRANT ALL ON FUNCTION doc.mark_document_charge_as_viewed(document_type_id integer, document_charge_id bigint, view_date timestamp without time zone) TO request_edit;
GRANT ALL ON FUNCTION doc.mark_document_charge_as_viewed(document_type_id integer, document_charge_id bigint, view_date timestamp without time zone) TO request_view;
GRANT ALL ON FUNCTION doc.mark_document_charge_as_viewed(document_type_id integer, document_charge_id bigint, view_date timestamp without time zone) TO umz_doc_edit;
GRANT ALL ON FUNCTION doc.mark_document_charge_as_viewed(document_type_id integer, document_charge_id bigint, view_date timestamp without time zone) TO u_53917;


--
-- Name: FUNCTION perform_charge(document_type_id integer, charge_id bigint, comment character varying, performing_date timestamp without time zone); Type: ACL; Schema: doc; Owner: developers
--

REVOKE ALL ON FUNCTION doc.perform_charge(document_type_id integer, charge_id bigint, comment character varying, performing_date timestamp without time zone) FROM PUBLIC;
GRANT ALL ON FUNCTION doc.perform_charge(document_type_id integer, charge_id bigint, comment character varying, performing_date timestamp without time zone) TO request_edit;
GRANT ALL ON FUNCTION doc.perform_charge(document_type_id integer, charge_id bigint, comment character varying, performing_date timestamp without time zone) TO request_view;
GRANT ALL ON FUNCTION doc.perform_charge(document_type_id integer, charge_id bigint, comment character varying, performing_date timestamp without time zone) TO umz_doc_edit;
GRANT ALL ON FUNCTION doc.perform_charge(document_type_id integer, charge_id bigint, comment character varying, performing_date timestamp without time zone) TO u_53917;


--
-- Name: FUNCTION perform_charges_by_application(document_type_id integer, application_id bigint, comment character varying, performing_date timestamp without time zone); Type: ACL; Schema: doc; Owner: developers
--

REVOKE ALL ON FUNCTION doc.perform_charges_by_application(document_type_id integer, application_id bigint, comment character varying, performing_date timestamp without time zone) FROM PUBLIC;
GRANT ALL ON FUNCTION doc.perform_charges_by_application(document_type_id integer, application_id bigint, comment character varying, performing_date timestamp without time zone) TO request_edit;
GRANT ALL ON FUNCTION doc.perform_charges_by_application(document_type_id integer, application_id bigint, comment character varying, performing_date timestamp without time zone) TO request_view;
GRANT ALL ON FUNCTION doc.perform_charges_by_application(document_type_id integer, application_id bigint, comment character varying, performing_date timestamp without time zone) TO umz_doc_edit;
GRANT ALL ON FUNCTION doc.perform_charges_by_application(document_type_id integer, application_id bigint, comment character varying, performing_date timestamp without time zone) TO u_53917;


--
-- Name: FUNCTION sd_requests_portal_add(p_req_content_id integer); Type: ACL; Schema: doc; Owner: sup
--

GRANT ALL ON FUNCTION doc.sd_requests_portal_add(p_req_content_id integer) TO developers;


--
-- Name: FUNCTION service_note_signer_department_trigger_func(); Type: ACL; Schema: doc; Owner: developers
--

REVOKE ALL ON FUNCTION doc.service_note_signer_department_trigger_func() FROM PUBLIC;
GRANT ALL ON FUNCTION doc.service_note_signer_department_trigger_func() TO umz_doc_edit;


--
-- Name: FUNCTION set_head_charge_sheet_for_new_charge_sheet(); Type: ACL; Schema: doc; Owner: developers
--

REVOKE ALL ON FUNCTION doc.set_head_charge_sheet_for_new_charge_sheet() FROM PUBLIC;
GRANT ALL ON FUNCTION doc.set_head_charge_sheet_for_new_charge_sheet() TO umz_doc_edit;


--
-- Name: FUNCTION set_personnel_orders_test_data(); Type: ACL; Schema: doc; Owner: u_59968
--

REVOKE ALL ON FUNCTION doc.set_personnel_orders_test_data() FROM PUBLIC;
GRANT ALL ON FUNCTION doc.set_personnel_orders_test_data() TO developers;


--
-- Name: FUNCTION update_department_employees_head_kindred_department_trigger_fun(); Type: ACL; Schema: doc; Owner: developers
--

GRANT ALL ON FUNCTION doc.update_department_employees_head_kindred_department_trigger_fun() TO umz_doc_edit;


--
-- Name: TABLE acceptance_posting_kinds; Type: ACL; Schema: doc; Owner: developers
--

GRANT ALL ON TABLE doc.acceptance_posting_kinds TO umz_doc_edit;


--
-- Name: SEQUENCE acceptance_posting_kinds_id_seq; Type: ACL; Schema: doc; Owner: developers
--

GRANT ALL ON SEQUENCE doc.acceptance_posting_kinds_id_seq TO umz_doc_edit;


--
-- Name: TABLE correspondence_creating_access_employee; Type: ACL; Schema: doc; Owner: developers
--

GRANT ALL ON TABLE doc.correspondence_creating_access_employee TO umz_doc_edit;


--
-- Name: TABLE correspondents; Type: ACL; Schema: doc; Owner: developers
--

GRANT ALL ON TABLE doc.correspondents TO umz_doc_edit;


--
-- Name: SEQUENCE correspondents_id_seq; Type: ACL; Schema: doc; Owner: developers
--

GRANT ALL ON SEQUENCE doc.correspondents_id_seq TO umz_doc_edit;
GRANT ALL ON SEQUENCE doc.correspondents_id_seq TO u_59968;


--
-- Name: TABLE department_email; Type: ACL; Schema: doc; Owner: developers
--

GRANT ALL ON TABLE doc.department_email TO umz_doc_edit;


--
-- Name: SEQUENCE department_email_id_seq; Type: ACL; Schema: doc; Owner: developers
--

GRANT ALL ON SEQUENCE doc.department_email_id_seq TO umz_doc_edit;


--
-- Name: SEQUENCE departments_outside_id_seq; Type: ACL; Schema: doc; Owner: developers
--

GRANT ALL ON SEQUENCE doc.departments_outside_id_seq TO umz_doc_edit;


--
-- Name: TABLE departments; Type: ACL; Schema: doc; Owner: developers
--

GRANT ALL ON TABLE doc.departments TO umz_doc_edit;


--
-- Name: TABLE document_approving_results; Type: ACL; Schema: doc; Owner: developers
--

GRANT ALL ON TABLE doc.document_approving_results TO umz_doc_edit;


--
-- Name: SEQUENCE document_approving_results_id_seq; Type: ACL; Schema: doc; Owner: developers
--

GRANT ALL ON SEQUENCE doc.document_approving_results_id_seq TO umz_doc_edit;


--
-- Name: TABLE document_approvings; Type: ACL; Schema: doc; Owner: developers
--

GRANT ALL ON TABLE doc.document_approvings TO umz_doc_edit;


--
-- Name: SEQUENCE document_approvings_id_seq; Type: ACL; Schema: doc; Owner: developers
--

GRANT ALL ON SEQUENCE doc.document_approvings_id_seq TO umz_doc_edit;


--
-- Name: TABLE document_charge_types; Type: ACL; Schema: doc; Owner: developers
--

GRANT ALL ON TABLE doc.document_charge_types TO umz_doc_edit;


--
-- Name: SEQUENCE document_charge_types_id_seq; Type: ACL; Schema: doc; Owner: developers
--

GRANT ALL ON SEQUENCE doc.document_charge_types_id_seq TO umz_doc_edit;


--
-- Name: TABLE document_file_metadata; Type: ACL; Schema: doc; Owner: developers
--

GRANT ALL ON TABLE doc.document_file_metadata TO umz_doc_edit;


--
-- Name: SEQUENCE document_file_metadata_uit_id_seq; Type: ACL; Schema: doc; Owner: developers
--

GRANT ALL ON SEQUENCE doc.document_file_metadata_uit_id_seq TO umz_doc_edit;


--
-- Name: TABLE document_type_work_cycle_stages; Type: ACL; Schema: doc; Owner: developers
--

GRANT ALL ON TABLE doc.document_type_work_cycle_stages TO umz_doc_edit;


--
-- Name: SEQUENCE document_life_cycle_stages_id_seq; Type: ACL; Schema: doc; Owner: developers
--

GRANT ALL ON SEQUENCE doc.document_life_cycle_stages_id_seq TO umz_doc_edit;


--
-- Name: TABLE document_links; Type: ACL; Schema: doc; Owner: developers
--

GRANT ALL ON TABLE doc.document_links TO umz_doc_edit;


--
-- Name: SEQUENCE document_links_uit_id_seq; Type: ACL; Schema: doc; Owner: developers
--

GRANT ALL ON SEQUENCE doc.document_links_uit_id_seq TO umz_doc_edit;


--
-- Name: TABLE document_numerators; Type: ACL; Schema: doc; Owner: developers
--

GRANT ALL ON TABLE doc.document_numerators TO umz_doc_edit;


--
-- Name: SEQUENCE document_numerators_id_seq; Type: ACL; Schema: doc; Owner: developers
--

GRANT ALL ON SEQUENCE doc.document_numerators_id_seq TO umz_doc_edit;


--
-- Name: TABLE document_receivers; Type: ACL; Schema: doc; Owner: developers
--

GRANT ALL ON TABLE doc.document_receivers TO umz_doc_edit;


--
-- Name: SEQUENCE document_receivers_uit_id_seq; Type: ACL; Schema: doc; Owner: developers
--

GRANT ALL ON SEQUENCE doc.document_receivers_uit_id_seq TO umz_doc_edit;


--
-- Name: TABLE document_signings; Type: ACL; Schema: doc; Owner: developers
--

GRANT ALL ON TABLE doc.document_signings TO umz_doc_edit;


--
-- Name: SEQUENCE document_signings_id_seq; Type: ACL; Schema: doc; Owner: developers
--

GRANT USAGE ON SEQUENCE doc.document_signings_id_seq TO umz_doc_edit;


--
-- Name: TABLE document_types; Type: ACL; Schema: doc; Owner: developers
--

GRANT ALL ON TABLE doc.document_types TO umz_doc_edit;


--
-- Name: TABLE document_types_allowable_document_charges_types; Type: ACL; Schema: doc; Owner: developers
--

GRANT ALL ON TABLE doc.document_types_allowable_document_charges_types TO umz_doc_edit;


--
-- Name: SEQUENCE document_types_allowable_document_charges_types_id_seq; Type: ACL; Schema: doc; Owner: developers
--

GRANT USAGE ON SEQUENCE doc.document_types_allowable_document_charges_types_id_seq TO umz_doc_edit;


--
-- Name: SEQUENCE document_types_id_seq; Type: ACL; Schema: doc; Owner: developers
--

GRANT ALL ON SEQUENCE doc.document_types_id_seq TO umz_doc_edit;


--
-- Name: TABLE documents; Type: ACL; Schema: doc; Owner: developers
--

GRANT ALL ON TABLE doc.documents TO umz_doc_edit;


--
-- Name: TABLE documents_view_access_rights; Type: ACL; Schema: doc; Owner: developers
--

GRANT ALL ON TABLE doc.documents_view_access_rights TO umz_doc_edit;


--
-- Name: SEQUENCE documents_view_access_rights_id_seq; Type: ACL; Schema: doc; Owner: developers
--

GRANT ALL ON SEQUENCE doc.documents_view_access_rights_id_seq TO umz_doc_edit;


--
-- Name: TABLE employee_replacements; Type: ACL; Schema: doc; Owner: developers
--

GRANT ALL ON TABLE doc.employee_replacements TO umz_doc_edit;


--
-- Name: SEQUENCE employee_replacements_id_seq; Type: ACL; Schema: doc; Owner: developers
--

GRANT ALL ON SEQUENCE doc.employee_replacements_id_seq TO umz_doc_edit;


--
-- Name: TABLE employee_work_groups; Type: ACL; Schema: doc; Owner: developers
--

GRANT ALL ON TABLE doc.employee_work_groups TO umz_doc_edit;


--
-- Name: SEQUENCE employee_work_groups_id_seq; Type: ACL; Schema: doc; Owner: developers
--

GRANT ALL ON SEQUENCE doc.employee_work_groups_id_seq TO umz_doc_edit;


--
-- Name: TABLE employees; Type: ACL; Schema: doc; Owner: developers
--

GRANT ALL ON TABLE doc.employees TO umz_doc_edit;
GRANT SELECT ON TABLE doc.employees TO request_view;


--
-- Name: TABLE employees_employee_work_groups; Type: ACL; Schema: doc; Owner: developers
--

GRANT ALL ON TABLE doc.employees_employee_work_groups TO umz_doc_edit;


--
-- Name: SEQUENCE employees_employee_work_groups_id_seq; Type: ACL; Schema: doc; Owner: developers
--

GRANT ALL ON SEQUENCE doc.employees_employee_work_groups_id_seq TO umz_doc_edit;


--
-- Name: SEQUENCE employees_outside_id_seq; Type: ACL; Schema: doc; Owner: developers
--

GRANT ALL ON SEQUENCE doc.employees_outside_id_seq TO umz_doc_edit;


--
-- Name: TABLE employees_roles; Type: ACL; Schema: doc; Owner: developers
--

GRANT ALL ON TABLE doc.employees_roles TO umz_doc_edit;


--
-- Name: TABLE employees_system_roles; Type: ACL; Schema: doc; Owner: developers
--

GRANT ALL ON TABLE doc.employees_system_roles TO umz_doc_edit;


--
-- Name: TABLE looked_document_charges; Type: ACL; Schema: doc; Owner: developers
--

GRANT ALL ON TABLE doc.looked_document_charges TO request_view;
GRANT ALL ON TABLE doc.looked_document_charges TO umz_doc_edit;
GRANT ALL ON TABLE doc.looked_document_charges TO request_edit;


--
-- Name: TABLE looked_documents; Type: ACL; Schema: doc; Owner: developers
--

GRANT ALL ON TABLE doc.looked_documents TO umz_doc_edit;


--
-- Name: SEQUENCE looked_documents_id_seq; Type: ACL; Schema: doc; Owner: developers
--

GRANT ALL ON SEQUENCE doc.looked_documents_id_seq TO umz_doc_edit;


--
-- Name: TABLE looked_personnel_orders; Type: ACL; Schema: doc; Owner: developers
--

GRANT ALL ON TABLE doc.looked_personnel_orders TO umz_doc_edit;


--
-- Name: TABLE looked_service_note_charges; Type: ACL; Schema: doc; Owner: developers
--

GRANT ALL ON TABLE doc.looked_service_note_charges TO request_view;
GRANT ALL ON TABLE doc.looked_service_note_charges TO umz_doc_edit;
GRANT ALL ON TABLE doc.looked_service_note_charges TO request_edit;


--
-- Name: TABLE looked_service_notes; Type: ACL; Schema: doc; Owner: developers
--

GRANT ALL ON TABLE doc.looked_service_notes TO umz_doc_edit;


--
-- Name: SEQUENCE looked_service_notes_id_seq; Type: ACL; Schema: doc; Owner: developers
--

GRANT ALL ON SEQUENCE doc.looked_service_notes_id_seq TO umz_doc_edit;


--
-- Name: TABLE personnel_order_approvings; Type: ACL; Schema: doc; Owner: developers
--

GRANT ALL ON TABLE doc.personnel_order_approvings TO umz_doc_edit;


--
-- Name: TABLE personnel_order_charges; Type: ACL; Schema: doc; Owner: developers
--

GRANT ALL ON TABLE doc.personnel_order_charges TO umz_doc_edit;


--
-- Name: TABLE personnel_order_control_groups; Type: ACL; Schema: doc; Owner: developers
--

GRANT ALL ON TABLE doc.personnel_order_control_groups TO umz_doc_edit;


--
-- Name: TABLE personnel_order_control_groups__employees; Type: ACL; Schema: doc; Owner: developers
--

GRANT ALL ON TABLE doc.personnel_order_control_groups__employees TO umz_doc_edit;


--
-- Name: TABLE personnel_order_control_groups__sub_kinds; Type: ACL; Schema: doc; Owner: developers
--

GRANT ALL ON TABLE doc.personnel_order_control_groups__sub_kinds TO umz_doc_edit;


--
-- Name: TABLE personnel_order_creating_access_employees; Type: ACL; Schema: doc; Owner: developers
--

GRANT ALL ON TABLE doc.personnel_order_creating_access_employees TO umz_doc_edit;


--
-- Name: TABLE personnel_order_file_metadata; Type: ACL; Schema: doc; Owner: developers
--

GRANT ALL ON TABLE doc.personnel_order_file_metadata TO umz_doc_edit;


--
-- Name: TABLE personnel_order_links; Type: ACL; Schema: doc; Owner: developers
--

GRANT ALL ON TABLE doc.personnel_order_links TO umz_doc_edit;


--
-- Name: TABLE personnel_order_signings; Type: ACL; Schema: doc; Owner: developers
--

GRANT ALL ON TABLE doc.personnel_order_signings TO umz_doc_edit;


--
-- Name: TABLE personnel_order_sub_kinds; Type: ACL; Schema: doc; Owner: developers
--

GRANT ALL ON TABLE doc.personnel_order_sub_kinds TO umz_doc_edit;


--
-- Name: TABLE personnel_order_sub_kinds__approvers; Type: ACL; Schema: doc; Owner: developers
--

GRANT ALL ON TABLE doc.personnel_order_sub_kinds__approvers TO umz_doc_edit;


--
-- Name: SEQUENCE service_notes_id_seq; Type: ACL; Schema: doc; Owner: developers
--

GRANT ALL ON SEQUENCE doc.service_notes_id_seq TO umz_doc_edit;


--
-- Name: TABLE personnel_orders; Type: ACL; Schema: doc; Owner: developers
--

GRANT ALL ON TABLE doc.personnel_orders TO umz_doc_edit;


--
-- Name: TABLE plant_structure_access_employees; Type: ACL; Schema: doc; Owner: developers
--

GRANT ALL ON TABLE doc.plant_structure_access_employees TO umz_doc_edit;
GRANT SELECT ON TABLE doc.plant_structure_access_employees TO employees;


--
-- Name: TABLE res_requests_sended_messages; Type: ACL; Schema: doc; Owner: developers
--

GRANT SELECT,INSERT ON TABLE doc.res_requests_sended_messages TO umz_doc_edit;


--
-- Name: TABLE role_rights; Type: ACL; Schema: doc; Owner: developers
--

GRANT ALL ON TABLE doc.role_rights TO umz_doc_edit;


--
-- Name: SEQUENCE role_rights_id_seq; Type: ACL; Schema: doc; Owner: developers
--

GRANT ALL ON SEQUENCE doc.role_rights_id_seq TO umz_doc_edit;


--
-- Name: TABLE roles; Type: ACL; Schema: doc; Owner: developers
--

GRANT ALL ON TABLE doc.roles TO umz_doc_edit;


--
-- Name: SEQUENCE roles_id_seq; Type: ACL; Schema: doc; Owner: developers
--

GRANT ALL ON SEQUENCE doc.roles_id_seq TO umz_doc_edit;


--
-- Name: TABLE roles_role_rights; Type: ACL; Schema: doc; Owner: developers
--

GRANT ALL ON TABLE doc.roles_role_rights TO umz_doc_edit;


--
-- Name: TABLE sd_database_system_names; Type: ACL; Schema: doc; Owner: sup
--

GRANT ALL ON TABLE doc.sd_database_system_names TO developers;
GRANT SELECT ON TABLE doc.sd_database_system_names TO sd_resources_read;
GRANT ALL ON TABLE doc.sd_database_system_names TO sd_resources_edit;


--
-- Name: SEQUENCE sd_database_system_names_id_seq; Type: ACL; Schema: doc; Owner: sup
--

GRANT ALL ON SEQUENCE doc.sd_database_system_names_id_seq TO developers;


--
-- Name: TABLE sd_development_environment_names; Type: ACL; Schema: doc; Owner: sup
--

GRANT ALL ON TABLE doc.sd_development_environment_names TO developers;
GRANT SELECT ON TABLE doc.sd_development_environment_names TO sd_resources_read;
GRANT ALL ON TABLE doc.sd_development_environment_names TO sd_resources_edit;


--
-- Name: SEQUENCE sd_development_environment_names_id_seq; Type: ACL; Schema: doc; Owner: sup
--

GRANT ALL ON SEQUENCE doc.sd_development_environment_names_id_seq TO developers;


--
-- Name: TABLE sd_equipment_types; Type: ACL; Schema: doc; Owner: sup
--

GRANT SELECT ON TABLE doc.sd_equipment_types TO sd_ip_read;
GRANT ALL ON TABLE doc.sd_equipment_types TO umz_doc_edit;
GRANT ALL ON TABLE doc.sd_equipment_types TO sd_ip_edit;
GRANT ALL ON TABLE doc.sd_equipment_types TO developers;


--
-- Name: SEQUENCE sd_equipment_types_id_seq; Type: ACL; Schema: doc; Owner: sup
--

GRANT ALL ON SEQUENCE doc.sd_equipment_types_id_seq TO sd_ip_edit;
GRANT ALL ON SEQUENCE doc.sd_equipment_types_id_seq TO sd_ip_partial_edit;
GRANT ALL ON SEQUENCE doc.sd_equipment_types_id_seq TO umz_doc_edit;
GRANT ALL ON SEQUENCE doc.sd_equipment_types_id_seq TO developers;


--
-- Name: TABLE sd_ip_adresses; Type: ACL; Schema: doc; Owner: sup
--

GRANT SELECT ON TABLE doc.sd_ip_adresses TO sd_ip_read;
GRANT ALL ON TABLE doc.sd_ip_adresses TO umz_doc_edit;
GRANT ALL ON TABLE doc.sd_ip_adresses TO sd_ip_edit;
GRANT ALL ON TABLE doc.sd_ip_adresses TO sd_ip_partial_edit;
GRANT ALL ON TABLE doc.sd_ip_adresses TO developers;


--
-- Name: SEQUENCE sd_ip_adresses_id_seq; Type: ACL; Schema: doc; Owner: sup
--

GRANT ALL ON SEQUENCE doc.sd_ip_adresses_id_seq TO sd_ip_edit;
GRANT ALL ON SEQUENCE doc.sd_ip_adresses_id_seq TO sd_ip_partial_edit;
GRANT ALL ON SEQUENCE doc.sd_ip_adresses_id_seq TO umz_doc_edit;
GRANT ALL ON SEQUENCE doc.sd_ip_adresses_id_seq TO developers;


--
-- Name: SEQUENCE sd_request_portal; Type: ACL; Schema: doc; Owner: sup
--

GRANT ALL ON SEQUENCE doc.sd_request_portal TO service_postfix_person_recipient;
GRANT ALL ON SEQUENCE doc.sd_request_portal TO developers;


--
-- Name: TABLE sd_resource_statuses; Type: ACL; Schema: doc; Owner: sup
--

GRANT ALL ON TABLE doc.sd_resource_statuses TO developers;
GRANT SELECT ON TABLE doc.sd_resource_statuses TO sd_resources_read;
GRANT ALL ON TABLE doc.sd_resource_statuses TO sd_resources_edit;


--
-- Name: SEQUENCE sd_resource_statuses_id_seq; Type: ACL; Schema: doc; Owner: sup
--

GRANT ALL ON SEQUENCE doc.sd_resource_statuses_id_seq TO developers;


--
-- Name: TABLE sd_resources_access_rights; Type: ACL; Schema: doc; Owner: sup
--

GRANT ALL ON TABLE doc.sd_resources_access_rights TO developers;
GRANT SELECT ON TABLE doc.sd_resources_access_rights TO sd_resources_read;
GRANT ALL ON TABLE doc.sd_resources_access_rights TO sd_resources_edit;


--
-- Name: SEQUENCE sd_resources_access_rights_id_seq; Type: ACL; Schema: doc; Owner: sup
--

GRANT ALL ON SEQUENCE doc.sd_resources_access_rights_id_seq TO sd_resources_edit;
GRANT ALL ON SEQUENCE doc.sd_resources_access_rights_id_seq TO developers;


--
-- Name: TABLE sd_serv_desc_requests; Type: ACL; Schema: doc; Owner: sup
--

GRANT ALL ON TABLE doc.sd_serv_desc_requests TO service_desk_manager_sd;
GRANT SELECT,UPDATE ON TABLE doc.sd_serv_desc_requests TO service_desk_employee_sd;
GRANT ALL ON TABLE doc.sd_serv_desc_requests TO developers;


--
-- Name: SEQUENCE sd_serv_desc_requests_id_seq; Type: ACL; Schema: doc; Owner: sup
--

GRANT ALL ON SEQUENCE doc.sd_serv_desc_requests_id_seq TO service_desk_manager_sd;
GRANT ALL ON SEQUENCE doc.sd_serv_desc_requests_id_seq TO developers;


--
-- Name: TABLE sd_serv_desc_resp_for_exec_requests; Type: ACL; Schema: doc; Owner: sup
--

GRANT ALL ON TABLE doc.sd_serv_desc_resp_for_exec_requests TO service_desk_manager_sd;
GRANT SELECT,INSERT,DELETE,UPDATE ON TABLE doc.sd_serv_desc_resp_for_exec_requests TO service_desk_employee_sd;
GRANT ALL ON TABLE doc.sd_serv_desc_resp_for_exec_requests TO developers;


--
-- Name: SEQUENCE sd_serv_desc_resp_for_exec_requests_id_seq; Type: ACL; Schema: doc; Owner: sup
--

GRANT ALL ON SEQUENCE doc.sd_serv_desc_resp_for_exec_requests_id_seq TO service_desk_manager_sd;
GRANT ALL ON SEQUENCE doc.sd_serv_desc_resp_for_exec_requests_id_seq TO service_desk_employee_sd;
GRANT ALL ON SEQUENCE doc.sd_serv_desc_resp_for_exec_requests_id_seq TO developers;


--
-- Name: TABLE sd_serv_desk_request_statuses; Type: ACL; Schema: doc; Owner: sup
--

GRANT SELECT ON TABLE doc.sd_serv_desk_request_statuses TO service_desk_manager_sd;
GRANT SELECT ON TABLE doc.sd_serv_desk_request_statuses TO service_desk_employee_sd;
GRANT ALL ON TABLE doc.sd_serv_desk_request_statuses TO developers;


--
-- Name: SEQUENCE sd_serv_desk_request_statuses_id_seq; Type: ACL; Schema: doc; Owner: sup
--

GRANT ALL ON SEQUENCE doc.sd_serv_desk_request_statuses_id_seq TO developers;


--
-- Name: TABLE sd_serv_desk_request_subtypes; Type: ACL; Schema: doc; Owner: sup
--

GRANT SELECT ON TABLE doc.sd_serv_desk_request_subtypes TO service_desk_manager_sd;
GRANT SELECT ON TABLE doc.sd_serv_desk_request_subtypes TO service_desk_employee_sd;
GRANT ALL ON TABLE doc.sd_serv_desk_request_subtypes TO developers;


--
-- Name: SEQUENCE sd_serv_desk_request_subtypes_id_seq; Type: ACL; Schema: doc; Owner: sup
--

GRANT ALL ON SEQUENCE doc.sd_serv_desk_request_subtypes_id_seq TO developers;


--
-- Name: TABLE sd_serv_desk_request_types; Type: ACL; Schema: doc; Owner: sup
--

GRANT SELECT ON TABLE doc.sd_serv_desk_request_types TO service_desk_manager_sd;
GRANT SELECT ON TABLE doc.sd_serv_desk_request_types TO service_desk_employee_sd;
GRANT ALL ON TABLE doc.sd_serv_desk_request_types TO developers;


--
-- Name: SEQUENCE sd_serv_desk_request_types_id_seq; Type: ACL; Schema: doc; Owner: sup
--

GRANT ALL ON SEQUENCE doc.sd_serv_desk_request_types_id_seq TO developers;


--
-- Name: TABLE sd_spr_equipment; Type: ACL; Schema: doc; Owner: sup
--

GRANT ALL ON TABLE doc.sd_spr_equipment TO umz_doc_edit;
GRANT ALL ON TABLE doc.sd_spr_equipment TO sd_equipment_edit;
GRANT SELECT ON TABLE doc.sd_spr_equipment TO sd_equipment_read;
GRANT ALL ON TABLE doc.sd_spr_equipment TO developers;


--
-- Name: SEQUENCE sd_spr_equipment_id_seq; Type: ACL; Schema: doc; Owner: sup
--

GRANT ALL ON SEQUENCE doc.sd_spr_equipment_id_seq TO sd_equipment_edit;
GRANT ALL ON SEQUENCE doc.sd_spr_equipment_id_seq TO umz_doc_edit;
GRANT ALL ON SEQUENCE doc.sd_spr_equipment_id_seq TO developers;


--
-- Name: TABLE sd_spr_laboratories; Type: ACL; Schema: doc; Owner: sup
--

GRANT ALL ON TABLE doc.sd_spr_laboratories TO developers;
GRANT SELECT ON TABLE doc.sd_spr_laboratories TO sd_resources_read;
GRANT ALL ON TABLE doc.sd_spr_laboratories TO sd_resources_edit;
GRANT SELECT ON TABLE doc.sd_spr_laboratories TO sd_read;
GRANT ALL ON TABLE doc.sd_spr_laboratories TO service_desk_manager_sd;


--
-- Name: SEQUENCE sd_spr_laboratories_id_seq; Type: ACL; Schema: doc; Owner: sup
--

GRANT ALL ON SEQUENCE doc.sd_spr_laboratories_id_seq TO sd_resources_edit;
GRANT ALL ON SEQUENCE doc.sd_spr_laboratories_id_seq TO developers;


--
-- Name: TABLE sd_spr_persons_in_laboratories; Type: ACL; Schema: doc; Owner: sup
--

GRANT ALL ON TABLE doc.sd_spr_persons_in_laboratories TO developers;
GRANT SELECT ON TABLE doc.sd_spr_persons_in_laboratories TO sd_read;
GRANT ALL ON TABLE doc.sd_spr_persons_in_laboratories TO sd_resources_edit;
GRANT ALL ON TABLE doc.sd_spr_persons_in_laboratories TO service_desk_manager_sd;


--
-- Name: TABLE sd_spr_resources; Type: ACL; Schema: doc; Owner: sup
--

GRANT ALL ON TABLE doc.sd_spr_resources TO developers;
GRANT SELECT ON TABLE doc.sd_spr_resources TO sd_resources_read;
GRANT ALL ON TABLE doc.sd_spr_resources TO sd_resources_edit;


--
-- Name: SEQUENCE sd_spr_resources_id_seq; Type: ACL; Schema: doc; Owner: sup
--

GRANT ALL ON SEQUENCE doc.sd_spr_resources_id_seq TO sd_resources_edit;
GRANT ALL ON SEQUENCE doc.sd_spr_resources_id_seq TO developers;


--
-- Name: TABLE service_note_approvings; Type: ACL; Schema: doc; Owner: developers
--

GRANT ALL ON TABLE doc.service_note_approvings TO umz_doc_edit;
GRANT SELECT ON TABLE doc.service_note_approvings TO request_view;


--
-- Name: SEQUENCE service_note_approvings_id_seq; Type: ACL; Schema: doc; Owner: developers
--

GRANT ALL ON SEQUENCE doc.service_note_approvings_id_seq TO umz_doc_edit;


--
-- Name: SEQUENCE service_note_file_metadata_id_seq; Type: ACL; Schema: doc; Owner: developers
--

GRANT ALL ON SEQUENCE doc.service_note_file_metadata_id_seq TO umz_doc_edit;


--
-- Name: TABLE service_note_file_metadata; Type: ACL; Schema: doc; Owner: developers
--

GRANT ALL ON TABLE doc.service_note_file_metadata TO umz_doc_edit;


--
-- Name: SEQUENCE service_note_links_id_seq; Type: ACL; Schema: doc; Owner: developers
--

GRANT ALL ON SEQUENCE doc.service_note_links_id_seq TO umz_doc_edit;


--
-- Name: TABLE service_note_links; Type: ACL; Schema: doc; Owner: developers
--

GRANT ALL ON TABLE doc.service_note_links TO umz_doc_edit;


--
-- Name: SEQUENCE service_note_receivers_id_seq; Type: ACL; Schema: doc; Owner: developers
--

GRANT ALL ON SEQUENCE doc.service_note_receivers_id_seq TO umz_doc_edit;


--
-- Name: TABLE service_note_receivers; Type: ACL; Schema: doc; Owner: developers
--

GRANT ALL ON TABLE doc.service_note_receivers TO umz_doc_edit;
GRANT SELECT ON TABLE doc.service_note_receivers TO request_view;


--
-- Name: TABLE service_note_signings; Type: ACL; Schema: doc; Owner: developers
--

GRANT ALL ON TABLE doc.service_note_signings TO umz_doc_edit;
GRANT SELECT ON TABLE doc.service_note_signings TO request_view;


--
-- Name: SEQUENCE service_note_signings_id_seq; Type: ACL; Schema: doc; Owner: developers
--

GRANT ALL ON SEQUENCE doc.service_note_signings_id_seq TO umz_doc_edit;


--
-- Name: SEQUENCE service_notes_outside_id_seq; Type: ACL; Schema: doc; Owner: developers
--

GRANT ALL ON SEQUENCE doc.service_notes_outside_id_seq TO umz_doc_edit;


--
-- Name: TABLE service_notes; Type: ACL; Schema: doc; Owner: developers
--

GRANT ALL ON TABLE doc.service_notes TO umz_doc_edit;


--
-- Name: TABLE system_roles; Type: ACL; Schema: doc; Owner: developers
--

GRANT ALL ON TABLE doc.system_roles TO umz_doc_edit;


--
-- Name: SEQUENCE system_roles_id_seq; Type: ACL; Schema: doc; Owner: developers
--

GRANT ALL ON SEQUENCE doc.system_roles_id_seq TO umz_doc_edit;


--
-- Name: TABLE users_for_which_permissible_receiving_notification_to_others; Type: ACL; Schema: doc; Owner: developers
--

GRANT ALL ON TABLE doc.users_for_which_permissible_receiving_notification_to_others TO umz_doc_edit;


--
-- Name: TABLE v_working_employees; Type: ACL; Schema: doc; Owner: u_57791
--

GRANT ALL ON TABLE doc.v_working_employees TO developers;


--
-- Name: TABLE v_all_possible_service_note_performers; Type: ACL; Schema: doc; Owner: u_57791
--

GRANT ALL ON TABLE doc.v_all_possible_service_note_performers TO umz_doc_edit;
GRANT ALL ON TABLE doc.v_all_possible_service_note_performers TO developers;


--
-- Name: TABLE v_departments_for_1c; Type: ACL; Schema: doc; Owner: sup
--

GRANT ALL ON TABLE doc.v_departments_for_1c TO adm1c;
GRANT ALL ON TABLE doc.v_departments_for_1c TO developers;


--
-- Name: TABLE v_document_charges; Type: ACL; Schema: doc; Owner: u_55536
--

GRANT ALL ON TABLE doc.v_document_charges TO umz_doc_edit;
GRANT SELECT ON TABLE doc.v_document_charges TO request_edit;
GRANT SELECT ON TABLE doc.v_document_charges TO request_view;
GRANT ALL ON TABLE doc.v_document_charges TO developers;


--
-- Name: TABLE v_document_files; Type: ACL; Schema: doc; Owner: sup
--

GRANT ALL ON TABLE doc.v_document_files TO umz_doc_edit;
GRANT SELECT ON TABLE doc.v_document_files TO request_edit;
GRANT ALL ON TABLE doc.v_document_files TO developers;


--
-- Name: TABLE v_document_numerators; Type: ACL; Schema: doc; Owner: u_55536
--

GRANT ALL ON TABLE doc.v_document_numerators TO umz_doc_edit;
GRANT ALL ON TABLE doc.v_document_numerators TO developers;


--
-- Name: TABLE v_documents; Type: ACL; Schema: doc; Owner: u_57791
--

GRANT ALL ON TABLE doc.v_documents TO umz_doc_edit;
GRANT SELECT ON TABLE doc.v_documents TO request_edit;
GRANT SELECT ON TABLE doc.v_documents TO request_view;
GRANT ALL ON TABLE doc.v_documents TO developers;


--
-- Name: TABLE v_employees; Type: ACL; Schema: doc; Owner: u_57791
--

GRANT ALL ON TABLE doc.v_employees TO umz_doc_edit;
GRANT ALL ON TABLE doc.v_employees TO developers;


--
-- Name: TABLE v_podr_departments; Type: ACL; Schema: doc; Owner: sup
--

GRANT SELECT ON TABLE doc.v_podr_departments TO umz_doc_edit;
GRANT ALL ON TABLE doc.v_podr_departments TO developers;


--
-- Name: TABLE v_sd_equipment; Type: ACL; Schema: doc; Owner: sup
--

GRANT SELECT ON TABLE doc.v_sd_equipment TO sd_equipment_edit;
GRANT ALL ON TABLE doc.v_sd_equipment TO umz_doc_edit;
GRANT SELECT ON TABLE doc.v_sd_equipment TO sd_equipment_read;
GRANT ALL ON TABLE doc.v_sd_equipment TO developers;


--
-- Name: TABLE v_sd_ip_adresses; Type: ACL; Schema: doc; Owner: sup
--

GRANT SELECT ON TABLE doc.v_sd_ip_adresses TO sd_ip_read;
GRANT ALL ON TABLE doc.v_sd_ip_adresses TO umz_doc_edit;
GRANT SELECT ON TABLE doc.v_sd_ip_adresses TO sd_ip_edit;
GRANT SELECT ON TABLE doc.v_sd_ip_adresses TO sd_ip_partial_edit;
GRANT ALL ON TABLE doc.v_sd_ip_adresses TO developers;


--
-- Name: TABLE v_sd_resources_and_sections; Type: ACL; Schema: doc; Owner: sup
--

GRANT SELECT ON TABLE doc.v_sd_resources_and_sections TO sd_resources_read;
GRANT SELECT ON TABLE doc.v_sd_resources_and_sections TO sd_resources_edit;
GRANT ALL ON TABLE doc.v_sd_resources_and_sections TO developers;


--
-- Name: TABLE v_sd_resources; Type: ACL; Schema: doc; Owner: sup
--

GRANT SELECT ON TABLE doc.v_sd_resources TO sd_resources_read;
GRANT SELECT ON TABLE doc.v_sd_resources TO sd_resources_edit;
GRANT ALL ON TABLE doc.v_sd_resources TO developers;


--
-- Name: TABLE v_sd_resources_access_rights; Type: ACL; Schema: doc; Owner: sup
--

GRANT SELECT ON TABLE doc.v_sd_resources_access_rights TO sd_resources_read;
GRANT SELECT ON TABLE doc.v_sd_resources_access_rights TO sd_resources_edit;
GRANT ALL ON TABLE doc.v_sd_resources_access_rights TO developers;


--
-- Name: TABLE v_sd_serv_desk_requests; Type: ACL; Schema: doc; Owner: sup
--

GRANT SELECT ON TABLE doc.v_sd_serv_desk_requests TO service_desk_manager_sd;
GRANT SELECT ON TABLE doc.v_sd_serv_desk_requests TO service_desk_employee_sd;
GRANT ALL ON TABLE doc.v_sd_serv_desk_requests TO developers;


--
-- Name: TABLE v_sd_serv_desk_resp_persons_for_exec_req; Type: ACL; Schema: doc; Owner: sup
--

GRANT SELECT ON TABLE doc.v_sd_serv_desk_resp_persons_for_exec_req TO service_desk_manager_sd;
GRANT SELECT ON TABLE doc.v_sd_serv_desk_resp_persons_for_exec_req TO service_desk_employee_sd;
GRANT ALL ON TABLE doc.v_sd_serv_desk_resp_persons_for_exec_req TO developers;


--
-- Name: TABLE versions_info; Type: ACL; Schema: doc; Owner: developers
--

GRANT ALL ON TABLE doc.versions_info TO umz_doc_edit;


--
-- PostgreSQL database dump complete
--

