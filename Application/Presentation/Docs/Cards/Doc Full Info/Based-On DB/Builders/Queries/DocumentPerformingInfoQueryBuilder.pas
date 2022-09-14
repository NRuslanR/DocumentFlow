unit DocumentPerformingInfoQueryBuilder;

interface

uses

  DocumentChargeSheetsInfoHolder,
  DocumentChargeTableDef,
  DocumentChargeKindTableDef,
  DocumentChargeSheetTableDef,
  DocumentChargesInfoHolder,
  SysUtils;

type

  IDocumentPerformingInfoQueryBuilder = interface

    function BuildDocumentPerformingInfoQuery(
      DocumentChargesInfoFieldNames: TDocumentChargesInfoFieldNames;
      DocumentChargeSheetsInfoFieldNames: TDocumentChargeSheetsInfoFieldNames;
      DocumentIdParamName: String
    ): String;

  end;

  TDocumentPerformingInfoQueryBuilder =
    class (TInterfacedObject, IDocumentPerformingInfoQueryBuilder)

      protected

        FDocumentChargeKindTableDef: TDocumentChargeKindTableDef;
        FDocumentChargeTableDef: TDocumentChargeTableDef;
        FDocumentChargeSheetTableDef: TDocumentChargeSheetTableDef;

      public

        constructor Create(
          DocumentChargeKindTableDef: TDocumentChargeKindTableDef;
          DocumentChargeTableDef: TDocumentChargeTableDef;
          DocumentChargeSheetTableDef: TDocumentChargeSheetTableDef
        );
        
        function BuildDocumentPerformingInfoQuery(
          DocumentChargesInfoFieldNames: TDocumentChargesInfoFieldNames;
          DocumentChargeSheetsInfoFieldNames: TDocumentChargeSheetsInfoFieldNames;
          DocumentIdParamName: String
        ): String; virtual;

    end;

implementation

{ TDocumentPerformingInfoQueryBuilder }

constructor TDocumentPerformingInfoQueryBuilder.Create(
  DocumentChargeKindTableDef: TDocumentChargeKindTableDef;
  DocumentChargeTableDef: TDocumentChargeTableDef;
  DocumentChargeSheetTableDef: TDocumentChargeSheetTableDef);
begin

  inherited Create;

  FDocumentChargeKindTableDef := DocumentChargeKindTableDef;
  FDocumentChargeTableDef := DocumentChargeTableDef;
  FDocumentChargeSheetTableDef := DocumentChargeSheetTableDef;
  
end;

function TDocumentPerformingInfoQueryBuilder.BuildDocumentPerformingInfoQuery(
  DocumentChargesInfoFieldNames: TDocumentChargesInfoFieldNames;
  DocumentChargeSheetsInfoFieldNames: TDocumentChargeSheetsInfoFieldNames;
  DocumentIdParamName: String
): String;
begin

  with DocumentChargesInfoFieldNames, DocumentChargeSheetsInfoFieldNames
  do begin

    Result :=
      'select distinct' + #13#10 +
      'doc_rec.id as ' + DocumentChargeIdFieldName + ',' + #13#10 +
      'dct.id as ' + DocumentChargeKindIdFieldName + ',' + #13#10 +
      'dct.name as ' + DocumentChargeKindNameFieldName + ',' + #13#10 +
      'dct.service_name as ' + DocumentChargeServiceKindNameFieldName + ',' + #13#10 +
      'doc_rec.charge as ' + DocumentChargeTextFieldName + ',' + #13#10 +
      'doc_rec.comment as ' + DocumentChargeResponseFieldName + ',' + #13#10 +
      'doc_rec.charge_period_start as ' + DocumentChargePeriodStartFieldName + ',' + #13#10 +
      'doc_rec.charge_period_end as ' + DocumentChargePeriodEndFieldName + ',' + #13#10 +
      'doc_rec.performing_date as ' + DocumentChargePerformingDateTimeFieldName + ',' + #13#10 + 
      'doc_rec.is_for_acquaitance as ' + DocumentChargeIsForAcquaitanceFieldName + ',' +
      'performers.id as ' + DocumentChargePerformerIdFieldName + ',' + #13#10 +
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
    
      'case when doc_rec.issuer_id is not null then doc_rec.id else null end as ' + DocumentChargeSheetIdFieldName + ',' + #13#10 +
      'case when doc_rec.issuer_id is not null then dct.id else null end as ' + DocumentChargeSheetKindIdFieldName + ',' +
      'case when doc_rec.issuer_id is not null then dct.name else null end as ' + DocumentChargeSheetKindNameFieldName + ',' +
      'case when doc_rec.issuer_id is not null then dct.service_name else null end as ' + DocumentChargeSheetServiceKindNameFieldName + ',' +
      'case when doc_rec.issuer_id is not null then doc_rec.document_id else null end as ' + ChargeSheetDocumentIdFieldName + ',' + #13#10 +
      'case when doc_rec.issuer_id is not null then doc_rec.top_level_charge_sheet_id else null end as ' + TopLevelDocumentChargeSheetIdFieldName + ',' + #13#10 + 
      'case when doc_rec.issuer_id is not null then doc_rec.charge	else null	end as ' + DocumentChargeSheetTextFieldName + ',' + #13#10 + 
      'case when doc_rec.issuer_id is not null then doc_rec.comment else null	end as ' + DocumentChargeSheetResponseFieldName + ',' + #13#10 + 
      'case when doc_rec.issuer_id is not null then doc_rec.charge_period_start else null end as ' + DocumentChargeSheetPeriodStartFieldName + ',' + #13#10 + 
      'case when doc_rec.issuer_id is not null then doc_rec.charge_period_end	else null	end as ' + DocumentChargeSheetPeriodEndFieldName + ',' + #13#10 +
      'case when doc_rec.issuer_id is not null then doc_rec.performing_date else null	end as ' + DocumentChargeSheetPerformingDateTimeFieldName + ',' + #13#10 +
      'case when doc_rec.issuer_id is not null then doc_rec.issuing_datetime else null end as ' + DocumentChargeSheetIssuingDateTimeFieldName + ',' + #13#10 +
      'case when doc_rec.issuer_id is not null then doc_rec.is_for_acquaitance else null end as ' + DocumentChargeSheetIsForAcquaitanceFieldName + ',' + #13#10 +

      'case when doc_rec.issuer_id is not null then (select role_id from doc.employees_roles where employee_id = performers.id) else null end as ' + DocumentChargeSheetPerformerRoleIdFieldName + ',' + #13#10 +
      'case when doc_rec.issuer_id is not null then performers.id else null end as ' + DocumentChargeSheetPerformerIdFieldName + ',' + #13#10 +
      'case when doc_rec.issuer_id is not null then performers.leader_id else null end as ' + DocumentChargeSheetPerformerLeaderIdFieldName + ',' + #13#10 +
      'case when doc_rec.issuer_id is not null then performers.is_foreign else null end as ' + DocumentChargeSheetPerformerIsForeignFieldName + ',' + #13#10 +
      'case when doc_rec.issuer_id is not null then (performers.surname || '' '' || performers.name || '' '' || performers.patronymic) else null end as ' + DocumentChargeSheetPerformerNameFieldName + ',' + #13#10 + 
      'case when doc_rec.issuer_id is not null then performers.speciality else null end as ' + DocumentChargeSheetPerformerSpecialityFieldName + ',' + #13#10 +
      'case when doc_rec.issuer_id is not null then perf_deps.id else null end as ' + DocumentChargeSheetPerformerDepartmentIdFieldName + ',' + #13#10 +
      'case when doc_rec.issuer_id is not null then perf_deps.code else null end as ' + DocumentChargeSheetPerformerDepartmentCodeFieldName + ',' + #13#10 +
      'case when doc_rec.issuer_id is not null then perf_deps.short_name else null end as ' + DocumentChargeSheetPerformerDepartmentNameFieldName + ',' + #13#10 + 

      'case when doc_rec.issuer_id is not null then fact_perf.id else null end as ' + DocumentChargeSheetActualPerformerIdFieldName + ',' + #13#10 +
      'case when doc_rec.issuer_id is not null then fact_perf.leader_id else null end as ' + DocumentChargeSheetActualPerformerLeaderIdFieldName + ',' + #13#10 +
      'case when doc_rec.issuer_id is not null then fact_perf.is_foreign else null end as ' + DocumentChargeSheetActualPerformerIsForeignFieldName + ',' + #13#10 +
      'case when doc_rec.issuer_id is not null then (fact_perf.surname || '' '' || fact_perf.name || '' '' || fact_perf.patronymic) else null end as ' + DocumentChargeSheetActualPerformerNameFieldName + ',' + #13#10 +
      'case when doc_rec.issuer_id is not null then fact_perf.speciality else null end as ' + DocumentChargeSheetActualPerformerSpecialityFieldName + ',' + #13#10 +
      'case when doc_rec.issuer_id is not null then fact_perf_dep.id else null end as ' + DocumentChargeSheetActualPerformerDepartmentIdFieldName + ',' + #13#10 +
      'case when doc_rec.issuer_id is not null then fact_perf_dep.code else null end as ' + DocumentChargeSheetActualPerformerDepartmentCodeFieldName + ',' + #13#10 +
      'case when doc_rec.issuer_id is not null then fact_perf_dep.short_name else null end as ' + DocumentChargeSheetActualPerformerDepartmentNameFieldName + ',' + #13#10 + 
      'case when doc_rec.issuer_id is not null then (select  min(look_date)' + #13#10 + 
                              'from doc.looked_service_notes lsn' + #13#10 + 
                              'where lsn.document_id=doc_rec.document_id and' + #13#10 + 
                            '((lsn.looked_employee_id=doc_rec.performer_id) or' + #13#10 + 
                            '(doc.is_employee_acting_for_other_or_vice_versa(lsn.looked_employee_id,doc_rec.performer_id))))' + #13#10 + 
                          'else null end as ' + DocumentChargeSheetViewingDateByPerformerFieldName + ',' +
      'fact_charge_sheet_sender.id as ' + DocumentChargeSheetSenderIdFieldName + ',' + #13#10 +
      'fact_charge_sheet_sender.leader_id as ' + DocumentChargeSheetSenderLeaderIdFieldName + ',' + #13#10 +
      'fact_charge_sheet_sender.is_foreign as ' + DocumentChargeSheetSenderIsForeignFieldName + ',' + #13#10 +
      '(fact_charge_sheet_sender.surname || '' '' || fact_charge_sheet_sender.name || '' '' || fact_charge_sheet_sender.patronymic) as ' + DocumentChargeSheetSenderNameFieldName + ',' + #13#10 +
      'fact_charge_sheet_sender.speciality as ' + DocumentChargeSheetSenderSpecialityFieldName + ',' + #13#10 +
      'fact_charge_sheet_sender_dep.id as ' + DocumentChargeSheetSenderDepartmentIdFieldName + ',' + #13#10 +
      'fact_charge_sheet_sender_dep.code as ' + DocumentChargeSheetSenderDepartmentCodeFieldName + ',' + #13#10 +
      'fact_charge_sheet_sender_dep.short_name as ' + DocumentChargeSheetSenderDepartmentNameFieldName + ',' + #13#10 +
      'replacings.is_cur_emp_issuer or replacings.is_cur_emp_performer as can_charge_sheet_view,' +
      'replacings.is_cur_emp_issuer as has_charge_section_access,' +
      'replacings.is_cur_emp_performer as has_response_section_access,' +
      'replacings.is_cur_emp_issuer as can_charge_sheet_remove,' +
      'replacings.is_cur_emp_performer as can_charge_sheet_perform' + #13#10 +

      'from ' + FDocumentChargeTableDef.TableName + ' doc_rec' + #13#10 +
      'left join ' + FDocumentChargeKindTableDef.TableName + ' dct on dct.id = doc_rec.kind_id ' +
      'join doc.get_current_employee_id() cur_emp(id) on true' + #13#10 +
      'left join doc.employees performers on performers.id = doc_rec.performer_id' + #13#10 +
      'left join doc.departments perf_deps on perf_deps.id = performers.department_id' + #13#10 +
      'left join doc.employees fact_perf on fact_perf.id = doc_rec.actual_performer_id' + #13#10 +
      'left join doc.departments fact_perf_dep on fact_perf_dep.id = fact_perf.department_id' + #13#10 +
      'left join doc.employees fact_charge_sheet_sender on fact_charge_sheet_sender.id = doc_rec.issuer_id' + #13#10 +
      'left join doc.departments fact_charge_sheet_sender_dep on fact_charge_sheet_sender_dep.id = fact_charge_sheet_sender.department_id' + #13#10 +

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
      'where doc_rec.document_id=:' + DocumentIdParamName +

      ' ORDER BY ' + DocumentChargeSheetPerformerDepartmentCodeFieldName + ', ' + DocumentChargeIdFieldName

  end;

end;

end.
