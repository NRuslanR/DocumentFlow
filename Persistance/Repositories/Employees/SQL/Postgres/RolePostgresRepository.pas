unit RolePostgresRepository;

interface

uses

  AbstractDBRepository,
  AbstractPostgresRepository,
  DBTableMapping,
  Classes,
  DomainObjectUnit,
  AbstractRepositoryCriteriaUnit,
  DomainObjectListUnit,
  RoleUnit,
  Employee,
  VariantListUnit,
  UnaryRepositoryCriterionUnit,
  TableMapping,
  TableColumnMappings,
  IRoleRepositoryUnit,
  QueryExecutor,
  DataReader,
  EmployeeRoleAssocTableDef,
  SysUtils;

const

  EMPLOYEES_ROLES_TABLE_ASSOCIATION_EMPLOYEE_ID_PARAM_NAME =
    'p' + EMPLOYEES_ROLES_TABLE_ASSOCIATION_EMPLOYEE_ID_FIELD;

  EMPLOYEES_ROLES_TABLE_ASSOCIATION_ROLE_ID_PARAM_NAME =
    'p' + EMPLOYEES_ROLES_TABLE_ASSOCIATION_ROLE_ID_FIELD;

  ADD_ROLE_FOR_EMPLOYEE_QUERY =
    'INSERT INTO doc.employees_roles (' +
    EMPLOYEES_ROLES_TABLE_ASSOCIATION_EMPLOYEE_ID_FIELD+ ',' +
    EMPLOYEES_ROLES_TABLE_ASSOCIATION_ROLE_ID_FIELD +
    ') values (:' + EMPLOYEES_ROLES_TABLE_ASSOCIATION_EMPLOYEE_ID_PARAM_NAME
    + ',:' + EMPLOYEES_ROLES_TABLE_ASSOCIATION_ROLE_ID_PARAM_NAME + ')';

  REMOVE_ROLE_FROM_EMPLOYEE_QUERY =

    'DELETE FROM ' + EMPLOYEES_ROLES_TABLE_ASSOCIATION_NAME +
    ' WHERE ' + EMPLOYEES_ROLES_TABLE_ASSOCIATION_EMPLOYEE_ID_FIELD
    + '=:' + EMPLOYEES_ROLES_TABLE_ASSOCIATION_EMPLOYEE_ID_PARAM_NAME;

  REMOVE_ALL_ROLES_FROM_EMPLOYEE_QUERY =
    'DELETE FROM ' + EMPLOYEES_ROLES_TABLE_ASSOCIATION_NAME +
    ' WHERE ' + EMPLOYEES_ROLES_TABLE_ASSOCIATION_EMPLOYEE_ID_FIELD
    + '=:' + EMPLOYEES_ROLES_TABLE_ASSOCIATION_EMPLOYEE_ID_PARAM_NAME;
    
type

  TMoreThanOneRoleFoundByNameInRepositoryException = class (Exception)

  end;

  TRolePostgresRepository = class;

  TRolePostgresRepositoryCriterion = class abstract (TAbstractRepositoryCriterion)

    protected

      FRolePostgresRepository: TRolePostgresRepository;

      constructor Create(RolePostgresRepository: TRolePostgresRepository);

      procedure InitializeFieldMappings(FieldMappings: TTableColumnMappings); virtual;

    public

      property RolePostgresRepository: TRolePostgresRepository
      read FRolePostgresRepository write FRolePostgresRepository;

  end;

  TFindRolesByIdsCriterion = class (TRolePostgresRepositoryCriterion)

    private

      FRoleIds: TVariantList;

    protected

      function GetExpression: String; override;

    public

      constructor Create(
        RolePostgresRepository: TRolePostgresRepository;
        RoleIds: TVariantList
      );

  end;

  TFindRoleForEmployeeCriterion = class (TRolePostgresRepositoryCriterion)

    private

      FEmployee: TEmployee;
      FUnaryCriterion: TUnaryRepositoryCriterion;

    protected

      procedure InitializeFieldMappings(FieldMappings: TTableColumnMappings); override;

      function GetExpression: String; override;
      
    public

      destructor Destroy; override;

      constructor Create(
        Employee: TEmployee;
        RolePostgresRepository: TRolePostgresRepository
      );

      property Employee: TEmployee read FEmployee write FEmployee;
      
  end;

  TRolePostgresRepository =
    class (TAbstractPostgresRepository, IRoleRepository)

      protected

        type

          TEmployeeRoleEditingOperation = (

            None,
            AddingRoleForEmployee,
            RemovingAllRolesFromEmployee

          );

      protected

        procedure Initialize; override;

      protected

        FCurrentEmployeeRoleEditingOperation: TEmployeeRoleEditingOperation;
      
        procedure CustomizeTableMapping(
          TableMapping: TDBTableMapping
        ); override;

        procedure PrepareAddDomainObjectQuery(
          DomainObject: TDomainObject;
          var QueryPattern: String;
          var QueryParams: TQueryParams
        ); override;
      
        procedure PrepareRemoveDomainObjectQuery(
          DomainObject: TDomainObject;
          var QueryPattern: String;
          var QueryParams: TQueryParams
        ); override;

        function InternalAdd(DomainObject: TDomainObject): Boolean; override;
        function InternalUpdate(DomainObject: TDomainObject): Boolean; override;
        function InternalRemove(DomainObject: TDomainObject): Boolean; override;
        function InternalFindDomainObjectByIdentity(Identity: Variant): TDomainObject; override;
        function InternalLoadAll: TDomainObjectList; override;

        procedure PrepareFindDomainObjectsByCriteria(
          Criteria: TAbstractRepositoryCriterion;
          var QueryPattern: String;
          var QueryParams: TQueryParams
        ); override;

      public

        procedure AddRoleForEmployee(Employee: TEmployee);
        procedure RemoveRoleFromEmployee(Employee: TEmployee);
        procedure RemoveAllRolesFromEmployee(Employee: TEmployee);
        function FindRoleForEmployee(Employee: TEmployee): TRole;
        function FindRoleById(const Id: Variant): TRole;
        function FindRolesByIds(const Ids: TVariantList): TRoleList;
        function FindRoleByName(const RoleName: String): TRole;
        function LoadAllRoles: TRoleList;

    end;

implementation

uses

  AbstractRepository,
  AuxiliaryStringFunctions,
  RoleTableDef,
  ZDataset;

{ TRolePostgresRepository }

procedure TRolePostgresRepository.CustomizeTableMapping(
  TableMapping: TDBTableMapping);
begin

  TableMapping.SetTableNameMapping(ROLE_TABLE_NAME, TRole, TRoleList);

  TableMapping.AddColumnMappingForSelect(ROLE_TABLE_ID_FIELD, 'Identity');
  TableMapping.AddColumnMappingForSelect(ROLE_TABLE_NAME_FIELD, 'Name');
  TableMapping.AddColumnMappingForSelect(ROLE_TABLE_DESCRIPTION_FIELD, 'Description');

  TableMapping.AddPrimaryKeyColumnMapping(ROLE_TABLE_ID_FIELD, 'Identity');

end;

function TRolePostgresRepository.LoadAllRoles: TRoleList;
begin

  Result := LoadAll as TRoleList;

  ThrowExceptionIfErrorIsNotUnknown;
  
end;

procedure TRolePostgresRepository.PrepareAddDomainObjectQuery(
  DomainObject: TDomainObject;
  var QueryPattern: String;
  var QueryParams: TQueryParams
);
var
    Employee: TEmployee;
begin

  if FCurrentEmployeeRoleEditingOperation <> AddingRoleForEmployee then begin

    inherited;
    Exit;

  end;

  Employee := DomainObject as TEmployee;

  QueryPattern := ADD_ROLE_FOR_EMPLOYEE_QUERY;

  QueryParams := TQueryParams.Create;

  QueryParams
    .AddFluently(
      EMPLOYEES_ROLES_TABLE_ASSOCIATION_EMPLOYEE_ID_PARAM_NAME,
      Employee.Identity
    )
    .AddFluently(
      EMPLOYEES_ROLES_TABLE_ASSOCIATION_ROLE_ID_PARAM_NAME,
      Employee.Role.Identity
    );

end;

procedure TRolePostgresRepository.PrepareFindDomainObjectsByCriteria(
  Criteria: TAbstractRepositoryCriterion;
  var QueryPattern: String;
  var QueryParams: TQueryParams
);
begin

  if Criteria is TFindRoleForEmployeeCriterion then begin

    QueryPattern :=
      Format(
        'SELECT %s FROM %s %s WHERE %s',
        [
          FDBTableMapping.GetSelectListForSelectGroup,
          FDBTableMapping.TableName,
          'JOIN doc.employees_roles ON ' +
          'doc.employees_roles.role_id = doc.roles.' +
          FDBTableMapping.PrimaryKeyColumnMappings[0].ColumnName,
          Criteria.Expression
        ]
      );

  end

  else inherited;

end;

procedure TRolePostgresRepository.PrepareRemoveDomainObjectQuery(
  DomainObject: TDomainObject;
  var QueryPattern: String;
  var QueryParams: TQueryParams
);
var Employee: TEmployee;
begin

  if FCurrentEmployeeRoleEditingOperation = None then begin

    inherited;
    Exit;

  end;

  Employee := DomainObject as TEmployee;

  if FCurrentEmployeeRoleEditingOperation = RemovingAllRolesFromEmployee
  then begin

    QueryPattern := REMOVE_ALL_ROLES_FROM_EMPLOYEE_QUERY;

    QueryParams := TQueryParams.Create;

    QueryParams.Add(
      EMPLOYEES_ROLES_TABLE_ASSOCIATION_EMPLOYEE_ID_PARAM_NAME,
      Employee.Identity
    );

  end;

end;

procedure TRolePostgresRepository.AddRoleForEmployee(Employee: TEmployee);
begin

  FCurrentEmployeeRoleEditingOperation := AddingRoleForEmployee;

  Add(Employee);

  ThrowExceptionIfErrorIsNotUnknown;
  
  FCurrentEmployeeRoleEditingOperation := None;

end;

procedure TRolePostgresRepository.RemoveAllRolesFromEmployee(
  Employee: TEmployee
);
begin

  FCurrentEmployeeRoleEditingOperation := RemovingAllRolesFromEmployee;

  Remove(Employee);

  ThrowExceptionIfErrorIsNotUnknown;
  
  FCurrentEmployeeRoleEditingOperation := None;

end;

procedure TRolePostgresRepository.RemoveRoleFromEmployee(Employee: TEmployee);
begin

  RemoveAllRolesFromEmployee(Employee);

  ThrowExceptionIfErrorIsNotUnknown;

end;

function TRolePostgresRepository.FindRoleById(const Id: Variant): TRole;
begin

   Result := FindDomainObjectByIdentity(Id) as TRole;

   ThrowExceptionIfErrorIsNotUnknown;
   
end;

function TRolePostgresRepository.FindRoleByName(const RoleName: String): TRole;
var FindRoleByNameRepositoryCriterion: TUnaryRepositoryCriterion;
    RoleList: TRoleList;
begin

  RoleList := nil;
  FindRoleByNameRepositoryCriterion := nil;

  try

    FindRoleByNameRepositoryCriterion :=
      GetUnaryRepositoryCriterionClass.Create(
        'Name',
        RoleName,
        GetEqualityRepositoryCriterionOperationClass.Create
      );

    RoleList :=
      FindDomainObjectsByCriteria(FindRoleByNameRepositoryCriterion)
        as TRoleList;

    ThrowExceptionIfErrorIsNotUnknown;
    
    if RoleList.Count = 1 then
      Result := RoleList[0].Clone as TRole

    else if RoleList.Count > 1 then
      raise TMoreThanOneRoleFoundByNameInRepositoryException.Create('')

    else Result := nil;
    
  finally

    FreeAndNil(RoleList);
    FreeAndNil(FindRoleByNameRepositoryCriterion);
    
  end;

end;

function TRolePostgresRepository.FindRoleForEmployee(
  Employee: TEmployee
): TRole;
var FindRoleForEmployeeCriterion: TFindRoleForEmployeeCriterion;
    RoleList: TRoleList;
    DomainObjectList: TDomainObjectList;
begin

  RoleList := nil;
  FindRoleForEmployeeCriterion := nil;

  try

    FindRoleForEmployeeCriterion :=
      TFindRoleForEmployeeCriterion.Create(Employee, Self);

    DomainObjectList :=
      FindDomainObjectsByCriteria(FindRoleForEmployeeCriterion);

    ThrowExceptionIfErrorIsNotUnknown;
    
    if DomainObjectList = nil then begin

      Result := nil;
      Exit;

    end;

    RoleList := DomainObjectList as TRoleList;
    
    if RoleList.Count > 0 then
      Result := RoleList[0].Clone as TRole

    else Result := nil;

  finally

    FreeAndNil(RoleList);
    FreeAndNil(FindRoleForEmployeeCriterion);

  end;
  
end;

function TRolePostgresRepository.FindRolesByIds(
  const Ids: TVariantList): TRoleList;
var
    Criteria: TFindRolesByIdsCriterion;
begin

  Criteria := TFindRolesByIdsCriterion.Create(Self, Ids);

  try

    Result := TRoleList(FindDomainObjectsByCriteria(Criteria));
    
  finally

    FreeAndNil(Criteria);

  end;

end;

procedure TRolePostgresRepository.Initialize;
begin

  inherited;

  FCurrentEmployeeRoleEditingOperation := None;

end;

function TRolePostgresRepository.InternalAdd(
  DomainObject: TDomainObject): Boolean;
begin

  if FCurrentEmployeeRoleEditingOperation = None then
    raise Exception.Create(
            'Нельзя добавлять новые роли в хранилище.' +
            ' Набор ролей фиксирован'
          )

  else Result := inherited InternalAdd(DomainObject);

end;

function TRolePostgresRepository.InternalRemove(
  DomainObject: TDomainObject): Boolean;
begin

  if FCurrentEmployeeRoleEditingOperation = None then
    raise Exception.Create(
            'Нельзя удалять роли из хранилища.' +
            ' Набор ролей фиксирован'
          )

  else Result := inherited InternalRemove(DomainObject);
  
end;

function TRolePostgresRepository.InternalUpdate(
  DomainObject: TDomainObject): Boolean;
begin

  if FCurrentEmployeeRoleEditingOperation = None then
    raise Exception.Create(
            'Нельзя изменять роли в хранилище.' +
            ' Набор ролей фиксирован'
          )

  else Result := inherited InternalUpdate(DomainObject);

end;

function TRolePostgresRepository.InternalFindDomainObjectByIdentity(
  Identity: Variant): TDomainObject;
begin

  Result := inherited InternalFindDomainObjectByIdentity(Identity);

end;

function TRolePostgresRepository.InternalLoadAll: TDomainObjectList;
begin

  Result := inherited InternalLoadAll;
  
end;

{ TRolePostgresRepositoryCriterion }

constructor TRolePostgresRepositoryCriterion.Create(
  RolePostgresRepository: TRolePostgresRepository);
begin

  inherited Create;

  FRolePostgresRepository := RolePostgresRepository;
  FFieldMappings := TTableColumnMappings.Create;

  InitializeFieldMappings(FFieldMappings as TTableColumnMappings);

end;


procedure TRolePostgresRepositoryCriterion.InitializeFieldMappings(
  FieldMappings: TTableColumnMappings);
begin

end;

{ TFindRoleForEmployeeCriterion }

constructor TFindRoleForEmployeeCriterion.Create(
  Employee: TEmployee;
  RolePostgresRepository: TRolePostgresRepository
);
begin

  inherited Create(RolePostgresRepository);

  FEmployee := Employee;
  FUnaryCriterion :=
    RolePostgresRepository.GetUnaryRepositoryCriterionClass.Create(
      'Identity',
      Employee.Identity,
      RolePostgresRepository.
        GetEqualityRepositoryCriterionOperationClass.Create
      );
  FUnaryCriterion.FieldMappings := FieldMappings;

end;

destructor TFindRoleForEmployeeCriterion.Destroy;
begin

  FreeAndNil(FUnaryCriterion);
  inherited;

end;

function TFindRoleForEmployeeCriterion.GetExpression: String;
begin

  Result := FUnaryCriterion.Expression;
  
end;

procedure TFindRoleForEmployeeCriterion.InitializeFieldMappings(
  FieldMappings: TTableColumnMappings
);
begin

  FieldMappings.AddColumnMapping(
    EMPLOYEES_ROLES_TABLE_ASSOCIATION_EMPLOYEE_ID_FIELD, 'Identity'
  );
  
end;

{ TFindRolesByIdsCriterion }

constructor TFindRolesByIdsCriterion.Create(
  RolePostgresRepository: TRolePostgresRepository; RoleIds: TVariantList);
begin

  inherited Create(RolePostgresRepository);

  FRoleIds := RoleIds;
  
end;

function TFindRolesByIdsCriterion.GetExpression: String;
var
    RoleIdColumnName: String;
begin

  RoleIdColumnName :=
    FRolePostgresRepository
      .TableMapping
        .FindSelectColumnMappingByObjectPropertyName('Identity')
          .GetColumnNameOrAliasName;

  Result :=
    Format(
      '%s IN (%s)',
      [
        RoleIdColumnName,
        CreateStringFromVariantList(FRoleIds)
      ]
    );

end;

end.
