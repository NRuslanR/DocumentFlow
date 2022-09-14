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

    DocumentApprovingIdFieldName := 'approving_id';
    DocumentApprovingPerformingDateTimeFieldName := 'approving_performing_date';
    DocumentApprovingPerformingResultIdFieldName := 'approving_performing_result_id';
    DocumentApprovingIsAccessibleFieldName := 'document_approving_accessible';
    DocumentApprovingPerformingResultFieldName := 'approving_performing_result';
    DocumentApprovingNoteFieldName := 'approving_note';
    DocumentApprovingCycleIdFieldName := 'approving_cycle_id';
    DocumentApprovingCycleNumberFieldName := 'approving_cycle_number';
    DocumentApprovingIsCompletedFieldName := 'approving_is_completed';
    DocumentApprovingIsLookedByApproverFieldName := 'approving_is_looked_by_approver';

    DocumentApproverIdFieldName := 'approver_id';
    DocumentApproverLeaderIdFieldName := 'approver_leader_id';
    DocumentApproverIsForeignFieldName := 'approver_is_foreign';
    DocumentApproverNameFieldName := 'approver_name';
    DocumentApproverSpecialityFieldName := 'approver_speciality';
    DocumentApproverDepartmentIdFieldName := 'approver_dep_id';
    DocumentApproverDepartmentCodeFieldName := 'approver_dep_code';
    DocumentApproverDepartmentNameFieldName := 'approver_dep_name';

    DocumentActualApproverIdFieldName := 'fact_approver_id';
    DocumentActualApproverLeaderIdFieldName := 'fact_approver_leader_id';
    DocumentActualApproverIsForeignFieldName := 'fact_approver_is_foreign';
    DocumentActualApproverNameFieldName := 'fact_approver_name';
    DocumentActualApproverSpecialityFieldName := 'fact_approver_speciality';
    DocumentActualApproverDepartmentIdFieldName := 'fact_approver_dep_id';
    DocumentActualApproverDepartmentCodeFieldName := 'fact_approver_dep_code';
    DocumentActualApproverDepartmentNameFieldName := 'fact_approver_dep_name';

  end;

end;

function TFullDocumentApprovingsInfoHolderBuilder
  .CreateFullDocumentApprovingsInfoHolderInstance: TDocumentApprovingsInfoHolder;
begin

  Result := TDocumentApprovingsInfoHolder.Create;

end;

end.
