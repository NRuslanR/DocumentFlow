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

