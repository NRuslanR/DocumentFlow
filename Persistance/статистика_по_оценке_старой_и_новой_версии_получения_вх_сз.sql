drop function if exists doc.calc_incoming_service_notes_getting_exec_time_stats();
create or replace function doc.calc_incoming_service_notes_getting_exec_time_stats() 
returns table (eid int, v1_c int, v2_c int, v1_c_minus_v2_c int, v2_c_minus_v1_c int, t_v1 float, t_v2 float, t_v2_minus_t_v1 float, optimum boolean, correct boolean)
as 
$$
declare
	emp doc.employees%rowtype;
	s1 float; s2 float;
	e1 float; e2 float;
	c1 int; c2 int;
	t1 float; t2 float;
	t2_minus_t1 float;
begin

	for emp in select * from doc.employees where not is_foreign and id in (12, 1355, 1332, 126, 2063, 1357, 1359, 1417, 1356)
	loop
		
		s1 = extract(epoch from clock_timestamp());

		create temp table emp1 on commit drop as select * from doc.get_incoming_service_notes_for_employee(emp.id);

		e1 = extract(epoch from clock_timestamp());

		s2 = extract(epoch from clock_timestamp());

		create temp table emp2 on commit drop as select * from doc.get_incoming_service_notes_for_employee_2(emp.id);

		e2 = extract(epoch from clock_timestamp());

		select count(*) into c1 from emp1; select count(*) into c2 from emp2;

		t1 = e1 - s1; t2 = e2 - s2; t2_minus_t1 = t2 - t1;
		
		return 
			query 
				select 
					emp.id, c1, c2, c1 - c2, c2 - c1, t1, t2, t2_minus_t1, t2_minus_t1 < 0,
					(select 
					count (*)
					from ( 
						(select id from emp1 except select id from emp2)  
						union
						(select id from emp2 except select id from emp1)
					) q ) = 0;
		
		drop table emp1; drop table emp2;

		
		
	end loop;

	return; 
end
$$
language plpgsql;

select doc.calc_incoming_service_notes_getting_exec_time_stats();

