CREATE OR REPLACE FUNCTION doc.update_leader_links_for_subordinates_of(target_employee_id bigint, is_employee_new boolean DEFAULT false)
 RETURNS void
 LANGUAGE plpgsql
AS $function$
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
$function$
;

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
$function$
;

update doc.employees e set leader_id = t.lid 
from (values (122, 1304), (2125, 1304)) as t(id, lid)
where e.id = t.id;

select doc.update_leader_links_for_subordinates_of(id) from doc.employees;

/*
drop function doc.is_employee_workspace_includes_other_employee_old2(bigint, bigint); 

alter FUNCTION doc.is_employee_workspace_includes_other_employee(workspace_employee_id bigint, checkable_employee_id bigint) 
rename to is_employee_workspace_includes_other_employee_old2;

alter FUNCTION doc.is_employee_workspace_includes_other_employee_old(workspace_employee_id bigint, checkable_employee_id bigint) 
rename to is_employee_workspace_includes_other_employee; */