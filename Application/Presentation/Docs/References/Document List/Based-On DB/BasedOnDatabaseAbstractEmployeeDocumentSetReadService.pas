unit BasedOnDatabaseAbstractEmployeeDocumentSetReadService;

interface

uses

  AbstractApplicationService,
  EmployeeDocumentSetReadService,
  DocumentSetHolder,
  QueryExecutor,
  DataReader,
  DataSetQueryExecutor,
  AbstractDataReader,
  BasedOnDatabaseAbstractDocumentSetReadService,
  EmployeeDocumentKindAccessRightsService,
  EmployeeDocumentKindAccessRightsInfo,
  DocumentKinds,
  DocumentKindsMapper,
  IEmployeeRepositoryUnit,
  Hashes,
  ArrayTypes,
  VariantListUnit,
  DB,
  SysUtils,
  Classes;

type

  IEmployeeDocumentSetFetchingQueryBuilder = interface

    function BuildEmployeeDocumentSetFetchingQuery(
      const EmployeeId: Variant;
      const Options: IEmployeeDocumentSetReadOptions = nil
    ): String;

    function BuildEmployeeDocumentSubSetByIdsFetchingQuery(
      const EmployeeId: Variant;
      const DocumentIds: TVariantList
    ): String; 

  end;

  TEmployeeDocumentSetFetchingQueryBuilder =
    class abstract (TInterfacedObject, IEmployeeDocumentSetFetchingQueryBuilder)

      protected

        procedure GetEmployeeDocumentSetByOptionsFetchingQueryPatternData(
          Options: IEmployeeDocumentSetReadOptions;
          var QueryPattern: String;
          ParamNames: TStringHash
        ); virtual; abstract;

        procedure GetEmployeeDocumentSetFetchingQueryPatternData(
          var QueryPattern: String;
          ParamNames: TStringHash
        ); virtual; abstract;

        procedure GetEmployeeDocumentSubSetByIdsFetchingQueryPatternData(
          var QueryPattern: String;
          ParamNames: TStringHash
        ); virtual; abstract;

      public

        function BuildEmployeeDocumentSetFetchingQuery(
          const EmployeeId: Variant;
          const Options: IEmployeeDocumentSetReadOptions = nil
        ): String;

        function BuildEmployeeDocumentSubSetByIdsFetchingQuery(
          const EmployeeId: Variant;
          const DocumentIds: TVariantList
        ): String; 

    end;
  
  TBasedOnDatabaseAbstractEmployeeDocumentSetReadService =
    class abstract (
      TBasedOnDatabaseAbstractDocumentSetReadService,
      IEmployeeDocumentSetReadService
    )

      protected

        FDocumentKindClass: TDocumentKindClass;

        FQueryBuilder: IEmployeeDocumentSetFetchingQueryBuilder;
        
        FEmployeeRepository: IEmployeeRepository;
        FEmployeeDocumentKindAccessRightsService: IEmployeeDocumentKindAccessRightsService;

        function ExecuteFetchingEmployeeDocumentSetQuery(
          const EmployeeId: Variant;
          const Options: IEmployeeDocumentSetReadOptions = nil
        ): TDataSet; virtual;

        function ExecuteEmployeeDocumentSubSetByIdsFetchingQuery(
          const EmployeeId: Variant;
          const DocumentIds: TVariantList
        ): TDataSet; virtual;

        procedure SetDocumentSetAccessRightsForEmployee(
          DocumentSetHolder: TDocumentSetHolder;
          const EmployeeId: Variant
        );

        procedure SetDocumentSetOperationAccessRights(
          DocumentSetHolder: TDocumentSetHolder;
          EmployeeDocumentKindAccessRightsInfo: TEmployeeDocumentKindAccessRightsInfo
        ); virtual;
        
      public

        constructor Create(
          DocumentKindClass: TDocumentKindClass;
          EmployeeRepository: IEmployeeRepository;
          EmployeeDocumentKindAccessRightsService: IEmployeeDocumentKindAccessRightsService;
          QueryExecutor: TDataSetQueryExecutor;
          QueryBuilder: IEmployeeDocumentSetFetchingQueryBuilder
        );

        function GetEmployeeDocumentSet(const EmployeeId: Variant; const Options: IEmployeeDocumentSetReadOptions = nil): TDocumentSetHolder;
        function GetEmployeeDocumentSubSetByIds(const EmployeeId: Variant; DocumentIds: array of Variant): TDocumentSetHolder; overload;
        function GetEmployeeDocumentSubSetByIds(const EmployeeId: Variant; const DocumentIds: TVariantList): TDocumentSetHolder; overload;

    end;

implementation

uses

  Employee,
  IDomainObjectBaseUnit,
  SelectDocumentRecordsViewQueries,
  AuxDataSetFunctionsUnit,
  ZQueryExecutor,
  AuxDebugFunctionsUnit,
  AuxiliaryStringFunctions,
  ArrayFunctions,
  SQLCastingFunctions,
  StrUtils,
  Variants;

{ TBasedOnDatabaseAbstractEmployeeDocumentSetReadService }

constructor TBasedOnDatabaseAbstractEmployeeDocumentSetReadService.Create(
  DocumentKindClass: TDocumentKindClass;
  EmployeeRepository: IEmployeeRepository;
  EmployeeDocumentKindAccessRightsService: IEmployeeDocumentKindAccessRightsService;
  QueryExecutor: TDataSetQueryExecutor;
  QueryBuilder: IEmployeeDocumentSetFetchingQueryBuilder
);
begin

  inherited Create(QueryExecutor);

  FDocumentKindClass := DocumentKindClass;
  
  FQueryBuilder := QueryBuilder;
  
  FEmployeeRepository := EmployeeRepository;
  FEmployeeDocumentKindAccessRightsService := EmployeeDocumentKindAccessRightsService;
  
end;

function TBasedOnDatabaseAbstractEmployeeDocumentSetReadService.GetEmployeeDocumentSet(
  const EmployeeId: Variant;
  const Options: IEmployeeDocumentSetReadOptions
): TDocumentSetHolder;
begin

  Result := CreateDocumentSetHolder;

  try

    Result.DataSet :=
      ExecuteFetchingEmployeeDocumentSetQuery(
        //FDocumentSetFetchingQueryPattern,
        EmployeeId, Options
      );

    SetDocumentSetAccessRightsForEmployee(Result, EmployeeId);

  except

    FreeAndNil(Result);

    Raise;

  end;

end;

function TBasedOnDatabaseAbstractEmployeeDocumentSetReadService.GetEmployeeDocumentSubSetByIds(
  const EmployeeId: Variant; DocumentIds: array of Variant
): TDocumentSetHolder;
var
    DocumentIdList: TVariantList;
begin

  DocumentIdList := TVariantList.CreateFrom(DocumentIds);

  try

    Result := GetEmployeeDocumentSubSetByIds(EmployeeId, DocumentIdList);
    
  finally

    FreeAndNil(DocumentIdList);

  end;

end;

function TBasedOnDatabaseAbstractEmployeeDocumentSetReadService.GetEmployeeDocumentSubSetByIds(
  const EmployeeId: Variant;
  const DocumentIds: TVariantList): TDocumentSetHolder;
begin

  Result := CreateDocumentSetHolder;

  try

    Result.DataSet :=
      ExecuteEmployeeDocumentSubSetByIdsFetchingQuery(EmployeeId, DocumentIds);

    SetDocumentSetAccessRightsForEmployee(Result, EmployeeId);
    
  except

    FreeAndNil(Result);

    Raise;

  end;

end;

function TBasedOnDatabaseAbstractEmployeeDocumentSetReadService.
  ExecuteFetchingEmployeeDocumentSetQuery(
    const EmployeeId: Variant;
    const Options: IEmployeeDocumentSetReadOptions
  ): TDataSet;
begin

  Result :=
    TDataSetQueryExecutor(FQueryExecutor.Self)
      .PrepareDataSet(
        FQueryBuilder.BuildEmployeeDocumentSetFetchingQuery(
          EmployeeId, Options
        )
      );

end;

function TBasedOnDatabaseAbstractEmployeeDocumentSetReadService.
  ExecuteEmployeeDocumentSubSetByIdsFetchingQuery(
    const EmployeeId: Variant;
    const DocumentIds: TVariantList
  ): TDataSet;
var
    DataReader: IDataReader;
begin

  DataReader :=
    FQueryExecutor.ExecuteSelectionQuery(
      FQueryBuilder.BuildEmployeeDocumentSubSetByIdsFetchingQuery(
        EmployeeId, DocumentIds
      )
    );

  Result := TAbstractDataReader(DataReader.Self).ToDataSet;

end;

procedure TBasedOnDatabaseAbstractEmployeeDocumentSetReadService.SetDocumentSetAccessRightsForEmployee(
  DocumentSetHolder: TDocumentSetHolder;
  const EmployeeId: Variant
);

var
    Employee: TEmployee;
    FreeEmployee: IDomainObjectBase;

    EmployeeDocumentKindAccessRightsInfo: TEmployeeDocumentKindAccessRightsInfo;
    FreeEmployeeDocumentKindAccessRightsInfo: IDomainObjectBase;
begin

  Employee := FEmployeeRepository.FindEmployeeById(EmployeeId);

  FreeEmployee := Employee;

  EmployeeDocumentKindAccessRightsInfo :=
    FEmployeeDocumentKindAccessRightsService
      .EnsureThatEmployeeHasAnyDocumentKindAccessRightsAndGetAll(
        TDocumentKindsMapper.MapDocumentKindToDomainDocumentKind(
          FDocumentKindClass
        ),
      Employee
    );

  FreeEmployeeDocumentKindAccessRightsInfo := EmployeeDocumentKindAccessRightsInfo;

  SetDocumentSetOperationAccessRights(DocumentSetHolder, EmployeeDocumentKindAccessRightsInfo);

end;

procedure TBasedOnDatabaseAbstractEmployeeDocumentSetReadService.SetDocumentSetOperationAccessRights(
  DocumentSetHolder: TDocumentSetHolder;
  EmployeeDocumentKindAccessRightsInfo: TEmployeeDocumentKindAccessRightsInfo
);
begin

  with DocumentSetHolder, EmployeeDocumentKindAccessRightsInfo do begin

    ViewAllowed := CanViewDocuments;
    AddingAllowed := CanCreateDocuments;
    EditingAllowed := CanEditDocuments;
    RemovingAllowed := CanRemoveDocuments;

  end;

end;

{ TEmployeeDocumentSetFetchingQueryBuilder }

function TEmployeeDocumentSetFetchingQueryBuilder
  .BuildEmployeeDocumentSetFetchingQuery(
    const EmployeeId: Variant;
    const Options: IEmployeeDocumentSetReadOptions
  ): String;
var
    QueryPattern: String;
    ParamNames: TStringHash;
    ParamValues: TVariantArray;
begin

  ParamNames := TStringHash.Create;

  try

    if
      not Assigned(Options)
      or (Options.SelectedDocumentWorkCycleStageNames.Count = 0)
    then begin

      GetEmployeeDocumentSetFetchingQueryPatternData(
        QueryPattern,
        ParamNames
      );

      Result :=
        ReplaceStr(
          QueryPattern,
          ParamNames['EmployeeId'],
          AsSQLString(EmployeeId)
        );

    end
    
    else begin

      GetEmployeeDocumentSetByOptionsFetchingQueryPatternData(
        Options,
        QueryPattern,
        ParamNames
      );

      Result :=
        ReplaceStrings(
          QueryPattern,
          [
            ParamNames['EmployeeId'],
            ParamNames['StageNames']
          ],
          [
            AsSQLString(EmployeeId),
            CreateSQLValueListString(Options.SelectedDocumentWorkCycleStageNames)
          ]
        );

    end

  finally

    FreeAndNil(ParamNames);
    
  end;

end;

function TEmployeeDocumentSetFetchingQueryBuilder
  .BuildEmployeeDocumentSubSetByIdsFetchingQuery(
    const EmployeeId: Variant;
    const DocumentIds: TVariantList
  ): String;
var
    QueryPattern: String;
    ParamNames: TStringHash;
begin

  ParamNames := TStringHash.Create;

  try

    GetEmployeeDocumentSubSetByIdsFetchingQueryPatternData(
      QueryPattern,
      ParamNames
    );

    Result :=
      ReplaceStrings(
        QueryPattern,
        [
          ParamNames['EmployeeId'],
          ParamNames['DocumentIds']
        ],
        [
          AsSQLString(EmployeeId),
          CreateSQLValueListString(DocumentIds)
        ]
      );

  finally

    FreeAndNil(ParamNames);

  end;

end;

end.
