unit ServiceNoteChargePostgresRepository;

interface

uses

  DocumentChargePostgresRepository,
  DBTableMapping,
  SysUtils,
  Classes;

type

  TServiceNoteChargePostgresRepository =
    class (TDocumentChargePostgresRepository)

      protected

        procedure CustomizeTableMapping(
          TableMapping: TDBTableMapping
        ); override;

    end;

implementation

uses

  DocumentChargeTableDef;
  
{ TServiceNoteChargePostgresRepository }

procedure TServiceNoteChargePostgresRepository.CustomizeTableMapping(
  TableMapping: TDBTableMapping);
begin

  inherited;

  TableMapping.TableName := SERVICE_NOTE_CHARGE_TABLE_NAME;

end;

end.
