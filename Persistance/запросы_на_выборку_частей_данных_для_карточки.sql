--  Файлы служебок 
SELECT doc_fm.id as document_file_id,
	doc_fm.file_name as document_file_name,
	doc_fm.file_path as document_file_path
FROM doc.service_note_file_metadata doc_fm 
WHERE doc_fm.document_id = 237391;


-- Информация о документе

select distinct 
	doc.id as document_id,
	doc.id as base_document_id,
	doc.type_id as document_kind_id,
	doc.document_number as document_number,
	doc.name as document_name,
	doc.content as document_content,
	doc.note as document_note,
	doc.is_self_registered,
	doc.product_code as product_code,
	doc.creation_date as document_creation_date,
	doc.document_date as document_date,
	dt.short_full_name as document_kind,
	dtwcs.stage_name as document_current_work_cycle_stage_name,
	dtwcs.stage_number as document_current_work_cycle_stage_number,
	e.id as document_author_id,
	e.leader_id as doc_author_leader_id,
	(e.surname || ' ' || e.name || ' ' || e.patronymic) as document_author_name,
	e.speciality as document_author_speciality,
	d.id as document_author_department_id,
	d.code as document_author_department_code,
	d.short_name as document_author_department_name,
	sp.id as document_responsible_id,
	(upper(substring(sp.family, 1, 1)) || lower(substring(sp.family, 2, length(sp.family) - 1))) || ' ' ||(upper(substring(sp.name, 1, 1)) || lower(substring(sp.name, 2, length(sp.name) - 1))) || ' ' ||(upper(substring(sp.patronymic, 1, 1)) || lower(substring(sp.patronymic, 2, length(sp.patronymic) - 1)))  as document_responsible_name,
	sptn.telephone_number as document_responsible_telephone_number,
	spr_podr.id as document_responsible_department_id,
	spr_podr.podr_code as document_responsible_department_code, 
	spr_podr.podr_short_name as document_responsible_department_name,

	doc_signings.id as document_signing_id,
	doc_signings.signing_date as document_signing_performing_date,
	signer.id as document_signer_id,
	signer.leader_id as document_signer_leader_id,
	(signer.surname || ' ' || signer.name || ' ' || signer.patronymic) as document_signer_name,
	signer.speciality as signer_speciality,
	signer_dep.id as document_signer_dep_id,
	signer_dep.code as document_signer_dep_code,
	signer_dep.short_name as document_signer_dep_name,fact_signer.id as document_fact_signer_id,
	fact_signer.leader_id as document_fact_signer_leader_id,
	(fact_signer.surname || ' ' || fact_signer.name || ' ' || fact_signer.patronymic) as document_fact_signer_name,
	fact_signer.speciality as fact_signer_speciality,
	fact_signer_dep.id as document_fact_signer_dep_id, 
	fact_signer_dep.code as document_fact_signer_dep_code,
	fact_signer_dep.short_name as document_charge_fact_perf_dep_name

from doc.service_notes doc
join doc.get_current_employee_id() cur_emp(id) on true
join doc.document_types dt on dt.id = doc.type_id
join doc.document_type_work_cycle_stages dtwcs on dtwcs.id = doc.current_work_cycle_stage_id
join doc.employees e on e.id = doc.author_id
join doc.departments d on d.id = e.department_id
join exchange.spr_person sp on sp.id = doc.performer_id
join nsi.spr_podr spr_podr on spr_podr.id = sp.podr_id
left join exchange.spr_person_telephone_numbers sptn on sptn.person_id = sp.id
left join doc.service_note_signings doc_signings on doc_signings.document_id = doc.id
left join doc.employees signer on signer.id = doc_signings.signer_id
left join doc.departments signer_dep on signer_dep.id = signer.department_id
left join doc.employees fact_signer on fact_signer.id = doc_signings.actual_signed_id
left join doc.departments fact_signer_dep on fact_signer_dep.id = fact_signer.department_id
where doc.id=237391;


--Получатели документов
select distinct 	
	doc_rec.id as document_charge_id,
	doc_rec.charge as document_charge_text,
	doc_rec.comment as document_charge_response,
	doc_rec.charge_period_start as document_charge_period_start,
	doc_rec.charge_period_end as document_charge_period_end,
	doc_rec.performing_date as document_charge_performing_date,
	doc_rec.is_for_acquaitance as document_charge_is_for_acquaitance,performers.id document_charge_performer_id,
	performers.leader_id as document_charge_perf_leader_id,
	performers.is_foreign as document_charge_perf_is_foreign,
	(performers.surname || ' ' || performers.name || ' ' || performers.patronymic) as document_charge_performer_name,
	performers.speciality as document_charge_performer_speciality,
	perf_deps.id as document_charge_perf_dep_id,
	perf_deps.code as document_charge_perf_dep_code,
	perf_deps.short_name as document_charge_perf_dep_name,
	fact_perf.id as document_charge_fact_perf_id,
	fact_perf.leader_id as document_charge_fact_perf_leader_id,
	fact_perf.is_foreign as document_charge_fact_perf_is_foreign,
	(fact_perf.surname || ' ' || fact_perf.name || ' ' || fact_perf.patronymic) as document_charge_fact_perf_name,
	fact_perf.speciality as document_charge_fact_perf_speciality,
	fact_perf_dep.id as document_charge_fact_perf_dep_id,
	fact_perf_dep.code as document_charge_fact_perf_dep_code,
	fact_perf_dep.short_name as document_charge_fact_perf_dep_name,

	case when doc_rec.issuer_id is not null then doc_rec.id	else null end as document_charge_sheet_id,
	case when doc_rec.issuer_id is not null then doc_rec.document_id else null end as charge_sheet_document_id,
	case when doc_rec.issuer_id is not null then doc_rec.top_level_charge_sheet_id else null end as top_level_document_charge_sheet_id,
	case when doc_rec.issuer_id is not null then doc_rec.charge	else null	end as document_charge_sheet_text,
	case when doc_rec.issuer_id is not null then doc_rec.comment else null	end as document_charge_sheet_response,
	case when doc_rec.issuer_id is not null then doc_rec.charge_period_start else null end as document_charge_sheet_period_start,
	case when doc_rec.issuer_id is not null then doc_rec.charge_period_end	else null	end as document_charge_sheet_period_end,
	case when doc_rec.issuer_id is not null then doc_rec.performing_date else null	end as document_charge_sheet_performing_date,
	case when doc_rec.issuer_id is not null then doc_rec.issuing_datetime else null end as document_charge_sheet_issuing_datetime,
	case when doc_rec.issuer_id is not null then doc_rec.is_for_acquaitance else null end as document_charge_sheet_is_for_acquaitance,
	case when doc_rec.issuer_id is not null then (select doc.is_employee_acting_for_other_or_vice_versa(doc.get_current_employee_id(), performers.id)) else null end as document_charge_sheet_is_accessible_charge,

	case when doc_rec.issuer_id is not null then (select role_id from doc.employees_roles where employee_id = performers.id) else null end as document_charge_sheet_performer_role_id,
	case when doc_rec.issuer_id is not null then performers.id else null end as document_charge_sheet_performer_id,
	case when doc_rec.issuer_id is not null then performers.leader_id else null end as document_charge_sheet_perf_leader_id,
	case when doc_rec.issuer_id is not null then performers.is_foreign else null end as document_charge_sheet_perf_is_foreign,
	case when doc_rec.issuer_id is not null then (performers.surname || ' ' || performers.name || ' ' || performers.patronymic) else null end as document_charge_sheet_performer_name,
	case when doc_rec.issuer_id is not null then performers.speciality else null end as document_charge_sheet_performer_speciality,
	case when doc_rec.issuer_id is not null then perf_deps.id else null end as document_charge_sheet_perf_dep_id,
	case when doc_rec.issuer_id is not null then perf_deps.code else null end as document_charge_sheet_perf_dep_code,
	case when doc_rec.issuer_id is not null then perf_deps.short_name else null end as document_charge_sheet_perf_dep_name,

	case when doc_rec.issuer_id is not null then fact_perf.id else null end as document_charge_sheet_fact_perf_id,
	case when doc_rec.issuer_id is not null then fact_perf.leader_id else null end as document_charge_sheet_fact_perf_leader_id,
	case when doc_rec.issuer_id is not null then fact_perf.is_foreign else null end as document_charge_sheet_fact_perf_is_foreign,
	case when doc_rec.issuer_id is not null then (fact_perf.surname || ' ' || fact_perf.name || ' ' || fact_perf.patronymic) else null end as document_charge_sheet_fact_perf_name,
	case when doc_rec.issuer_id is not null then fact_perf.speciality else null end as document_charge_sheet_fact_perf_speciality,
	case when doc_rec.issuer_id is not null then fact_perf_dep.id else null end as document_charge_sheet_fact_perf_dep_id,
	case when doc_rec.issuer_id is not null then fact_perf_dep.code else null end as document_charge_sheet_fact_perf_dep_code,
	case when doc_rec.issuer_id is not null then fact_perf_dep.short_name else null end as document_charge_sheet_fact_perf_dep_name,
	case when doc_rec.issuer_id is not null then (select  min(look_date) 
												  from doc.looked_service_notes lsn 
												  where lsn.document_id=doc_rec.document_id and
												((lsn.looked_employee_id=doc_rec.performer_id) or
												(doc.is_employee_acting_for_other_or_vice_versa(lsn.looked_employee_id,doc_rec.performer_id))))
											else null end as document_charge_sheet_viewing_date,fact_charge_sheet_sender.id as charge_sheet_sender_id,
	fact_charge_sheet_sender.leader_id as charge_sheet_sender_leader_id,
	fact_charge_sheet_sender.is_foreign as charge_sheet_sender_is_foreign,
	(fact_charge_sheet_sender.surname || ' ' || fact_charge_sheet_sender.name || ' ' || fact_charge_sheet_sender.patronymic) as charge_sheet_sender_name,
	fact_charge_sheet_sender.speciality as charge_sheet_sender_speciality,
	fact_charge_sheet_sender_dep.id as charge_sheet_sender_dep_id,
	fact_charge_sheet_sender_dep.code as charge_sheet_sender_dep_code,
	fact_charge_sheet_sender_dep.short_name as charge_sheet_sender_dep_name

from doc.service_note_receivers doc_rec 
left join doc.employees performers on performers.id = doc_rec.performer_id
left join doc.departments perf_deps on perf_deps.id = performers.department_id
left join doc.employees fact_perf on fact_perf.id = doc_rec.actual_performer_id
left join doc.departments fact_perf_dep on fact_perf_dep.id = fact_perf.department_id
left join doc.employees fact_charge_sheet_sender on fact_charge_sheet_sender.id = doc_rec.issuer_id
left join doc.departments fact_charge_sheet_sender_dep on fact_charge_sheet_sender_dep.id = fact_charge_sheet_sender.department_id

where doc_rec.document_id=237391;

--Согласования
select distinct 
	da.id as approving_id,
	da.performing_date as approving_performing_date,
	da.performing_result_id as approving_performing_result_id,
	(approver.id = cur_emp.id or doc.is_employee_acting_for_other_or_vice_versa(cur_emp.id, approver.id)) as document_approving_accessible, 
	dar.result_name as approving_performing_result,
	da.note as approving_note,
	da.cycle_number as approving_cycle_number,
	da.cycle_number as approving_cycle_id,
	case when da.id is not null then da.cycle_number is not null else null end as approving_is_completed,
	exists  ( select 1 from doc.looked_service_notes lsn where lsn.document_id=da.document_id and ((lsn.looked_employee_id=da.approver_id) or
															(doc.is_employee_acting_for_other_or_vice_versa(lsn.looked_employee_id,da.approver_id)))
			) as approving_is_looked_by_approver,
	approver.id as approver_id,
	approver.leader_id as approver_leader_id,
	approver.is_foreign as approver_is_foreign,
	(approver.surname || ' ' || approver.name || ' ' || approver.patronymic) as approver_name,
	approver.speciality as approver_speciality,
	approver_dep.id as approver_dep_id,
	approver_dep.code as approver_dep_code,
	approver_dep.short_name as approver_dep_name,
	fact_approver.id as fact_approver_id,
	fact_approver.leader_id as fact_approver_leader_id,
	fact_approver.is_foreign as fact_approver_is_foreign,
	(fact_approver.surname || ' ' || fact_approver.name || ' ' || fact_approver.patronymic) as fact_approver_name,
	fact_approver.speciality as fact_approver_speciality,
	fact_approver_dep.id as fact_approver_dep_id,
	fact_approver_dep.code as fact_approver_dep_code,
	fact_approver_dep.short_name as fact_approver_dep_name 

from  doc.service_note_approvings da 
join doc.get_current_employee_id() cur_emp(id) on true
left join doc.document_approving_results dar on dar.id = da.performing_result_id
left join doc.employees approver on approver.id = da.approver_id
left join doc.departments approver_dep on approver_dep.id = approver.department_id
left join doc.employees fact_approver on fact_approver.id = da.actual_performed_employee_id
left join doc.departments fact_approver_dep on fact_approver_dep.id = fact_approver.department_id 

where da.document_id=237391;


--Связанные документы
select distinct 
	
	doc_links.id as document_relation_id,
	coalesce(rel_docs.id, rel_servs.id, rel_po.id) as related_document_id,
	coalesce(rel_docs.type_id, rel_servs.type_id, rel_po.type_id) as related_document_kind_id,
	coalesce(rel_doc_type.single_full_name, rel_serv_type.single_full_name, rel_po_type.single_full_name) as related_document_kind_name,
	coalesce(rel_docs.document_number, rel_servs.document_number, rel_po.document_number) as related_document_number,
	coalesce(rel_docs.name, rel_servs.name, rel_po.name) as related_document_name,
	coalesce(rel_docs.document_date, rel_servs.document_date, rel_po.document_date) as related_document_date
	
from doc.service_note_links doc_links
left join lateral
(
	select
		doc_links.related_document_id as id,
		doc_links.related_document_type_id as type_id,
		rel_servs.document_number,
		rel_servs.name,
		rel_servs.document_date
	from doc.service_notes rel_servs
	where rel_servs.id = doc_links.related_document_id and rel_servs.type_id = doc_links.related_document_type_id
	or exists (
		select 1 from doc.service_note_receivers a
		where a.document_id = rel_servs.id and a.id = doc_links.related_document_id and a.incoming_document_type_id = doc_links.related_document_type_id
	)
) rel_servs on rel_servs.id = doc_links.related_document_id
left join lateral
(
	select
		doc_links.related_document_id as id,
		doc_links.related_document_type_id as type_id,
		rel_docs.document_number,
		rel_docs.name,
		rel_docs.document_date
	from doc.documents rel_docs
	where rel_docs.id = doc_links.related_document_id and rel_docs.type_id = doc_links.related_document_type_id
	or exists(
		select 1 from doc.document_receivers a
		where a.document_id = rel_docs.id and a.id = doc_links.related_document_id and a.incoming_document_type_id = doc_links.related_document_type_id
	)
) rel_docs on rel_docs.id = doc_links.related_document_id
left join lateral ( select doc_links.related_document_id as id,doc_links.related_document_type_id as type_id,rel_po.document_number,rel_po.name,rel_po.document_date 
					from doc.personnel_orders rel_po 
					where rel_po.id = doc_links.related_document_id and rel_po.type_id = doc_links.related_document_type_id) rel_po on rel_po.id = doc_links.related_document_id 
left join doc.document_types rel_doc_type on rel_doc_type.id = rel_docs.type_id
left join doc.document_types rel_serv_type on rel_serv_type.id = rel_servs.type_id
left join doc.document_types rel_po_type on rel_po_type.id = rel_po.type_id 

where doc_links.document_id=227797;