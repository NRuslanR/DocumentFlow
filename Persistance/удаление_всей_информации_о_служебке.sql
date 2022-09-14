select * from doc.service_notes order by creation_date desc limit 1;

with get_user_service_notes as (
	select id from doc.service_notes where id = 261254 --changing_user = 'u_59968' and changing_date::date = now()::date
),
delete_signings as (

	delete from doc.service_note_signings where document_id in (select * from get_user_service_notes) returning document_id
),

delete_approvings as (

	delete from doc.service_note_approvings where document_id in (select * from get_user_service_notes) returning document_id
),	

delete_receivers as (

	delete from doc.service_note_receivers where document_id in (select * from get_user_service_notes) returning document_id
),
/* удалить предварительно из хранилища */
delete_files as (

	delete from doc.service_note_file_metadata where document_id in (select * from get_user_service_notes) returning document_id 
)
delete from doc.service_notes where id in (
	select * from delete_signings
	union
	select * from delete_approvings
	union
	select * from delete_receivers
	union
	select * from delete_files
	union
	select * from get_user_service_notes
);
