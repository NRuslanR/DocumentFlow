unit ServiceNoteApprovingCycleResultPostgresRepository;

interface

uses

  DocumentApprovingCycleResultPostgresRepository,
  SysUtils,
  Classes,
  QueryExecutor,
  HistoricalDocumentApprovingPostgresRepository,
  HistoricalServiceNoteApprovingPostgresRepository;

type

  TServiceNoteApprovingCycleResultPostgresRepository =
    class (TDocumentApprovingCycleResultPostgresRepository)

      protected

        function CreateHistoricalDocumentApprovingPostgresRepository(
          QueryExecutor: IQueryExecutor
        ): THistoricalDocumentApprovingPostgresRepository; override;

    end;

implementation

{ TServiceNoteApprovingCycleResultPostgresRepository }

function TServiceNoteApprovingCycleResultPostgresRepository.
  CreateHistoricalDocumentApprovingPostgresRepository(
    QueryExecutor: IQueryExecutor
  ): THistoricalDocumentApprovingPostgresRepository;
begin

  Result :=
    THistoricalServiceNoteApprovingPostgresRepository.Create(QueryExecutor);
  
end;

end.
