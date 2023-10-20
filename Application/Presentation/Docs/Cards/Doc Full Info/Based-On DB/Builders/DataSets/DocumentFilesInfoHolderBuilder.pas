unit DocumentFilesInfoHolderBuilder;

interface

uses

  DocumentFilesInfoQueryBuilder,
  DocumentFilesInfoHolder,
  DataSetQueryExecutor,
  QueryExecutor,
  DataSetDataReader,
  DB,
  SysUtils;

type

  IDocumentFilesInfoHolderBuilder = interface

    function BuildDocumentFilesInfoHolder(
      DocumentId: Variant
    ): TDocumentFilesInfoHolder;
    
  end;

  TDocumentFilesInfoHolderBuilder =
    class (TInterfacedObject, IDocumentFilesInfoHolderBuilder)

      protected

        FQueryBuilder: IDocumentFilesInfoQueryBuilder;
        FQueryExecutor: TDataSetQueryExecutor;

      protected

        function CreateDocumentFilesInfoHolder: TDocumentFilesInfoHolder;

      protected

        function CreateDocumentFilesInfoDataSet(
          FieldNames: TDocumentFilesInfoFieldNames;
          DocumentId: Variant
        ): TDataSet;
        
      public

        constructor Create(
          QueryBuilder: IDocumentFilesInfoQueryBuilder;
          QueryExecutor: TDataSetQueryExecutor
        );

        function BuildDocumentFilesInfoHolder(
          DocumentId: Variant
        ): TDocumentFilesInfoHolder;

    end;
  
implementation

{ TDocumentFilesInfoHolderBuilder }

constructor TDocumentFilesInfoHolderBuilder.Create(
  QueryBuilder: IDocumentFilesInfoQueryBuilder;
  QueryExecutor: TDataSetQueryExecutor);
begin

  inherited Create;

  FQueryBuilder := QueryBuilder;
  FQueryExecutor := QueryExecutor;

end;

function TDocumentFilesInfoHolderBuilder.BuildDocumentFilesInfoHolder(
  DocumentId: Variant): TDocumentFilesInfoHolder;
begin

  Result := CreateDocumentFilesInfoHolder;

  try

    Result.DataSet := CreateDocumentFilesInfoDataSet(Result.FieldNames, DocumentId);

  except

    FreeAndNil(Result);

    Raise;

  end;

end;

function TDocumentFilesInfoHolderBuilder.CreateDocumentFilesInfoHolder: TDocumentFilesInfoHolder;
begin

  Result := TDocumentFilesInfoHolder.Create;
  Result.FieldNames := TDocumentFilesInfoFieldNames.Create;
  
  with Result.FieldNames do begin

    IdFieldName := 'document_file_id';
    NameFieldName := 'document_file_name';
    PathFieldName := 'document_file_path';
    DocumentIdFieldName := 'document_id';

  end;

end;

function TDocumentFilesInfoHolderBuilder.CreateDocumentFilesInfoDataSet(
  FieldNames: TDocumentFilesInfoFieldNames; DocumentId: Variant): TDataSet;
var
    QueryParams: TQueryParams;
    Query: String;
begin

  Query :=
    FQueryBuilder.BuildDocumentFilesInfoQuery(FieldNames, 'pdocument_id');

  QueryParams := TQueryParams.Create.AddFluently('pdocument_id', DocumentId);

  try

    Result := TDataSetDataReader(FQueryExecutor.ExecuteSelectionQuery(Query, QueryParams).Self).ToDataSet;
    
  finally

    FreeAndNil(QueryParams);

  end;

end;


end.
