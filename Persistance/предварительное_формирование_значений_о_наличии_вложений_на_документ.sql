alter table doc.service_notes add column applications_exists boolean default false;
alter table doc.personnel_orders add column applications_exists boolean default false;

update
	doc.service_notes sn
	set
		applications_exists =
			exists(select 1 from doc.service_note_file_metadata where document_id = sn.id)
			or exists(select 1 from doc.service_note_links where document_id = sn.id);

create or replace function doc.update_document_application_exists_column(document_id bigint, changes_source varchar, changes_type varchar) returns void
as
$$
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
$$
language plpgsql;

create or replace function doc.update_document_application_exists_column_trigger_proc() returns trigger 
as
$$
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
$$
language plpgsql;

create trigger update_document_application_exists_column_trigger 
after insert or update or delete on doc.service_note_file_metadata    
for each row execute procedure doc.update_document_application_exists_column_trigger_proc();

create trigger update_document_application_exists_column_trigger 
after insert or update or delete on doc.service_note_links 
for each row execute procedure doc.update_document_application_exists_column_trigger_proc();

create trigger update_document_application_exists_column_trigger 
after insert or update or delete on doc.personnel_order_file_metadata    
for each row execute procedure doc.update_document_application_exists_column_trigger_proc();

create trigger update_document_application_exists_column_trigger 
after insert or update or delete on doc.personnel_order_links 
for each row execute procedure doc.update_document_application_exists_column_trigger_proc();