drop function 

create type doc.employee_link as (employee_id bigint, role_id bigint, department_id bigint, head_kindred_department_id bigint);

alter type doc.employee_link alter attribute employee_id type int;

alter table doc.employees add column leader_links doc.employee_link[];

--alter function doc.calc_head_kindred_department_for_employee_trigger_proc() owner to u_59968;
--alter function doc.find_all_same_head_kindred_department_leaders_for_employee(int) owner to u_59968;

CREATE OR REPLACE FUNCTION doc.calc_head_kindred_department_for_employee_trigger_proc()
  RETURNS trigger AS
$BODY$
begin
	
	new.head_kindred_department_id = doc.find_head_kindred_department_for_inner(new.department_id);

	--raise exception '%', new.head_kindred_department_id;
	/*
	update doc.employees set head_kindred_department_id = null 
	where leader_id = new.id and exists(select 1 from doc.employees_roles where employee_id = new.id and role_id = 2);
	*/
	return new;
end
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;

GRANT EXECUTE ON FUNCTION doc.calc_head_kindred_department_for_employee_trigger_proc() TO umz_doc_edit;
REVOKE ALL ON FUNCTION doc.calc_head_kindred_department_for_employee_trigger_proc() FROM public;

drop function if exists doc.find_all_same_head_kindred_department_leaders_for_employee(int);
CREATE OR REPLACE FUNCTION doc.find_all_same_head_kindred_department_leaders_for_employee(IN employee_id int)
  RETURNS TABLE(
	id int, name character varying, surname character varying, patronymic character varying, speciality character varying, 
	personnel_number character varying, telephone_number character varying, is_foreign boolean, department_code character varying, 
	department_short_name character varying, department_full_name character varying, leader_id integer, role_id int, department_id int, head_kindred_department_id int
) AS
$BODY$
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
$BODY$
  LANGUAGE sql STABLE
  COST 100
  ROWS 1000;

GRANT EXECUTE ON FUNCTION doc.find_all_same_head_kindred_department_leaders_for_employee(integer) TO umz_doc_edit;
REVOKE ALL ON FUNCTION doc.find_all_same_head_kindred_department_leaders_for_employee(integer) FROM public;

drop function if exists doc.update_leader_links_for_subordinates_of(bigint);
create or replace function doc.update_leader_links_for_subordinates_of(target_employee_id bigint, is_employee_new boolean default false) returns void
as
$$
begin
	with recursive get_subordinates(id, top_level_id, head_kindred_department_id) as (
		select
		e.id,
		e.leader_id,
		e.head_kindred_department_id
		from doc.employees as e
		where 
			case 
			    when $2 
			    then e.id = $1
			    else e.leader_id = $1 
			end

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
$$
language plpgsql;

create or replace function doc.update_leader_links_for_subordinates_of__trigger_proc() returns trigger
as
$$
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
$$ language plpgsql;

create or replace function doc.update_leader_links_for_subordinates_of__trigger_proc2() returns trigger
as
$$
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
$$ language plpgsql;

drop trigger if exists calc_head_kindred_department_for_employee_trigger on doc.employees;
CREATE TRIGGER calc_head_kindred_department_for_employee_trigger
BEFORE INSERT OR UPDATE of department_id
ON doc.employees
FOR EACH ROW
EXECUTE PROCEDURE doc.calc_head_kindred_department_for_employee_trigger_proc();
  
drop trigger if exists update_leader_links_for_subordinates_of__trigger on doc.employees_roles;
create trigger update_leader_links_for_subordinates_of__trigger 
after insert or update or delete on doc.employees_roles 
for each row execute procedure doc.update_leader_links_for_subordinates_of__trigger_proc2();

drop trigger if exists update_leader_links_for_subordinates_of__trigger on doc.employees;
create trigger update_leader_links_for_subordinates_of__trigger 
after insert or update of leader_id, department_id or delete on doc.employees 
for each row execute procedure doc.update_leader_links_for_subordinates_of__trigger_proc();

--select * from doc.find_all_same_head_kindred_department_leaders_for_employee(2482);


alter function doc.is_employee_workspace_includes_other_employee_new(bigint, bigint) rename to is_employee_workspace_includes_other_employee;

drop function doc.is_employee_workspace_includes_other_employee(bigint, bigint);

alter function doc.is_employee_workspace_includes_other_employee(bigint, bigint) rename to is_employee_workspace_includes_other_employee_old;
CREATE OR REPLACE FUNCTION doc.is_employee_workspace_includes_other_employee(
    workspace_employee_id int,
    checkable_employee_id int)
  RETURNS boolean AS
$BODY$
select 
exists(
select 
1
from doc.employees e
where 
	e.id = $2 
	and exists(
		select
		1
		from doc.employees e1
		join doc.employees_roles er on er.employee_id = e1.id
		where e1.id = $1
		and 
		    case 
		        when er.role_id in (2) 
		        then row(e1.id::bigint, er.role_id::bigint, e1.department_id::bigint, e1.head_kindred_department_id::bigint) = any(e.leader_links)
			else exists(
				select
				1
				from doc.employees e2 
				join doc.employees_roles er2 on er2.employee_id = e2.id
				where e2.id = e1.leader_id and row(e2.id::bigint, er2.role_id::bigint, e2.department_id::bigint, e2.head_kindred_department_id::bigint) = any(e.leader_links)
			)
		    end
	)
);
$BODY$
  LANGUAGE sql STABLE
  COST 100;

GRANT EXECUTE ON FUNCTION doc.is_employee_workspace_includes_other_employee(bigint, bigint) TO umz_doc_edit;
REVOKE ALL ON FUNCTION doc.is_employee_workspace_includes_other_employee(bigint, bigint) FROM public;

update doc.employees
set leader_links = 
	(
	select 
		array_agg(
			row(id, role_id, department_id, head_kindred_department_id)::doc.employee_link
		)
	from doc.find_all_same_head_kindred_department_leaders_for_employee(id)
	);

--select * from doc.employees where leader_id is not null and leader_links is null;

/*
with get_max_leader_links_length as (
select 
max(cardinality(leader_links))
from doc.employees
)
select 
m.* as max_leader_links_length,
max(cardinality(leader_links)) over (partition by department_id) as leader_links_length,
e.* 
from doc.employees e, get_max_leader_links_length as m(value)
where cardinality(leader_links) = m.value*/