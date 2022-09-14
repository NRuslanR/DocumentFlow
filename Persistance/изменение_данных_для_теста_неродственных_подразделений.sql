-- настройка иерархии подразделений

update doc.departments d set top_level_department_id = t.top_id, is_top_level_department_kindred = t.kindred
from 
(values (15, 2769, false), (2769, 2763, false)) t(dep_id, top_id, kindred)
where t.dep_id = d.outside_id;

-- настройка иерархии сотрудников
update doc.employees e set 
leader_id = t.leader_id, 
department_id = t.dep_id,
spr_person_id = t.person_id, 
was_dismissed = false
from (values (126, 1312, 15, 3435), (1312, 115, 2769, 15024)) t(id,leader_id,dep_id,person_id)
where e.outside_id = t.id;

-- настройка ролей 
update doc.employees_roles set role_id = 2 where employee_id in (1312,115);

--настройка логина для илюхина (doc_performer4), пряхина (doc_performer5), 
--горностаева (doc_performer3), войта (doc_performer1) и аисова (doc_performer2)
update doc.employees set login = null where login ~* 'doc_performer';

update doc.employees e set login = 'doc_performer' || t.suffix 
from (values (126, '1'), (1312, '2'), (115, '3')) t(id, suffix)
where e.outside_id = t.id;
