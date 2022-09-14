CREATE OR REPLACE FUNCTION doc.gen(
    count integer,
    start character varying)
  RETURNS void AS
$BODY$
declare
i int;
j int;
dup_serv_note record;
dup_receivers doc.service_note_receivers[];
dup_receiver doc.service_note_receivers;
new_id integer;
begin

			select
			 type_id,
			  name,
			  document_number,
			  creation_date,
			  note, 
			  current_work_cycle_stage_id, 
			  content,
			  employee_login_who_created,
			  employee_login_who_agreed,
			  signing_date, -- Дата подписания документа
			  performer_id, -- Ссылка на ответственного за данный документ
			  outside_performer_id, -- Ссылка (внешняя) на исполнителя служебной записки
			  author_id,
			  employee_id_who_signed
			  into dup_serv_note
			  from doc.service_notes
			  where outside_id = 227614;

		for dup_receiver in select
					  *
					  from doc.service_note_receivers
					  where outside_document_id = 227614 loop

			dup_receivers = array_append(dup_receivers, dup_receiver)::doc.service_note_receivers[];
			
		end loop;

		for i in 1..count loop

			insert into doc.service_notes 
			(
			type_id,
			  name,
			  document_number,
			  creation_date,
			  note, 
			  current_work_cycle_stage_id, 
			  content,
			  employee_login_who_created,
			  employee_login_who_agreed,
			  signing_date, -- Дата подписания документа
			  performer_id, -- Ссылка на ответственного за данный документ
			  outside_performer_id, -- Ссылка (внешняя) на исполнителя служебной записки
			  author_id,
			  employee_id_who_signed
			)
			select 
			dup_serv_note.type_id,
			  start || ' ' || i,
			  dup_serv_note.document_number,
			  dup_serv_note.creation_date,
			  dup_serv_note.note, 
			  dup_serv_note.current_work_cycle_stage_id, 
			  dup_serv_note.content,
			  dup_serv_note.employee_login_who_created,
			  dup_serv_note.employee_login_who_agreed,
			  dup_serv_note.signing_date, -- Дата подписания документа
			  dup_serv_note.performer_id, -- Ссылка на ответственного за данный документ
			  dup_serv_note.outside_performer_id, -- Ссылка (внешняя) на исполнителя служебной записки
			  dup_serv_note.author_id,
			  dup_serv_note.employee_id_who_signed
			  returning outside_id into new_id;

			foreach dup_receiver in array dup_receivers loop

				insert into doc.service_note_receivers
				(
					outside_document_id, -- Ссылка на служебную записку, полученная из внешнего справочника-- Ссылка на сотрудника, к которому относится полученная служебная записка
					  outside_employee_id, -- Ссылка на получившего сотрудника, полученная из внешнего справочника
					  performing_date, -- Дата исполнения служебной записки
					  comment, -- Комментарий к исполнению

					  input_number_date, -- Дата проставления входящего номера служебной записки для данного сотрудника
					  sender_id, -- Ссылка на запись об отправителе служебной записки
					  knowing_date, -- Дата ознакомления со служебной запиской получателем
					  input_number, -- Входящий номер документа для данного сотрудника
					  is_performer, -- является ли получатель исполнителем документа
					  receiver_category,
					  current_work_cycle_stage_id, -- Ссылка на текущую стадию рабочего цикла входящей служебной записки
					  charge, -- Поручение по данной служебной записке (для подчиненных исполнителей)
					  actual_performer_id, -- Фактически исполнивший документ сотрудник
					  real_sender_employee_id
				)
				select 
					  new_id, -- Ссылка на служебную записку, полученная из внешнего справочника-- Ссылка на сотрудника, к которому относится полученная служебная записка
					  dup_receiver.outside_employee_id, -- Ссылка на получившего сотрудника, полученная из внешнего справочника
					  dup_receiver.performing_date, -- Дата исполнения служебной записки
					  dup_receiver.comment, -- Комментарий к исполнению
					  dup_receiver.input_number_date, -- Дата проставления входящего номера служебной записки для данного сотрудника
					  dup_receiver.sender_id, -- Ссылка на запись об отправителе служебной записки
					  dup_receiver.knowing_date, -- Дата ознакомления со служебной запиской получателем
					  dup_receiver.input_number, -- Входящий номер документа для данного сотрудника
					  dup_receiver.is_performer, -- является ли получатель исполнителем документа
					  dup_receiver.receiver_category,
					  dup_receiver.current_work_cycle_stage_id, -- Ссылка на текущую стадию рабочего цикла входящей служебной записки
					  dup_receiver.charge, -- Поручение по данной служебной записке (для подчиненных исполнителей)
					  dup_receiver.actual_performer_id, -- Фактически исполнивший документ сотрудник
					  dup_receiver.real_sender_employee_id;
					  
			end loop;
			
		end loop;
end
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;
ALTER FUNCTION doc.gen(integer, character varying)
  OWNER TO u_59968;

select doc.gen(41000, 'EMPTINESS')