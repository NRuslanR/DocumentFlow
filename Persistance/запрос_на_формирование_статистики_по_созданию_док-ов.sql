select 

year_month,
year,
month,
doc_count,
round(avg(doc_count) over (partition by year)) as year_avg,
max(doc_count) over (partition by year) as max_year,
round(avg(doc_count) over ()) as avg_doc_count
from (
	select 
	year || '-' || month as year_month,
	year,
	month,
	count(author_id) as doc_count
		from (
		select 
			date_part('year', creation_date) as year,
			date_part('month', creation_date) as month, 
			creation_date, 
			author_id
			from doc.service_notes
		) q
	where year >= 2020
	group by year, month
	order by year, month
) q