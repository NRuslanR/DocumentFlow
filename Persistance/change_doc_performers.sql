with a as (
	update doc.employees set login = null where login = 'doc_performer3' returning id 
)
update doc.employees e set login = 'doc_performer3'
from a where e.id = 42;