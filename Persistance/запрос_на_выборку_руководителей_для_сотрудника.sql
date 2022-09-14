drop function if exists doc.find_all_leaders_for_employee(IN employee_id integer);
CREATE OR REPLACE FUNCTION doc.find_all_leaders_for_employee(IN employee_id integer)
  RETURNS TABLE(id integer, name character varying, surname character varying, patronymic character varying, speciality character varying, personnel_number character varying, telephone_number character varying, is_foreign boolean, department_code character varying, department_short_name character varying, department_full_name character varying, leader_id integer) AS
$BODY$
with recursive
employee_leaders(
id,name,surname,patronymic,speciality,personnel_number,
telephone_number,is_foreign,department_code,department_short_name,department_full_name,leader_id
)
as (
select 
a.id,
a.name,
a.surname,
a.patronymic,
a.speciality,
a.personnel_number,
a.telephone_number,
a.is_foreign,
a.department_code,
a.department_short_name,
a.department_full_name,
a.leader_id
from doc.v_employees a
where a.id = $1
union
select 
b.id,
b.name,
b.surname,
b.patronymic,
b.speciality,
b.personnel_number,
b.telephone_number,
b.is_foreign,
b.department_code,
b.department_short_name,
b.department_full_name,
b.leader_id
from employee_leaders a
join doc.v_employees b on a.leader_id = b.id
),
get_leader as
(
select 
a.* 
from employee_leaders a
join doc.employees_roles b on a.id = b.employee_id
where b.role_id = 2
)
select 
*
from
(
select * from get_leader where /*leader_id is null*/ true
) get_signers
order by id
$BODY$
  LANGUAGE sql VOLATILE
  COST 100
  ROWS 1000;
  
ALTER FUNCTION doc.find_all_leaders_for_employee(integer)
  OWNER TO sup;
GRANT EXECUTE ON FUNCTION doc.find_all_leaders_for_employee(integer) TO sup;
GRANT EXECUTE ON FUNCTION doc.find_all_leaders_for_employee(integer) TO umz_doc_edit;
REVOKE ALL ON FUNCTION doc.find_all_leaders_for_employee(integer) FROM public;