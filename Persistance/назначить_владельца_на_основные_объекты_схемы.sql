--SELECT $1.get_outcoming_service_notes_for_employee(2063);

create or replace function doc.assign_schema_objects_owner(schema_name varchar, user_name varchar) returns void
as
$$
declare
	alter_expr record;
begin
	for alter_expr in
			select
			q.* as value
			from (
			select
			'alter table ' || n.nspname || '.' || c.relname || ' owner to ' || $2 as value
			from pg_class c
			join pg_namespace n on n.oid = relnamespace
			where n.nspname ~* $1 and c.relkind = 'r' and relname !~* '^sd_'

			union

			select 
			'alter function ' || n.nspname || '.' || p.proname || '(' || coalesce((
				select 
				string_agg(q.arg_type_name, ', ')
				from (
				select 
				(select
				case when t.typarray = 0 then n.nspname || '.' || regexp_replace(t.typname, '^_', '') || '[]' else n.nspname || '.' || t.typname end as arg_type_name
				from pg_type as t
				left join pg_type as arr on arr.oid = t.typarray
				join pg_namespace as n on n.oid = t.typnamespace
				where t.oid = arg_type_ids.id
			 )
			 from unnest(p.proargtypes) as arg_type_ids(id)
			) q 
			), '') || ')' || ' owner to ' || $2 as value
			from pg_proc p
			join pg_namespace n on p.pronamespace = n.oid
			where n.nspname ~* $1 and p.proname !~* '^sd_'

			union

			select 
			'alter sequence ' || n.nspname || '.' || c.relname || ' owner to ' || $2 as value
			from pg_class c
			join pg_namespace n on n.oid = relnamespace
			where 
			n.nspname ~* $1 and 
			c.relkind = 'S' and relname !~* '^sd_'
			) q
			order by q.* loop

			execute alter_expr.value;
	end loop;

end
$$
language plpgsql;


select doc.assign_schema_objects_owner('doc', 'u_59968');

