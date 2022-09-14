unit ServiceNoteRelationsPostgresRepository;

interface

uses

  Document,
  QueryExecutor,
  ServiceNote,
  AbstractDBRepository,
  DocumentRelationsPostgresRepository,
  SysUtils,
  Classes;

type

  TServiceNoteRelationsPostgresRepository =
    class (TDocumentRelationsPostgresRepository)

      public

        constructor Create(QueryExecutor: IQueryExecutor); 

    end;

implementation

{ TServiceNoteRelationsPostgresRepository }

constructor TServiceNoteRelationsPostgresRepository.Create(
  QueryExecutor: IQueryExecutor);
begin

  inherited Create(TServiceNote, QueryExecutor);

end;

end.
