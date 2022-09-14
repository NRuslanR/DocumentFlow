unit ServiceNoteChargeSheetPostgresRepository;

interface

uses

  DocumentChargeSheetPostgresRepository,
  DBTableMapping,
  DocumentChargeSheet,
  ServiceNoteChargeSheet;

type

  TServiceNoteChargeSheetPostgresRepository =
    class (TDocumentChargeSheetPostgresRepository)

      protected

        procedure CustomizeTableMapping(
          TableMapping: TDBTableMapping
        ); override;

      protected

        function GetDocumentChargeSheetPerformingStageId: Variant; override;
        function GetDocumentChargeSheetPerformedStageId: Variant; override;

    end;
    
implementation

uses

  ServiceNoteChargeSheetTable,
  DocumentChargeSheetStageTable;
  
{ TServiceNoteChargeSheetPostgresRepository }

procedure TServiceNoteChargeSheetPostgresRepository.CustomizeTableMapping(
  TableMapping: TDBTableMapping
);
begin

  inherited;
  
  TableMapping.SetTableNameMapping(
    SERVICE_NOTE_CHARGE_SHEET_TABLE_NAME,
    TServiceNoteChargeSheet,
    TServiceNoteChargeSheets
  );
  
end;

function TServiceNoteChargeSheetPostgresRepository.
  GetDocumentChargeSheetPerformedStageId: Variant;
begin

  Result := SERVICE_NOTE_CHARGE_SHEET_STAGE_ID_OF_PERFORMED;
  
end;

function TServiceNoteChargeSheetPostgresRepository.
  GetDocumentChargeSheetPerformingStageId: Variant;
begin

  Result := SERVICE_NOTE_CHARGE_SHEET_STAGE_ID_OF_PERFORMING;
  
end;

end.
