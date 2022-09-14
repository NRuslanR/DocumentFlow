unit BasedOnDatabaseAbstractDocumentSetReadService;

interface

uses

  AbstractApplicationService,
  DocumentSetHolder,
  DataSetQueryExecutor,
  DocumentSetHolderFactory,
  QueryExecutor,
  SysUtils,
  Classes;

type

  TBasedOnDatabaseAbstractDocumentSetReadService =
    class abstract (TAbstractApplicationService)

      protected

        FDocumentSetFetchingQueryPattern: String;

        FQueryExecutor: IQueryExecutor;
        FDocumentSetHolderFactory: TDocumentSetHolderFactory;

        function CreateDocumentSetHolder: TDocumentSetHolder;

        function CreateDocumentSetHolderFactory: TDocumentSetHolderFactory; virtual; abstract;

      public

        destructor Destroy; override;
        constructor Create(QueryExecutor: TDataSetQueryExecutor);

    end;
  
implementation

{ TBasedOnDatabaseAbstractDocumentSetReadService }

constructor TBasedOnDatabaseAbstractDocumentSetReadService.Create(
  QueryExecutor: TDataSetQueryExecutor
);
begin

  inherited Create;

  FQueryExecutor := QueryExecutor;

  FDocumentSetHolderFactory := CreateDocumentSetHolderFactory;

end;

function TBasedOnDatabaseAbstractDocumentSetReadService.CreateDocumentSetHolder: TDocumentSetHolder;
begin

  Result := FDocumentSetHolderFactory.CreateDocumentSetHolder;

end;

destructor TBasedOnDatabaseAbstractDocumentSetReadService.Destroy;
begin

  FreeAndNil(FDocumentSetHolderFactory);

  inherited;

end;

end.
                  