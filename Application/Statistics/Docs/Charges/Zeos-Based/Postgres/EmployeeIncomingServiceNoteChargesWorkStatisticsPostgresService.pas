unit EmployeeIncomingServiceNoteChargesWorkStatisticsPostgresService;

interface

uses

  EmployeeDocumentChargesWorkStatisticsZeosService,
  EmployeeDocumentChargesWorkStatisticsPostgresService,
  SysUtils;

type

  TEmployeeIncomingServiceNoteChargesWorkStatisticsPostgresService =
    class (TEmployeeDocumentChargesWorkStatisticsPostgresService)

      protected

        function CreateDocumentChargesStatisticsFetchingQueryDataFrom(
          const EmployeeId: Variant;
          const DocumentId: Variant
        ): TEmployeeDocumentChargesStatisticsFetchingQueryData;
        override;

    end;                             


implementation

uses

  Variants;
  
{ TEmployeeIncomingServiceNoteChargesWorkStatisticsPostgresService }

function TEmployeeIncomingServiceNoteChargesWorkStatisticsPostgresService.CreateDocumentChargesStatisticsFetchingQueryDataFrom(
  const EmployeeId,
  DocumentId: Variant
): TEmployeeDocumentChargesStatisticsFetchingQueryData;
begin

  Result := TEmployeeDocumentChargesStatisticsFetchingQueryData.Create;

  Result.QueryText :=

    Format(
      'SELECT * FROM doc.get_employee_service_note_charge_sheets_performing_statistics(%s, %s)',
      [
        VarToStr(DocumentId),
        VarToStr(EmployeeId)
      ]
    );

    {
    'with recursive get_subordinate_document_performers (id, performing_date) as' + #13#10 +
    '(' + #13#10 +
    'select' + #13#10 +
    'b.id,' + #13#10 +
    'b.performing_date' + #13#10 +
    'from' + #13#10 +
    'doc.service_note_receivers a' + #13#10 +
    'join doc.service_note_receivers b on b.sender_id = a.id' + #13#10 +
    'where a.performing_date is null and a.incoming_document_id = ' + VarToStr(DocumentId) + ' and' + #13#10 +
      '(a.employee_id = ' + VarToStr(EmployeeId) + ' or doc.is_employee_acting_for_other_or_vice_versa(' + VarToStr(EmployeeId) + ', a.employee_id))' + #13#10 +
    'union' + #13#10 +
    'select' + #13#10 +
    'a.id,' + #13#10 +
    'a.performing_date' + #13#10 +
    'from doc.service_note_receivers a' + #13#10 +
    'join get_subordinate_document_performers b on a.sender_id = b.id' + #13#10 +
    ')' + #13#10 +
    'select' + #13#10 +
    'count(case when performing_date is not null then id else null end) as performed_charge_count,' + #13#10 +
    'count(*) as total_charge_count' + #13#10 +
    'from get_subordinate_document_performers'; }

  Result.PerformedChargeCountFieldName := 'subordinate_performed_charge_count';
  Result.TotalChargeCountFieldName := 'subordinate_charge_count';
  
end;

end.
