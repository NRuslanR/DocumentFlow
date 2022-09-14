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
      'doc.id as ' + DocumentIdFieldName + ',' + #13#10 +
      'doc.id as ' + BaseDocumentIdFieldName + ',' +
      'doc.type_id as ' + DocumentKindIdFieldName + ',' + #13#10 +
      'doc.document_number as ' + DocumentNumberFieldName + ',' + #13#10 +
      'doc.name as ' + DocumentNameFieldName + ',' + #13#10 +
      'doc.content as ' + DocumentContentFieldName + ',' + #13#10 + 
      'doc.note as ' + DocumentNoteFieldName + ',' + #13#10 +
      IfThen(DocumentIsSelfRegisteredFieldName <> '', 'doc.is_self_registered,', '') + #13#10 +
      'doc.product_code as ' + DocumentProductCodeFieldName + ',' + #13#10 +
      'doc.creation_date as ' + DocumentCreationDateFieldName + ',' + #13#10 +
      'doc.document_date as ' + DocumentDateFieldName + ',' + #13#10 +
      'dt.short_full_name as ' + DocumentKindFieldName + ',' + #13#10 +
      'dtwcs.stage_name as ' + DocumentCurrentWorkCycleStageNameFieldName + ',' + #13#10 +
      'dtwcs.stage_number as ' + DocumentCurrentWorkCycleStageNumberFieldName + ',' + #13#10 +
      'e.id as ' + DocumentAuthorIdFieldName + ',' + #13#10 + 
      'e.leader_id as ' + DocumentAuthorLeaderIdFieldName + ',' + #13#10 +
      '(e.surname || '' '' || e.name || '' '' || e.patronymic) as ' + DocumentAuthorNameFieldName + ',' + #13#10 + 
      'e.speciality as ' + DocumentAuthorSpecialityFieldName + ',' + #13#10 + 
      'd.id as ' + DocumentAuthorDepartmentIdFieldName + ',' + #13#10 + 
      'd.code as ' + DocumentAuthorDepartmentCodeFieldName + ',' + #13#10 +
      'd.short_name as ' + DocumentAuthorDepartmentNameFieldName + ',' + #13#10 + 
      'sp.id as ' + DocumentResponsibleIdFieldName + ',' + #13#10 + 
      '(upper(substring(sp.family, 1, 1)) || lower(substring(sp.family, 2, length(sp.family) - 1))) || '' '' ||' +
      '(upper(substring(sp.name, 1, 1)) || lower(substring(sp.name, 2, length(sp.name) - 1))) || '' '' ||' +
      '(upper(substring(sp.patronymic, 1, 1)) || lower(substring(sp.patronymic, 2, length(sp.patronymic) - 1))) ' +
      ' as ' + DocumentResponsibleNameFieldName + ',' + #13#10 +
      'sptn.telephone_number as ' + DocumentResponsibleTelephoneNumberFieldName + ',' + #13#10 + 
      'spr_podr.id as ' + DocumentResponsibleDepartmentIdFieldName + ',' + #13#10 +
      'dct.id as ' + DocumentChargesInfoFieldNames.DocumentChargeKindIdFieldName + ',' + #13#10 +
      'dct.name as ' + DocumentChargesInfoFieldNames.DocumentChargeKindNameFieldName + ',' + #13#10 +
      'dct.service_name as ' + DocumentChargesInfoFieldNames.DocumentChargeServiceKindNameFieldName + ',' + #13#10 +
      'spr_podr.podr_code as ' + DocumentResponsibleDepartmentCodeFieldName + ', ' + #13#10 + 
      'spr_podr.podr_short_name as ' + DocumentResponsibleDepartmentNameFieldName + ',' + #13#10 + 
      'doc_rec.id as ' + DocumentChargeIdFieldName + ',' + #13#10 + 
      'doc_rec.charge as ' + DocumentChargeTextFieldName + ',' + #13#10 + 
      'doc_rec.comment as ' + DocumentChargeResponseFieldName + ',' + #13#10 + 
      'doc_rec.charge_period_start as ' + DocumentChargePeriodStartFieldName + ',' + #13#10 + 
      'doc_rec.charge_period_end as ' + DocumentChargePeriodEndFieldName + ',' + #13#10 + 
      'doc_rec.performing_date as ' + DocumentChargePerformingDateTimeFieldName + ',' + #13#10 +
      'doc_rec.is_for_acquaitance as ' + DocumentChargeIsForAcquaitanceFieldName + ',' +
      'performers.id ' + DocumentChargePerformerIdFieldName + ',' + #13#10 +
      'performers.leader_id as ' + DocumentChargePerformerLeaderIdFieldName + ',' + #13#10 + 
      'performers.is_foreign as ' + DocumentChargePerformerIsForeignFieldName + ',' + #13#10 + 
      '(performers.surname || '' '' || performers.name || '' '' || performers.patronymic) as ' + DocumentChargePerformerNameFieldName + ',' + #13#10 + 
      'performers.speciality as ' + DocumentChargePerformerSpecialityFieldName + ',' + #13#10 + 
      'perf_deps.id as ' + DocumentChargePerformerDepartmentIdFieldName + ',' + #13#10 + 
      'perf_deps.code as ' + DocumentChargePerformerDepartmentCodeFieldName + ',' + #13#10 + 
      'perf_deps.short_name as ' + DocumentChargePerformerDepartmentNameFieldName + ',' + #13#10 + 
      'fact_perf.id as ' + DocumentChargeActualPerformerIdFieldName + ',' + #13#10 + 
      'fact_perf.leader_id as ' + DocumentChargeActualPerformerLeaderIdFieldName + ',' + #13#10 + 
      'fact_perf.is_foreign as ' + DocumentChargeActualPerformerIsForeignFieldName + ',' + #13#10 +
      '(fact_perf.surname || '' '' || fact_perf.name || '' '' || fact_perf.patronymic) as ' + DocumentChargeActualPerformerNameFieldName + ',' + #13#10 +
      'fact_perf.speciality as ' + DocumentChargeActualPerformerSpecialityFieldName + ',' + #13#10 +
      'fact_perf_dep.id as ' + DocumentChargeActualPerformerDepartmentIdFieldName + ',' + #13#10 + 
      'fact_perf_dep.code as ' + DocumentChargeActualPerformerDepartmentCodeFieldName + ',' + #13#10 +
      'fact_perf_dep.short_name as ' + DocumentChargeActualPerformerDepartmentNameFieldName + ',' + #13#10 + 
      '' + #13#10 + 
      'case when doc_rec.issuer_id is not null then' + #13#10 + 
        'doc_rec.id' + #13#10 + 
        'else null' + #13#10 + 
      'end as ' + DocumentChargeSheetIdFieldName + ',' + #13#10 +
      'case when doc_rec.issuer_id is not null then' + #13#10 + 
        'doc_rec.document_id ' +
        'else null' + #13#10 +
      'end as ' + ChargeSheetDocumentIdFieldName + ',' + #13#10 +

      'case when doc_rec.issuer_id is not null then dct.id else null end as ' + DocumentChargeSheetsInfoFieldNames.DocumentChargeSheetKindIdFieldName + ',' +
      'case when doc_rec.issuer_id is not null then dct.name else null end as ' + DocumentChargeSheetsInfoFieldNames.DocumentChargeSheetKindNameFieldName + ',' +
      'case when doc_rec.issuer_id is not null then dct.service_name else null end as ' + DocumentChargeSheetsInfoFieldNames.DocumentChargeSheetServiceKindNameFieldName + ',' +

      'case when doc_rec.issuer_id is not null then' + #13#10 +
        'doc_rec.top_level_charge_sheet_id' + #13#10 + 
        'else null' + #13#10 +
      'end as ' + TopLevelDocumentChargeSheetIdFieldName + ',' + #13#10 +
      'case when doc_rec.issuer_id is not null then' + #13#10 + 
        'doc_rec.charge' + #13#10 + 
        'else null' + #13#10 + 
      'end as ' + DocumentChargeSheetTextFieldName + ',' + #13#10 + 
      'case when doc_rec.issuer_id is not null then' + #13#10 + 
        'doc_rec.comment' + #13#10 + 
        'else null' + #13#10 + 
      'end as ' + DocumentChargeSheetResponseFieldName + ',' + #13#10 +
      'case when doc_rec.issuer_id is not null then' + #13#10 + 
        'doc_rec.charge_period_start' + #13#10 +
        'else null' + #13#10 + 
      'end as ' + DocumentChargeSheetPeriodStartFieldName + ',' + #13#10 + 
      'case when doc_rec.issuer_id is not null then' + #13#10 + 
        'doc_rec.charge_period_end' + #13#10 + 
        'else null' + #13#10 + 
      'end as ' + DocumentChargeSheetPeriodEndFieldName + ',' + #13#10 + 
      'case when doc_rec.issuer_id is not null then' + #13#10 + 
        'doc_rec.performing_date' + #13#10 + 
        'else null' + #13#10 +
      'end as ' + DocumentChargeSheetPerformingDateTimeFieldName + ',' + #13#10 +
      'case when doc_rec.issuer_id is not null then ' +
      'doc_rec.issuing_datetime ' +
      'else null ' +
      'end as ' + DocumentChargeSheetIssuingDateTimeFieldName + ',' +
      'case when doc_rec.issuer_id is not null then' + #13#10 + 
        'doc_rec.is_for_acquaitance' + #13#10 +
        'else null' + #13#10 + 
      'end as ' + DocumentChargeSheetIsForAcquaitanceFieldName + ',' + #13#10 +
      'case when doc_rec.issuer_id is not null then' + #13#10 + 
        '(select role_id from doc.employees_roles where employee_id = performers.id)' + #13#10 + 
        'else null' + #13#10 + 
      'end as ' + DocumentChargeSheetPerformerRoleIdFieldName + ',' +
      'case when doc_rec.issuer_id is not null then' + #13#10 + 
        'performers.id' + #13#10 + 
        'else null' + #13#10 + 
      'end as ' + DocumentChargeSheetPerformerIdFieldName + ',' + #13#10 + 
      'case when doc_rec.issuer_id is not null then' + #13#10 + 
        'performers.leader_id ' + #13#10 + 
        'else null' + #13#10 + 
      'end as ' + DocumentChargeSheetPerformerLeaderIdFieldName + ',' + #13#10 + 
      'case when doc_rec.issuer_id is not null then' + #13#10 + 
        'performers.is_foreign ' + #13#10 + 
        'else null' + #13#10 + 
      'end as ' + DocumentChargeSheetPerformerIsForeignFieldName + ',' + #13#10 + 
      'case when doc_rec.issuer_id is not null then' + #13#10 + 
        '(performers.surname || '' '' || performers.name || '' '' || performers.patronymic)' + #13#10 +
        'else null' + #13#10 + 
      'end as ' + DocumentChargeSheetPerformerNameFieldName + ',' + #13#10 +
      'case when doc_rec.issuer_id is not null then' + #13#10 + 
        'performers.speciality' + #13#10 +
        'else null' + #13#10 + 
      'end as ' + DocumentChargeSheetPerformerSpecialityFieldName + ',' + #13#10 + 
      'case when doc_rec.issuer_id is not null then' + #13#10 + 
        'perf_deps.id ' + #13#10 + 
        'else null' + #13#10 + 
      'end as ' + DocumentChargeSheetPerformerDepartmentIdFieldName + ',' + #13#10 +
      'case when doc_rec.issuer_id is not null then' + #13#10 + 
        'perf_deps.code ' + #13#10 + 
        'else null' + #13#10 + 
      'end as ' + DocumentChargeSheetPerformerDepartmentCodeFieldName + ',' + #13#10 +
      'case when doc_rec.issuer_id is not null then' + #13#10 + 
        'perf_deps.short_name' + #13#10 + 
        'else null' + #13#10 + 
      'end as ' + DocumentChargeSheetPerformerDepartmentNameFieldName + ',' + #13#10 +
      '' + #13#10 + 
      'case when doc_rec.issuer_id is not null then' + #13#10 + 
        'fact_perf.id' + #13#10 + 
        'else null' + #13#10 + 
      'end as ' + DocumentChargeSheetActualPerformerIdFieldName + ',' + #13#10 +
      'case when doc_rec.issuer_id is not null then' + #13#10 + 
        'fact_perf.leader_id' + #13#10 + 
        'else null' + #13#10 + 
      'end as ' + DocumentChargeSheetActualPerformerLeaderIdFieldName + ',' + #13#10 +
      'case when doc_rec.issuer_id is not null then' + #13#10 + 
        'fact_perf.is_foreign ' + #13#10 + 
        'else null' + #13#10 +
      'end as ' + DocumentChargeSheetActualPerformerIsForeignFieldName + ',' + #13#10 +
      'case when doc_rec.issuer_id is not null then' + #13#10 + 
        '(fact_perf.surname || '' '' || fact_perf.name || '' '' || fact_perf.patronymic)' + #13#10 +
        'else null' + #13#10 + 
      'end as ' + DocumentChargeSheetActualPerformerNameFieldName + ',' + #13#10 + 
      'case when doc_rec.issuer_id is not null then' + #13#10 + 
        'fact_perf.speciality' + #13#10 + 
        'else null' + #13#10 + 
      'end as ' + DocumentChargeSheetActualPerformerSpecialityFieldName + ',' + #13#10 + 
      'case when doc_rec.issuer_id is not null then' + #13#10 + 
        'fact_perf_dep.id' + #13#10 + 
        'else null' + #13#10 + 
      'end as ' + DocumentChargeSheetActualPerformerDepartmentIdFieldName + ',' + #13#10 +
      'case when doc_rec.issuer_id is not null then' + #13#10 +
        'fact_perf_dep.code' + #13#10 + 
        'else null' + #13#10 + 
      'end as ' + DocumentChargeSheetActualPerformerDepartmentCodeFieldName + ',' + #13#10 +
      'case when doc_rec.issuer_id is not null then' + #13#10 + 
        'fact_perf_dep.short_name' + #13#10 + 
        'else null' + #13#10 + 
      'end as ' + DocumentChargeSheetActualPerformerDepartmentNameFieldName + ',' +

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
      'end as ' + DocumentChargeSheetViewingDateByPerformerFieldName + ',' +
      'fact_charge_sheet_sender.id as ' + DocumentChargeSheetSenderIdFieldName + ',' + #13#10 +
      'fact_charge_sheet_sender.leader_id as ' + DocumentChargeSheetSenderLeaderIdFieldName + ',' + #13#10 +
      'fact_charge_sheet_sender.is_foreign as ' + DocumentChargeSheetSenderIsForeignFieldName + ',' + #13#10 +
      '(fact_charge_sheet_sender.surname || '' '' || fact_charge_sheet_sender.name || '' '' || fact_charge_sheet_sender.patronymic) as ' + DocumentChargeSheetSenderNameFieldName + ',' + #13#10 +
      'fact_charge_sheet_sender.speciality as ' + DocumentChargeSheetSenderSpecialityFieldName + ',' + #13#10 + 
      'fact_charge_sheet_sender_dep.id as ' + DocumentChargeSheetSenderDepartmentIdFieldName + ',' + #13#10 +
      'fact_charge_sheet_sender_dep.code as ' + DocumentChargeSheetSenderDepartmentCodeFieldName + ',' + #13#10 + 
      'fact_charge_sheet_sender_dep.short_name as ' + DocumentChargeSheetSenderDepartmentNameFieldName + ', ' + #13#10 +
      'doc_signings.id as ' + DocumentSigningIdFieldName + ',' + #13#10 +
      'doc_signings.signing_date as ' + DocumentSigningDateFieldName + ',' + #13#10 +
      GetDocumentSignerInfoFieldNameListExpression(DocumentFullInfoDataSetFieldNames) + ',' +
      'fact_signer.id as ' + DocumentActualSignerIdFieldName + ',' + #13#10 + 
      'fact_signer.leader_id as ' + DocumentActualSignerLeaderIdFieldName + ',' + #13#10 +
      '(fact_signer.surname || '' '' || fact_signer.name || '' '' || fact_signer.patronymic) as ' + DocumentActualSignerNameFieldName + ',' + #13#10 +
      'fact_signer.speciality as ' + DocumentActualSignerSpecialityFieldName + ',' + #13#10 +
      'fact_signer_dep.id as ' + DocumentActualSignerDepartmentIdFieldName + ', ' + #13#10 +
      'fact_signer_dep.code as ' + DocumentActualSignerDepartmentCodeFieldName + ',' + #13#10 +
      'fact_signer_dep.short_name as ' + DocumentActualSignerDepartmentNameFieldName + ',' + #13#10 + 
      'doc_fm.id as ' + DocumentFileIdFieldName + ',' + #13#10 +
      'doc_fm.file_name as ' + DocumentFileNameFieldName + ',' + #13#10 +
      'doc_fm.file_path as ' + DocumentFilePathFieldName + ',' + #13#10 + 
      'doc_links.id as ' + DocumentRelationIdFieldName + ',' + #13#10 +
      'coalesce(rel_docs.id, rel_servs.id, rel_po.id) as ' + RelatedDocumentIdFieldName + ',' +
      'coalesce(rel_docs.type_id, rel_servs.type_id, rel_po.type_id) as ' + RelatedDocumentKindIdFieldName + ',' +
      'coalesce(rel_doc_type.single_full_name, rel_serv_type.single_full_name, rel_po_type.single_full_name) as ' + RelatedDocumentKindNameFieldName + ',' +
      'coalesce(rel_docs.document_number, rel_servs.document_number, rel_po.document_number) as ' + RelatedDocumentNumberFieldName + ',' +
      'coalesce(rel_docs.name, rel_servs.name, rel_po.name) as ' + RelatedDocumentNameFieldName + ',' +
      'coalesce(rel_docs.document_date, rel_servs.document_date, rel_po.document_date) as ' + RelatedDocumentDateFieldName + ',' +
      'da.id as ' + DocumentApprovingIdFieldName + ',' + #13#10 +
      'da.performing_date as ' + DocumentApprovingPerformingDateTimeFieldName + ',' + #13#10 +
      'da.performing_result_id as ' + DocumentApprovingPerformingResultIdFieldName + ',' + #13#10 +
      '(approver.id = cur_emp.id or ' +
      'doc.is_employee_acting_for_other_or_vice_versa(cur_emp.id, approver.id)) as ' + DocumentApprovingIsAccessibleFieldName + ', ' +
      'dar.result_name as ' + DocumentApprovingPerformingResultFieldName + ',' + #13#10 + 
      'da.note as ' + DocumentApprovingNoteFieldName + ',' + #13#10 +
      'da.cycle_number as ' + DocumentApprovingCycleNumberFieldName + ',' + #13#10 +
      'da.cycle_number as ' + DocumentApprovingCycleIdFieldName + ',' +
      'case when da.id is not null then da.cycle_number is not null else null end as ' + DocumentApprovingIsCompletedFieldName + ',' +
      'exists (' + #13#10 +
          'select 1' + #13#10 + 
          'from ' + GetLookedDocumentsTableDef.TableName + ' lsn' + #13#10 +
          'where' + #13#10 +
          'lsn.document_id=doc.id and' + #13#10 + 
          '((lsn.looked_employee_id=da.approver_id) or' + #13#10 + 
          '(doc.is_employee_acting_for_other_or_vice_versa(lsn.looked_employee_id,da.approver_id)))' + #13#10 + 
        ') as ' + DocumentApprovingIsLookedByApproverFieldName + ',' +
      'approver.id as ' + DocumentApproverIdFieldName + ',' + #13#10 +
      'approver.leader_id as ' + DocumentApproverLeaderIdFieldName + ',' + #13#10 +
      'approver.is_foreign as ' + DocumentApproverIsForeignFieldName + ',' + #13#10 +
      '(approver.surname || '' '' || approver.name || '' '' || approver.patronymic) as ' + DocumentApproverNameFieldName + ',' + #13#10 +
      'approver.speciality as ' + DocumentApproverSpecialityFieldName + ',' + #13#10 +
      'approver_dep.id as ' + DocumentApproverDepartmentIdFieldName + ',' + #13#10 +
      'approver_dep.code as ' + DocumentApproverDepartmentCodeFieldName + ',' + #13#10 +
      'approver_dep.short_name as ' + DocumentApproverDepartmentNameFieldName + ',' + #13#10 +
      'fact_approver.id as ' + DocumentActualApproverIdFieldName + ',' + #13#10 +
      'fact_approver.leader_id as ' + DocumentActualApproverLeaderIdFieldName + ',' + #13#10 +
      'fact_approver.is_foreign as ' + DocumentActualApproverIsForeignFieldName + ',' + #13#10 +
      '(fact_approver.surname || '' '' || fact_approver.name || '' '' || fact_approver.patronymic) as ' + DocumentActualApproverNameFieldName + ',' + #13#10 +
      'fact_approver.speciality as ' + DocumentActualApproverSpecialityFieldName + ',' + #13#10 +
      'fact_approver_dep.id as ' + DocumentActualApproverDepartmentIdFieldName + ',' + #13#10 +
      'fact_approver_dep.code as ' + DocumentActualApproverDepartmentCodeFieldName + ',' + #13#10 +
      'fact_approver_dep.short_name as ' + DocumentActualApproverDepartmentNameFieldName;

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
      'signer.id as ' + DocumentSignerIdFieldName + ',' + #13#10 +
      'signer.leader_id as ' + DocumentSignerLeaderIdFieldName + ',' + #13#10 +
      '(signer.surname || '' '' || signer.name || '' '' || signer.patronymic) as ' + DocumentSignerNameFieldName + ',' + #13#10 +
      'signer.speciality as ' + DocumentSignerSpecialityFieldName + ',' + #13#10 +
      'signer_dep.id as ' + DocumentSignerDepartmentIdFieldName + ',' + #13#10 +
      'signer_dep.code as ' + DocumentSignerDepartmentCodeFieldName + ',' + #13#10 +
      'signer_dep.short_name as ' + DocumentSignerDepartmentNameFieldName;

  end;

end;

end.
