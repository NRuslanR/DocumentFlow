select 
q.cycle_count,
sn.*
from (
select
sna.document_id,
count (distinct cycle_number) as cycle_count
from doc.service_notes sn
left join doc.service_note_approvings sna on sna.document_id = sn.id
group by sna.document_id
) q
join doc.service_notes sn on sn.id = q.document_id
order by cycle_count desc