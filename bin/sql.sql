select distinct
doc_rec.id as document_charge_id,
dct.id as document_charge_kind_id,
dct.name as document_charge_kind_name,
dct.service_name as document_charge_service_kind_name,
doc_rec.charge as document_charge_text,
doc_rec.comment as document_charge_response,
doc_rec.charge_period_start as document_charge_period_start,
doc_rec.charge_period_end as document_charge_period_end,
doc_rec.performing_date as document_charge_performing_date,
doc_rec.is_for_acquaitance as document_charge_is_for_acquaitance,performers.id as document_charge_performer_id,
performers.is_foreign as document_charge_perf_is_foreign,
(performers.surname || ' ' || performers.name || ' ' || performers.patronymic) as document_charge_performer_name,
performers.speciality as document_charge_performer_speciality,
perf_deps.id as document_charge_perf_dep_id,
perf_deps.code as document_charge_perf_dep_code,
perf_deps.short_name as document_charge_perf_dep_name,
fact_perf.id as document_charge_fact_perf_id,
(fact_perf.surname || ' ' || fact_perf.name || ' ' || fact_perf.patronymic) as document_charge_fact_perf_name,
fact_perf.speciality as document_charge_fact_perf_speciality,
fact_perf_dep.id as document_charge_fact_perf_dep_id,
fact_perf_dep.code as document_charge_fact_perf_dep_code,
fact_perf_dep.short_name as document_charge_fact_perf_dep_name,
case when doc_rec.issuer_id is not null then doc_rec.id else null end as document_charge_sheet_id,
case when doc_rec.issuer_id is not null then doc_rec.id else null end as document_charge_sheet_charge_id,
case when doc_rec.issuer_id is not null then dct.id else null end as document_charge_sheet_kind_id,case when doc_rec.issuer_id is not null then dct.name else null end as document_charge_sheet_kind_name,case when doc_rec.issuer_id is not null then dct.service_name else null end as document_charge_sheet_service_kind_name,case when doc_rec.issuer_id is not null then doc_rec.document_id else null end as charge_sheet_document_id,
case when doc_rec.issuer_id is not null then doc_rec.document_kind_id else null end as charge_sheet_document_kind_id,
case when doc_rec.issuer_id is not null then doc_rec.top_level_charge_sheet_id else null end as top_level_document_charge_sheet_id,
case when doc_rec.issuer_id is not null then doc_rec.charge	else null	end as document_charge_sheet_text,
case when doc_rec.issuer_id is not null then doc_rec.comment else null	end as document_charge_sheet_response,
case when doc_rec.issuer_id is not null then doc_rec.charge_period_start else null end as document_charge_sheet_period_start,
case when doc_rec.issuer_id is not null then doc_rec.charge_period_end	else null	end as document_charge_sheet_period_end,
case when doc_rec.issuer_id is not null then doc_rec.performing_date else null	end as document_charge_sheet_performing_date,
case when doc_rec.issuer_id is not null then doc_rec.issuing_datetime else null end as document_charge_sheet_issuing_datetime,
case when doc_rec.issuer_id is not null then doc_rec.is_for_acquaitance else null end as document_charge_sheet_is_for_acquaitance,
case when doc_rec.issuer_id is not null then performers.id else null end as document_charge_sheet_performer_id,
case when doc_rec.issuer_id is not null then performers.is_foreign else null end as document_charge_sheet_perf_is_foreign,
case when doc_rec.issuer_id is not null then (performers.surname || ' ' || performers.name || ' ' || performers.patronymic) else null end as document_charge_sheet_performer_name,
case when doc_rec.issuer_id is not null then performers.speciality else null end as document_charge_sheet_performer_speciality,
case when doc_rec.issuer_id is not null then perf_deps.id else null end as document_charge_sheet_perf_dep_id,
case when doc_rec.issuer_id is not null then perf_deps.code else null end as document_charge_sheet_perf_dep_code,
case when doc_rec.issuer_id is not null then perf_deps.short_name else null end as document_charge_sheet_perf_dep_name,
case when doc_rec.issuer_id is not null then fact_perf.id else null end as document_charge_sheet_fact_perf_id,
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
fact_charge_sheet_sender.is_foreign as charge_sheet_sender_is_foreign,
(fact_charge_sheet_sender.surname || ' ' || fact_charge_sheet_sender.name || ' ' || fact_charge_sheet_sender.patronymic) as charge_sheet_sender_name,
fact_charge_sheet_sender.speciality as charge_sheet_sender_speciality,
fact_charge_sheet_sender_dep.id as charge_sheet_sender_dep_id,
fact_charge_sheet_sender_dep.code as charge_sheet_sender_dep_code,
fact_charge_sheet_sender_dep.short_name as charge_sheet_sender_dep_name,
replacings.is_cur_emp_issuer or replacings.is_cur_emp_performer as can_charge_sheet_view,replacings.is_cur_emp_issuer as has_charge_section_access,replacings.is_cur_emp_performer as has_response_section_access,replacings.is_cur_emp_issuer as can_charge_sheet_remove,replacings.is_cur_emp_performer as can_charge_sheet_perform
from doc.personnel_order_charges doc_rec
left join doc.document_charge_types dct on dct.id = doc_rec.kind_id join doc.get_current_employee_id() cur_emp(id) on true
left join doc.employees performers on performers.id = doc_rec.performer_id
left join doc.departments perf_deps on perf_deps.id = performers.department_id
left join doc.employees fact_perf on fact_perf.id = doc_rec.actual_performer_id
left join doc.departments fact_perf_dep on fact_perf_dep.id = fact_perf.department_id
left join doc.employees fact_charge_sheet_sender on fact_charge_sheet_sender.id = doc_rec.issuer_id
left join doc.departments fact_charge_sheet_sender_dep on fact_charge_sheet_sender_dep.id = fact_charge_sheet_sender.department_id
join lateral (select doc.is_employee_acting_for_other_or_vice_versa(cur_emp.id, doc_rec.issuer_id) as is_cur_emp_issuer,doc.is_employee_acting_for_other_or_vice_versa(cur_emp.id, doc_rec.performer_id) as is_cur_emp_performer) as replacings on true where doc_rec.document_id=:pdocument_id ORDER BY document_charge_sheet_perf_dep_code, document_charge_sheet_charge_id
