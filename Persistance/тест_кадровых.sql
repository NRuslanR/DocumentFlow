
create or replace function doc.set_personnel_orders_test_data() returns void
as
$$
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
$$
language plpgsql;
alter function doc.set_personnel_orders_test_data() owner to sup;
grant execute on function doc.set_personnel_orders_test_data() to developers;
revoke all privileges on function doc.set_personnel_orders_test_data() from public;

select doc.set_personnel_orders_test_data();

alter function doc.set_personnel_orders_test_data() owner to u_59968;