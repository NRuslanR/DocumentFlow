alter table doc.document_approving_results add column result_service_name varchar;

update doc.document_approving_results dar 
set result_service_name = t.result_service_name
from (values (1, 'approved'), (2, 'not_approved'), (3, 'not_performed')) t(id, result_service_name)
where dar.id = t.id;