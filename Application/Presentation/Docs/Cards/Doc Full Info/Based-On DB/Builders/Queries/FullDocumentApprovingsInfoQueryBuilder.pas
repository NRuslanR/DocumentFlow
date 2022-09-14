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
      'da.id as ' + DocumentApprovingIdFieldName + ',' + #13#10 +
      'da.performing_date as ' + DocumentApprovingPerformingDateTimeFieldName + ',' + #13#10 +
      'da.performing_result_id as ' + DocumentApprovingPerformingResultIdFieldName + ',' + #13#10 +
      '(approver.id = cur_emp.id or doc.is_employee_acting_for_other_or_vice_versa(cur_emp.id, approver.id)) as ' + DocumentApprovingIsAccessibleFieldName + ',' + #13#10 +
      'dar.result_name as ' + DocumentApprovingPerformingResultFieldName + ',' + #13#10 +
      'da.note as ' + DocumentApprovingNoteFieldName + ',' + #13#10 +
      'da.cycle_number as ' + DocumentApprovingCycleNumberFieldName + ',' + #13#10 +
      'da.cycle_number as ' + DocumentApprovingCycleIdFieldName + ',' + #13#10 + 
      'case when da.id is not null then da.cycle_number is not null else null end as ' + DocumentApprovingIsCompletedFieldName + ',' + #13#10 +
      'exists  ( select 1 from doc.looked_service_notes lsn where lsn.document_id=da.document_id and ((lsn.looked_employee_id=da.approver_id) or' + #13#10 + 
                                  '(doc.is_employee_acting_for_other_or_vice_versa(lsn.looked_employee_id,da.approver_id)))' + #13#10 +
          ') as ' + DocumentApprovingIsLookedByApproverFieldName + ',' + #13#10 +
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
      'fact_approver_dep.short_name as ' + DocumentActualApproverDepartmentNameFieldName + #13#10 +

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
