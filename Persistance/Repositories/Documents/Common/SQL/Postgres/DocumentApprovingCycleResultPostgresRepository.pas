unit DocumentApprovingCycleResultPostgresRepository;

interface

uses

  AbstractPostgresRepository,
  IEmployeeRepositoryUnit,
  DBTableMapping,
  DomainObjectUnit,
  DomainObjectListUnit,
  ZConnection,
  Employee,
  DocumentApprovings,
  DocumentApprovingCycleResult,
  DocumentApprovingCycleResultRepository,
  AbstractRepositoryCriteriaUnit,
  DocumentApprovingsTableDef,
  DocumentApprovingResultsTableDef,
  Disposable,
  QueryExecutor,
  HistoricalDocumentApprovingPostgresRepository,
  SysUtils,
  Classes,
  DB;

type

  TDocumentApprovingCycleResultPostgresRepository =
    class (TAbstractPostgresRepository, IDocumentApprovingCycleResultRepository)

      protected

        FDocumentApprovingsTableDef: TDocumentApprovingsTableDef;
        FFreeDocumentApprovingsTableDef: IDisposable;

        FDocumentApprovingResultsTableDef: TDocumentApprovingResultsTableDef;
        FFreeDocumentApprovingResultsTableDef: IDisposable;
        
        FHistoricalDocumentApprovingPostgresRepository:
          THistoricalDocumentApprovingPostgresRepository;

        function CreateHistoricalDocumentApprovingPostgresRepository(
          QueryExecutor: IQueryExecutor
        ): THistoricalDocumentApprovingPostgresRepository; virtual;

      protected

        function CreateHistoricalDocumentApprovingsFrom(
          DocumentApprovingCycleResult: TDocumentApprovingCycleResult
        ): THistoricalDocumentApprovings; 
        
      protected

        procedure SetQueryExecutor(const Value: IQueryExecutor); override;

      public

        constructor Create(
          QueryExecutor: IQueryExecutor;
          DocumentApprovingsTableDef: TDocumentApprovingsTableDef;
          DocumentApprovingResultsTableDef: TDocumentApprovingResultsTableDef
        );

        function AreDocumentApprovingCycleResultsExistsForEmployee(
          const DocumentId: Variant;
          const EmployeeId: Variant
        ): Boolean;
        
        function GetApprovingCycleResultCountForDocument(
          const DocumentId: Variant
        ): Integer;

        function FindAllApprovingCycleResultsForDocument(
          const DocumentId: Variant
        ): TDocumentApprovingCycleResults;

        procedure AddDocumentApprovingCycleResult(
          DocumentApprovingCycleResult: TDocumentApprovingCycleResult
        );

        procedure RemoveDocumentApprovingCycleResult(
          DocumentApprovingCycleResult: TDocumentApprovingCycleResult
        );

        procedure RemoveAllApprovingCycleResultsForDocument(
          const DocumentId: Variant
        );
        
    end;
  
implementation

uses

  Variants,
  AbstractRepository,
  DataReader,
  AbstractDBRepository;

type

  TFindLastDocumentApprovingCycleResultForEmployeeCriteria =
    class (TAbstractRepositoryCriterion)

      protected

        FDocumentId: Variant;
        FEmployeeId: Variant;

        FRepository: TDocumentApprovingCycleResultPostgresRepository;

        function GetExpression: String; override;

      public

        constructor Create(
          Repository: TDocumentApprovingCycleResultPostgresRepository;
          const DocumentId: Variant;
          const EmployeeId: Variant
        );

      published

        property DocumentId: Variant read FDocumentId write FDocumentId;
        property EmployeeId: Variant read FEmployeeId write FEmployeeId;
        
    end;


{ TDocumentApprovingCycleResultPostgresRepository }

procedure TDocumentApprovingCycleResultPostgresRepository.
  AddDocumentApprovingCycleResult(
    DocumentApprovingCycleResult: TDocumentApprovingCycleResult
  );
var HistoricalDocumentApprovings: THistoricalDocumentApprovings;
begin

  HistoricalDocumentApprovings :=
    CreateHistoricalDocumentApprovingsFrom(DocumentApprovingCycleResult);

  FHistoricalDocumentApprovingPostgresRepository.
    AddHistoricalDocumentApprovings(HistoricalDocumentApprovings);

  FHistoricalDocumentApprovingPostgresRepository.
    ThrowExceptionIfErrorIsNotUnknown;
    
end;

constructor TDocumentApprovingCycleResultPostgresRepository.Create(
  QueryExecutor: IQueryExecutor;
  DocumentApprovingsTableDef: TDocumentApprovingsTableDef;
  DocumentApprovingResultsTableDef: TDocumentApprovingResultsTableDef
);
begin

  inherited Create;

  FDocumentApprovingsTableDef := DocumentApprovingsTableDef;
  FFreeDocumentApprovingsTableDef := FDocumentApprovingsTableDef;

  FDocumentApprovingResultsTableDef := DocumentApprovingResultsTableDef;
  FFreeDocumentApprovingResultsTableDef := FDocumentApprovingResultsTableDef;
  
  Self.QueryExecutor := QueryExecutor;
  
end;

function TDocumentApprovingCycleResultPostgresRepository.
  CreateHistoricalDocumentApprovingPostgresRepository(
    QueryExecutor: IQueryExecutor
  ): THistoricalDocumentApprovingPostgresRepository;
begin

  Result :=
    THistoricalDocumentApprovingPostgresRepository.Create(
      QueryExecutor,
      FDocumentApprovingsTableDef,
      FDocumentApprovingResultsTableDef
    );
            
end;

function TDocumentApprovingCycleResultPostgresRepository.
  CreateHistoricalDocumentApprovingsFrom(
    DocumentApprovingCycleResult: TDocumentApprovingCycleResult
  ): THistoricalDocumentApprovings;
var OriginalApproving: TDocumentApproving;
begin

  Result := THistoricalDocumentApprovings.Create;

  try

    for OriginalApproving in DocumentApprovingCycleResult.DocumentApprovings
    do begin

      Result.AddDomainObject(
        THistoricalDocumentApproving.Create(
          OriginalApproving,
          DocumentApprovingCycleResult.CycleNumber
        )
      );

    end;

  except

    on e: Exception do begin

      FreeAndNil(Result);

      Raise;
      
    end;

  end;
    
end;

function TDocumentApprovingCycleResultPostgresRepository.
  FindAllApprovingCycleResultsForDocument(
    const DocumentId: Variant
  ): TDocumentApprovingCycleResults;
var HistoricalDocumentApprovings: THistoricalDocumentApprovings;
begin

  HistoricalDocumentApprovings :=
    FHistoricalDocumentApprovingPostgresRepository.
      FindAllHistoricalApprovingsForDocument(DocumentId);

  FHistoricalDocumentApprovingPostgresRepository.
    ThrowExceptionIfErrorIsNotUnknown;

  if not Assigned(HistoricalDocumentApprovings) then
    Result := nil

  else begin
  
    Result :=
      TDocumentApprovingCycleResults.CreateFrom(HistoricalDocumentApprovings);

  end;

end;

function TDocumentApprovingCycleResultPostgresRepository.
  GetApprovingCycleResultCountForDocument(
    const DocumentId: Variant
  ): Integer;
var
    DocumentIdColumnName: String;
    ApprovingCycleIdColumnName: String;
    TableName: String;
    TableMapping: TDBTableMapping;
    ApprovingCycleCountVariant: Variant;
    QueryParams: TQueryParams;
    DataReader: IDataReader;
begin

  TableMapping := FHistoricalDocumentApprovingPostgresRepository.TableMapping;

  TableName := TableMapping.TableName;

  DocumentIdColumnName :=
    TableMapping.
      ColumnMappingsForSelect.
        FindColumnMappingByObjectPropertyName(
          'DocumentId'
        ).ColumnName;

  ApprovingCycleIdColumnName :=
    TableMapping.ColumnMappingsForSelect.
    FindColumnMappingByObjectPropertyName(
      'ApprovingCycleId'
    ).ColumnName;

  QueryParams := TQueryParams.Create;

  try

    QueryParams.Add('p' + DocumentIdColumnName, DocumentId);

    DataReader :=
      SafeQueryExecutor.ExecuteSelectionQuery(
        Format(
          'SELECT COUNT(DISTINCT %s) as result FROM %s WHERE %s=:p%s',
          [
            ApprovingCycleIdColumnName,

            TableName,

            DocumentIdColumnName,
            DocumentIdColumnName
          ]
        ),
        QueryParams
      );

    ApprovingCycleCountVariant := DataReader['result'];

    if VarIsNull(ApprovingCycleCountVariant) then
      Result := 0

    else Result := ApprovingCycleCountVariant;

  finally

    FreeAndNil(QueryParams);
    
  end;

end;

function TDocumentApprovingCycleResultPostgresRepository.
  AreDocumentApprovingCycleResultsExistsForEmployee(
    const DocumentId, EmployeeId: Variant
  ): Boolean;
var
    ApproverIdColumnName: String;
    DocumentIdColumnName: String;
    ApprovingCycleIdColumnName: String;
    TableMapping: TDBTableMapping;
    ResultVariant: Variant;
    QueryTextPattern: String;
    QueryParams: TQueryParams;
    DataReader: IDataReader;
begin

  TableMapping := FHistoricalDocumentApprovingPostgresRepository.TableMapping;

  ApproverIdColumnName :=
    TableMapping.
      ColumnMappingsForSelect.
        FindColumnMappingByObjectPropertyName(
          'Approver'
        ).ColumnName;

  DocumentIdColumnName :=
    TableMapping.
      ColumnMappingsForSelect.
        FindColumnMappingByObjectPropertyName(
          'DocumentId'
        ).ColumnName;

  ApprovingCycleIdColumnName :=
    TableMapping.
      ColumnMappingsForSelect.
        FindColumnMappingByObjectPropertyName(
          'ApprovingCycleId'
        ).ColumnName;

  {
    refactor: рассмотреть вариант загрузки всех согласований,
    связанных с док-ом, и к каждой записе набора данных во время
    его перебора применять спецификацию, пока не будет найдено
    совпадение
  }

  QueryParams := TQueryParams.Create;

  try

    QueryParams
      .AddFluently('p' + DocumentIdColumnName, DocumentId)
      .AddFluently('p' + ApproverIdColumnName, EmployeeId);
      
    QueryTextPattern :=
      Format(
        'SELECT EXISTS(' +
        'SELECT 1 ' +
        'FROM %s ' +
        'WHERE %s=:p%s AND ' +
        '(%s=:p%s or ' +
        'doc.is_employee_acting_for_other_or_vice_versa(:p%s,%s)) ' +
        ' AND %s is not null) as result',
        [
          TableMapping.TableName,

          DocumentIdColumnName,
          DocumentIdColumnName,

          ApproverIdColumnName,
          ApproverIdColumnName,

          ApproverIdColumnName,
          ApproverIdColumnName,

          ApprovingCycleIdColumnName
        ]
      );


    DataReader :=
      SafeQueryExecutor.ExecuteSelectionQuery(QueryTextPattern, QueryParams);

    ResultVariant := DataReader['result'];

    if VarIsNull(ResultVariant) then
      Result := False

    else Result := ResultVariant;

  finally

    FreeAndNil(QueryParams);

  end;

end;

procedure TDocumentApprovingCycleResultPostgresRepository.
  RemoveAllApprovingCycleResultsForDocument(
    const DocumentId: Variant
  );
begin

  FHistoricalDocumentApprovingPostgresRepository.
    RemoveAllHistoricalDocumentApprovings(DocumentId);

  FHistoricalDocumentApprovingPostgresRepository.
    ThrowExceptionIfErrorIsNotUnknown;
    
end;

procedure TDocumentApprovingCycleResultPostgresRepository.
  RemoveDocumentApprovingCycleResult(
    DocumentApprovingCycleResult: TDocumentApprovingCycleResult
  );
begin

  FHistoricalDocumentApprovingPostgresRepository.
    RemoveHistoricalApprovingsForDocument(
      DocumentApprovingCycleResult.DocumentId,
      DocumentApprovingCycleResult.CycleNumber
    );

  FHistoricalDocumentApprovingPostgresRepository.
    ThrowExceptionIfErrorIsNotUnknown;

end;

procedure TDocumentApprovingCycleResultPostgresRepository.SetQueryExecutor(const Value: IQueryExecutor);
begin

  inherited SetQueryExecutor(Value);

  if not Assigned(FHistoricalDocumentApprovingPostgresRepository) then begin

    FHistoricalDocumentApprovingPostgresRepository :=
      CreateHistoricalDocumentApprovingPostgresRepository(Value);
      
  end

  else FHistoricalDocumentApprovingPostgresRepository.QueryExecutor := Value;

end;

{ TFindLastDocumentApprovingCycleResultForEmployeeCriteria }

constructor TFindLastDocumentApprovingCycleResultForEmployeeCriteria.Create(
  Repository: TDocumentApprovingCycleResultPostgresRepository;
  const DocumentId, EmployeeId: Variant);
begin

  inherited Create;

  FRepository := Repository;

  FDocumentId := DocumentId;
  FEmployeeId := EmployeeId;

end;

function TFindLastDocumentApprovingCycleResultForEmployeeCriteria.GetExpression: String;
begin

  raise Exception.Create(
    'TFindLastDocumentApprovingCycleResultForEmployeeCriteria.GetExpression: Not implemented'
  );
  
end;

end.
