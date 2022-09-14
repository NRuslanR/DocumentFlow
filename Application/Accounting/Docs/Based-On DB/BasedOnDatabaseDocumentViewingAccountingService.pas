unit BasedOnDatabaseDocumentViewingAccountingService;

interface

uses

  DocumentViewingAccountingService,
  AbstractApplicationService,
  QueryExecutor,
  DataReader,
  ZConnection,
  ZDataset,
  SysUtils,
  Classes;

type

  TLookedDocumentsDbSchema = record

    TableName: String;
    
    IdColumnName: String;
    DocumentIdColumnName: String;
    EmployeeIdColumnName: String;
    ViewDateColumnName: String;
    
  end;

  TBasedOnDatabaseDocumentViewingAccountingService =
    class abstract (TAbstractApplicationService, IDocumentViewingAccountingService)

      protected

        FQueryExecutor: IQueryExecutor;
        FLookedDocumentsDbSchema: TLookedDocumentsDbSchema;

      protected

        FDocumentViewDateByEmployeeGettingQueryPattern: String;
        FDocumentViewDateByEmployeeUpdatingQueryPattern: String;
        FDocumentAsViewedByEmployeeMarkingQueryPattern: String;
        
        function PrepareDocumentViewDateByEmployeeGettingQueryPattern(
          LookedDocumentsDbSchema: TLookedDocumentsDbSchema
        ): String; virtual;

        function PrepareDocumentAsViewedByEmployeeMarkingQueryPattern(
          LookedDocumentsDbSchema: TLookedDocumentsDbSchema
        ): String; virtual;

        function PrepareDocumentViewDateByEmployeeUpdatingQueryPattern(
          LookedDocumentsDbSchema: TLookedDocumentsDbSchema
        ): String; virtual;
        
      protected

        function ExecuteDocumentViewDateByEmployeeGettingQuery(
          const QueryPattern: String;
          const DocumentId, EmployeeId: Variant
        ): IDataReader; virtual;

        function CreateDocumentViewDateByEmployeeGettingQueryParamsFrom(
          const DocumentId, EmployeeId: Variant
        ): TQueryParams; virtual;
        
        procedure ExecuteDocumentAsViewedByEmployeeMarkingQuery(
          const QueryPattern: String;
          const DocumentId, EmployeeId: Variant;
          const ViewDate: TDateTime
        ); virtual;

        function CreateDocumentAsViewedByEmployeeMarkingQueryParamsFrom(
          const DocumentId, EmployeeId: Variant;
          const ViewDate: TDateTime
        ): TQueryParams; virtual;
        
        procedure ExecuteDocumentViewDateByEmployeeUpdatingQuery(
          const QueryPattern: String;
          const DocumentId, EmployeeId: Variant;
          const ViewDate: TDateTime
        ); virtual;

        function CreateDocumentViewDateByEmployeeUpdatingQueryParamsFrom(
          const DocumentId, EmployeeId: Variant;
          const ViewDate: TDateTime
        ): TQueryParams; virtual;
        
      public

        destructor Destroy; override;

        constructor Create(
          LookedDocumentsDbSchema: TLookedDocumentsDbSchema;
          QueryExecutor: IQueryExecutor
        );

        function IsDocumentViewedByEmployee(
          const DocumentId, EmployeeId: Variant
        ): Boolean;

        function GetDocumentViewDateByEmployee(
          const DocumentId, EmployeeId: Variant
        ): Variant;

        procedure MarkDocumentAsViewedByEmployee(
          const DocumentId: Variant;
          const EmployeeId: Variant;
          const ViewDate: TDateTime
        );

        procedure MarkDocumentAsViewedByEmployeeIfItIsNotViewed(
          const DocumentId: Variant;
          const EmployeeId: Variant;
          const ViewDate: TDateTime
        );

    end;

implementation

uses

  Variants;
  
{ TBasedOnDatabaseDocumentViewingAccountingService }

constructor TBasedOnDatabaseDocumentViewingAccountingService.Create(
  LookedDocumentsDbSchema: TLookedDocumentsDbSchema;
  QueryExecutor: IQueryExecutor
);
begin

  inherited Create;

  FLookedDocumentsDbSchema := LookedDocumentsDbSchema;
  FQueryExecutor := QueryExecutor;

  FDocumentViewDateByEmployeeGettingQueryPattern :=
    PrepareDocumentViewDateByEmployeeGettingQueryPattern(LookedDocumentsDbSchema);

  FDocumentAsViewedByEmployeeMarkingQueryPattern :=
    PrepareDocumentAsViewedByEmployeeMarkingQueryPattern(LookedDocumentsDbSchema);

  FDocumentViewDateByEmployeeUpdatingQueryPattern :=
    PrepareDocumentViewDateByEmployeeUpdatingQueryPattern(LookedDocumentsDbSchema);
    
end;

destructor TBasedOnDatabaseDocumentViewingAccountingService.Destroy;
begin

  inherited;

end;

function TBasedOnDatabaseDocumentViewingAccountingService.
  GetDocumentViewDateByEmployee(
    const DocumentId, EmployeeId: Variant
  ): Variant;
var
    DataReader: IDataReader;
begin

  DataReader :=
    ExecuteDocumentViewDateByEmployeeGettingQuery(
      FDocumentViewDateByEmployeeGettingQueryPattern,
      DocumentId,
      EmployeeId
    );

  Result := DataReader[FLookedDocumentsDbSchema.ViewDateColumnName];
  
end;

function TBasedOnDatabaseDocumentViewingAccountingService.IsDocumentViewedByEmployee(
  const DocumentId, EmployeeId: Variant
): Boolean;

begin

  Result := not VarIsNull(GetDocumentViewDateByEmployee(DocumentId, EmployeeId));
  
end;

procedure TBasedOnDatabaseDocumentViewingAccountingService.
  MarkDocumentAsViewedByEmployee(
    const DocumentId, EmployeeId: Variant;
    const ViewDate: TDateTime
  );
begin

  ExecuteDocumentAsViewedByEmployeeMarkingQuery(
    FDocumentAsViewedByEmployeeMarkingQueryPattern,
    DocumentId,
    EmployeeId,
    ViewDate
  );

end;

procedure TBasedOnDatabaseDocumentViewingAccountingService.
  MarkDocumentAsViewedByEmployeeIfItIsNotViewed(
    const DocumentId, EmployeeId: Variant;
    const ViewDate: TDateTime
  );
var
    DataReader: IDataReader;
begin

  DataReader :=
    ExecuteDocumentViewDateByEmployeeGettingQuery(
      FDocumentViewDateByEmployeeGettingQueryPattern,
      DocumentId,
      EmployeeId
    );

  if DataReader.RecordCount = 0 then
    MarkDocumentAsViewedByEmployee(DocumentId, EmployeeId, ViewDate)

  else if VarIsNull(DataReader[FLookedDocumentsDbSchema.ViewDateColumnName])
  then begin

    ExecuteDocumentViewDateByEmployeeUpdatingQuery(
      FDocumentViewDateByEmployeeUpdatingQueryPattern,
      DocumentId,
      EmployeeId,
      ViewDate
    );

  end;

end;

procedure TBasedOnDatabaseDocumentViewingAccountingService.
  ExecuteDocumentAsViewedByEmployeeMarkingQuery(
    const QueryPattern: String;
    const DocumentId, EmployeeId: Variant;
    const ViewDate: TDateTime
  );
var
    QueryParams: TQueryParams;
begin

  QueryParams :=
    CreateDocumentAsViewedByEmployeeMarkingQueryParamsFrom(
      DocumentId, EmployeeId, ViewDate
    );

  try

    FQueryExecutor.ExecuteModificationQuery(QueryPattern, QueryParams);
    
  finally

    FreeAndNil(QueryParams);

  end;

end;

function TBasedOnDatabaseDocumentViewingAccountingService.
  CreateDocumentAsViewedByEmployeeMarkingQueryParamsFrom(
    const DocumentId, EmployeeId: Variant;
    const ViewDate: TDateTime
  ): TQueryParams;
begin

  Result := TQueryParams.Create;

  try

    Result
      .AddFluently(
        'p' + FLookedDocumentsDbSchema.DocumentIdColumnName, DocumentId
      )
      .AddFluently(
        'p' + FLookedDocumentsDbSchema.EmployeeIdColumnName, EmployeeId
      )
      .AddFluently(
        'p' + FLookedDocumentsDbSchema.ViewDateColumnName, ViewDate
      );

  except

    on E: Exception do begin

      FreeAndNil(Result);

      Raise;
      
    end;

  end;
  
end;

function TBasedOnDatabaseDocumentViewingAccountingService.
  ExecuteDocumentViewDateByEmployeeGettingQuery(
    const QueryPattern: String;
    const DocumentId, EmployeeId: Variant
  ): IDataReader;
var
    QueryParams: TQueryParams;
begin

  QueryParams :=
    CreateDocumentViewDateByEmployeeGettingQueryParamsFrom(
      DocumentId, EmployeeId
    );

  try

    Result := FQueryExecutor.ExecuteSelectionQuery(QueryPattern, QueryParams);
    
  finally

    FreeAndNil(QueryParams);

  end;
  
end;

function TBasedOnDatabaseDocumentViewingAccountingService.
  CreateDocumentViewDateByEmployeeGettingQueryParamsFrom(
    const DocumentId, EmployeeId: Variant
  ): TQueryParams;
begin

  Result := TQueryParams.Create;

  try

    Result
      .AddFluently(
        'p' + FLookedDocumentsDbSchema.DocumentIdColumnName, DocumentId
      )
      .AddFluently(
        'p' + FLookedDocumentsDbSchema.EmployeeIdColumnName, EmployeeId
      );
    
  except

    on E: Exception do begin

      FreeAndNil(Result);

      Raise;
      
    end;

  end;
  
end;

procedure TBasedOnDatabaseDocumentViewingAccountingService.
  ExecuteDocumentViewDateByEmployeeUpdatingQuery(
    const QueryPattern: String;
    const DocumentId, EmployeeId: Variant;
    const ViewDate: TDateTime
  );
var
    QueryParams: TQueryParams;
begin

  QueryParams :=
    CreateDocumentViewDateByEmployeeUpdatingQueryParamsFrom(
      DocumentId, EmployeeId, ViewDate
    );

  try

    FQueryExecutor.ExecuteModificationQuery(QueryPattern, QueryParams);

  finally

    FreeAndNil(QueryParams);

  end;

end;

function TBasedOnDatabaseDocumentViewingAccountingService.
  CreateDocumentViewDateByEmployeeUpdatingQueryParamsFrom(
    const DocumentId, EmployeeId: Variant;
    const ViewDate: TDateTime
  ): TQueryParams;
begin

  Result := TQueryParams.Create;

  try

    Result
      .AddFluently(
        'p' + FLookedDocumentsDbSchema.ViewDateColumnName, ViewDate
      )
      .AddFluently(
        'p' + FLookedDocumentsDbSchema.DocumentIdColumnName, DocumentId
      )
      .AddFluently(
        'p' + FLookedDocumentsDbSchema.EmployeeIdColumnName, EmployeeId
      );

  except

    on E: Exception do begin

      FreeAndNil(Result);

      Raise;

    end;

  end;
  
end;

function TBasedOnDatabaseDocumentViewingAccountingService.
  PrepareDocumentAsViewedByEmployeeMarkingQueryPattern(
    LookedDocumentsDbSchema: TLookedDocumentsDbSchema
  ): String;
begin

  Result :=
    Format(
      'INSERT INTO %s (%s,%s,%s) ' +
      'VALUES (:p%s,:p%s,:p%s)',
      [
        LookedDocumentsDbSchema.TableName,

        LookedDocumentsDbSchema.DocumentIdColumnName,
        LookedDocumentsDbSchema.EmployeeIdColumnName,
        LookedDocumentsDbSchema.ViewDateColumnName,

        LookedDocumentsDbSchema.DocumentIdColumnName,
        LookedDocumentsDbSchema.EmployeeIdColumnName,
        LookedDocumentsDbSchema.ViewDateColumnName
      ]
    );
    
end;

function TBasedOnDatabaseDocumentViewingAccountingService.
  PrepareDocumentViewDateByEmployeeGettingQueryPattern(
    LookedDocumentsDbSchema: TLookedDocumentsDbSchema
  ): String;
begin

  Result :=
    Format(
      'SELECT %s,%s,%s FROM %s WHERE %s=:p%s AND %s=:p%s',
      [
        LookedDocumentsDbSchema.DocumentIdColumnName,
        LookedDocumentsDbSchema.EmployeeIdColumnName,
        LookedDocumentsDbSchema.ViewDateColumnName,

        LookedDocumentsDbSchema.TableName,

        LookedDocumentsDbSchema.DocumentIdColumnName,
        LookedDocumentsDbSchema.DocumentIdColumnName,

        LookedDocumentsDbSchema.EmployeeIdColumnName,
        LookedDocumentsDbSchema.EmployeeIdColumnName
      ]
    );
    
end;

function TBasedOnDatabaseDocumentViewingAccountingService.
  PrepareDocumentViewDateByEmployeeUpdatingQueryPattern(
    LookedDocumentsDbSchema: TLookedDocumentsDbSchema
  ): String;
begin

  Result :=
    Format(
      'UPDATE %s SET %s=:p%s ' +
      'WHERE %s=:p%s AND %s=:p%s',
      [
        LookedDocumentsDbSchema.TableName,

        LookedDocumentsDbSchema.ViewDateColumnName,
        LookedDocumentsDbSchema.ViewDateColumnName,
        
        LookedDocumentsDbSchema.DocumentIdColumnName,
        LookedDocumentsDbSchema.DocumentIdColumnName,

        LookedDocumentsDbSchema.EmployeeIdColumnName,
        LookedDocumentsDbSchema.EmployeeIdColumnName
      ]
    );
    
end;

end.
