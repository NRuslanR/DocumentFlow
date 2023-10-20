unit DocumentRelationsInfoHolderBuilder;

interface

uses

  DocumentRelationsInfoHolder,
  DocumentRelationsInfoQueryBuilder,
  DB,
  DataSetQueryExecutor,
  QueryExecutor,
  DataSetDataReader,
  SysUtils;

type

  IDocumentRelationsInfoHolderBuilder = interface

    function BuildDocumentRelationsInfoHolder(DocumentId: Variant): TDocumentRelationsInfoHolder;
    
  end;

  TDocumentRelationsInfoHolderBuilder =
    class (TInterfacedObject, IDocumentRelationsInfoHolderBuilder)

      protected

        FQueryBuilder: IDocumentRelationsInfoQueryBuilder;
        FQueryExecutor: TDataSetQueryExecutor;

      protected

        function CreateDocumentRelationsInfoHolder: TDocumentRelationsInfoHolder;
        function CreateDocumentRelationsInfoHolderInstance: TDocumentRelationsInfoHolder; virtual;
        function CreateDocumentRelationsInfoFieldNames: TDocumentRelationsInfoFieldNames;
        function CreateDocumentRelationsInfoFieldNamesInstance: TDocumentRelationsInfoFieldNames; virtual;
        procedure FillDocumentRelationsInfoFieldNames(FieldNames: TDocumentRelationsInfoFieldNames); virtual;
        
      protected

        function CreateDocumentRelationsInfoDataSet(
          FieldNames: TDocumentRelationsInfoFieldNames;
          DocumentId: Variant
        ): TDataSet;

      public

        constructor Create(
          QueryBuilder: IDocumentRelationsInfoQueryBuilder;
          QueryExecutor: TDataSetQueryExecutor
        );
        
        function BuildDocumentRelationsInfoHolder(DocumentId: Variant): TDocumentRelationsInfoHolder;

    end;

implementation

{ TDocumentRelationsInfoHolderBuilder }

constructor TDocumentRelationsInfoHolderBuilder.Create(
  QueryBuilder: IDocumentRelationsInfoQueryBuilder;
  QueryExecutor: TDataSetQueryExecutor);
begin

  inherited Create;

  FQueryBuilder := QueryBuilder;
  FQueryExecutor := QueryExecutor;
  
end;

function TDocumentRelationsInfoHolderBuilder.BuildDocumentRelationsInfoHolder(
  DocumentId: Variant): TDocumentRelationsInfoHolder;
begin

  Result := CreateDocumentRelationsInfoHolder;

  try

    Result.DataSet := CreateDocumentRelationsInfoDataSet(Result.FieldNames, DocumentId);

  except

    FreeAndNil(Result);

    Raise;

  end;

end;

function TDocumentRelationsInfoHolderBuilder
  .CreateDocumentRelationsInfoHolder: TDocumentRelationsInfoHolder;
begin

  Result := CreateDocumentRelationsInfoHolderInstance;

  Result.FieldNames := CreateDocumentRelationsInfoFieldNames;
  
end;

function TDocumentRelationsInfoHolderBuilder
  .CreateDocumentRelationsInfoHolderInstance: TDocumentRelationsInfoHolder;
begin

  Result := TDocumentRelationsInfoHolder.Create;
  
end;

function TDocumentRelationsInfoHolderBuilder
  .CreateDocumentRelationsInfoFieldNames: TDocumentRelationsInfoFieldNames;
begin

  Result := CreateDocumentRelationsInfoFieldNamesInstance;

  FillDocumentRelationsInfoFieldNames(Result);

end;

function TDocumentRelationsInfoHolderBuilder
  .CreateDocumentRelationsInfoFieldNamesInstance: TDocumentRelationsInfoFieldNames;
begin

  Result := TDocumentRelationsInfoFieldNames.Create;

end;

procedure TDocumentRelationsInfoHolderBuilder.FillDocumentRelationsInfoFieldNames(
  FieldNames: TDocumentRelationsInfoFieldNames);
begin

  with FieldNames do begin

    RelationIdFieldName := 'document_relation_id';
    TargetDocumentIdFieldName := 'document_id';
    RelatedDocumentIdFieldName := 'related_document_id';
    RelatedDocumentKindIdFieldName := 'related_document_kind_id';
    RelatedDocumentKindNameFieldName := 'related_document_kind_name';
    RelatedDocumentNumberFieldName := 'related_document_number';
    RelatedDocumentNameFieldName := 'related_document_name';
    RelatedDocumentDateFieldName := 'related_document_date'

  end;

end;

function TDocumentRelationsInfoHolderBuilder.CreateDocumentRelationsInfoDataSet(
  FieldNames: TDocumentRelationsInfoFieldNames;
  DocumentId: Variant
): TDataSet;
var
    QueryParams: TQueryParams;
    Query: String;
begin

  Query :=
    FQueryBuilder.BuildDocumentRelationsInfoQuery(FieldNames, 'pdocument_id');

  QueryParams := TQueryParams.Create.AddFluently('pdocument_id', DocumentId);

  try

    Result := TDataSetDataReader(FQueryExecutor.ExecuteSelectionQuery(Query, QueryParams).Self).ToDataSet;
    
  finally

    FreeAndNil(QueryParams);

  end;

end;

end.
