unit IncomingDocumentInfoHolderBuilder;

interface

uses

  DocumentInfoHolderBuilder,
  IncomingDocumentInfoHolder,
  DocumentInfoHolder,
  DataSetQueryExecutor,
  IncomingDocumentInfoQueryBuilder,
  DB,
  SysUtils;

type

  TIncomingDocumentInfoHolderBuilder =
    class (TDocumentInfoHolderBuilder)

      protected

        FDocumentInfoHolderBuilder: TDocumentInfoHolderBuilder;

      protected

        function CreateDocumentInfoHolderInstance: TDocumentInfoHolder; override;
        function CreateDocumentInfoFieldNamesInstance: TDocumentInfoFieldNames; override;
        procedure FillDocumentInfoFieldNames(FieldNames: TDocumentInfoFieldNames); override;

      protected

        function CreateDocumentInfoDataSet(
          DocumentId: Variant;
          FieldNames: TDocumentInfoFieldNames
        ): TDataSet; override;

      public

        constructor Create(
          QueryExecutor: TDataSetQueryExecutor;
          DocumentInfoQueryBuilder: TIncomingDocumentInfoQueryBuilder;
          DocumentInfoHolderBuilder: TDocumentInfoHolderBuilder
        );

        function CreateDocumentInfoHolder: TDocumentInfoHolder; override;
        
        function BuildDocumentInfoHolder(DocumentId: Variant): TDocumentInfoHolder; override;
        
    end;
    
implementation

uses

  AuxiliaryStringFunctions;
  
{ TIncomingDocumentInfoHolderBuilder }

function TIncomingDocumentInfoHolderBuilder.BuildDocumentInfoHolder(
  DocumentId: Variant): TDocumentInfoHolder;
begin

  Result := inherited BuildDocumentInfoHolder(DocumentId);

  with TIncomingDocumentInfoHolder(Result) do begin

    OriginalDocumentInfoHolder.DataSet := DataSet;
                  
  end;

end;

constructor TIncomingDocumentInfoHolderBuilder.Create(
  QueryExecutor: TDataSetQueryExecutor;
  DocumentInfoQueryBuilder: TIncomingDocumentInfoQueryBuilder;
  DocumentInfoHolderBuilder: TDocumentInfoHolderBuilder
);
begin

  inherited Create(QueryExecutor, DocumentInfoQueryBuilder);

  FDocumentInfoHolderBuilder := DocumentInfoHolderBuilder;
  
end;

function TIncomingDocumentInfoHolderBuilder.CreateDocumentInfoDataSet(
  DocumentId: Variant; FieldNames: TDocumentInfoFieldNames): TDataSet;
begin

  Result := inherited CreateDocumentInfoDataSet(DocumentId, FieldNames);
  
end;

function TIncomingDocumentInfoHolderBuilder.CreateDocumentInfoFieldNamesInstance: TDocumentInfoFieldNames;
begin

  Result := TIncomingDocumentInfoFieldNames.Create;

end;

function TIncomingDocumentInfoHolderBuilder.CreateDocumentInfoHolder: TDocumentInfoHolder;
begin

  Result := inherited CreateDocumentInfoHolder;

  with TIncomingDocumentInfoHolder(Result) do begin

    OriginalDocumentInfoHolder :=
      FDocumentInfoHolderBuilder.CreateDocumentInfoHolder;
      
  end;

end;

function TIncomingDocumentInfoHolderBuilder.CreateDocumentInfoHolderInstance: TDocumentInfoHolder;
begin

  Result := TIncomingDocumentInfoHolder.Create;

end;

procedure TIncomingDocumentInfoHolderBuilder.FillDocumentInfoFieldNames(
  FieldNames: TDocumentInfoFieldNames);
begin

  with FieldNames as TIncomingDocumentInfoFieldNames do begin

    IncomingDocumentIdFieldName := 'incoming_document_id';
    IncomingDocumentKindIdFieldName := 'incoming_document_kind_id';
    IncomingDocumentKindNameFieldName := 'incoming_document_kind_name';
    IncomingNumberFieldName := 'incoming_number';
    ReceiptDateFieldName := 'receipt_date';
    IncomingDocumentStageNumberFieldName := 'incoming_doc_stage_number';
    IncomingDocumentStageNameFieldName := 'incoming_doc_stage_name';

  end;

end;

end.
