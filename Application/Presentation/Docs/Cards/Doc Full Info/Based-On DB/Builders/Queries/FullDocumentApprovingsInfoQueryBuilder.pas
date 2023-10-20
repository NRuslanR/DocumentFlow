unit FullDocumentApprovingsInfoQueryBuilder;

interface

uses

  DocumentApprovingsInfoHolder,
  DocumentApprovingsTableDef,
  SysUtils;

type

  IFullDocumentApprovingsInfoQueryBuilder = interface

    function BuildFullDocumentApprovingsInfoQuery(
      FieldNames: TDocumentApprovingsInfoFieldNames;
      DocumentIdParamName: String
    ): String;

  end;

  TFullDocumentApprovingsInfoQueryBuilder =
    class (TInterfacedObject, IFullDocumentApprovingsInfoQueryBuilder)

      protected

        FDocumentApprovingsTableDef: TDocumentApprovingsTableDef;

      public

        constructor Create(DocumentApprovingsTableDef: TDocumentApprovingsTableDef);

        function BuildFullDocumentApprovingsInfoQuery(
          FieldNames: TDocumentApprovingsInfoFieldNames;
          DocumentIdParamName: String
        ): String; virtual;

    end;

implementation

{ TFullDocumentApprovingsInfoQueryBuilder }

function TFullDocumentApprovingsInfoQueryBuilder.BuildFullDocumentApprovingsInfoQuery(
  FieldNames: TDocumentApprovingsInfoFieldNames;
  DocumentIdParamName: String
): String;
begin

  with FieldNames do begin

    Result :=
      'select distinct ' + #13#10 + 
      'da.id as ' + IdFieldName + ',' + #13#10 +
      'da.performing_date as ' + PerformingDateTimeFieldName + ',' + #13#10 +
      'da.performing_result_id as ' + PerformingResultIdFieldName + ',' + #13#10 +
      '(approver.id = cur_emp.id or doc.is_employee_acting_for_other_or_vice_versa(cur_emp.id, approver.id)) as ' + IsAccessibleFieldName + ',' + #13#10 +
      'dar.result_name as ' + PerformingResultFieldName + ',' + #13#10 +
      'dar.result_service_name as ' + PerformingResultServiceNameFieldName + ',' + #13#10 +
      'da.note as ' + NoteFieldName + ',' + #13#10 +
      'da.cycle_number as ' + CycleNumberFieldName + ',' + #13#10 +
      'da.cycle_number as ' + CycleIdFieldName + ',' + #13#10 + 
      'case when da.id is not null then da.cycle_number is not null else null end as ' + IsCompletedFieldName + ',' + #13#10 +
      'exists  ( select 1 from doc.looked_service_notes lsn where lsn.document_id=da.document_id and ((lsn.looked_employee_id=da.approver_id) or' + #13#10 + 
                                  '(doc.is_employee_acting_for_other_or_vice_versa(lsn.looked_employee_id,da.approver_id)))' + #13#10 +
          ') as ' + IsLookedByApproverFieldName + ',' + #13#10 +
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
      'fact_approver_dep.short_name as ' + ActualApproverDepartmentNameFieldName + #13#10 +

      'from ' + FDocumentApprovingsTableDef.TableName + ' da' + #13#10 +
      'join doc.get_current_employee_id() cur_emp(id) on true' + #13#10 +
      'left join doc.document_approving_results dar on dar.id = da.performing_result_id' + #13#10 +
      'left join doc.employees approver on approver.id = da.approver_id' + #13#10 +
      'left join doc.departments approver_dep on approver_dep.id = approver.department_id' + #13#10 +
      'left join doc.employees fact_approver on fact_approver.id = da.actual_performed_employee_id' + #13#10 +
      'left join doc.departments fact_approver_dep on fact_approver_dep.id = fact_approver.department_id' + #13#10 +
      
      'where da.document_id=:' + DocumentIdParamName;

  end;

end;

constructor TFullDocumentApprovingsInfoQueryBuilder.Create(
  DocumentApprovingsTableDef: TDocumentApprovingsTableDef);
begin

  inherited Create;

  FDocumentApprovingsTableDef := DocumentApprovingsTableDef;
  
end;

end.
