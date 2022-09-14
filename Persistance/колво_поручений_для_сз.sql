with charge_groups as (
select
snr.document_id,
count (snr.id) as charge_count
from doc.service_notes sn
join doc.service_note_receivers snr on snr.document_id = sn.id
where head_charge_sheet_id is not null 
group by snr.document_id
)
select 
d.code,
max(cg.charge_count) over () as max_charge_count,
cg.charge_count,
sn.*
from charge_groups cg
join doc.service_notes sn on sn.id = cg.document_id
join doc.employees e on e.id = sn.author_id
join doc.departments d on d.id = e.department_id
order by cg.charge_count desc 
