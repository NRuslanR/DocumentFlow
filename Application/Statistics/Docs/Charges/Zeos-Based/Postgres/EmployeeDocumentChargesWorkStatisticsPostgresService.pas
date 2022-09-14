unit EmployeeDocumentChargesWorkStatisticsPostgresService;

interface

uses

  EmployeeDocumentChargesWorkStatisticsZeosService;

type

  TEmployeeDocumentChargesWorkStatisticsPostgresService =
    class (TEmployeeDocumentChargesWorkStatisticsZeosService)

      protected

        function CreateDocumentChargesStatisticsFetchingQueryDataFrom(
          const EmployeeId: Variant;
          const DocumentId: Variant
        ): TEmployeeDocumentChargesStatisticsFetchingQueryData; override;

    end;

implementation

uses

  Variants;
  
{ TEmployeeDocumentChargesWorkStatisticsPostgresService }

function TEmployeeDocumentChargesWorkStatisticsPostgresService.
  CreateDocumentChargesStatisticsFetchingQueryDataFrom(
    const EmployeeId, DocumentId: Variant
  ): TEmployeeDocumentChargesStatisticsFetchingQueryData;
begin

  Result := TEmployeeDocumentChargesStatisticsFetchingQueryData.Create;
  
  Result.QueryText :=

    'with recursive get_subordinate_document_performers (id, performing_date) as' + #13#10 +
    '(' + #13#10 + 
    'select' + #13#10 + 
    'b.id,' + #13#10 + 
    'b.performing_date' + #13#10 + 
    'from' + #13#10 + 
    'doc.document_receivers a' + #13#10 + 
    'join doc.document_receivers b on b.sender_id = a.id' + #13#10 + 
    'where a.performing_date is null and a.incoming_document_id = ' + VarToStr(DocumentId) + ' and' + #13#10 +
      '(a.employee_id = ' + VarToStr(EmployeeId) + ' or doc.is_employee_acting_for_other_or_vice_versa(' + VarToStr(EmployeeId) + ', a.employee_id))' + #13#10 + 
    'union' + #13#10 + 
    'select' + #13#10 + 
    'a.id,' + #13#10 +
    'a.performing_date' + #13#10 + 
    'from doc.document_receivers a' + #13#10 + 
    'join get_subordinate_document_performers b on a.sender_id = b.id' + #13#10 + 
    ')' + #13#10 + 
    'select' + #13#10 + 
    'count(case when performing_date is not null then id else null end) as performed_charge_count,' + #13#10 +
    'count(*) as total_charge_count' + #13#10 +
    'from get_subordinate_document_performers';

  Result.PerformedChargeCountFieldName :=
    'performed_charge_count';

  Result.TotalChargeCountFieldName := 'total_charge_count';

end;

end.
