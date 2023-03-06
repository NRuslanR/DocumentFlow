alter FUNCTION doc.is_employee_workspace_includes_other_employee(workspace_employee_id bigint, checkable_employee_id bigint) rename to 
	is_employee_workspace_includes_other_employee_old;

CREATE OR REPLACE FUNCTION doc.is_employee_workspace_includes_other_employee(workspace_employee_id bigint, checkable_employee_id bigint)
 RETURNS boolean
 LANGUAGE sql
 STABLE
AS $function$

select 
exists (
select
1
from doc.employees e1
join doc.employees_roles er1 on er1.employee_id = e1.id 
join doc.employees e2 on e2.id = $2
join doc.employees_roles er2 on er2.employee_id = e2.id 
where 
(e1.id = $1)
and exists (
(select * from unnest(e1.leader_links))
intersect
(select * from unnest(e2.leader_links))
)
)
$function$
;


select doc.update_leader_links_for_subordinates_of(id) from doc.employees;

create or replace function doc.test_is_employee_workspace_includes_other_employee(head_kindred_dep_id int) returns boolean
as 
$$
declare 
	rec record;
begin 
	
	for rec in  with need_emps as (
					select 
					*
					from doc.employees e1
					join doc.employees_roles er1 on er1.employee_id = e1.id 
					where head_kindred_department_id = $1 and er1.role_id <> 5 and not was_dismissed 
				)
				select 
				e1.id as first, e2.id as second 
				from need_emps e1
				cross join need_emps e2 
    loop
			
		if not (select doc.is_employee_workspace_includes_other_employee(rec.first, rec.second)) then
			raise exception 'first: %, second: %', rec.first, rec.second;
			return false;
		end if;
	    
	end loop;

	return true;
end

$$
language plpgsql;

select bool_and(doc.test_is_employee_workspace_includes_other_employee(head_kindred_department_id)) from (select distinct head_kindred_department_id from doc.employees where not was_dismissed) q;  

select * from doc.employees e2 where id in (1224, 1338, 1302)

select * from doc.departments  where id = 2838;

select * from doc.employees e2 where leader_id = 1258;

select 
er.role_id,
d.top_level_department_id ,
d.is_top_level_department_kindred ,
d.short_name ,
d.full_name ,
e.* 
from doc.employees e
join doc.employees_roles er on er.employee_id = e.id 
join doc.departments d on d.id = e.department_id 
where e.id in (1394, 122);


select * from doc.find_all_same_head_kindred_department_leaders_for_employee(122);

update doc.employees e set leader_id = t.lid 
from (values (122, 1304), (2125, 1304)) as t(id, lid)
where e.id = t.id;

select * from doc.employees e where leader_id = 136

select * from doc.employees e where head_kindred_department_id = 769313

select * from doc.find_all_same_head_kindred_department_leaders_for_employee(2585);

select doc.update_leader_links_for_subordinates_of(2585);

with recursive get_subordinates(id, top_level_id, head_kindred_department_id) as (
		select
		e.id,
		e.leader_id,
		e.head_kindred_department_id
		from doc.employees as e
		where e.id = 1811

		union

		select 
		e.id,
		e.leader_id,
		e.head_kindred_department_id
		from doc.employees as e
		join get_subordinates as s on e.leader_id = s.id
	)
	select * from get_subordinates

	alter FUNCTION doc.is_employee_workspace_includes_other_employee_old(workspace_employee_id bigint, checkable_employee_id bigint) rename to 
	is_employee_workspace_includes_other_employee;
	




select
1
from doc.employees e1
join doc.employees_roles er1 on er1.employee_id = e1.id 
join doc.employees e2 on e2.id = 1355
join doc.employees_roles er2 on er2.employee_id = e2.id 
where 
(e1.id = 1361)
and (er1.role_id <> 5)
and (er2.role_id <> 5)
and exists (
(select * from unnest(e1.leader_links))
intersect
(select * from unnest(e2.leader_links))
)

