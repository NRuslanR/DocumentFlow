unit InternalServiceNoteChargeSheetPostgresRepository;

interface

uses

  ServiceNoteChargeSheetPostgresRepository,
  DBTableMapping,
  InternalServiceNoteChargeSheet,
  SysUtils,
  Classes;

type

  TInternalServiceNoteChargeSheetPostgresRepository =
    class (TServiceNoteChargeSheetPostgresRepository)

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

  DocumentChargeSheetStageTable;
  
{ TInternalServiceNoteChargeSheetPostgresRepository }

procedure TInternalServiceNoteChargeSheetPostgresRepository.CustomizeTableMapping(
  TableMapping: TDBTableMapping);
begin

  inherited;

  TableMapping.ObjectClass := TInternalServiceNoteChargeSheet;
  TableMapping.ObjectListClass := TInternalServiceNoteChargeSheets;
  
end;

function TInternalServiceNoteChargeSheetPostgresRepository.
  GetDocumentChargeSheetPerformedStageId: Variant;
begin

  Result := INTERNAL_SERVICE_NOTE_CHARGE_SHEET_STAGE_ID_OF_PERFORMED;
  
end;

function TInternalServiceNoteChargeSheetPostgresRepository.
  GetDocumentChargeSheetPerformingStageId: Variant;
begin

  Result := INTERNAL_SERVICE_NOTE_CHARGE_SHEET_STAGE_ID_OF_PERFORMING;
  
end;

end.
