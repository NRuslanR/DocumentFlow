select * from doc.employees where not is_foreign and not was_dismissed

select
avg(avg_emp_reg_count) over () as total_avg_emp_reg_count,
q.*
from (
select 
q.*,
(count(*) over (partition by case when changing_date::date = first_emp_reg_time then changing_date::date else (changing_date + avg_emp_reg_diff_time)::date end order by changing_date)) as avg_emp_reg_count
from (
select 
(max(changing_date) over ())::date as last_emp_reg_time,
(min(changing_date) over ())::date as first_emp_reg_time,
((max(changing_date) over()  - min(changing_date) over ()) / (count(changing_date) over () - 1)) as avg_emp_reg_diff_time,
changing_date
from doc.employees
) q
) q