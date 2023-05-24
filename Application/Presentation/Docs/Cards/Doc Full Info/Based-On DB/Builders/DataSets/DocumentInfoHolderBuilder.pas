unit DocumentInfoHolderBuilder;

interface

uses

  DocumentInfoQueryBuilder,
  DocumentInfoHolder,
  QueryExecutor,
  DataSetQueryExecutor,
  DataSetDataReader,
  IGetSelfUnit,
  DB,
  SysUtils,
  Classes;

type

  IDocumentInfoHolderBuilder = interface (IGetSelf)

    function BuildDocumentInfoHolder(DocumentId: Variant): TDocumentInfoHolder;
    
  end;
  
  TDocumentInfoHolderBuilder = class (TInterfacedObject, IDocumentInfoHolderBuilder)

    protected

      FQueryExecutor: IQueryExecutor;
      FDocumentInfoQueryBuilder: IDocumentInfoQueryBuilder;

    protected

      function CreateDocumentInfoHolderInstance: TDocumentInfoHolder; virtual;
      
      function CreateDocumentInfoFieldNames: TDocumentInfoFieldNames; 
      function CreateDocumentInfoFieldNamesInstance: TDocumentInfoFieldNames; virtual;
      procedure FillDocumentInfoFieldNames(FieldNames: TDocumentInfoFieldNames); virtual;
      
    protected

      function CreateDocumentInfoDataSet(
        DocumentId: Variant;
        FieldNames: TDocumentInfoFieldNames
      ): TDataSet; virtual;

    public

      constructor Create(
         QueryExecutor: TDataSetQueryExecutor;
         DocumentInfoQueryBuilder: IDocumentInfoQueryBuilder
      );

      function GetSelf: TObject;
      
    public

      function CreateDocumentInfoHolder: TDocumentInfoHolder; virtual;

      function BuildDocumentInfoHolder(DocumentId: Variant): TDocumentInfoHolder; virtual;

  end;

implementation

{ TAbstractDocumentInfoHolderBuilder }

function TDocumentInfoHolderBuilder.BuildDocumentInfoHolder(
  DocumentId: Variant
): TDocumentInfoHolder;
begin

  Result := CreateDocumentInfoHolder;

  try
  
    Result.DataSet := CreateDocumentInfoDataSet(DocumentId, Result.FieldNames);

  except

    FreeAndNil(Result);

    Raise;

  end;

end;

constructor TDocumentInfoHolderBuilder.Create(
  QueryExecutor: TDataSetQueryExecutor;
  DocumentInfoQueryBuilder: IDocumentInfoQueryBuilder);
begin

  inherited Create;

  FQueryExecutor := QueryExecutor;
  FDocumentInfoQueryBuilder := DocumentInfoQueryBuilder;
  
end;

function TDocumentInfoHolderBuilder.CreateDocumentInfoDataSet(
  DocumentId: Variant; FieldNames: TDocumentInfoFieldNames): TDataSet;
var
    QueryParams: TQueryParams;
    Query: String;
begin

  Query := FDocumentInfoQueryBuilder.BuildDocumentInfoQuery(FieldNames, 'pdocument_id');
  
  QueryParams := TQueryParams.Create;

  try

    QueryParams.Add('pdocument_id', DocumentId);
    
    Result :=
      TDataSetDataReader(
        FQueryExecutor.ExecuteSelectionQuery(Query, QueryParams).Self
      ).ToDataSet;
    
  finally

    FreeAndNil(QueryParams);

  end;

end;

function TDocumentInfoHolderBuilder.CreateDocumentInfoFieldNames: TDocumentInfoFieldNames;
begin

  Result := CreateDocumentInfoFieldNamesInstance;

  FillDocumentInfoFieldNames(Result);

end;

procedure TDocumentInfoHolderBuilder.FillDocumentInfoFieldNames(
  FieldNames: TDocumentInfoFieldNames);
begin

  with FieldNames do begin

    IdFieldName := 'document_id';
    BaseIdFieldName := 'base_document_id';
    NumberFieldName := 'document_number';
    NameFieldName := 'document_name';
    ProductCodeFieldName := 'product_code';
    ContentFieldName := 'document_content';
    NoteFieldName := 'document_note';
    IsSelfRegisteredFieldName := 'is_self_registered'; { refactor: набор полей передавать конструктор, поле is_self_registered актуально на данный момент только для служебок }
    CreationDateFieldName := 'document_creation_date';
    DateFieldName := 'document_date';
    KindFieldName := 'document_kind';
    KindIdFieldName := 'document_kind_id';
    CurrentWorkCycleStageNameFieldName := 'document_current_work_cycle_stage_name';
    CurrentWorkCycleStageNumberFieldName := 'document_current_work_cycle_stage_number';

    AuthorIdFieldName := 'document_author_id';
    AuthorLeaderIdFieldName := 'doc_author_leader_id';
    AuthorNameFieldName := 'document_author_name';
    AuthorSpecialityFieldName := 'document_author_speciality';
    AuthorDepartmentIdFieldName := 'document_author_department_id';
    AuthorDepartmentCodeFieldName := 'document_author_department_code';
    AuthorDepartmentNameFieldName := 'document_author_department_name';

    ResponsibleIdFieldName := 'document_responsible_id';
    ResponsibleNameFieldName := 'document_responsible_name';
    ResponsibleTelephoneNumberFieldName := 'document_responsible_telephone_number';
    ResponsibleDepartmentIdFieldName := 'document_responsible_department_id';
    ResponsibleDepartmentCodeFieldName := 'document_responsible_department_code';
    ResponsibleDepartmentNameFieldName := 'document_responsible_department_name';

    SigningIdFieldName := 'document_signing_id';
    SigningDateFieldName := 'document_signing_performing_date';
    SignerIdFieldName := 'document_signer_id';
    SignerLeaderIdFieldName := 'document_signer_leader_id';
    SignerNameFieldName := 'document_signer_name';
    SignerSpecialityFieldName := 'signer_speciality';
    SignerDepartmentIdFieldName := 'document_signer_dep_id';
    SignerDepartmentCodeFieldName := 'document_signer_dep_code';
    SignerDepartmentNameFieldName := 'document_signer_dep_name';

    ActualSignerIdFieldName := 'document_fact_signer_id';
    ActualSignerLeaderIdFieldName := 'document_fact_signer_leader_id';
    ActualSignerNameFieldName := 'document_fact_signer_name';
    ActualSignerSpecialityFieldName := 'fact_signer_speciality';
    ActualSignerDepartmentIdFieldName := 'document_fact_signer_dep_id';
    ActualSignerDepartmentCodeFieldName := 'document_fact_signer_dep_code';
    ActualSignerDepartmentNameFieldName := 'document_charge_fact_perf_dep_name';

  end;

end;

function TDocumentInfoHolderBuilder.GetSelf: TObject;
begin

  Result := Self;
  
end;

function TDocumentInfoHolderBuilder.CreateDocumentInfoFieldNamesInstance: TDocumentInfoFieldNames;
begin

  Result := TDocumentInfoFieldNames.Create;

end;

function TDocumentInfoHolderBuilder.CreateDocumentInfoHolder: TDocumentInfoHolder;
begin

  Result := CreateDocumentInfoHolderInstance;

  Result.FieldNames := CreateDocumentInfoFieldNames;
  
end;

function TDocumentInfoHolderBuilder.CreateDocumentInfoHolderInstance: TDocumentInfoHolder;
begin

  Result := TDocumentInfoHolder.Create;

end;

end.
