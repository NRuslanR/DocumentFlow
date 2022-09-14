unit EmployeeOutcomingServiceNoteChargesWorkStatisticsPostgresService;

interface

uses

  EmployeeDocumentChargesWorkStatisticsZeosService,
  EmployeeDocumentChargesWorkStatisticsPostgresService;

type

  TEmployeeOutcomingServiceNoteChargesWorkStatisticsPostgresService =
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
  
{ TEmployeeOutcomingServiceNoteChargesWorkStatisticsPostgresService }

function TEmployeeOutcomingServiceNoteChargesWorkStatisticsPostgresService.
  CreateDocumentChargesStatisticsFetchingQueryDataFrom(
    const EmployeeId,
    DocumentId: Variant
  ): TEmployeeDocumentChargesStatisticsFetchingQueryData;
begin

  Result := TEmployeeDocumentChargesStatisticsFetchingQueryData.Create;

  Result.QueryText :=
    'SELECT * FROM doc.get_service_note_performing_statistics(' +
    VarToStr(DocumentId) + ') t(total_charge_count, performed_charge_count)';

  Result.TotalChargeCountFieldName := 'total_charge_count';
  Result.PerformedChargeCountFieldName := 'performed_charge_count';

end;

end.
