unit PostgresDocumentFullInfoFetchingQueryBuilder;

interface

uses

  DB,
  BasedOnDatabaseDocumentInfoReadService,
  DocumentFullInfoDTO,
  DocumentFullInfoDataSetHolder,
  DocumentTableDefsFactory,
  SysUtils,
  ZConnection,
  ZDataset,
  Classes;

type

  TPostgresDocumentInfoFetchingQueryBuilder = class (TDocumentInfoFetchingQueryBuilder)

    protected

      function GetDocumentTableExpression(
        DocumentFullInfoDataSetFieldNames: TDocumentFullInfoDataSetFieldNames;
        const DocumentIdParamName: String
      ): String;

      function GetRestTableJoinExpression(
        DocumentFullInfoDataSetFieldNames: TDocumentFullInfoDataSetFieldNames;
        const DocumentIdParamName: String
      ): String;

      function GetCurrentEmployeeTableJoinExpression: String;
      
    protected

      function GetDocumentFullInfoFieldNameListExpression(
        DocumentFullInfoDataSetFieldNames: TDocumentFullInfoDataSetFieldNames
      ): String; override;

      function GetDocumentSignerInfoFieldNameListExpression(
        DocumentFullInfoDataSetFieldNames: TDocumentFullInfoDataSetFieldNames
      ): String; override;

      function GetDocumentFullInfoTableExpression(
        DocumentFullInfoDataSetFieldNames: TDocumentFullInfoDataSetFieldNames;
        const DocumentIdParamName: String
      ): String; override;

      function GetDocumentFullInfoWhereExpression(
        DocumentFullInfoDataSetFieldNames: TDocumentFullInfoDataSetFieldNames;
        const DocumentIdParamName: String
      ): String; override;

  end;
    
implementation

uses

  StrUtils;

{ TPostgresDocumentInfoFetchingQueryBuilder }

function TPostgresDocumentInfoFetchingQueryBuilder.
  GetDocumentFullInfoFieldNameListExpression(
    DocumentFullInfoDataSetFieldNames: TDocumentFullInfoDataSetFieldNames
  ): String;
begin

  with FDocumentTableDefsFactory, DocumentFullInfoDataSetFieldNames do begin
  
    Result :=
      'doc.id as ' + IdFieldName + ',' + #13#10 +
      'doc.id as ' + BaseIdFieldName + ',' +
      'doc.type_id as ' + KindIdFieldName + ',' + #13#10 +
      'doc.document_number as ' + NumberFieldName + ',' + #13#10 +
      'doc.name as ' + NameFieldName + ',' + #13#10 +
      'doc.content as ' + ContentFieldName + ',' + #13#10 + 
      'doc.note as ' + NoteFieldName + ',' + #13#10 +
      IfThen(IsSelfRegisteredFieldName <> '', 'doc.is_self_registered,', '') + #13#10 +
      'doc.product_code as ' + ProductCodeFieldName + ',' + #13#10 +
      'doc.creation_date as ' + CreationDateFieldName + ',' + #13#10 +
      'doc.document_date as ' + DateFieldName + ',' + #13#10 +
      'dt.short_full_name as ' + KindFieldName + ',' + #13#10 +
      'dtwcs.stage_name as ' + CurrentWorkCycleStageNameFieldName + ',' + #13#10 +
      'dtwcs.stage_number as ' + CurrentWorkCycleStageNumberFieldName + ',' + #13#10 +
      'e.id as ' + AuthorIdFieldName + ',' + #13#10 + 
      'e.leader_id as ' + AuthorLeaderIdFieldName + ',' + #13#10 +
      '(e.surname || '' '' || e.name || '' '' || e.patronymic) as ' + AuthorNameFieldName + ',' + #13#10 + 
      'e.speciality as ' + AuthorSpecialityFieldName + ',' + #13#10 + 
      'd.id as ' + AuthorDepartmentIdFieldName + ',' + #13#10 + 
      'd.code as ' + AuthorDepartmentCodeFieldName + ',' + #13#10 +
      'd.short_name as ' + AuthorDepartmentNameFieldName + ',' + #13#10 + 
      'sp.id as ' + ResponsibleIdFieldName + ',' + #13#10 + 
      '(upper(substring(sp.family, 1, 1)) || lower(substring(sp.family, 2, length(sp.family) - 1))) || '' '' ||' +
      '(upper(substring(sp.name, 1, 1)) || lower(substring(sp.name, 2, length(sp.name) - 1))) || '' '' ||' +
      '(upper(substring(sp.patronymic, 1, 1)) || lower(substring(sp.patronymic, 2, length(sp.patronymic) - 1))) ' +
      ' as ' + ResponsibleNameFieldName + ',' + #13#10 +
      'sptn.telephone_number as ' + ResponsibleTelephoneNumberFieldName + ',' + #13#10 + 
      'spr_podr.id as ' + ResponsibleDepartmentIdFieldName + ',' + #13#10 +
      'dct.id as ' + ChargesInfoFieldNames.KindIdFieldName + ',' + #13#10 +
      'dct.name as ' + ChargesInfoFieldNames.KindNameFieldName + ',' + #13#10 +
      'dct.service_name as ' + ChargesInfoFieldNames.ServiceKindNameFieldName + ',' + #13#10 +
      'spr_podr.podr_code as ' + ResponsibleDepartmentCodeFieldName + ', ' + #13#10 + 
      'spr_podr.podr_short_name as ' + ResponsibleDepartmentNameFieldName + ',' + #13#10 + 
      'doc_rec.id as ' + ChargeIdFieldName + ',' + #13#10 + 
      'doc_rec.charge as ' + ChargeChargeTextFieldName + ',' + #13#10 +
      'doc_rec.comment as ' + ChargeResponseFieldName + ',' + #13#10 + 
      'doc_rec.charge_period_start as ' + ChargeTimeFrameStartFieldName + ',' + #13#10 + 
      'doc_rec.charge_period_end as ' + ChargeTimeFrameDeadlineFieldName + ',' + #13#10 + 
      'doc_rec.performing_date as ' + ChargePerformingDateTimeFieldName + ',' + #13#10 +
      'doc_rec.is_for_acquaitance as ' + ChargeIsForAcquaitanceFieldName + ',' +
      'performers.id ' + ChargePerformerIdFieldName + ',' + #13#10 +
      'performers.is_foreign as ' + ChargePerformerIsForeignFieldName + ',' + #13#10 + 
      '(performers.surname || '' '' || performers.name || '' '' || performers.patronymic) as ' + ChargePerformerNameFieldName + ',' + #13#10 + 
      'performers.speciality as ' + ChargePerformerSpecialityFieldName + ',' + #13#10 + 
      'perf_deps.id as ' + ChargePerformerDepartmentIdFieldName + ',' + #13#10 + 
      'perf_deps.code as ' + ChargePerformerDepartmentCodeFieldName + ',' + #13#10 + 
      'perf_deps.short_name as ' + ChargePerformerDepartmentNameFieldName + ',' + #13#10 + 
      'fact_perf.id as ' + ChargeActualPerformerIdFieldName + ',' + #13#10 +
      '(fact_perf.surname || '' '' || fact_perf.name || '' '' || fact_perf.patronymic) as ' + ChargeActualPerformerNameFieldName + ',' + #13#10 +
      'fact_perf.speciality as ' + ChargeActualPerformerSpecialityFieldName + ',' + #13#10 +
      'fact_perf_dep.id as ' + ChargeActualPerformerDepartmentIdFieldName + ',' + #13#10 + 
      'fact_perf_dep.code as ' + ChargeActualPerformerDepartmentCodeFieldName + ',' + #13#10 +
      'fact_perf_dep.short_name as ' + ChargeActualPerformerDepartmentNameFieldName + ',' + #13#10 +
      '' + #13#10 + 
      'case when doc_rec.issuer_id is not null then' + #13#10 +
        'doc_rec.id' + #13#10 +
        'else null' + #13#10 +
      'end as ' + ChargeSheetIdFieldName + ',' + #13#10 +

      'case when doc_rec.issuer_id is not null then' + #13#10 + 
        'doc_rec.id' + #13#10 +
        'else null' + #13#10 +
      'end as ' + ChargeSheetChargeIdFieldName + ',' + #13#10 +

      'case when doc_rec.issuer_id is not null then' + #13#10 +
        'doc_rec.document_id ' +
        'else null' + #13#10 +
      'end as ' + ChargeSheetDocumentIdFieldName + ',' + #13#10 +


      'case when doc_rec.issuer_id is not null then dct.id else null end as ' + ChargeSheetsInfoFieldNames.KindIdFieldName + ',' +
      'case when doc_rec.issuer_id is not null then dct.name else null end as ' + ChargeSheetsInfoFieldNames.KindNameFieldName + ',' +
      'case when doc_rec.issuer_id is not null then dct.service_name else null end as ' + ChargeSheetsInfoFieldNames.ServiceKindNameFieldName + ',' +

      'case when doc_rec.issuer_id is not null then' + #13#10 +
        'doc_rec.top_level_charge_sheet_id' + #13#10 + 
        'else null' + #13#10 +
      'end as ' + TopLevelChargeSheetIdFieldName + ',' + #13#10 +
      'case when doc_rec.issuer_id is not null then' + #13#10 + 
        'doc_rec.charge' + #13#10 + 
        'else null' + #13#10 +
      'end as ' + ChargeSheetChargeTextFieldName + ',' + #13#10 + 
      'case when doc_rec.issuer_id is not null then' + #13#10 + 
        'doc_rec.comment' + #13#10 + 
        'else null' + #13#10 + 
      'end as ' + ChargeSheetResponseFieldName + ',' + #13#10 +
      'case when doc_rec.issuer_id is not null then' + #13#10 + 
        'doc_rec.charge_period_start' + #13#10 +
        'else null' + #13#10 + 
      'end as ' + ChargeSheetTimeFrameStartFieldName + ',' + #13#10 + 
      'case when doc_rec.issuer_id is not null then' + #13#10 + 
        'doc_rec.charge_period_end' + #13#10 + 
        'else null' + #13#10 + 
      'end as ' + ChargeSheetTimeFrameDeadlineFieldName + ',' + #13#10 +
      'case when doc_rec.issuer_id is not null then' + #13#10 + 
        'doc_rec.performing_date' + #13#10 + 
        'else null' + #13#10 +
      'end as ' + ChargeSheetPerformingDateTimeFieldName + ',' + #13#10 +
      'case when doc_rec.issuer_id is not null then ' +
      'doc_rec.issuing_datetime ' +
      'else null ' +
      'end as ' + ChargeSheetIssuingDateTimeFieldName + ',' +
      'case when doc_rec.issuer_id is not null then' + #13#10 + 
        'doc_rec.is_for_acquaitance' + #13#10 +
        'else null' + #13#10 + 
      'end as ' + ChargeSheetIsForAcquaitanceFieldName + ',' + #13#10 +
      'case when doc_rec.issuer_id is not null then' + #13#10 +
        'performers.id' + #13#10 + 
        'else null' + #13#10 + 
      'end as ' + ChargeSheetPerformerIdFieldName + ',' + #13#10 +
      'case when doc_rec.issuer_id is not null then' + #13#10 +
        'performers.is_foreign ' + #13#10 +
        'else null' + #13#10 +
      'end as ' + ChargeSheetPerformerIsForeignFieldName + ',' + #13#10 +
      'case when doc_rec.issuer_id is not null then' + #13#10 +
        '(performers.surname || '' '' || performers.name || '' '' || performers.patronymic)' + #13#10 +
        'else null' + #13#10 + 
      'end as ' + ChargeSheetPerformerNameFieldName + ',' + #13#10 +
      'case when doc_rec.issuer_id is not null then' + #13#10 + 
        'performers.speciality' + #13#10 +
        'else null' + #13#10 + 
      'end as ' + ChargeSheetPerformerSpecialityFieldName + ',' + #13#10 + 
      'case when doc_rec.issuer_id is not null then' + #13#10 + 
        'perf_deps.id ' + #13#10 + 
        'else null' + #13#10 + 
      'end as ' + ChargeSheetPerformerDepartmentIdFieldName + ',' + #13#10 +
      'case when doc_rec.issuer_id is not null then' + #13#10 + 
        'perf_deps.code ' + #13#10 + 
        'else null' + #13#10 + 
      'end as ' + ChargeSheetPerformerDepartmentCodeFieldName + ',' + #13#10 +
      'case when doc_rec.issuer_id is not null then' + #13#10 + 
        'perf_deps.short_name' + #13#10 + 
        'else null' + #13#10 + 
      'end as ' + ChargeSheetPerformerDepartmentNameFieldName + ',' + #13#10 +
      '' + #13#10 + 
      'case when doc_rec.issuer_id is not null then' + #13#10 + 
        'fact_perf.id' + #13#10 + 
        'else null' + #13#10 + 
      'end as ' + ChargeSheetActualPerformerIdFieldName + ',' + #13#10 +
      'case when doc_rec.issuer_id is not null then' + #13#10 + 
        '(fact_perf.surname || '' '' || fact_perf.name || '' '' || fact_perf.patronymic)' + #13#10 +
        'else null' + #13#10 + 
      'end as ' + ChargeSheetActualPerformerNameFieldName + ',' + #13#10 + 
      'case when doc_rec.issuer_id is not null then' + #13#10 + 
        'fact_perf.speciality' + #13#10 + 
        'else null' + #13#10 + 
      'end as ' + ChargeSheetActualPerformerSpecialityFieldName + ',' + #13#10 + 
      'case when doc_rec.issuer_id is not null then' + #13#10 + 
        'fact_perf_dep.id' + #13#10 + 
        'else null' + #13#10 + 
      'end as ' + ChargeSheetActualPerformerDepartmentIdFieldName + ',' + #13#10 +
      'case when doc_rec.issuer_id is not null then' + #13#10 +
        'fact_perf_dep.code' + #13#10 + 
        'else null' + #13#10 + 
      'end as ' + ChargeSheetActualPerformerDepartmentCodeFieldName + ',' + #13#10 +
      'case when doc_rec.issuer_id is not null then' + #13#10 + 
        'fact_perf_dep.short_name' + #13#10 + 
        'else null' + #13#10 + 
      'end as ' + ChargeSheetActualPerformerDepartmentNameFieldName + ',' +

      'replacings.is_cur_emp_issuer or replacings.is_cur_emp_performer as can_charge_sheet_view,' +
      'replacings.is_cur_emp_issuer as has_charge_section_access,' +
      'replacings.is_cur_emp_performer as has_response_section_access,' +
      'replacings.is_cur_emp_issuer as can_charge_sheet_remove,' +
      'replacings.is_cur_emp_performer as can_charge_sheet_perform,' + 

      'case when doc_rec.issuer_id is not null then' + #13#10 +
          '(select ' + #13#10 +
          'min(look_date) ' +  
          'from ' + GetLookedDocumentsTableDef.TableName + ' lsn' + #13#10 +
          'where' + #13#10 + 
          'lsn.document_id=doc_rec.document_id and' + #13#10 + 
          '((lsn.looked_employee_id=doc_rec.performer_id) or' + #13#10 + 
          '(doc.is_employee_acting_for_other_or_vice_versa(lsn.looked_employee_id,doc_rec.performer_id))))' + #13#10 +
        'else null' + #13#10 +
      'end as ' + ChargeSheetViewDateByPerformerFieldName + ',' +
      'fact_charge_sheet_sender.id as ' + ChargeSheetIssuerIdFieldName + ',' + #13#10 +
      'fact_charge_sheet_sender.is_foreign as ' + ChargeSheetIssuerIsForeignFieldName + ',' + #13#10 +
      '(fact_charge_sheet_sender.surname || '' '' || fact_charge_sheet_sender.name || '' '' || fact_charge_sheet_sender.patronymic) as ' + ChargeSheetIssuerNameFieldName + ',' + #13#10 +
      'fact_charge_sheet_sender.speciality as ' + ChargeSheetIssuerSpecialityFieldName + ',' + #13#10 + 
      'fact_charge_sheet_sender_dep.id as ' + ChargeSheetIssuerDepartmentIdFieldName + ',' + #13#10 +
      'fact_charge_sheet_sender_dep.code as ' + ChargeSheetIssuerDepartmentCodeFieldName + ',' + #13#10 + 
      'fact_charge_sheet_sender_dep.short_name as ' + ChargeSheetIssuerDepartmentNameFieldName + ', ' + #13#10 +
      'doc_signings.id as ' + SigningIdFieldName + ',' + #13#10 +
      'doc_signings.signing_date as ' + SigningDateFieldName + ',' + #13#10 +
      GetDocumentSignerInfoFieldNameListExpression(DocumentFullInfoDataSetFieldNames) + ',' +
      'fact_signer.id as ' + ActualSignerIdFieldName + ',' + #13#10 + 
      'fact_signer.leader_id as ' + ActualSignerLeaderIdFieldName + ',' + #13#10 +
      '(fact_signer.surname || '' '' || fact_signer.name || '' '' || fact_signer.patronymic) as ' + ActualSignerNameFieldName + ',' + #13#10 +
      'fact_signer.speciality as ' + ActualSignerSpecialityFieldName + ',' + #13#10 +
      'fact_signer_dep.id as ' + ActualSignerDepartmentIdFieldName + ', ' + #13#10 +
      'fact_signer_dep.code as ' + ActualSignerDepartmentCodeFieldName + ',' + #13#10 +
      'fact_signer_dep.short_name as ' + ActualSignerDepartmentNameFieldName + ',' + #13#10 + 
      'doc_fm.id as ' + FileIdFieldName + ',' + #13#10 +
      'doc_fm.file_name as ' + FileNameFieldName + ',' + #13#10 +
      'doc_fm.file_path as ' + FilePathFieldName + ',' + #13#10 + 
      'doc_links.id as ' + RelationIdFieldName + ',' + #13#10 +
      'coalesce(rel_docs.id, rel_servs.id, rel_po.id) as ' + RelatedDocumentIdFieldName + ',' +
      'coalesce(rel_docs.type_id, rel_servs.type_id, rel_po.type_id) as ' + RelatedDocumentKindIdFieldName + ',' +
      'coalesce(rel_doc_type.single_full_name, rel_serv_type.single_full_name, rel_po_type.single_full_name) as ' + RelatedDocumentKindNameFieldName + ',' +
      'coalesce(rel_docs.document_number, rel_servs.document_number, rel_po.document_number) as ' + RelatedDocumentNumberFieldName + ',' +
      'coalesce(rel_docs.name, rel_servs.name, rel_po.name) as ' + RelatedDocumentNameFieldName + ',' +
      'coalesce(rel_docs.document_date, rel_servs.document_date, rel_po.document_date) as ' + RelatedDocumentDateFieldName + ',' +
      'da.id as ' + ApprovingIdFieldName + ',' + #13#10 +
      'da.performing_date as ' + ApprovingPerformingDateTimeFieldName + ',' + #13#10 +
      'da.performing_result_id as ' + ApprovingPerformingResultIdFieldName + ',' + #13#10 +
      '(approver.id = cur_emp.id or ' +
      'doc.is_employee_acting_for_other_or_vice_versa(cur_emp.id, approver.id)) as ' + ApprovingIsAccessibleFieldName + ', ' +
      'dar.result_name as ' + ApprovingPerformingResultFieldName + ',' + #13#10 + 
      'da.note as ' + ApprovingNoteFieldName + ',' + #13#10 +
      'da.cycle_number as ' + ApprovingCycleNumberFieldName + ',' + #13#10 +
      'da.cycle_number as ' + ApprovingCycleIdFieldName + ',' +
      'case when da.id is not null then da.cycle_number is not null else null end as ' + ApprovingIsCompletedFieldName + ',' +
      'exists (' + #13#10 +
          'select 1' + #13#10 + 
          'from ' + GetLookedDocumentsTableDef.TableName + ' lsn' + #13#10 +
          'where' + #13#10 +
          'lsn.document_id=doc.id and' + #13#10 + 
          '((lsn.looked_employee_id=da.approver_id) or' + #13#10 + 
          '(doc.is_employee_acting_for_other_or_vice_versa(lsn.looked_employee_id,da.approver_id)))' + #13#10 + 
        ') as ' + ApprovingIsLookedByApproverFieldName + ',' +
      'approver.id as ' + ApproverIdFieldName + ',' + #13#10 +
      'approver.leader_id as ' + ApproverLeaderIdFieldName + ',' + #13#10 +
      'approver.is_foreign as ' + ApproverIsForeignFieldName + ',' + #13#10 +
      '(approver.surname || '' '' || approver.name || '' '' || approver.patronymic) as ' + ApproverNameFieldName + ',' + #13#10 +
      'approver.speciality as ' + ApproverSpecialityFieldName + ',' + #13#10 +
      'approver_dep.id as ' + ApproverDepartmentIdFieldName + ',' + #13#10 +
      'approver_dep.code as ' + ApproverDepartmentCodeFieldName + ',' + #13#10 +
      'approver_dep.short_name as ' + ApproverDepartmentNameFieldName + ',' + #13#10 +
      'fact_approver.id as ' + ActualApproverIdFieldName + ',' + #13#10 +
      'fact_approver.leader_id as ' + ActualApproverLeaderIdFieldName + ',' + #13#10 +
      'fact_approver.is_foreign as ' + ActualApproverIsForeignFieldName + ',' + #13#10 +
      '(fact_approver.surname || '' '' || fact_approver.name || '' '' || fact_approver.patronymic) as ' + ActualApproverNameFieldName + ',' + #13#10 +
      'fact_approver.speciality as ' + ActualApproverSpecialityFieldName + ',' + #13#10 +
      'fact_approver_dep.id as ' + ActualApproverDepartmentIdFieldName + ',' + #13#10 +
      'fact_approver_dep.code as ' + ActualApproverDepartmentCodeFieldName + ',' + #13#10 +
      'fact_approver_dep.short_name as ' + ActualApproverDepartmentNameFieldName;

  end;

end;

function TPostgresDocumentInfoFetchingQueryBuilder.GetDocumentFullInfoTableExpression(
  DocumentFullInfoDataSetFieldNames: TDocumentFullInfoDataSetFieldNames;
  const DocumentIdParamName: String
): String;
begin

  with DocumentFullInfoDataSetFieldNames, FDocumentTableDefsFactory do begin
  
    Result :=
      GetDocumentTableExpression(DocumentFullInfoDataSetFieldNames, DocumentIdParamName) + #13#10 +
      GetCurrentEmployeeTableJoinExpression + #13#10 +
      GetRestTableJoinExpression(DocumentFullInfoDataSetFieldNames, DocumentIdParamName);

  end;

end;

function TPostgresDocumentInfoFetchingQueryBuilder.GetDocumentTableExpression(
  DocumentFullInfoDataSetFieldNames: TDocumentFullInfoDataSetFieldNames;
  const DocumentIdParamName: String): String;
begin

  with FDocumentTableDefsFactory do begin

    Result := GetDocumentTableDef.TableName + ' doc';

  end;

end;

function TPostgresDocumentInfoFetchingQueryBuilder.GetRestTableJoinExpression(
  DocumentFullInfoDataSetFieldNames: TDocumentFullInfoDataSetFieldNames;
  const DocumentIdParamName: String): String;
begin

  with FDocumentTableDefsFactory do begin
  
    Result :=
      'join doc.document_types dt on dt.id = doc.type_id' + #13#10 +
      'join doc.document_type_work_cycle_stages dtwcs on dtwcs.id = doc.current_work_cycle_stage_id' + #13#10 +
      'join doc.employees e on e.id = doc.author_id' + #13#10 +
      'join doc.departments d on d.id = e.department_id' + #13#10 +
      'join exchange.spr_person sp on sp.id = doc.performer_id' + #13#10 +
      'join nsi.spr_podr spr_podr on spr_podr.id = sp.podr_id' + #13#10 +
      'left join exchange.spr_person_telephone_numbers sptn on sptn.person_id = sp.id' + #13#10 +
      'left join ' + GetDocumentChargeTableDef.TableName + ' doc_rec on doc_rec.document_id = doc.id' + #13#10 +
      'left join doc.document_charge_types dct on dct.id = doc_rec.kind_id ' +
      'left join doc.employees performers on performers.id = doc_rec.performer_id' + #13#10 +
      'left join doc.departments perf_deps on perf_deps.id = performers.department_id' + #13#10 +
      'left join doc.employees fact_perf on fact_perf.id = doc_rec.actual_performer_id' + #13#10 +
      'left join doc.departments fact_perf_dep on fact_perf_dep.id = fact_perf.department_id' + #13#10 +
      'left join doc.employees fact_charge_sheet_sender on fact_charge_sheet_sender.id = doc_rec.issuer_id' + #13#10 +
      'left join doc.departments fact_charge_sheet_sender_dep on fact_charge_sheet_sender_dep.id = fact_charge_sheet_sender.department_id' + #13#10 +
      'left join ' + GetDocumentSigningTableDef.TableName + ' doc_signings on doc_signings.document_id = doc.id' + #13#10 +
      'left join doc.employees signer on signer.id = doc_signings.signer_id' + #13#10 +
      'left join doc.departments signer_dep on signer_dep.id = signer.department_id' + #13#10 +
      'left join doc.employees fact_signer on fact_signer.id = doc_signings.actual_signed_id' + #13#10 +
      'left join doc.departments fact_signer_dep on fact_signer_dep.id = fact_signer.department_id' + #13#10 +
      'left join ' + GetDocumentApprovingsTableDef.TableName + ' da on da.document_id = doc.id' + #13#10 +
      'left join doc.document_approving_results dar on dar.id = da.performing_result_id' + #13#10 +
      'left join doc.employees approver on approver.id = da.approver_id' + #13#10 +
      'left join doc.departments approver_dep on approver_dep.id = approver.department_id' + #13#10 +
      'left join doc.employees fact_approver on fact_approver.id = da.actual_performed_employee_id' + #13#10 +
      'left join doc.departments fact_approver_dep on fact_approver_dep.id = fact_approver.department_id ' +
      'left join ' + GetDocumentRelationsTableDef.TableName + ' doc_links on doc_links.document_id = doc.id' + #13#10 +

      {
        refactor(DocumentPerformingInfoQueryBuilder, 1):
        remove domain-specific check-functions, use corresponding app service
        in the UI to the getting a particular charge sheet's access rights
      }
      'join lateral (' +
      'select ' +
      'doc.is_employee_acting_for_other_or_vice_versa(cur_emp.id, doc_rec.issuer_id) as is_cur_emp_issuer,' +
      'doc.is_employee_acting_for_other_or_vice_versa(cur_emp.id, doc_rec.performer_id) as is_cur_emp_performer' +
      ') as replacings on true ' +
      'left join lateral' + #13#10 +
      '(' + #13#10 +
      'select' + #13#10 +
      'doc_links.related_document_id as id,' + #13#10 +
      'doc_links.related_document_type_id as type_id,' + #13#10 +
      'rel_servs.document_number,' + #13#10 +
      'rel_servs.name,' + #13#10 +
      'rel_servs.document_date' + #13#10 +
      'from doc.service_notes rel_servs' + #13#10 +
      'where rel_servs.id = doc_links.related_document_id and rel_servs.type_id = doc_links.related_document_type_id' + #13#10 +
      'or exists (' + #13#10 +
        'select 1 from doc.service_note_receivers a' + #13#10 +
        'where a.document_id = rel_servs.id and a.id = doc_links.related_document_id and a.incoming_document_type_id = doc_links.related_document_type_id' + #13#10 +
      ')' + #13#10 +
      ') rel_servs on rel_servs.id = doc_links.related_document_id' + #13#10 +
      'left join lateral' + #13#10 +
      '(' + #13#10 + 
      'select' + #13#10 +
      'doc_links.related_document_id as id,' + #13#10 + 
      'doc_links.related_document_type_id as type_id,' + #13#10 +
      'rel_docs.document_number,' + #13#10 +
      'rel_docs.name,' + #13#10 +
      'rel_docs.document_date' + #13#10 +
      'from doc.documents rel_docs' + #13#10 +
      'where rel_docs.id = doc_links.related_document_id and rel_docs.type_id = doc_links.related_document_type_id' + #13#10 +
      'or exists(' + #13#10 +
        'select 1 from doc.document_receivers a' + #13#10 +
        'where a.document_id = rel_docs.id and a.id = doc_links.related_document_id and a.incoming_document_type_id = doc_links.related_document_type_id' + #13#10 +
      ')' + #13#10 +
      ') rel_docs on rel_docs.id = doc_links.related_document_id' + #13#10 +
      'left join lateral (' +
      'select ' +
      'doc_links.related_document_id as id,' +
      'doc_links.related_document_type_id as type_id,' +
      'rel_po.document_number,' +
      'rel_po.name,' +
      'rel_po.document_date ' +
      'from doc.personnel_orders rel_po ' +
      'where rel_po.id = doc_links.related_document_id and rel_po.type_id = doc_links.related_document_type_id' +
      ') rel_po on rel_po.id = doc_links.related_document_id ' +
      'left join doc.document_types rel_doc_type on rel_doc_type.id = rel_docs.type_id' + #13#10 +
      'left join doc.document_types rel_serv_type on rel_serv_type.id = rel_servs.type_id' + #13#10 +
      'left join doc.document_types rel_po_type on rel_po_type.id = rel_po.type_id ' +
      'left join ' + GetDocumentFilesTableDef.TableName + ' doc_fm on doc_fm.document_id = doc.id';

  end;

end;

function TPostgresDocumentInfoFetchingQueryBuilder.GetCurrentEmployeeTableJoinExpression: String;
begin

  Result := 'join doc.get_current_employee_id() cur_emp(id) on true';

end;

function TPostgresDocumentInfoFetchingQueryBuilder.
  GetDocumentFullInfoWhereExpression(
    DocumentFullInfoDataSetFieldNames: TDocumentFullInfoDataSetFieldNames;
    const DocumentIdParamName: String
  ): String;
begin

  Result := 'doc.id=:' + DocumentIdParamName;

end;

function TPostgresDocumentInfoFetchingQueryBuilder.GetDocumentSignerInfoFieldNameListExpression(
  DocumentFullInfoDataSetFieldNames: TDocumentFullInfoDataSetFieldNames
): String;
begin

  with DocumentFullInfoDataSetFieldNames do begin

    Result :=
      'signer.id as ' + SignerIdFieldName + ',' + #13#10 +
      'signer.leader_id as ' + SignerLeaderIdFieldName + ',' + #13#10 +
      '(signer.surname || '' '' || signer.name || '' '' || signer.patronymic) as ' + SignerNameFieldName + ',' + #13#10 +
      'signer.speciality as ' + SignerSpecialityFieldName + ',' + #13#10 +
      'signer_dep.id as ' + SignerDepartmentIdFieldName + ',' + #13#10 +
      'signer_dep.code as ' + SignerDepartmentCodeFieldName + ',' + #13#10 +
      'signer_dep.short_name as ' + SignerDepartmentNameFieldName;

  end;

end;

end.
