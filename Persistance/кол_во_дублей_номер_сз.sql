alter table doc.service_notes add constraint document_number_unique unique (document_number);

with q as (
select 
document_number,
count(*) as dup_count
from doc.service_notes 
where document_number is not null and trim(document_number) <> ''
group by document_number
having count(*) > 1
) 
select * from q where q.dup_count = (select max(dup_count) from q)