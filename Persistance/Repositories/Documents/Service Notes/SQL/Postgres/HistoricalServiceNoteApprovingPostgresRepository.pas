unit HistoricalServiceNoteApprovingPostgresRepository;

interface

uses

  HistoricalDocumentApprovingPostgresRepository,
  DBTableMapping,
  SysUtils,
  Classes;

type

  THistoricalServiceNoteApprovingPostgresRepository =
    class (THistoricalDocumentApprovingPostgresRepository)

      protected

        procedure CustomizeTableMapping(
          TableMapping: TDBTableMapping
        ); override;
      
    end;

implementation

uses

  ServiceNoteApprovingsTable;

{ TServiceNoteHistoricalApprovingPostgresRepository }

procedure THistoricalServiceNoteApprovingPostgresRepository.
  CustomizeTableMapping(
    TableMapping: TDBTableMapping
  );
begin

  inherited;

  TableMapping.TableName := SERVICE_NOTE_APPROVINGS_TABLE_NAME;
  
end;

end.
