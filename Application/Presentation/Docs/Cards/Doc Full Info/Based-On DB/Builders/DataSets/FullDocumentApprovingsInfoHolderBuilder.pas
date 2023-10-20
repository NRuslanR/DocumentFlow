unit FullDocumentApprovingsInfoHolderBuilder;

interface

uses

  FullDocumentApprovingsInfoQueryBuilder,
  DocumentApprovingsInfoHolder,
  QueryExecutor,
  DataSetQueryExecutor,
  DataSetDataReader,
  DB,
  SysUtils;

type

  IFullDocumentApprovingsInfoHolderBuilder = interface

    function BuildFullDocumentApprovingsInfoHolder(
      const DocumentId: Variant
    ): TDocumentApprovingsInfoHolder;
    
  end;

  TFullDocumentApprovingsInfoHolderBuilder =
    class (TInterfacedObject, IFullDocumentApprovingsInfoHolderBuilder)

      protected

        function CreateFullDocumentApprovingsInfoHolderInstance: TDocumentApprovingsInfoHolder; virtual;
        function CreateFullDocumentApprovingsInfoFieldNames: TDocumentApprovingsInfoFieldNames; virtual;
        function CreateFullDocumentApprovingsInfoFieldNamesInstance: TDocumentApprovingsInfoFieldNames; virtual;
        procedure FillFullDocumentApprovingsInfoFieldNames(FieldNames: TDocumentApprovingsInfoFieldNames); virtual;

      protected

        function CreateFullDocumentApprovingsInfoDataSet(
          DocumentId: Variant;
          FieldNames: TDocumentApprovingsInfoFieldNames
        ): TDataSet;

      protected

        FFullDocumentApprovingsInfoQueryBuilder: IFullDocumentApprovingsInfoQueryBuilder;
        FQueryExecutor: TDataSetQueryExecutor;

      public

        constructor Create(
          FullDocumentApprovingsInfoQueryBuilder: IFullDocumentApprovingsInfoQueryBuilder;
          QueryExecutor: TDataSetQueryExecutor
        );
        
        function BuildFullDocumentApprovingsInfoHolder(
          const DocumentId: Variant
        ): TDocumentApprovingsInfoHolder;

    end;

implementation

{ TFullDocumentApprovingsInfoHolderBuilder }

function TFullDocumentApprovingsInfoHolderBuilder
  .BuildFullDocumentApprovingsInfoHolder(
    const DocumentId: Variant
  ): TDocumentApprovingsInfoHolder;
begin

  Result := CreateFullDocumentApprovingsInfoHolderInstance;

  try

    Result.FieldNames := CreateFullDocumentApprovingsInfoFieldNames;
    Result.DataSet := CreateFullDocumentApprovingsInfoDataSet(DocumentId, Result.FieldNames);

  except

    FreeAndNil(Result);

    Raise;
    
  end;
  
end;

constructor TFullDocumentApprovingsInfoHolderBuilder.Create(
  FullDocumentApprovingsInfoQueryBuilder: IFullDocumentApprovingsInfoQueryBuilder;
  QueryExecutor: TDataSetQueryExecutor);
begin

  inherited Create;

  FFullDocumentApprovingsInfoQueryBuilder := FullDocumentApprovingsInfoQueryBuilder;
  FQueryExecutor := QueryExecutor;
  
end;

function TFullDocumentApprovingsInfoHolderBuilder.CreateFullDocumentApprovingsInfoDataSet(
  DocumentId: Variant;
  FieldNames: TDocumentApprovingsInfoFieldNames
): TDataSet;
var
    QueryParams: TQueryParams;
    Query: String;
begin

  Query :=
    FFullDocumentApprovingsInfoQueryBuilder
      .BuildFullDocumentApprovingsInfoQuery(FieldNames, 'pdocument_id');

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

function TFullDocumentApprovingsInfoHolderBuilder
  .CreateFullDocumentApprovingsInfoFieldNames: TDocumentApprovingsInfoFieldNames;
begin

  Result := CreateFullDocumentApprovingsInfoFieldNamesInstance;

  FillFullDocumentApprovingsInfoFieldNames(Result);

end;

function TFullDocumentApprovingsInfoHolderBuilder.
  CreateFullDocumentApprovingsInfoFieldNamesInstance: TDocumentApprovingsInfoFieldNames;
begin

  Result := TDocumentApprovingsInfoFieldNames.Create;

end;

procedure TFullDocumentApprovingsInfoHolderBuilder.FillFullDocumentApprovingsInfoFieldNames(
  FieldNames: TDocumentApprovingsInfoFieldNames);
begin

  with FieldNames do begin

    IdFieldName := 'approving_id';
    PerformingDateTimeFieldName := 'approving_performing_date';
    PerformingResultIdFieldName := 'approving_performing_result_id';
    IsAccessibleFieldName := 'document_approving_accessible';
    PerformingResultFieldName := 'approving_performing_result';
    PerformingResultServiceNameFieldName := 'approving_performing_result_service_name';
    NoteFieldName := 'approving_note';
    CycleIdFieldName := 'approving_cycle_id';
    CycleNumberFieldName := 'approving_cycle_number';
    IsCompletedFieldName := 'approving_is_completed';
    IsLookedByApproverFieldName := 'approving_is_looked_by_approver';

    ApproverIdFieldName := 'approver_id';
    ApproverLeaderIdFieldName := 'approver_leader_id';
    ApproverIsForeignFieldName := 'approver_is_foreign';
    ApproverNameFieldName := 'approver_name';
    ApproverSpecialityFieldName := 'approver_speciality';
    ApproverDepartmentIdFieldName := 'approver_dep_id';
    ApproverDepartmentCodeFieldName := 'approver_dep_code';
    ApproverDepartmentNameFieldName := 'approver_dep_name';

    ActualApproverIdFieldName := 'fact_approver_id';
    ActualApproverLeaderIdFieldName := 'fact_approver_leader_id';
    ActualApproverIsForeignFieldName := 'fact_approver_is_foreign';
    ActualApproverNameFieldName := 'fact_approver_name';
    ActualApproverSpecialityFieldName := 'fact_approver_speciality';
    ActualApproverDepartmentIdFieldName := 'fact_approver_dep_id';
    ActualApproverDepartmentCodeFieldName := 'fact_approver_dep_code';
    ActualApproverDepartmentNameFieldName := 'fact_approver_dep_name';

  end;

end;

function TFullDocumentApprovingsInfoHolderBuilder
  .CreateFullDocumentApprovingsInfoHolderInstance: TDocumentApprovingsInfoHolder;
begin

  Result := TDocumentApprovingsInfoHolder.Create;

end;

end.
