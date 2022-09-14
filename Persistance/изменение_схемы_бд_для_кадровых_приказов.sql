create table doc.personnel_order_sub_kinds(
id serial primary key,
name varchar not null unique
);

grant all on table doc.personnel_order_sub_kinds to umz_doc_edit;

comment on table doc.personnel_order_sub_kinds is 'Подтипы кадрового приказа';

comment on column doc.personnel_order_sub_kinds.name is 'Наименование подтипа';

insert into doc.personnel_order_sub_kinds (name) values 

('Приказы о приёме на работу'),
('Приказ о переводе'),
('Приказ об увольнении'),
('Приказ о предоставлении очередного отпуска'),
('Приказ о предоставлении отпуска без сохранения заработной платы'),
('Приказ о предоставлении доп. оплачиваемых выходных дней для ухода за ребенком инвалидом'),
('Приказ о предоставлении учебный'),
('Приказ о предоставлении частично-оплачиваемого отпуска до 1.5 лет'),
('Приказ о возложение обязанностей'),
('Приказ о разделении отпуска на части'),
('Приказ о переносе очередного отпуска'),
('Приказ об отзыве из очередного отпуска'),
('Приказ об изменении графика работы'),
('Приказ о работе на условиях неполного рабочего времени'),
('Приказ о прерывании отпуска по уходу за ребенком'),
('Приказ о применении дисциплинарного взыскания'),
('Приказ о снятии дисциплинарного взыскания'),
('Приказ о поощрении'),
('Приказ о направлении на медосмотр'),
('Приказ о предоставлении дополнительных дней отдыха за сдачу крови'),
('Приказ об отмене приказа'),
('Приказ об отстранении от работы'),
('Приказ об увольнении за нарушение трудовой дисциплины'),
('Приказ о работе в выходные и нерабочие дни'),
('Приказ о переносе выходного дня'),
('Приказ о переводе на лёгкий труд');

CREATE TABLE doc.personnel_orders
(
  id integer NOT NULL DEFAULT nextval('doc.service_notes_id_seq'::regclass), -- Идентификатор записи кадрового приказа
  type_id integer not null references doc.document_types (id), -- Ссылка на информацию о общем типе кадровых приказов
  sub_type_id integer not null references doc.personnel_order_sub_kinds (id), -- Ссылка на подтип кадрового приказа
  name character varying not null, -- Название
  document_number character varying, -- Номер
  document_date timestamp without time zone,
  creation_date timestamp without time zone NOT NULL, -- Дата создания
  note character varying, -- Примечания
  current_work_cycle_stage_id integer DEFAULT 1, -- Ссылка на текущую стадию жизненного служебной записки
  content character varying(8192), -- Содержимое
  inserting_date timestamp without time zone DEFAULT now(), -- Дата добавления записи
  inserted_user character varying DEFAULT "session_user"(), -- Пользователь, добавивший запись
  author_id integer not null references doc.employees (id),
  performer_id integer not null references exchange.spr_person (id),
  is_sent_to_signing boolean,
  CONSTRAINT personnel_orders_pkey PRIMARY KEY (id),
  CONSTRAINT performer_id_fkey FOREIGN KEY (performer_id)
      REFERENCES exchange.spr_person (id) MATCH SIMPLE
      ON UPDATE NO ACTION ON DELETE NO ACTION
)
WITH (
  OIDS=FALSE
);
GRANT ALL ON TABLE doc.personnel_orders TO umz_doc_edit;

COMMENT ON TABLE doc.personnel_orders
  IS 'Кадровые приказы';
COMMENT ON COLUMN doc.personnel_orders.id IS 'Идентификатор записи';
COMMENT ON COLUMN doc.personnel_orders.type_id IS 'Ссылка на общий тип';
COMMENT ON COLUMN doc.personnel_orders.sub_type_id IS 'Ссылка на подтип кадрового приказа';
COMMENT ON COLUMN doc.personnel_orders.name IS 'Название';
COMMENT ON COLUMN doc.personnel_orders.document_number IS 'Номер';
COMMENT ON COLUMN doc.personnel_orders.document_date IS 'Дата документа';
COMMENT ON COLUMN doc.personnel_orders.creation_date IS 'Дата создания';
COMMENT ON COLUMN doc.personnel_orders.note IS 'Примечания';
COMMENT ON COLUMN doc.personnel_orders.current_work_cycle_stage_id IS 'Ссылка на текущую стадию жизненного цикла документа';
COMMENT ON COLUMN doc.personnel_orders.content IS 'Содержимое';
COMMENT ON COLUMN doc.personnel_orders.inserting_date IS 'Дата добавления записи';
COMMENT ON COLUMN doc.personnel_orders.inserted_user IS 'Пользователь, добавивший запись';
COMMENT ON COLUMN doc.personnel_orders.performer_id IS 'Ссылка на ответственного за данный документ';

CREATE TABLE doc.personnel_order_charges
(
  id serial not null primary key,
  document_id integer not null references doc.personnel_orders (id),
  performing_date timestamp without time zone, -- Дата исполнения служебной записки
  comment character varying, -- Комментарий к исполнению
  inserting_date timestamp without time zone DEFAULT now(), -- Дата внесения изменений
  inserted_user character varying DEFAULT "session_user"(), -- Пользователь, внёсший изменения
  top_level_charge_sheet_id integer references doc.personnel_order_charges (id), -- Ссылка на вышестояющий лист поручения
  charge character varying, -- Поручение по данной служебной записке (для подчиненных исполнителей)
  performer_id int not null references doc.employees (id),
  actual_performer_id integer references doc.employees (id), -- Фактически исполнивший документ сотрудник
  issuer_id integer references doc.employees (id),
  charge_period_start timestamp without time zone,
  charge_period_end timestamp without time zone,
  head_charge_sheet_id integer references doc.personnel_order_charges (id),
  is_for_acquaitance boolean DEFAULT false,
  issuing_datetime timestamp without time zone
)
WITH (
  OIDS=FALSE
);

GRANT ALL ON TABLE doc.personnel_order_charges TO umz_doc_edit;

COMMENT ON TABLE doc.personnel_order_charges
  IS 'Поручения и листы поручений по кадровым приказам';
COMMENT ON COLUMN doc.personnel_order_charges.document_id IS 'Ссылка на кадровый приказ';
COMMENT ON COLUMN doc.personnel_order_charges.performer_id IS 'Ссылка на исполнителя поручения (листа поручения)';
COMMENT ON COLUMN doc.personnel_order_charges.performing_date IS 'Дата исполнения поручения';
COMMENT ON COLUMN doc.personnel_order_charges.comment IS 'Комментарий к исполнению';
COMMENT ON COLUMN doc.personnel_order_charges.inserting_date IS 'Дата добавления записи';
COMMENT ON COLUMN doc.personnel_order_charges.inserted_user IS 'Пользователь, добавивший запись';
COMMENT ON COLUMN doc.personnel_order_charges.top_level_charge_sheet_id IS 'Ссылка на вышестояющий лист поручения';
COMMENT ON COLUMN doc.personnel_order_charges.charge IS 'Текст поручения (листа поручения)';
COMMENT ON COLUMN doc.personnel_order_charges.actual_performer_id IS 'Фактически исполнивший поручение (лист поручения) сотрудник';

CREATE TABLE doc.personnel_order_signings
(
  id serial NOT NULL primary key,
  document_id bigint NOT NULL references doc.personnel_orders (id),
  signer_id bigint NOT NULL references doc.employees (id),
  actual_signed_id bigint references doc.employees (id),
  signing_date timestamp without time zone
);

grant all on table doc.personnel_order_signings to umz_doc_edit;

CREATE TABLE doc.personnel_order_links
(
  id serial not null primary key,
  document_id integer not null references doc.personnel_orders (id), 
  related_document_id integer,
  related_document_type_id integer not null references doc.document_types (id),
  inserting_date timestamp without time zone DEFAULT now(), -- Дата добавления записи
  inserted_user character varying DEFAULT "session_user"() -- Пользователь, добавивший запись
);

grant all on table doc.personnel_order_links to umz_doc_edit;

COMMENT ON TABLE doc.personnel_order_links
  IS 'Связи кадровых приказов с другими видами документов';
COMMENT ON COLUMN doc.personnel_order_links.document_id IS 'Ссылка на кадровый приказ';
COMMENT ON COLUMN doc.personnel_order_links.related_document_id IS 'Ссылка на связанный документ';
COMMENT ON COLUMN doc.personnel_order_links.related_document_type_id IS 'Ссылка на тип связанного документа';

CREATE TABLE doc.personnel_order_file_metadata
(
  id serial not null primary key,
  document_id integer not null references doc.personnel_orders (id), -- Ссылка на описываемую служебную записку
  file_path character varying, -- Путь к файлу служебной записки в архиве
  file_name character varying, -- Название файла служебной записки
  inserting_date timestamp without time zone DEFAULT now(), -- Дата внесения изменений
  inserted_user character varying DEFAULT "session_user"() -- Пользователь, внёсший изменения
);

grant all on table doc.personnel_order_file_metadata to umz_doc_edit;
  
COMMENT ON TABLE doc.personnel_order_file_metadata
  IS 'Метаданные файлов, прилагаемых к кадровым приказам';
COMMENT ON COLUMN doc.personnel_order_file_metadata.document_id IS 'Ссылка на кадровый приказ';
COMMENT ON COLUMN doc.personnel_order_file_metadata.file_path IS 'Путь к файлу служебной записки в архиве';
COMMENT ON COLUMN doc.personnel_order_file_metadata.file_name IS 'Название файла служебной записки';
COMMENT ON COLUMN doc.personnel_order_file_metadata.inserting_date IS 'Дата добавления записи';
COMMENT ON COLUMN doc.personnel_order_file_metadata.inserted_user IS 'Пользователь, добавивший запись';

CREATE TABLE doc.personnel_order_approvings
(
  id serial NOT NULL,
  document_id integer NOT NULL references doc.personnel_orders (id), -- id документа
  performing_date timestamp without time zone, -- Дата принятия участия в согласовании документа сотрудником actual_approved_employee_id
  performing_result_id integer NOT NULL references doc.document_approving_results (id), -- id результата согласования документа (согласовано, не согласовано)
  approver_id integer NOT NULL references doc.employees (id), -- id назначенного согласованта для документа
  actual_performed_employee_id integer references doc.employees (id), -- id фактически принявшего участие в согласовании документа сотрудника
  note character varying(8192), -- примечания согласованта
  cycle_number integer, -- номер цикла согласования документа. Данное поля заполняется в случае завершения цикла согласования. Отсутствие значения в данном поле свидетельствует о том, что согласование ещё не завершено.
  inserting_date timestamp without time zone DEFAULT now(),
  inserted_user character varying DEFAULT "session_user"()
);

grant all on table doc.personnel_order_approvings to umz_doc_edit;

COMMENT ON TABLE doc.personnel_order_approvings
  IS 'Согласования кадровых приказов';
COMMENT ON COLUMN doc.personnel_order_approvings.document_id IS 'Ссылка на документ';
COMMENT ON COLUMN doc.personnel_order_approvings.performing_date IS 'Дата принятия участия в согласовании документа сотрудником actual_approved_employee_id';
COMMENT ON COLUMN doc.personnel_order_approvings.performing_result_id IS 'id результата согласования документа (согласовано, не согласовано)';
COMMENT ON COLUMN doc.personnel_order_approvings.approver_id IS 'id назначенного согласованта для документа';
COMMENT ON COLUMN doc.personnel_order_approvings.actual_performed_employee_id IS 'id фактически принявшего участие в согласовании документа сотрудника';
COMMENT ON COLUMN doc.personnel_order_approvings.note IS 'примечания согласованта';
COMMENT ON COLUMN doc.personnel_order_approvings.cycle_number IS 'номер цикла согласования документа. Данное поля заполняется в случае завершения цикла согласования. Отсутствие значения в данном поле свидетельствует о том, что согласование ещё не завершено.';


CREATE TABLE doc.looked_personnel_orders
(
  id serial NOT NULL,
  document_id integer not null references doc.personnel_orders (id) on delete cascade on update cascade, -- Ссылка на просмотренную служебную записку
  looked_employee_id integer not null references doc.employees (id), -- Ссылка на сотрудника, просмотревшего служебную записку
  look_date timestamp without time zone DEFAULT now() -- Дата просмотра служебной записки
);


GRANT ALL ON TABLE doc.looked_personnel_orders TO umz_doc_edit;

COMMENT ON TABLE doc.looked_personnel_orders
  IS 'Просмотренные кадровые приказы';
COMMENT ON COLUMN doc.looked_personnel_orders.document_id IS 'Ссылка на просмотренный кадровый приказ';
COMMENT ON COLUMN doc.looked_personnel_orders.looked_employee_id IS 'Ссылка на сотрудника, просмотревшего кадровый приказ';
COMMENT ON COLUMN doc.looked_personnel_orders.look_date IS 'Дата просмотра кадрового приказа';

create table doc.personnel_order_control_groups(
id serial primary key,
name varchar not null unique
);

create table doc.personnel_order_control_groups__employees(
id serial primary key,
control_group_id int not null references doc.personnel_order_control_groups(id),
employee_id int not null references doc.employees (id)
);

create table doc.personnel_order_control_groups__sub_kinds(
id serial primary key,
control_group_id int not null references doc.personnel_order_control_groups(id),
personnel_order_sub_kind_id int not null references doc.personnel_order_sub_kinds(id)
);

create table doc.personnel_order_sub_kinds__approvers(
id serial primary key,
personnel_order_sub_kind_id int not null references doc.personnel_order_sub_kinds (id),
approver_id int not null references doc.employees (id)
);

grant all on table doc.personnel_order_sub_kinds__approvers to umz_doc_edit;

comment on table doc.personnel_order_sub_kinds__approvers is 'Соответствия подвидов кадрового приказа сотрудникам, 
которые по умолчанию являются согласовантами конкретных подвидов';

grant all on table doc.personnel_order_control_groups__sub_kinds to umz_doc_edit;

comment on table doc.personnel_order_control_groups__sub_kinds is 'Соответствия групп сотрудников, ответственных за контроль кадровых приказов, и подтипов кадровых приказов';

grant all on table doc.personnel_order_control_groups to umz_doc_edit;

comment on table doc.personnel_order_control_groups is 'Группы сотрудников, ответсвенные за контроль кадровых приказов';

grant all on table doc.personnel_order_control_groups__employees to umz_doc_edit;

comment on table doc.personnel_order_control_groups__employees is 'Соответствия групп и сотрудников, ответственных за контроль кадровых приказов';

create table doc.personnel_order_creating_access_employees(
employee_id int not null primary key references doc.employees (id)
);

/*
create or replace function doc.set_head_kindred_department_id_for_po_employee() returns trigger 
as
$$
begin
	new.head_kindred_department_id = doc.find_head_kindred_department_for_inner(new.employee_id);

	return new;
end
$$
language plpgsql;

create trigger set_head_kindred_department_id_for_po_employee_trigger before insert or update on doc.personnel_orders_creating_access_employee
for each row execute procedure doc.set_head_kindred_department_id_for_po_employee();*/

grant all on table doc.personnel_order_creating_access_employees to umz_doc_edit;

comment on table doc.personnel_order_creating_access_employees is 'Сотрудники, которым доступна возможность создания кадровых приказов';

drop function if exists doc.get_personnel_orders_for_employee(int);

CREATE OR REPLACE FUNCTION doc.get_personnel_orders_for_employee(IN employee_id integer)
  RETURNS TABLE(
	is_document_viewed boolean, id integer, base_document_id int, type_id integer, sub_type_id int, sub_type_name varchar, name character varying, number character varying, document_date date, creation_date date, 
	creation_date_year integer, creation_date_month integer, type_name character varying, current_work_cycle_stage_number integer, 
	current_work_cycle_stage_name character varying, author_id integer, author_short_name character varying, author_department_short_name varchar,
	can_be_removed boolean
	) 
  AS $$
select  
    distinct
    exists( 
    select 1 
    from doc.looked_personnel_orders lpo 
    where lpo.document_id = po.id and lpo.looked_employee_id = $1  
    ) as is_document_viewed, 
    po.id, 
    po.id as base_document_id,
    po.type_id, 
    po.sub_type_id,
    posk.name as sub_type_name,
    po.name, 
    po.document_number as number, 
    po.document_date::date,
    po.creation_date::date, 
    date_part('year', po.creation_date)::integer as creation_date_year, 
    date_part('month', po.creation_date)::integer as creation_date_month, 
    dt.short_full_name as type_name, 
    dtwcs.stage_number as current_work_cycle_stage_number, 
    dtwcs.stage_name as current_work_cycle_stage_name, 
    po.author_id,
    (e.surname || ' ' || e.name || ' ' || e.patronymic)::varchar as author_short_name,
    d.short_name as author_department_short_name,
    null::boolean as can_be_removed 
    from doc.personnel_orders po 
    join doc.personnel_order_sub_kinds posk on posk.id = po.sub_type_id
    join doc.employees e on e.id = po.author_id  
    join doc.departments d on d.id = e.department_id
    join doc.document_types dt on po.type_id = dt.id 
    join doc.document_type_work_cycle_stages dtwcs on dtwcs.id = po.current_work_cycle_stage_id 
    join doc.employees e1 on e1.id = $1  
    join doc.employees_roles er on er.employee_id = $1
    left join doc.personnel_order_creating_access_employees pocae on pocae.employee_id = $1
    left join doc.personnel_order_signings pos on pos.document_id = po.id 
    left join doc.personnel_order_approvings poa on poa.document_id = po.id 
    where 
	(po.author_id = $1) 
	or(
		(e.head_kindred_department_id = e1.head_kindred_department_id) and
		pocae.employee_id is not null 
		or
		doc.is_employee_replacing_for_other($1, po.author_id)
	)
	or (
		(po.is_sent_to_signing or dtwcs.stage_number = 6) 
		and exists (
			select 
			1 
			from doc.personnel_order_control_groups__sub_kinds pocgsk
			join doc.personnel_order_control_groups__employees pocge on pocge.control_group_id = pocgsk.control_group_id
			where 
				pocgsk.personnel_order_sub_kind_id = po.sub_type_id 
				and (
					$1 = pocge.employee_id
					/*or 		
					doc.is_employee_replacing_for_other($1, pocge.employee_id)*/
				)
		)
			
	)
	or (
		(dtwcs.stage_number = 2 or poa.cycle_number is not null) and
		(
			$1 = poa.approver_id
			or
			case 
			    when er.role_id in (2, 3, 4, 6)
			    then doc.is_employee_workspace_includes_other_employee($1, poa.approver_id)
			    else false
			end
			or
			doc.is_employee_replacing_for_other($1, poa.approver_id)
		)
	);
			
		
$$
language sql;  

grant execute on function doc.get_personnel_orders_for_employee(int) to umz_doc_edit;
revoke all on function doc.get_personnel_orders_for_employee(int) from public;

drop function if exists doc.get_personnel_orders_for_employee_by_ids(int, int[]);

CREATE OR REPLACE FUNCTION doc.get_personnel_orders_for_employee_by_ids(IN employee_id integer, document_ids int[])
  RETURNS TABLE(
	is_document_viewed boolean, id integer, base_document_id int, type_id integer, sub_type_id int, sub_type_name varchar, name character varying, number character varying, document_date date, creation_date date, 
	creation_date_year integer, creation_date_month integer, type_name character varying, current_work_cycle_stage_number integer, 
	current_work_cycle_stage_name character varying, author_id integer, author_short_name character varying, author_department_short_name varchar,
	can_be_removed boolean
	) 
  AS $$
select  
    distinct
    exists( 
    select 1 
    from doc.looked_personnel_orders lpo 
    where lpo.document_id = po.id and lpo.looked_employee_id = $1  
    ) as is_document_viewed, 
    po.id, 
    po.id as base_document_id,
    po.type_id, 
    po.sub_type_id,
    posk.name as sub_type_name,
    po.name, 
    po.document_number as number, 
    po.document_date::date,
    po.creation_date::date, 
    date_part('year', po.creation_date)::integer as creation_date_year, 
    date_part('month', po.creation_date)::integer as creation_date_month, 
    dt.short_full_name as type_name, 
    dtwcs.stage_number as current_work_cycle_stage_number, 
    dtwcs.stage_name as current_work_cycle_stage_name, 
    po.author_id,
    (e.surname || ' ' || e.name || ' ' || e.patronymic)::varchar as author_short_name,
    d.short_name as author_department_short_name,
    null::boolean as can_be_removed 
    from doc.personnel_orders po 
    join doc.personnel_order_sub_kinds posk on posk.id = po.sub_type_id
    join doc.employees e on e.id = po.author_id  
    join doc.departments d on d.id = e.department_id
    join doc.document_types dt on po.type_id = dt.id 
    join doc.document_type_work_cycle_stages dtwcs on dtwcs.id = po.current_work_cycle_stage_id 
    join doc.employees e1 on e1.id = $1  
    join doc.employees_roles er on er.employee_id = $1
    left join doc.personnel_order_creating_access_employees pocae on pocae.employee_id = $1 
    left join doc.personnel_order_signings pos on pos.document_id = po.id 
    left join doc.personnel_order_approvings poa on poa.document_id = po.id 
    where (po.id = any($2)) and
	((po.author_id = $1) 
	or(
		(e.head_kindred_department_id = e1.head_kindred_department_id) and
		pocae.employee_id is not null 
		or
		doc.is_employee_replacing_for_other($1, po.author_id)
	)
	or (
		(po.is_sent_to_signing or dtwcs.stage_number = 6) 
		and exists (
			select 
			1 
			from doc.personnel_order_control_groups__sub_kinds pocgsk
			join doc.personnel_order_control_groups__employees pocge on pocge.control_group_id = pocgsk.control_group_id
			where 
				pocgsk.personnel_order_sub_kind_id = po.sub_type_id 
				and (
					$1 = pocge.employee_id
					/*or 		
					doc.is_employee_replacing_for_other($1, pocge.employee_id)*/
				)
		)
			
	)
	or (
		(dtwcs.stage_number = 2 or poa.cycle_number is not null) and
		(
			$1 = poa.approver_id
			or
			case 
			    when er.role_id in (2, 3, 4, 6)
			    then doc.is_employee_workspace_includes_other_employee($1, poa.approver_id)
			    else false
			end
			or
			doc.is_employee_replacing_for_other($1, poa.approver_id)
		)
	));
			
		
$$
language sql;  

grant execute on function doc.get_personnel_orders_for_employee_by_ids(int, int[]) to umz_doc_edit;
revoke all on function doc.get_personnel_orders_for_employee_by_ids(int, int[]) from public;
----------------------------------------------------------------------------------------------------------
drop function if exists doc.get_personnel_orders_from_departments(int[]);
create or replace function doc.get_personnel_orders_from_departments(department_ids int[])
	RETURNS TABLE(
		id integer, base_document_id int, type_id integer, sub_type_id int, sub_type_name varchar, name character varying, number character varying, document_date date, creation_date date, 
		creation_date_year integer, creation_date_month integer, type_name character varying, current_work_cycle_stage_number integer, 
		current_work_cycle_stage_name character varying, author_id integer, author_short_name character varying, author_department_short_name varchar,
		can_be_removed boolean
	) 
AS
$$

select  
    distinct
    po.id, 
    po.id as base_document_id,
    po.type_id, 
    po.sub_type_id,
    posk.name as sub_type_name,
    po.name, 
    po.document_number as number, 
    po.document_date::date,
    po.creation_date::date, 
    date_part('year', po.creation_date)::integer as creation_date_year, 
    date_part('month', po.creation_date)::integer as creation_date_month, 
    dt.short_full_name as type_name, 
    dtwcs.stage_number as current_work_cycle_stage_number, 
    dtwcs.stage_name as current_work_cycle_stage_name, 
    po.author_id,
    (e.surname || ' ' || e.name || ' ' || e.patronymic)::varchar as author_short_name,
    d.short_name as author_department_short_name,
    null::boolean as can_be_removed 
    from doc.personnel_orders po 
    join doc.personnel_order_sub_kinds posk on posk.id = po.sub_type_id
    join doc.employees e on e.id = po.author_id  
    join doc.departments d on d.id = e.department_id
    join doc.document_types dt on po.type_id = dt.id 
    join doc.document_type_work_cycle_stages dtwcs on dtwcs.id = po.current_work_cycle_stage_id 
    where e.department_id = any($1);
    
$$
language sql;

grant execute on function doc.get_personnel_orders_from_departments(int[]) to umz_doc_edit;
revoke all on function doc.get_personnel_orders_from_departments(int[]) from public;
-----------------------------------
drop function if exists doc.get_department_personnel_orders_by_ids(int[]);
create or replace function doc.get_department_personnel_orders_by_ids(document_ids int[])
	RETURNS TABLE(
		id integer, base_document_id int, type_id integer, sub_type_id int, sub_type_name varchar, name character varying, number character varying, document_date date, creation_date date, 
		creation_date_year integer, creation_date_month integer, type_name character varying, current_work_cycle_stage_number integer, 
		current_work_cycle_stage_name character varying, author_id integer, author_short_name character varying, author_department_short_name varchar,
		can_be_removed boolean
	) 
AS
$$

select  
    distinct
    po.id, 
    po.id as base_document_id,
    po.type_id, 
    po.sub_type_id,
    posk.name as sub_type_name,
    po.name, 
    po.document_number as number, 
    po.document_date::date,
    po.creation_date::date, 
    date_part('year', po.creation_date)::integer as creation_date_year, 
    date_part('month', po.creation_date)::integer as creation_date_month, 
    dt.short_full_name as type_name, 
    dtwcs.stage_number as current_work_cycle_stage_number, 
    dtwcs.stage_name as current_work_cycle_stage_name, 
    po.author_id,
    (e.surname || ' ' || e.name || ' ' || e.patronymic)::varchar as author_short_name,
    d.short_name as author_department_short_name,
    null::boolean as can_be_removed 
    from doc.personnel_orders po 
    join doc.personnel_order_sub_kinds posk on posk.id = po.sub_type_id
    join doc.employees e on e.id = po.author_id  
    join doc.departments d on d.id = e.department_id
    join doc.document_types dt on po.type_id = dt.id 
    join doc.document_type_work_cycle_stages dtwcs on dtwcs.id = po.current_work_cycle_stage_id 
    where po.id = any($1);
    
$$
language sql;
grant execute on function doc.get_department_personnel_orders_by_ids(int[]) to umz_doc_edit;
revoke all on function doc.get_department_personnel_orders_by_ids(int[]) from public;
-----------------------------------------------------
insert into doc.document_types (id, parent_type_id, name, single_full_name, short_full_name, is_presented, is_domain)
values (8, null, 'ОРД', 'ОРД', 'ОРД', true, default),
(9, 8, 'Приказы', 'Приказ', 'Приказ', false, default),
(10, 8, 'Распоряжения', 'Распоряжение', 'Распоряжение', false, default),
(11, 8, 'Кадровые приказы', 'Кадровый приказ', 'Кадровый приказ', true, true);

CREATE OR REPLACE FUNCTION doc.get_personnel_order_head_charge_sheet_for(charge_sheet_id integer)
  RETURNS integer AS
$BODY$
	with recursive head_charge_sheet_view (id, top_level_charge_sheet_id) as (
		select 
		id,
		top_level_charge_sheet_id
		from doc.personnel_order_charges 
		where id = charge_sheet_id

		union

		select 
		snr.id,
		snr.top_level_charge_sheet_id
		from doc.personnel_order_charges snr
		join head_charge_sheet_view t on t.top_level_charge_sheet_id = snr.id
		where t.top_level_charge_sheet_id is not null
	)
	select id from head_charge_sheet_view where top_level_charge_sheet_id is null;
$BODY$
  LANGUAGE sql VOLATILE
  COST 100;

  grant execute on function doc.get_personnel_order_head_charge_sheet_for(int) to umz_doc_edit;
  revoke execute on function doc.get_personnel_order_head_charge_sheet_for(int) from umz_doc_edit;
  
CREATE OR REPLACE FUNCTION doc.set_personnel_order_head_charge_sheet_for_new_charge_sheet()
  RETURNS trigger AS
$BODY$
begin

	update doc.personnel_order_charges 
	set head_charge_sheet_id = doc.get_personnel_order_head_charge_sheet_for(new.id)
	where id = new.id;
	
	return new;
end
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;

 grant execute on function doc.set_personnel_order_head_charge_sheet_for_new_charge_sheet() to umz_doc_edit;
 revoke execute on function doc.set_personnel_order_head_charge_sheet_for_new_charge_sheet() from umz_doc_edit;

CREATE TRIGGER set_personnel_order_head_charge_sheet_for_new_charge_sheet
  AFTER INSERT OR UPDATE
  ON doc.personnel_order_charges
  FOR EACH ROW
  WHEN (((new.head_charge_sheet_id IS NULL) AND (new.performing_date IS NOT NULL)))
  EXECUTE PROCEDURE doc.set_head_charge_sheet_for_new_charge_sheet();

  insert into doc.document_type_work_cycle_stages (document_type_id, stage_name, stage_number, service_stage_name)
  values
  (11, 'Создан', 1, 'Created'),
  (11, 'На согласовании', 2, 'IsApproving'),
  (11, 'Согласован', 3, 'Approved'),
  (11, 'Не согласован', 4, 'NotApproved'),
  (11, 'На подписании', 5, 'IsSigning'),
  (11, 'Отклонён', 6, 'SigningRejected'),
  (11, 'Подписан', 7, 'Signed'),
  (11, 'На исполнении', 8, 'IsPerforming'),
  (11, 'Исполнен', 9, 'Performed');

create table doc.personnel_order_signers (
 signer_id int not null primary key references doc.employees (id),
 is_default boolean not null default false
);

comment on table doc.personnel_order_signers is 'Подписанты кадровых приказов';
comment on column doc.personnel_order_signers.signer_id is 'Ссылка на имеющего возможность подписи кадровых приказов сотрудника';

