unit BasedOnDatabaseDepartmentSetReadService;

interface

uses

  AbstractApplicationService,
  DepartmentSetReadService,
  DepartmentSetHolder,
  AbstractQueryExecutor,
  QueryExecutor,
  DataSetQueryExecutor,
  DataReader,
  DepartmentDbSchema,
  DB,
  AbstractDataReader,
  SysUtils;

type

  TBasedOnDatabaseDepartmentSetReadService =
    class (TAbstractApplicationService, IDepartmentSetReadService)

      private

        FDepartmentSetFetchingQueryPattern: String;

        function PrepareDepartmentSetFetchingQueryPattern(
          const DepartmentDbSchema: TDepartmentDbSchema
        ): String;
        
      private

        FQueryExecutor: IQueryExecutor;
        FDepartmentDbSchema: TDepartmentDbSchema;

        function ExecuteDepartmentSetFetchingQuery(
          const QueryPattern: String
        ): IDataReader;

        procedure ExecuteDepartmentSetFetchingQueryAsync(
          const QueryPattern: String;
          SuccessedEventHandler: TDepartmentSetGettingSuccessedEventHandler;
          FailedEventHandler: TDepartmentSetGettingFailedEventHandler
        );

        procedure OnSelectionQuerySuccessedEventHandler(
          Sender: TObject;
          DataReader: IDataReader;
          RelatedState: TObject
        );

        procedure OnSelectionQueryFailedEventHandler(
          Sender: TObject;
          const Error: TQueryExecutingError;
          RelatedState: TObject
        );

      private

        function CreateDepartmentSetHolderFrom(
          DepartmentSet: TDataSet;
          DepartmentDbSchema: TDepartmentDbSchema
          
        ): TDepartmentSetHolder;

      public

        destructor Destroy; override;
        
        constructor Create(
          QueryExecutor: TDataSetQueryExecutor;
          DepartmentDbSchema: TDepartmentDbSchema
        );
        
        function GetDepartmentSet: TDepartmentSetHolder;

        function GetPreparedDepartmentSet: TDepartmentSetHolder;
        
        procedure GetDepartmentSetAsync(
          SuccessedEventHandler: TDepartmentSetGettingSuccessedEventHandler;
          FailedEventHandler: TDepartmentSetGettingFailedEventHandler
        );

    end;

implementation
  
type

  TDepartmentSetGettingAsyncEventHandlers = class

    public

      constructor Create(
        SuccessedEventHandler: TDepartmentSetGettingSuccessedEventHandler;
        FailedEventHandler: TDepartmentSetGettingFailedEventHandler
      );

    public
    
      SuccessedEventHandler: TDepartmentSetGettingSuccessedEventHandler;
      FailedEventHandler: TDepartmentSetGettingFailedEventHandler;

      
  end;

{ TBasedOnDatabaseDepartmentSetReadService }

constructor TBasedOnDatabaseDepartmentSetReadService.Create(
  QueryExecutor: TDataSetQueryExecutor;
  DepartmentDbSchema: TDepartmentDbSchema
);
begin

  inherited Create;

  FQueryExecutor := QueryExecutor;
  FDepartmentDbSchema := DepartmentDbSchema;

  FDepartmentSetFetchingQueryPattern :=
    PrepareDepartmentSetFetchingQueryPattern(DepartmentDbSchema);

end;

function TBasedOnDatabaseDepartmentSetReadService.
  PrepareDepartmentSetFetchingQueryPattern(
    const DepartmentDbSchema: TDepartmentDbSchema
  ): String;
begin

  Result :=
    Format(
      'SELECT FALSE AS %s, %s, %s, %s, %s FROM %s WHERE %s IS NULL',
      [
        'is_selected',
        DepartmentDbSchema.IdColumnName,
        DepartmentDbSchema.CodeColumnName,
        DepartmentDbSchema.ShortNameColumnName,
        DepartmentDbSchema.FullNameColumnName,
        DepartmentDbSchema.TableName,
        DepartmentDbSchema.InActiveStatusColumnName
      ]
    );
    
end;

destructor TBasedOnDatabaseDepartmentSetReadService.Destroy;
begin

  FreeAndNil(FDepartmentDbSchema);
  
  inherited;

end;

function TBasedOnDatabaseDepartmentSetReadService.
  GetDepartmentSet: TDepartmentSetHolder;
var
    DataReader: IDataReader;
begin
                     
  DataReader := ExecuteDepartmentSetFetchingQuery(FDepartmentSetFetchingQueryPattern);

  Result :=
    CreateDepartmentSetHolderFrom(
      TAbstractDataReader(DataReader.Self).ToDataSet,
      FDepartmentDbSchema
    );

end;

function TBasedOnDatabaseDepartmentSetReadService.
  ExecuteDepartmentSetFetchingQuery(const QueryPattern: String): IDataReader;
begin

  Result := FQueryExecutor.ExecuteSelectionQuery(QueryPattern);
  
end;

function TBasedOnDatabaseDepartmentSetReadService.CreateDepartmentSetHolderFrom(
  DepartmentSet: TDataSet;
  DepartmentDbSchema: TDepartmentDbSchema
): TDepartmentSetHolder;
begin

  Result := TDepartmentSetHolder.CreateFrom(DepartmentSet);

  try

    Result.FieldDefs := TDepartmentSetFieldDefs.Create;

    with Result.FieldDefs do begin

      IsSelectedFieldName := 'is_selected';
      DepartmentIdFieldName := DepartmentDbSchema.IdColumnName;
      CodeFieldName := DepartmentDbSchema.CodeColumnName;
      ShortNameFieldName := DepartmentDbSchema.ShortNameColumnName;
      FullNameFieldName := DepartmentDbSchema.FullNameColumnName;

    end;

  except

    on E: Exception do begin

      FreeAndNil(Result);

      Raise;

    end;

  end;

end;

procedure TBasedOnDatabaseDepartmentSetReadService.GetDepartmentSetAsync(
  SuccessedEventHandler: TDepartmentSetGettingSuccessedEventHandler;
  FailedEventHandler: TDepartmentSetGettingFailedEventHandler
);
begin

  ExecuteDepartmentSetFetchingQueryAsync(
    FDepartmentSetFetchingQueryPattern,
    SuccessedEventHandler,
    FailedEventHandler
  );
  
end;

function TBasedOnDatabaseDepartmentSetReadService.
  GetPreparedDepartmentSet: TDepartmentSetHolder;
begin

  Result :=
    CreateDepartmentSetHolderFrom(

      TDataSetQueryExecutor(FQueryExecutor.Self).PrepareDataSet(
        FDepartmentSetFetchingQueryPattern
      ),

      FDepartmentDbSchema
    );
    
end;

procedure TBasedOnDatabaseDepartmentSetReadService.
  ExecuteDepartmentSetFetchingQueryAsync(
    const QueryPattern: String;
    SuccessedEventHandler: TDepartmentSetGettingSuccessedEventHandler;
    FailedEventHandler: TDepartmentSetGettingFailedEventHandler
  );
begin

  FQueryExecutor.ExecuteSelectionQueryAsync(
    QueryPattern,
    nil,
    TDepartmentSetGettingAsyncEventHandlers.Create(
      SuccessedEventHandler,
      FailedEventHandler
    ),
    OnSelectionQuerySuccessedEventHandler,
    OnSelectionQueryFailedEventHandler
  );

end;

procedure TBasedOnDatabaseDepartmentSetReadService.
  OnSelectionQueryFailedEventHandler(
    Sender: TObject;
    const Error: TQueryExecutingError;
    RelatedState: TObject
  );
var
    DepartmentSetGettingAsyncEventHandlers: TDepartmentSetGettingAsyncEventHandlers;
    SelfError: TDepartmentSetReadServiceException;
begin

  DepartmentSetGettingAsyncEventHandlers :=
    TDepartmentSetGettingAsyncEventHandlers(RelatedState);

  SelfError := TDepartmentSetReadServiceException.Create(Error.Message);

  try
  
    DepartmentSetGettingAsyncEventHandlers.FailedEventHandler(Self, SelfError);

  finally

    FreeAndNil(SelfError);
    FreeAndNil(RelatedState);

  end;

end;

procedure TBasedOnDatabaseDepartmentSetReadService.
  OnSelectionQuerySuccessedEventHandler(
    Sender: TObject;
    DataReader: IDataReader;
    RelatedState: TObject
  );
var
    DepartmentSetGettingAsyncEventHandlers: TDepartmentSetGettingAsyncEventHandlers;
begin

  DepartmentSetGettingAsyncEventHandlers :=
    TDepartmentSetGettingAsyncEventHandlers(RelatedState);

  DepartmentSetGettingAsyncEventHandlers.SuccessedEventHandler(
    Self,
    CreateDepartmentSetHolderFrom(
      TAbstractDataReader(DataReader.Self).ToDataSet,
      FDepartmentDbSchema
    )
  );


end;

{ TDepartmentSetGettingAsyncEventHandlers }

constructor TDepartmentSetGettingAsyncEventHandlers.Create(
  SuccessedEventHandler: TDepartmentSetGettingSuccessedEventHandler;
  FailedEventHandler: TDepartmentSetGettingFailedEventHandler
);
begin

  inherited Create;

  Self.SuccessedEventHandler := SuccessedEventHandler;
  Self.FailedEventHandler := FailedEventHandler;
  
end;

end.
