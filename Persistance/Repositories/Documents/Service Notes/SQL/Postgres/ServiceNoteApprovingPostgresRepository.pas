unit ServiceNoteApprovingPostgresRepository;

interface

uses

  DocumentApprovingPostgresRepository,
  DBTableMapping,
  SysUtils,
  Classes;

type

  TServiceNoteApprovingPostgresRepository =
    class (TDocumentApprovingPostgresRepository)

      protected

         procedure CustomizeTableMapping(
          TableMapping: TDBTableMapping
        ); override;

    end;
    
implementation

uses

  ServiceNoteApprovingsTable;
  
{ TServiceNoteApprovingPostgresRepository }

procedure TServiceNoteApprovingPostgresRepository.CustomizeTableMapping(
  TableMapping: TDBTableMapping);
begin

  inherited;

  TableMapping.TableName := SERVICE_NOTE_APPROVINGS_TABLE_NAME;  

end;

end.
