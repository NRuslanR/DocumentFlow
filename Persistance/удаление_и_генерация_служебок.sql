create index del_test_docs on doc.service_note_receivers using btree 
((changing_user = 'u_59968'));

create index del_test_receivers on doc.service_notes using btree ((changing_user = 'u_59968'));

with del as (
select id from doc.service_note_receivers where changing_user = 'u_59968' and changing_date::date = current_date::date limit 5000
)
delete
from 
doc.service_note_receivers
where id in (select * from del);

delete 
from
doc.service_notes
where outside_id in (
select outside_id from doc.service_notes where changing_user = 'u_59968' and changing_date::date = current_date::date
);

select count(*) from doc.service_notes
select doc.gen(50000, 'UPD_NEW TEST');

select current_date::timestamp without time zone