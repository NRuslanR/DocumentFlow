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

  with DocumentChargesInfoFieldNames
  do begin

    Result :=
      'select distinct' + #13#10 +
      'doc_rec.id as ' + IdFieldName + ',' + #13#10 +
      'dct.id as ' + KindIdFieldName + ',' + #13#10 +
      'dct.name as ' + KindNameFieldName + ',' + #13#10 +
      'dct.service_name as ' + ServiceKindNameFieldName + ',' + #13#10 +
      'doc_rec.charge as ' + ChargeTextFieldName + ',' + #13#10 +
      'doc_rec.comment as ' + ResponseFieldName + ',' + #13#10 +
      'doc_rec.charge_period_start as ' + TimeFrameStartFieldName + ',' + #13#10 +
      'doc_rec.charge_period_end as ' + TimeFrameDeadlineFieldName + ',' + #13#10 +
      'doc_rec.performing_date as ' + PerformingDateTimeFieldName + ',' + #13#10 + 
      'doc_rec.is_for_acquaitance as ' + IsForAcquaitanceFieldName + ',' +
      'performers.id as ' + PerformerIdFieldName + ',' + #13#10 +
      'performers.is_foreign as ' + PerformerIsForeignFieldName + ',' + #13#10 +
      '(performers.surname || '' '' || performers.name || '' '' || performers.patronymic) as ' + PerformerNameFieldName + ',' + #13#10 + 
      'performers.speciality as ' + PerformerSpecialityFieldName + ',' + #13#10 +
      'perf_deps.id as ' + PerformerDepartmentIdFieldName + ',' + #13#10 +
      'perf_deps.code as ' + PerformerDepartmentCodeFieldName + ',' + #13#10 +
      'perf_deps.short_name as ' + PerformerDepartmentNameFieldName + ',' + #13#10 + 
      'fact_perf.id as ' + ActualPerformerIdFieldName + ',' + #13#10 +
      '(fact_perf.surname || '' '' || fact_perf.name || '' '' || fact_perf.patronymic) as ' + ActualPerformerNameFieldName + ',' + #13#10 + 
      'fact_perf.speciality as ' + ActualPerformerSpecialityFieldName + ',' + #13#10 + 
      'fact_perf_dep.id as ' + ActualPerformerDepartmentIdFieldName + ',' + #13#10 + 
      'fact_perf_dep.code as ' + ActualPerformerDepartmentCodeFieldName + ',' + #13#10 + 
      'fact_perf_dep.short_name as ' + ActualPerformerDepartmentNameFieldName + ',' + #13#10;

  end;

  with DocumentChargeSheetsInfoFieldNames do begin

    Result := Result +
      'case when doc_rec.issuer_id is not null then doc_rec.id else null end as ' + IdFieldName + ',' + #13#10 +
      'case when doc_rec.issuer_id is not null then doc_rec.id else null end as ' + ChargeIdFieldName + ',' + #13#10 +
      'case when doc_rec.issuer_id is not null then dct.id else null end as ' + KindIdFieldName + ',' +
      'case when doc_rec.issuer_id is not null then dct.name else null end as ' + KindNameFieldName + ',' +
      'case when doc_rec.issuer_id is not null then dct.service_name else null end as ' + ServiceKindNameFieldName + ',' +
      'case when doc_rec.issuer_id is not null then doc_rec.document_id else null end as ' + DocumentIdFieldName + ',' + #13#10 +
      'case when doc_rec.issuer_id is not null then doc_rec.document_kind_id else null end as ' + DocumentKindIdFieldName + ',' + #13#10 +
      'case when doc_rec.issuer_id is not null then doc_rec.top_level_charge_sheet_id else null end as ' + TopLevelChargeSheetIdFieldName + ',' + #13#10 +
      'case when doc_rec.issuer_id is not null then doc_rec.charge	else null	end as ' + ChargeTextFieldName + ',' + #13#10 +
      'case when doc_rec.issuer_id is not null then doc_rec.comment else null	end as ' + ResponseFieldName + ',' + #13#10 + 
      'case when doc_rec.issuer_id is not null then doc_rec.charge_period_start else null end as ' + TimeFrameStartFieldName + ',' + #13#10 + 
      'case when doc_rec.issuer_id is not null then doc_rec.charge_period_end	else null	end as ' + TimeFrameDeadlineFieldName + ',' + #13#10 +
      'case when doc_rec.issuer_id is not null then doc_rec.performing_date else null	end as ' + PerformingDateTimeFieldName + ',' + #13#10 +
      'case when doc_rec.issuer_id is not null then doc_rec.issuing_datetime else null end as ' + IssuingDateTimeFieldName + ',' + #13#10 +
      'case when doc_rec.issuer_id is not null then doc_rec.is_for_acquaitance else null end as ' + IsForAcquaitanceFieldName + ',' + #13#10 +

      'case when doc_rec.issuer_id is not null then performers.id else null end as ' + PerformerIdFieldName + ',' + #13#10 +
      'case when doc_rec.issuer_id is not null then performers.is_foreign else null end as ' + PerformerIsForeignFieldName + ',' + #13#10 +
      'case when doc_rec.issuer_id is not null then (performers.surname || '' '' || performers.name || '' '' || performers.patronymic) else null end as ' + PerformerNameFieldName + ',' + #13#10 + 
      'case when doc_rec.issuer_id is not null then performers.speciality else null end as ' + PerformerSpecialityFieldName + ',' + #13#10 +
      'case when doc_rec.issuer_id is not null then perf_deps.id else null end as ' + PerformerDepartmentIdFieldName + ',' + #13#10 +
      'case when doc_rec.issuer_id is not null then perf_deps.code else null end as ' + PerformerDepartmentCodeFieldName + ',' + #13#10 +
      'case when doc_rec.issuer_id is not null then perf_deps.short_name else null end as ' + PerformerDepartmentNameFieldName + ',' + #13#10 + 

      'case when doc_rec.issuer_id is not null then fact_perf.id else null end as ' + ActualPerformerIdFieldName + ',' + #13#10 +
      'case when doc_rec.issuer_id is not null then (fact_perf.surname || '' '' || fact_perf.name || '' '' || fact_perf.patronymic) else null end as ' + ActualPerformerNameFieldName + ',' + #13#10 +
      'case when doc_rec.issuer_id is not null then fact_perf.speciality else null end as ' + ActualPerformerSpecialityFieldName + ',' + #13#10 +
      'case when doc_rec.issuer_id is not null then fact_perf_dep.id else null end as ' + ActualPerformerDepartmentIdFieldName + ',' + #13#10 +
      'case when doc_rec.issuer_id is not null then fact_perf_dep.code else null end as ' + ActualPerformerDepartmentCodeFieldName + ',' + #13#10 +
      'case when doc_rec.issuer_id is not null then fact_perf_dep.short_name else null end as ' + ActualPerformerDepartmentNameFieldName + ',' + #13#10 + 
      'case when doc_rec.issuer_id is not null then (select  min(look_date)' + #13#10 + 
                              'from doc.looked_service_notes lsn' + #13#10 + 
                              'where lsn.document_id=doc_rec.document_id and' + #13#10 + 
                            '((lsn.looked_employee_id=doc_rec.performer_id) or' + #13#10 + 
                            '(doc.is_employee_acting_for_other_or_vice_versa(lsn.looked_employee_id,doc_rec.performer_id))))' + #13#10 + 
                          'else null end as ' + ViewDateByPerformerFieldName + ',' +
      'fact_charge_sheet_sender.id as ' + IssuerIdFieldName + ',' + #13#10 +
      'fact_charge_sheet_sender.is_foreign as ' + IssuerIsForeignFieldName + ',' + #13#10 +
      '(fact_charge_sheet_sender.surname || '' '' || fact_charge_sheet_sender.name || '' '' || fact_charge_sheet_sender.patronymic) as ' + IssuerNameFieldName + ',' + #13#10 +
      'fact_charge_sheet_sender.speciality as ' + IssuerSpecialityFieldName + ',' + #13#10 +
      'fact_charge_sheet_sender_dep.id as ' + IssuerDepartmentIdFieldName + ',' + #13#10 +
      'fact_charge_sheet_sender_dep.code as ' + IssuerDepartmentCodeFieldName + ',' + #13#10 +
      'fact_charge_sheet_sender_dep.short_name as ' + IssuerDepartmentNameFieldName + ',' + #13#10 +

      'replacings.is_cur_emp_issuer or replacings.is_cur_emp_performer as ' + ViewingAllowedFieldName + ',' +
      'replacings.is_cur_emp_issuer and doc_rec.performing_date is null as ' + ChargeSectionAccessibleFieldName + ',' +
      'replacings.is_cur_emp_performer and doc_rec.performing_date is null as ' + ResponseSectionAccessibleFieldName + ',' +
      'replacings.is_cur_emp_issuer and doc_rec.performing_date is null as ' + RemovingAllowedFieldName + ',' +
      'replacings.is_cur_emp_performer and doc_rec.performing_date is null as ' + PerformingAllowedFieldName + ',' +
      'case when dct.service_name = ''performing'' then ' +
        'replacings.is_cur_emp_performer and doc_rec.performing_date is null ' +
      'else replacings.is_cur_emp_performer end as ' + SubordinateChargeSheetsIssuingAllowedFieldName + ',' +
      'replacings.is_cur_emp_performer as ' + IsEmployeePerformerFieldName + #13#10 +

      'from ' + FDocumentChargeTableDef.TableName + ' doc_rec' + #13#10 +
      'left join ' + FDocumentChargeKindTableDef.TableName + ' dct on dct.id = doc_rec.kind_id ' +
      'join doc.get_current_employee_id() cur_emp(id) on true' + #13#10 +
      'left join doc.employees performers on performers.id = doc_rec.performer_id' + #13#10 +
      'left join doc.departments perf_deps on perf_deps.id = performers.department_id' + #13#10 +
      'left join doc.employees fact_perf on fact_perf.id = doc_rec.actual_performer_id' + #13#10 +
      'left join doc.departments fact_perf_dep on fact_perf_dep.id = fact_perf.department_id' + #13#10 +
      'left join doc.employees fact_charge_sheet_sender on fact_charge_sheet_sender.id = doc_rec.issuer_id' + #13#10 +
      'left join doc.departments fact_charge_sheet_sender_dep on fact_charge_sheet_sender_dep.id = fact_charge_sheet_sender.department_id' + #13#10 +

      'join lateral (' +
      'select ' +
      'cur_emp.id = doc_rec.issuer_id or doc.is_employee_acting_for_other_or_vice_versa(cur_emp.id, doc_rec.issuer_id) as is_cur_emp_issuer,' +
      'cur_emp.id = doc_rec.performer_id or doc.is_employee_acting_for_other_or_vice_versa(cur_emp.id, doc_rec.performer_id) as is_cur_emp_performer' +
      ') as replacings on true ' +
      'where doc_rec.document_id=:' + DocumentIdParamName +

      ' ORDER BY ' + PerformerDepartmentCodeFieldName + ', ' + ChargeIdFieldName;

  end;

end;

end.
