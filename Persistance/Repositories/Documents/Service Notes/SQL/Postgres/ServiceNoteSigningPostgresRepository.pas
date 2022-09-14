unit ServiceNoteSigningPostgresRepository;

interface

uses

  DocumentSigningPostgresRepository,
  DBTableMapping,
  SysUtils,
  Classes;

type

  TServiceNoteSigningPostgresRepository =
    class (TDocumentSigningPostgresRepository)

      protected

        procedure CustomizeTableMapping(
          TableMapping: TDBTableMapping
        ); override;
      
    end;


implementation

uses

  ServiceNoteSigningTable;

{ TServiceNoteSigningPostgresRepository }

procedure TServiceNoteSigningPostgresRepository.CustomizeTableMapping(
  TableMapping: TDBTableMapping);
begin

  inherited;

  TableMapping.TableName := SERVICE_NOTE_SIGNING_TABLE_NAME;

end;

end.
