unit BasedOnDatabaseDocumentFlowAuthorizationService;

interface

uses

  AbstractDocumentFlowAuthorizationService,
  DocumentFlowAuthorizationService,
  QueryExecutor,
  DataReader,
  SysUtils,
  Classes;

type

  TDocumentFlowAuthorizationServiceDbSchema = class

    private

      FEmployeeSystemRoleAssociationTableName: String;
      FEmployeeIdColumnName: String;
      FSystemRoleIdColumnName: String;

      FEmployeeIdQueryParamName: String;
      FSystemRoleIdQueryParamName: String;

      FSystemAdminViewRoleId: Variant;
      FSystemAdminEditRoleId: Variant;
      FEmployeeAuthorizationVerificatingQueryResultFieldName: String;

    public

      constructor Create;
      constructor CreateFrom(

        const EmployeeSystemRoleAssociationTableName: String;
        const EmployeeIdColumnName: String;
        const SystemRoleIdColumnName: String;

        const EmployeeIdQueryParamName: String;
        const SystemRoleIdQueryParamName: String;

        const EmployeeAuthorizationVerificatingQueryResultFieldName: String;

        const SystemAdminViewRoleId: Variant;
        const SystemAdminEditRoleId: Variant

      );

      property EmployeeSystemRoleAssociationTableName: String
      read FEmployeeSystemRoleAssociationTableName write FEmployeeSystemRoleAssociationTableName;

      property EmployeeIdColumnName: String
      read FEmployeeIdColumnName write FEmployeeIdColumnName;

      property SystemRoleIdColumnName: String
      read FSystemRoleIdColumnName write FSystemRoleIdColumnName;

      property EmployeeIdQueryParamName: String
      read FEmployeeIdQueryParamName write FEmployeeIdQueryParamName;

      property EmployeeAuthorizationVerificatingQueryResultFieldName: String
      read FEmployeeAuthorizationVerificatingQueryResultFieldName
      write FEmployeeAuthorizationVerificatingQueryResultFieldName;
      
      property SystemRoleIdQueryParamName: String
      read FSystemRoleIdQueryParamName write FSystemRoleIdQueryParamName;

      property SystemAdminViewRoleId: Variant
      read FSystemAdminViewRoleId write FSystemAdminViewRoleId;

      property SystemAdminEditRoleId: Variant
      read FSystemAdminEditRoleId write FSystemAdminEditRoleId;
      
  end;

  TBasedOnDatabaseDocumentFlowAuthorizationService =
    class (TAbstractDocumentFlowAuthorizationService, IDocumentFlowAuthorizationService)

      protected

        FQueryExecutor: IQueryExecutor;
        FDbSchemaData: TDocumentFlowAuthorizationServiceDbSchema;
        
        FClientRoleAssigningCheckingQueryPattern: String;
        FClientRoleAssigningQueryPattern: String;
        FClientSystemRoleFlagsFetchingQueryPattern: String;
        
      protected

        function PrepareClientRoleAssigningCheckingQueryPattern(
          SchemaData: TDocumentFlowAuthorizationServiceDbSchema
        ): String; virtual;

        function PrepareClientRoleAssigningQueryPattern(
          SchemaData: TDocumentFlowAuthorizationServiceDbSchema
        ): String; virtual;

        function PrepareClientSystemRoleFlagsFetchingQueryPattern(
          SchemaData: TDocumentFlowAuthorizationServiceDbSchema
        ): String; virtual;
        
      protected

        function ExecuteClientSystemRoleFlagsFetchingQuery(
          const QueryPattern: String;
          const EmployeeId: Variant
        ): IDataReader; virtual;
        
        function ExecuteClientRoleAssigningCheckingQuery(
          const QueryPattern: String;
          const EmployeeId: Variant;
          const RoleId: Variant
        ): IDataReader; virtual;

        function ExecuteClientRoleAssigningQuery(
          const QueryPattern: String;
          const EmployeeId: Variant;
          const RoleId: Variant
        ): Integer; virtual;

      public

        destructor Destroy; override;
        
        constructor Create(
          QueryExecutor: IQueryExecutor;
          DbSchemaData: TDocumentFlowAuthorizationServiceDbSchema
        );

      public

        function IsRoleAssignedToClient(
          const ClientIdentity: Variant;
          const RoleIdentity: Variant
        ): Boolean;

        procedure EnsureThatRoleAssignedToClient(
          const RoleIdentity: Variant;
          const ClientIdentity: Variant
        );

        procedure AssignRoleToClient(
          const RoleIdentity: Variant;
          const ClientIdentity: Variant
        );

      public

        function GetEmployeeSystemRoleFlags(const EmployeeId: Variant): TDocumentFlowSystemRoleFlags; override;
  
        function IsEmployeeAdminView(const EmployeeId: Variant): Boolean; override;
        function IsEmployeeAdminEdit(const EmployeeId: Variant): Boolean; override;

        procedure MakeEmployeeAsAdminView(const EmployeeId: Variant); override;
        procedure MakeEmployeeAsAdminEdit(const EmployeeId: Variant); override;

    end;

implementation

uses

  Variants;

{ TBasedOnDatabaseDocumentFlowAuthorizationService }

constructor TBasedOnDatabaseDocumentFlowAuthorizationService.Create(
  QueryExecutor: IQueryExecutor;
  DbSchemaData: TDocumentFlowAuthorizationServiceDbSchema);
begin

  inherited Create;

  FQueryExecutor := QueryExecutor;
  FDbSchemaData := DbSchemaData;

  FClientRoleAssigningCheckingQueryPattern :=
    PrepareClientRoleAssigningCheckingQueryPattern(DbSchemaData);

  FClientRoleAssigningQueryPattern :=
    PrepareClientRoleAssigningQueryPattern(DbSchemaData);

  FClientSystemRoleFlagsFetchingQueryPattern :=
    PrepareClientSystemRoleFlagsFetchingQueryPattern(DbSchemaData);
    
end;

destructor TBasedOnDatabaseDocumentFlowAuthorizationService.Destroy;
begin

  FreeAndNil(FDbSchemaData);
  
  inherited;

end;

function TBasedOnDatabaseDocumentFlowAuthorizationService.IsEmployeeAdminEdit(
  const EmployeeId: Variant
): Boolean;
begin

  Result := IsRoleAssignedToClient(EmployeeId, FDbSchemaData.SystemAdminEditRoleId);

end;

function TBasedOnDatabaseDocumentFlowAuthorizationService.IsEmployeeAdminView(
  const EmployeeId: Variant): Boolean;
begin

  Result :=
    IsRoleAssignedToClient(EmployeeId, FDbSchemaData.SystemAdminViewRoleId) or
    IsEmployeeAdminEdit(EmployeeId);

end;

procedure TBasedOnDatabaseDocumentFlowAuthorizationService.MakeEmployeeAsAdminEdit(
  const EmployeeId: Variant);
begin

  AssignRoleToClient(FDbSchemaData.SystemAdminEditRoleId, EmployeeId);
  
end;

procedure TBasedOnDatabaseDocumentFlowAuthorizationService.MakeEmployeeAsAdminView(
  const EmployeeId: Variant
);
begin

  AssignRoleToClient(FDbSchemaData.SystemAdminViewRoleId, EmployeeId);

end;

function TBasedOnDatabaseDocumentFlowAuthorizationService.GetEmployeeSystemRoleFlags(
  const EmployeeId: Variant
): TDocumentFlowSystemRoleFlags;
var
    DataReader: IDataReader;
    SystemRoleId: Variant;
begin

  Result := TDocumentFlowSystemRoleFlags.Create;

  try

    DataReader :=
      ExecuteClientSystemRoleFlagsFetchingQuery(
        FClientSystemRoleFlagsFetchingQueryPattern, EmployeeId
      );

    while DataReader.Next do begin

      SystemRoleId := DataReader[FDbSchemaData.SystemRoleIdColumnName];

      if SystemRoleId = FDbSchemaData.SystemAdminViewRoleId then
        Result.HasAdminViewRole := True

      else if SystemRoleId = FDbSchemaData.SystemAdminEditRoleId then
        Result.HasAdminEditRole := True;

    end;

  except

    on E: Exception do begin

      FreeAndNil(Result);

      Raise;

    end;

  end;

end;

function TBasedOnDatabaseDocumentFlowAuthorizationService.
  PrepareClientRoleAssigningCheckingQueryPattern(
    SchemaData: TDocumentFlowAuthorizationServiceDbSchema
  ): String;
begin

  Result :=
    Format(
      'SELECT ' +
      'true as %s ' +
      'FROM %s ' +
      'WHERE %s=:%s AND %s=:%s',
      [
        SchemaData.EmployeeAuthorizationVerificatingQueryResultFieldName,
        SchemaData.EmployeeSystemRoleAssociationTableName,
        SchemaData.EmployeeIdColumnName,
        SchemaData.EmployeeIdQueryParamName,
        SchemaData.SystemRoleIdColumnName,
        SchemaData.SystemRoleIdQueryParamName
      ]
    );

end;

function TBasedOnDatabaseDocumentFlowAuthorizationService.
  PrepareClientRoleAssigningQueryPattern(
    SchemaData: TDocumentFlowAuthorizationServiceDbSchema
  ): String;
begin

  Result :=
    Format(
      'INSERT INTO %s (%s,%s) VALUES (:%s,:%s)',
      [
        SchemaData.EmployeeSystemRoleAssociationTableName,
        SchemaData.EmployeeIdColumnName,
        SchemaData.SystemRoleIdColumnName,
        SchemaData.EmployeeIdQueryParamName,
        SchemaData.SystemRoleIdQueryParamName
      ]
    );

end;

function TBasedOnDatabaseDocumentFlowAuthorizationService.PrepareClientSystemRoleFlagsFetchingQueryPattern(
  SchemaData: TDocumentFlowAuthorizationServiceDbSchema
): String;
begin

  Result :=
    Format(
      'SELECT %s FROM %s WHERE %s=:p%s',
      [
        SchemaData.SystemRoleIdColumnName,

        SchemaData.EmployeeSystemRoleAssociationTableName,
        
        SchemaData.EmployeeIdColumnName,
        SchemaData.EmployeeIdColumnName
      ]
    );

end;

function TBasedOnDatabaseDocumentFlowAuthorizationService.IsRoleAssignedToClient(
  const ClientIdentity, RoleIdentity: Variant
): Boolean;
var
    DataReader: IDataReader;
begin

  DataReader :=
    ExecuteClientRoleAssigningCheckingQuery(
      FClientRoleAssigningCheckingQueryPattern,
      ClientIdentity,
      RoleIdentity
    );

  Result :=
    not VarIsNull(
      DataReader[FDbSchemaData.EmployeeAuthorizationVerificatingQueryResultFieldName]
    );

end;

procedure TBasedOnDatabaseDocumentFlowAuthorizationService.AssignRoleToClient(
  const RoleIdentity, ClientIdentity: Variant
);
begin

  if not IsRoleAssignedToClient(ClientIdentity, RoleIdentity) then begin

    ExecuteClientRoleAssigningQuery(
      FClientRoleAssigningQueryPattern, ClientIdentity, RoleIdentity
    );

  end;

end;

procedure TBasedOnDatabaseDocumentFlowAuthorizationService.EnsureThatRoleAssignedToClient(
  const RoleIdentity, ClientIdentity: Variant
);
begin

  if not IsRoleAssignedToClient(ClientIdentity, RoleIdentity) then begin

    raise TDocumentFlowAuthorizationServiceException.Create(
      '” сотрудника отсутствует заданна€ роль'
    );

  end;

end;

function TBasedOnDatabaseDocumentFlowAuthorizationService.ExecuteClientRoleAssigningCheckingQuery(
  const QueryPattern: String; const EmployeeId, RoleId: Variant
): IDataReader;
var
    QueryParams: TQueryParams;
begin

  QueryParams := TQueryParams.Create;

  try

    QueryParams
      .AddFluently(FDbSchemaData.EmployeeIdQueryParamName, EmployeeId)
      .AddFluently(FDbSchemaData.FSystemRoleIdQueryParamName, RoleId);

    Result :=
      FQueryExecutor.ExecuteSelectionQuery(
        QueryPattern, QueryParams
      );
    
  finally

    FreeAndNil(QueryParams);

  end;

end;

function TBasedOnDatabaseDocumentFlowAuthorizationService.ExecuteClientRoleAssigningQuery(
  const QueryPattern: String; const EmployeeId, RoleId: Variant
): Integer;
var
    QueryParams: TQueryParams;
begin

  QueryParams := TQueryParams.Create;

  try

    QueryParams
      .AddFluently(FDbSchemaData.EmployeeIdQueryParamName, EmployeeId)
      .AddFluently(FDbSchemaData.SystemRoleIdQueryParamName, RoleId);

    Result := FQueryExecutor.ExecuteModificationQuery(QueryPattern, QueryParams);
    
  finally

    FreeAndNil(QueryParams);

  end;

end;

function TBasedOnDatabaseDocumentFlowAuthorizationService.ExecuteClientSystemRoleFlagsFetchingQuery(
  const QueryPattern: String; const EmployeeId: Variant
): IDataReader;
var
    QueryParams: TQueryParams;
begin

  QueryParams := TQueryParams.Create;

  try

    QueryParams.Add(FDbSchemaData.EmployeeIdQueryParamName, EmployeeId);

    Result := FQueryExecutor.ExecuteSelectionQuery(QueryPattern, QueryParams);
    
  finally

    FreeAndNil(QueryParams);

  end;

end;

{ TDocumentFlowAuthorizationServiceDbSchema }

constructor TDocumentFlowAuthorizationServiceDbSchema.Create;
begin

  inherited;

end;

constructor TDocumentFlowAuthorizationServiceDbSchema.CreateFrom(
  const EmployeeSystemRoleAssociationTableName, EmployeeIdColumnName,
  SystemRoleIdColumnName, EmployeeIdQueryParamName, SystemRoleIdQueryParamName,
  EmployeeAuthorizationVerificatingQueryResultFieldName: String;
  const SystemAdminViewRoleId, SystemAdminEditRoleId: Variant);
begin

  inherited Create;

  Self.EmployeeSystemRoleAssociationTableName := EmployeeSystemRoleAssociationTableName;
  Self.EmployeeIdColumnName := EmployeeIdColumnName;
  Self.SystemRoleIdColumnName := SystemRoleIdColumnName;
  Self.EmployeeIdQueryParamName := EmployeeIdQueryParamName;
  Self.SystemRoleIdQueryParamName := SystemRoleIdQueryParamName;
  Self.EmployeeAuthorizationVerificatingQueryResultFieldName := EmployeeAuthorizationVerificatingQueryResultFieldName;
  Self.SystemAdminViewRoleId := SystemAdminViewRoleId;
  Self.SystemAdminEditRoleId := SystemAdminEditRoleId;
  
end;

end.
