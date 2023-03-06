
CREATE OR REPLACE FUNCTION doc.are_employees_subleaders_of_same_leader(employee_ids integer[])
 RETURNS boolean
 LANGUAGE sql
 STABLE
AS $function$
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
$function$
;
