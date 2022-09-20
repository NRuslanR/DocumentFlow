unit EmployeePostgresRepository;

interface

uses

  Employee,
  DomainObjectListUnit,
  DomainObjectUnit,
  RoleUnit,
  AbstractDBRepository,
  AbstractPostgresRepository,
  DBTableMapping,
  UnaryRepositoryCriterionUnit,
  AbstractRepositoryCriteriaUnit,
  TableColumnMappings,
  DomainObjectCompiler,
  EmployeeReplacementPostgresRepository,
  IEmployeeRepositoryUnit,
  ArrayTypes,
  QueryExecutor,
  TableDef,
  DataReader,
  VariantListUnit,
  Classes,
  SysUtils;

type

  TRoleIdArray = TVariantArray;
  
  TEmployeePostgresRepository = class;

  TEmployeePostgresRepositoryCriterion =
    class abstract (TAbstractRepositoryCriterion)

      protected

        FEmployeePostgresRepository: TEmployeePostgresRepository;

        constructor Create(
          EmployeePostgresRepository: TEmployeePostgresRepository
        );

    end;

  TFindLeaderByDepartmentPropertyCriterion =
    class (TEmployeePostgresRepositoryCriterion)

      private

        FDepartmentProperty: Variant;
        FDepartmentPropertyColumnName: String;
        
      protected

        function GetExpression: String; override;
        
      public

        constructor Create(
          const DepartmentProperty: Variant;
          const DepartmentPropertyColumnName: String;
          Repository: TEmployeePostgresRepository
        );

  end;

  TEmployeePostgresRepository =
    class (TAbstractPostgresRepository, IEmployeeRepository)

      private

        FRoleMappings: TDBTableMapping;
        FEmployeeContactInfoMappings: TDBTableMapping;
        FEmployeeWorkGroupAssociationMappings: TDBTableMapping;

        FTopLevelEmployeeMappings: TDBTableMapping;
        FTopLevelEmployeeRoleMappings: TDBTableMapping;
        FTopLevelEmployeeContactInfoMappings: TDBTableMapping;
        FTopLevelEmployeeWorkGroupAssociationMappings: TDBTableMapping;

        FEmployeeReplacementPostgresRepository: TEmployeeReplacementPostgresRepository;

        FRoleCompiler: TDomainObjectCompiler;
        FTopLevelEmployeeRoleCompiler: TDomainObjectCompiler;
        FTopLevelEmployeeCompiler: TDomainObjectCompiler;

        procedure CustomizeEmployeeMappings(EmployeeMappings: TDBTableMapping);
        procedure CustomizeEmployeeContactInfoMappings(EmployeeContactInfoMappings: TDBTableMapping);
        procedure CustomizeRoleMappings(RoleMappings: TDBTableMapping);
        procedure CustomizeEmployeeWorkGroupAssociationMappings(EmployeeWorkGroupAssociationMappings: TDBTableMapping);

        procedure CustomizeTopLevelEmployeeMappings(TopLevelEmployeeMappings: TDBTableMapping);
        procedure CustomizeTopLevelEmployeeRoleMappings(TopLevelEmployeeRoleMappings: TDBTableMapping);
        procedure CustomizeTopLevelEmployeeContactInfoMappings(TopLevelEmployeeContactInfoMappings: TDBTableMapping);
        procedure CustomizeTopLevelEmployeeWorkGroupAssociationMappings(TopLevelEmployeeWorkGroupAssociationMappings: TDBTableMapping);

        function GetJoinWithRoleTableExpression: String;
        function GetJoinWithEmailTableExpression: String;
        function GetJoinWithEmployeeRoleAssociationTableExpression: String;
        function GetJoinWithEmployeeWorkGroupAssociationTableExpression: String;
    
        function GetEmployeeColumnNameList: String;
      
        function GetJoinWithTopLevelEmployeeTableExpression: String;
        function GetJoinWithTopLevelEmployeeRoleTableExpression: String;
        function GetJoinWithTopLevelEmployeeEmailTableExpression: String;
        function GetJoinWithTopLevelEmployeeRoleAssociationTableExpression: String;
        function GetJoinWithTopLevelEmployeeWorkGroupAssociationTableExpression: String;
    
        procedure FillEmployeeContactInfoFrom(
          EmployeeContactInfo: TEmployeeContactInfo;
          DataReader: IDataReader
        );

        procedure FillEmployeeWorkGroupIdsFrom(
          Employee: TEmployee;
          EmployeeWorkGroupAssociationMappings: TDBTableMapping;
          DataReader: IDataReader
        );
      
        function FetchTopLevelEmployeeFrom(
          DataReader: IDataReader
        ): TEmployee;

        function GetQueryParameterValueFromDomainObject(
          DomainObject: TDomainObject;
          const DomainObjectPropertyName: String
        ): Variant; override;

      protected

        procedure Initialize; override;
        procedure InitializeTableMappings(TableDef: TTableDef); override;
      
        procedure CustomizeTableMapping(
          TableMapping: TDBTableMapping
        ); override;

        procedure GetSelectListFromTableMappingForSelectByIdentity(
          var SelectList: String;
          var WhereClauseForSelectIdentity: String
        ); override;

        function GetSelectListFromTableMappingForSelectGroup: String; override;
        function GetTableNameFromTableMappingForSelect: String; override;
        function GetCustomTrailingSelectQueryTextPart: String; override;

        procedure FillDomainObjectFromDataReader(
          DomainObject: TDomainObject;
          DataReader: IDataReader
        ); override;

        function CreateAndFillEmployeeRoleFrom(
          DataReader: IDataReader
        ): TRole;

        function CheckThatSingleRecordSelected(DataReader: IDataReader): Boolean; override;

        procedure PrepareAndExecuteAddDomainObjectQuery(DomainObject: TDomainObject); override;
        procedure PrepareAndExecuteUpdateDomainObjectQuery(DomainObject: TDomainObject); override;
        procedure PrepareAndExecuteRemoveDomainObjectQuery(DomainObject: TDomainObject); override;

        procedure PrepareFindDomainObjectsByCriteria(
          Criteria: TAbstractRepositoryCriterion;
          var QueryPattern: String;
          var QueryParams: TQueryParams
        ); override;

        procedure PrepareAllLeadersForEmployeeFetchingQuery(
          const EmployeeId: Variant;
          var QueryPattern: String;
          var QueryParams: TQueryParams
        );
      
        procedure PrepareAllTopLevelEmployeesForEmployeeFetchingQuery(
          const EmployeeId: Variant;
          var QueryPattern: String;
          var QueryParams: TQueryParams
        );

        procedure PrepareAllTopLevelEmployeesFromSameHeadKindredDepartmentForEmployeeFetchingQuery(
          const EmployeeId: Variant;
          var QueryPattern: String;
          var QueryParams: TQueryParams
        );

        procedure SetQueryExecutor(const Value: IQueryExecutor); override;

      protected

        function FindEmployeesByCriteria(
          Criteria: TEmployeePostgresRepositoryCriterion
        ): TEmployees;

      protected

        function FindEmployeesForLeaderByRoles(
          const LeaderId: Variant;
          const EmployeeRoleIds: TRoleIdArray
        ): TEmployees; overload;

        function FindLeaderByDepartmentPropertyCriterion(
          const Criterion: TFindLeaderByDepartmentPropertyCriterion
        ): TEmployee;
      
      public

        destructor Destroy; override;

        function FindLeaderByDepartmentId(const DepartmentId: Variant): TEmployee;
        function FindLeaderByDepartmentCode(const DepartmentCode: String): TEmployee;
        function FindLeadersForEmployee(const EmployeeId: Variant): TEmployees;
        function FindLeadershipEmployeesForLeader(const LeaderId: Variant): TEmployees;
        function FindAllTopLevelEmployeesForEmployee(const EmployeeId: Variant): TEmployees;

        function FindAllTopLevelEmployeesFromSameHeadKindredDepartmentForEmployee(
          const EmployeeId: Variant
        ): TEmployees;

        function FindEmployeeById(const Id: Variant): TEmployee;
        function FindEmployeesByIdentities(const Identities: TVariantList): TEmployees;

        function FindLeadersByIdentities(const Identities: TVariantList): TEmployees;
        
        function FindEmployeesByIdentitiesAndRoles(
          const Identities:  TVariantList;
          const RoleIds: TVariantList
        ): TEmployees;

        function FindEmployeesForLeaderByRoles(
          const LeaderId: Variant;
          const RoleIds: TVariantList
        ): TEmployees; overload;

        function LoadAllEmployees: TEmployees;

        procedure AddEmployee(Employee: TEmployee);
        procedure UpdateEmployee(Employee: TEmployee);
        procedure RemoveEmployee(Employee: TEmployee);
  
    end;


implementation

uses

  DB,
  Variants,
  RepositoryRegistryUnit,
  IRoleRepositoryUnit,
  SQLCastingFunctions,
  ZDataset,
  EmployeeTableDef,
  DepartmentTableDef,
  Windows,
  RoleTableDef,
  IDomainObjectBaseListUnit,
  StrUtils,
  EmployeePostgresRepositoryQueryTextsUnit,
  EmployeeRoleAssocTableDef,
  EmployeeContactInfoTableDef,
  DBTableColumnMappings,
  EmployeeWorkGroupAssocTableDef,
  AuxiliaryStringFunctions;

type

  TFindAllTopLevelEmployeesForEmployeeCriterion =
    class (TEmployeePostgresRepositoryCriterion)

      protected

        FEmployeeId: Variant;

        function GetExpression: String; override;

      public

        destructor Destroy; override;
        constructor Create(
          const EmployeeId: Variant;
          EmployeePostgresRepository: TEmployeePostgresRepository
        );

        property EmployeeId: Variant read FEmployeeId;

    end;

  TFindAllTopLevelEmployeesFromSameHeadKindredDepartmentForEmployeeCriterion =
    class (TFindAllTopLevelEmployeesForEmployeeCriterion)

    end;
      
  TFindAllLeadersForEmployeeCriterion =
    class (TFindAllTopLevelEmployeesForEmployeeCriterion)

    end;

  TFindEmployeesByIdentitiesCriterion =
    class (TEmployeePostgresRepositoryCriterion)

      private

        FEmployeeIdentities: TVariantList;

      protected

        function GetExpression: String; override;
        
      public

        constructor Create(
          EmployeeIdentities: TVariantList;
          Repository: TEmployeePostgresRepository
        );

        property EmployeeIdentities: TVariantList
        read FEmployeeIdentities;

    end;

  TFindLeaderByDepartmentIdCriterion = class (TFindLeaderByDepartmentPropertyCriterion)

    public

      constructor Create(
        const DepartmentId: Variant;
        Repository: TEmployeePostgresRepository
      );

  end;

  TFindLeaderByDepartmentCodeCriterion = class (TFindLeaderByDepartmentPropertyCriterion)

    public

      constructor Create(
        const DepartmentCode: String;
        Repository: TEmployeePostgresRepository
      );

  end;

  TFindEmployeesForLeaderByRolesCritertion = class (TEmployeePostgresRepositoryCriterion)

    protected

      FLeaderId: Variant;
      FEmployeeRoleIds: TRoleIdArray;

      function GetExpression: String; override;

    public

      constructor Create(
        EmployeePostgresRepository: TEmployeePostgresRepository;
        const LeaderId: Variant;
        const EmployeeRoleIds: TRoleIdArray
      );
      
  end;

{ TEmployeePostgresRepository }

function TEmployeePostgresRepository.CheckThatSingleRecordSelected(DataReader: IDataReader): Boolean;
begin

  Result := DataReader.RecordCount > 0;
  
end;

function TEmployeePostgresRepository.CreateAndFillEmployeeRoleFrom(
  DataReader: IDataReader
): TRole;
begin

  Result := FRoleMappings.ObjectClass.Create as TRole;

  FRoleCompiler.CompileDomainObject(
    Result,
    DataReader
  );                                     

end;

procedure TEmployeePostgresRepository.CustomizeEmployeeContactInfoMappings(
  EmployeeContactInfoMappings: TDBTableMapping);
begin

  EmployeeContactInfoMappings.SetTableNameMapping(
    EMPLOYEE_EMAIL_TABLE_NAME, TEmployeeContactInfo
  );

  EmployeeContactInfoMappings.AddColumnMappingForSelect(
    EMPLOYEE_EMAIL_TABLE_EMAIL_FIELD_NAME, 'Email'
  );

  EmployeeContactInfoMappings.AddPrimaryKeyColumnMapping(
    EMPLOYEE_EMAIL_TABLE_EMPLOYEE_ID_FIELD_NAME, ''
  );

end;

procedure TEmployeePostgresRepository.CustomizeEmployeeMappings(
  EmployeeMappings: TDBTableMapping);
begin

  EmployeeMappings.SetTableNameMappingWithAlias(
    EMPLOYEE_TABLE_NAME, TEmployee, 'emp1', TEmployees
  );

  EmployeeMappings.AddColumnMappingForSelect(EMPLOYEE_TABLE_ID_FIELD, 'Identity');
  EmployeeMappings.AddColumnMappingForSelect(EMPLOYEE_TABLE_LEGACY_ID_FIELD, 'LegacyIdentity');
  EmployeeMappings.AddColumnMappingForSelect(EMPLOYEE_TABLE_NAME_FIELD, 'Name');
  EmployeeMappings.AddColumnMappingForSelect(EMPLOYEE_TABLE_SURNAME_FIELD, 'Surname');
  EmployeeMappings.AddColumnMappingForSelect(EMPLOYEE_TABLE_PATRONYMIC_FIELD, 'Patronymic');
  EmployeeMappings.AddColumnMappingForSelect(EMPLOYEE_TABLE_SPECIALITY_FIELD, 'Speciality');
  EmployeeMappings.AddColumnMappingForSelect(EMPLOYEE_TABLE_PERSONNEL_NUMBER_FIELD, 'PersonnelNumber');
  EmployeeMappings.AddColumnMappingForSelect(EMPLOYEE_TABLE_TELEPHONE_NUMBER_FIELD, 'TelephoneNumber');
  EmployeeMappings.AddColumnMappingForSelect(EMPLOYEE_TABLE_DEPARTMENT_ID_FIELD, 'DepartmentIdentity');
  EmployeeMappings.AddColumnNameForSelect(EMPLOYEE_TABLE_LEADER_ID_FIELD);
  EmployeeMappings.AddColumnMappingForSelect(EMPLOYEE_TABLE_IS_FOREIGN_FIELD, 'IsForeign');
  EmployeeMappings.AddColumnMappingForSelect(EMPLOYEE_TABLE_IS_DISMISSED_FIELD, 'IsDismissed');
  EmployeeMappings.AddColumnMappingForSelect(EMPLOYEE_TABLE_HEAD_KINDRED_DEPARTMENT_ID_FIELD, 'NOT_MAPPED', False);

  EmployeeMappings.AddColumnMappingForModification(EMPLOYEE_TABLE_NAME_FIELD, 'Name');
  EmployeeMappings.AddColumnMappingForModification(EMPLOYEE_TABLE_SURNAME_FIELD, 'Surname');
  EmployeeMappings.AddColumnMappingForModification(EMPLOYEE_TABLE_PATRONYMIC_FIELD, 'Patronymic');
  EmployeeMappings.AddColumnMappingForModification(EMPLOYEE_TABLE_SPECIALITY_FIELD, 'Speciality');
  EmployeeMappings.AddColumnMappingForModification(EMPLOYEE_TABLE_PERSONNEL_NUMBER_FIELD, 'PersonnelNumber');
  EmployeeMappings.AddColumnMappingForModification(EMPLOYEE_TABLE_TELEPHONE_NUMBER_FIELD, 'TelephoneNumber');
  EmployeeMappings.AddColumnMappingForModification(EMPLOYEE_TABLE_DEPARTMENT_ID_FIELD, 'DepartmentIdentity');
  EmployeeMappings.AddColumnMappingForModification(EMPLOYEE_TABLE_LEADER_ID_FIELD, 'LeaderIdentity');
  EmployeeMappings.AddColumnMappingForModification(EMPLOYEE_TABLE_IS_FOREIGN_FIELD, 'IsForeign');
  EmployeeMappings.AddColumnMappingForModification(EMPLOYEE_TABLE_IS_DISMISSED_FIELD, 'IsDismissed');
  
  EmployeeMappings.AddPrimaryKeyColumnMapping(EMPLOYEE_TABLE_ID_FIELD, 'Identity');

end;

procedure TEmployeePostgresRepository.
  CustomizeEmployeeWorkGroupAssociationMappings(
    EmployeeWorkGroupAssociationMappings: TDBTableMapping
  );
begin

  EmployeeWorkGroupAssociationMappings.SetTableNameMapping(
    EMPLOYEE_WORK_GROUPS_ASSOCIATION_TABLE_NAME, nil
  );

  EmployeeWorkGroupAssociationMappings.AddColumnMappingForSelectWithAlias(
    EMPLOYEE_WORK_GROUPS_ASSOCIATION_TABLE_WORK_GROUP_ID_FIELD,
    'WorkGroupId',
    EMPLOYEE_WORK_GROUPS_ASSOCIATION_TABLE_WORK_GROUP_ID_FIELD_ALIAS_1
  );

  EmployeeWorkGroupAssociationMappings.AddColumnMappingForSelectWithAlias(
    EMPLOYEE_WORK_GROUPS_ASSOCIATION_TABLE_EMPLOYEE_ID_FIELD,
    'EmployeeId',
    EMPLOYEE_WORK_GROUPS_ASSOCIATION_TABLE_EMPLOYEE_ID_FIELD_ALIAS_1
  );
  
end;

procedure TEmployeePostgresRepository.CustomizeRoleMappings(
  RoleMappings: TDBTableMapping
);
begin

  RoleMappings.SetTableNameMapping(ROLE_TABLE_NAME, TRole);

  RoleMappings.AddColumnMappingForSelectWithAlias(
    ROLE_TABLE_ID_FIELD, 'Identity', EMPLOYEE_ROLE_ID_FIELD
  );

  RoleMappings.AddColumnMappingForSelectWithAlias(
    ROLE_TABLE_NAME_FIELD, 'Name', EMPLOYEE_ROLE_NAME_FIELD
  );
  
  RoleMappings.AddColumnMappingForSelectWithAlias(
    ROLE_TABLE_DESCRIPTION_FIELD, 'Description', EMPLOYEE_ROLE_DESCRIPTION_FIELD
  );

  RoleMappings.AddPrimaryKeyColumnMapping(ROLE_TABLE_ID_FIELD, 'Identity');

end;

procedure TEmployeePostgresRepository.CustomizeTableMapping(
  TableMapping: TDBTableMapping
);
begin

  CustomizeEmployeeMappings(TableMapping);

  FRoleMappings := TDBTableMapping.Create;

  CustomizeRoleMappings(FRoleMappings);

  FEmployeeContactInfoMappings := TDBTableMapping.Create;

  CustomizeEmployeeContactInfoMappings(FEmployeeContactInfoMappings);

  FEmployeeWorkGroupAssociationMappings := TDBTableMapping.Create;

  CustomizeEmployeeWorkGroupAssociationMappings(FEmployeeWorkGroupAssociationMappings);

  FTopLevelEmployeeMappings := TDBTableMapping.Create;

  CustomizeTopLevelEmployeeMappings(FTopLevelEmployeeMappings);

  FTopLevelEmployeeRoleMappings := TDBTableMapping.Create;

  CustomizeTopLevelEmployeeRoleMappings(FTopLevelEmployeeRoleMappings);

  FTopLevelEmployeeContactInfoMappings := TDBTableMapping.Create;

  CustomizeTopLevelEmployeeContactInfoMappings(FTopLevelEmployeeContactInfoMappings);

  FTopLevelEmployeeWorkGroupAssociationMappings := TDBTableMapping.Create;

  CustomizeTopLevelEmployeeWorkGroupAssociationMappings(FTopLevelEmployeeWorkGroupAssociationMappings);

end;

procedure TEmployeePostgresRepository.
  CustomizeTopLevelEmployeeContactInfoMappings(
    TopLevelEmployeeContactInfoMappings: TDBTableMapping
  );
begin

  TopLevelEmployeeContactInfoMappings.SetTableNameMappingWithAlias(
    EMPLOYEE_EMAIL_TABLE_NAME,
    TEmployeeContactInfo,
    EMPLOYEE_EMAIL_TABLE_NAME_ALIAS_2
  );

  TopLevelEmployeeContactInfoMappings.AddColumnMappingForSelectWithAlias(
    EMPLOYEE_EMAIL_TABLE_EMAIL_FIELD_NAME,
    'Email',
    EMPLOYEE_EMAIL_TABLE_EMAIL_FIELD_NAME_ALIAS_2
  );

  TopLevelEmployeeContactInfoMappings.AddPrimaryKeyColumnMapping(
    EMPLOYEE_EMAIL_TABLE_EMPLOYEE_ID_FIELD_NAME, ''
  );

end;

procedure TEmployeePostgresRepository.CustomizeTopLevelEmployeeMappings(
  TopLevelEmployeeMappings: TDBTableMapping);
begin

  TopLevelEmployeeMappings.SetTableNameMappingWithAlias(
    EMPLOYEE_TABLE_NAME, TEmployee, 'emp2'
  );

  TopLevelEmployeeMappings.AddColumnMappingForSelectWithAlias(
    EMPLOYEE_TABLE_ID_FIELD, 'Identity', EMPLOYEE_TABLE_ID_FIELD_ALIAS_2
  );

  TopLevelEmployeeMappings.AddColumnMappingForSelectWithAlias(
    EMPLOYEE_TABLE_LEGACY_ID_FIELD, 'LegacyIdentity', EMPLOYEE_TABLE_NAME_FIELD_ALIAS_2
  );
  
  TopLevelEmployeeMappings.AddColumnMappingForSelectWithAlias(
    EMPLOYEE_TABLE_NAME_FIELD, 'Name', EMPLOYEE_TABLE_NAME_FIELD_ALIAS_2
  );

  TopLevelEmployeeMappings.AddColumnMappingForSelectWithAlias(
    EMPLOYEE_TABLE_SURNAME_FIELD, 'Surname',
    EMPLOYEE_TABLE_SURNAME_FIELD_ALIAS_2
  );

  TopLevelEmployeeMappings.AddColumnMappingForSelectWithAlias(
    EMPLOYEE_TABLE_PATRONYMIC_FIELD, 'Patronymic',
    EMPLOYEE_TABLE_PATRONYMIC_FIELD_ALIAS_2
  );

  TopLevelEmployeeMappings.AddColumnMappingForSelectWithAlias(
    EMPLOYEE_TABLE_SPECIALITY_FIELD, 'Speciality',
    EMPLOYEE_TABLE_SPECIALITY_FIELD_ALIAS_2
  );

  TopLevelEmployeeMappings.AddColumnMappingForSelectWithAlias(
    EMPLOYEE_TABLE_PERSONNEL_NUMBER_FIELD, 'PersonnelNumber',
    EMPLOYEE_TABLE_PERSONNEL_NUMBER_FIELD_ALIAS_2
  );

  TopLevelEmployeeMappings.AddColumnMappingForSelectWithAlias(
    EMPLOYEE_TABLE_TELEPHONE_NUMBER_FIELD, 'TelephoneNumber',
    EMPLOYEE_TABLE_TELEPHONE_NUMBER_FIELD_ALIAS_2
  );

  TopLevelEmployeeMappings.AddColumnMappingForSelectWithAlias(
    EMPLOYEE_TABLE_DEPARTMENT_ID_FIELD, 'DepartmentIdentity',
    EMPLOYEE_TABLE_DEPARTMENT_ID_FIELD_ALIAS_2
  );

  TopLevelEmployeeMappings.AddColumnNameWithAliasForSelect(
    EMPLOYEE_TABLE_LEADER_ID_FIELD,
    EMPLOYEE_TABLE_LEADER_ID_FIELD_ALIAS_2
  );
  
  TopLevelEmployeeMappings.AddColumnMappingForSelectWithAlias(
    EMPLOYEE_TABLE_IS_FOREIGN_FIELD, 'IsForeign',
    EMPLOYEE_TABLE_IS_FOREIGN_FIELD_ALIAS_2
  );

  TopLevelEmployeeMappings.AddColumnMappingForSelectWithAlias(
    EMPLOYEE_TABLE_IS_DISMISSED_FIELD,
    'IsDismissed',
    EMPLOYEE_TABLE_IS_DISMISSED_FIELD_ALIAS_2
  );

  TopLevelEmployeeMappings.AddPrimaryKeyColumnMapping(
    EMPLOYEE_TABLE_ID_FIELD, 'Identity'
  );

end;

procedure TEmployeePostgresRepository.
  CustomizeTopLevelEmployeeRoleMappings(
    TopLevelEmployeeRoleMappings: TDBTableMapping
  );
begin

  TopLevelEmployeeRoleMappings.SetTableNameMappingWithAlias(
    ROLE_TABLE_NAME, TRole, ROLE_TABLE_NAME_ALIAS_2
  );

  TopLevelEmployeeRoleMappings.AddColumnMappingForSelectWithAlias(
    ROLE_TABLE_ID_FIELD, 'Identity', ROLE_TABLE_ID_FIELD_ALIAS_2
  );

  TopLevelEmployeeRoleMappings.AddColumnMappingForSelectWithAlias(
    ROLE_TABLE_NAME_FIELD, 'Name', ROLE_TABLE_NAME_FIELD_ALIAS_2
  );

  TopLevelEmployeeRoleMappings.AddColumnMappingForSelectWithAlias(
    ROLE_TABLE_DESCRIPTION_FIELD, 'Description', ROLE_TABLE_DESCRIPTION_FIELD_ALIAS_2
  );

  TopLevelEmployeeRoleMappings.AddPrimaryKeyColumnMapping(
    ROLE_TABLE_ID_FIELD, 'Identity'
  );

end;

procedure TEmployeePostgresRepository.
  CustomizeTopLevelEmployeeWorkGroupAssociationMappings(
    TopLevelEmployeeWorkGroupAssociationMappings: TDBTableMapping
  );
begin

  TopLevelEmployeeWorkGroupAssociationMappings.SetTableNameMappingWithAlias(
    EMPLOYEE_WORK_GROUPS_ASSOCIATION_TABLE_NAME,
    nil,
    EMPLOYEE_WORK_GROUPS_ASSOCIATION_TABLE_NAME_ALIAS_2
  );

  TopLevelEmployeeWorkGroupAssociationMappings.AddColumnMappingForSelectWithAlias(
    EMPLOYEE_WORK_GROUPS_ASSOCIATION_TABLE_WORK_GROUP_ID_FIELD,
    'WorkGroupId',
    EMPLOYEE_WORK_GROUPS_ASSOCIATION_TABLE_WORK_GROUP_ID_FIELD_ALIAS_2
  );

  TopLevelEmployeeWorkGroupAssociationMappings.AddColumnMappingForSelectWithAlias(
    EMPLOYEE_WORK_GROUPS_ASSOCIATION_TABLE_EMPLOYEE_ID_FIELD,
    'EmployeeId',
    EMPLOYEE_WORK_GROUPS_ASSOCIATION_TABLE_EMPLOYEE_ID_FIELD_ALIAS_2
  );
  
end;

destructor TEmployeePostgresRepository.Destroy;
begin

  FreeAndNil(FRoleMappings);
  FreeAndNil(FEmployeeContactInfoMappings);

  FreeAndNil(FTopLevelEmployeeMappings);
  FreeAndNil(FTopLevelEmployeeRoleMappings);
  FreeAndNil(FTopLevelEmployeeContactInfoMappings);

  FreeAndNil(FEmployeeReplacementPostgresRepository);

  FreeAndNil(FEmployeeWorkGroupAssociationMappings);
  FreeAndNil(FTopLevelEmployeeWorkGroupAssociationMappings);

  FreeAndNil(FTopLevelEmployeeCompiler);
  FreeAndNil(FTopLevelEmployeeRoleCompiler);
  FreeAndNil(FRoleCompiler);

  inherited;

end;

procedure TEmployeePostgresRepository.
  FillEmployeeWorkGroupIdsFrom(
    Employee: TEmployee;
    EmployeeWorkGroupAssociationMappings: TDBTableMapping;
    DataReader: IDataReader
  );
var
    EmployeeWorkGroupIdColumnName: String;
    EmployeeIdColumnName: String;
    EmployeeWorkGroupId: Variant;
begin

  EmployeeWorkGroupIdColumnName :=
    EmployeeWorkGroupAssociationMappings.
      FindSelectColumnMappingByObjectPropertyName(
        'WorkGroupId'
      ).GetColumnNameOrAliasName;


  EmployeeIdColumnName :=
    EmployeeWorkGroupAssociationMappings.
      FindSelectColumnMappingByObjectPropertyName(
        'EmployeeId'
      ).GetColumnNameOrAliasName;

  DataReader.Restart;
  
  while DataReader.Next do begin

    EmployeeWorkGroupId := DataReader[EmployeeWorkGroupIdColumnName];

    if VarIsNull(EmployeeWorkGroupId) or
       (DataReader[EmployeeIdColumnName] <> Employee.Identity) or
       Employee.WorkGroupIds.Contains(EmployeeWorkGroupId)
    then
      Continue;

    Employee.WorkGroupIds.Add(EmployeeWorkGroupId);

  end;

end;

function TEmployeePostgresRepository.FetchTopLevelEmployeeFrom(
  DataReader: IDataReader
): TEmployee;
var
    TopLevelEmployeeRole: TRole;
    EmailColumnName: String;
    TopLevelEmployeeIdColumnName: String;
    TopLevelEmployeeRoleIdColumnName: String;
begin

  Result := nil;
  TopLevelEmployeeRole := nil;

  try

    TopLevelEmployeeIdColumnName :=
      FTopLevelEmployeeMappings.
        FindSelectColumnMappingByObjectPropertyName('Identity').
          AliasColumnName;

    if VarIsNull(DataReader[TopLevelEmployeeIdColumnName])then
      Exit;

    Result := TEmployee.Create;
    
    FTopLevelEmployeeCompiler.CompileDomainObject(
      Result,
      DataReader
    );

    TopLevelEmployeeRoleIdColumnName :=
      FTopLevelEmployeeRoleMappings.
        FindSelectColumnMappingByObjectPropertyName('Identity').
          GetColumnNameOrAliasName;
          
    if VarIsNull(DataReader[TopLevelEmployeeRoleIdColumnName]) then
      Exit;

    TopLevelEmployeeRole := TRole.Create;

    FTopLevelEmployeeRoleCompiler.CompileDomainObject(
      TopLevelEmployeeRole,
      DataReader
    );

    Result.Role := TopLevelEmployeeRole;
    
    EmailColumnName :=
      FTopLevelEmployeeContactInfoMappings.
        FindSelectColumnMappingByObjectPropertyName('Email').
          GetColumnNameOrAliasName;

    if VarIsNull(DataReader[EmailColumnName]) then
      Exit;

    Result.Email := DataReader[EmailColumnName];

    FillEmployeeWorkGroupIdsFrom(
      Result, FTopLevelEmployeeWorkGroupAssociationMappings, DataReader
    );
      
  except

    on e: Exception do begin

      FreeAndNil(Result);
      FreeAndNil(TopLevelEmployeeRole);
      
      raise;
      
    end;

  end;
  
end;

procedure TEmployeePostgresRepository.FillDomainObjectFromDataReader(
  DomainObject: TDomainObject;
  DataReader: IDataReader
);
var EmployeeRole: TRole;
    LoadedEmployee: TEmployee;
begin

  inherited;

  LoadedEmployee := DomainObject as TEmployee;
  LoadedEmployee.Role := CreateAndFillEmployeeRoleFrom(DataReader);

  FillEmployeeContactInfoFrom(
    LoadedEmployee.ContactInfo, DataReader
  );

  LoadedEmployee.TopLevelEmployee :=
    FetchTopLevelEmployeeFrom(DataReader);

  LoadedEmployee.EmployeeReplacements :=
    FEmployeeReplacementPostgresRepository.FindEmployeeReplacements(
      LoadedEmployee.Identity
    );

  FillEmployeeWorkGroupIdsFrom(
    LoadedEmployee, FEmployeeWorkGroupAssociationMappings, DataReader
  );

end;

procedure TEmployeePostgresRepository.FillEmployeeContactInfoFrom(
  EmployeeContactInfo: TEmployeeContactInfo;
  DataReader: IDataReader
);
begin

  if not VarIsNull(DataReader[EMPLOYEE_EMAIL_TABLE_EMAIL_FIELD_NAME]) then
  begin
  
    EmployeeContactInfo.Email := DataReader[EMPLOYEE_EMAIL_TABLE_EMAIL_FIELD_NAME];
      
  end;

end;

function TEmployeePostgresRepository.GetCustomTrailingSelectQueryTextPart: String;
begin

  Result :=
    Format(
      'ORDER BY %s.%s',
      [
        FDBTableMapping.AliasTableName,
        FDBTableMapping.PrimaryKeyColumnMappings[0].ColumnName
      ]
    );

end;

function TEmployeePostgresRepository.GetJoinWithEmailTableExpression: String;
begin

  Result :=
    Format(
      'LEFT JOIN %s ON %s.%s=%s.%s',
      [
        FEmployeeContactInfoMappings.TableName,
        FEmployeeContactInfoMappings.TableName,
        FEmployeeContactInfoMappings.PrimaryKeyColumnMappings[0].ColumnName,
        FDBTableMapping.AliasTableName,
        EMPLOYEE_TABLE_EXTERNAL_ID_FIELD
      ]
    );

end;

function TEmployeePostgresRepository.
  GetJoinWithTopLevelEmployeeEmailTableExpression: String;
begin

  Result :=
    Format(
      'LEFT JOIN %s ON %s.%s=%s.%s',
      [
        FTopLevelEmployeeContactInfoMappings.TableNameWithAlias,
        FTopLevelEmployeeContactInfoMappings.AliasTableName,
        FTopLevelEmployeeContactInfoMappings.PrimaryKeyColumnMappings[0].ColumnName,
        FTopLevelEmployeeMappings.AliasTableName,
        EMPLOYEE_TABLE_EXTERNAL_ID_FIELD
      ]
    );

end;

function TEmployeePostgresRepository.
  GetJoinWithTopLevelEmployeeRoleAssociationTableExpression: String;
begin

  Result :=
    Format(
      'LEFT JOIN %s ON %s.%s=%s.%s',
      [
        EMPLOYEES_ROLES_TABLE_ASSOCIATION_NAME + ' as ' +
        EMPLOYEES_ROLES_TABLE_ASSOCIATION_NAME_ALIAS_2,
        EMPLOYEES_ROLES_TABLE_ASSOCIATION_NAME_ALIAS_2,
        EMPLOYEES_ROLES_TABLE_ASSOCIATION_EMPLOYEE_ID_FIELD,
        FTopLevelEmployeeMappings.AliasTableName,
        FDBTableMapping.PrimaryKeyColumnMappings[0].ColumnName
      ]
    );

end;

function TEmployeePostgresRepository.
  GetJoinWithTopLevelEmployeeRoleTableExpression: String;
begin

  Result :=
    Format(
      'LEFT JOIN %s ON %s.%s=%s.%s',
      [
        FTopLevelEmployeeRoleMappings.TableNameWithAlias,
        FTopLevelEmployeeRoleMappings.AliasTableName,
        FTopLevelEmployeeRoleMappings.PrimaryKeyColumnMappings[0].ColumnName,
        EMPLOYEES_ROLES_TABLE_ASSOCIATION_NAME_ALIAS_2,
        EMPLOYEES_ROLES_TABLE_ASSOCIATION_ROLE_ID_FIELD
      ]
    );
    
end;

function TEmployeePostgresRepository.
  GetJoinWithTopLevelEmployeeTableExpression: String;
begin

  Result :=
    Format(
      'LEFT JOIN %s ON %s.%s=%s.%s',
      [
        FTopLevelEmployeeMappings.TableNameWithAlias,
        FTopLevelEmployeeMappings.AliasTableName,

        FTopLevelEmployeeMappings.FindSelectColumnMappingByObjectPropertyName(
          'Identity'
        ).ColumnName,

        FDBTableMapping.AliasTableName,
        EMPLOYEE_TABLE_LEADER_ID_FIELD
      ]
    );

end;

function TEmployeePostgresRepository.
  GetJoinWithTopLevelEmployeeWorkGroupAssociationTableExpression: String;
begin

  Result :=
    Format(
      'LEFT JOIN %s ON %s.%s=%s.%s',
      [
        FTopLevelEmployeeWorkGroupAssociationMappings.TableNameWithAlias,
        FTopLevelEmployeeWorkGroupAssociationMappings.AliasTableName,

        FTopLevelEmployeeWorkGroupAssociationMappings.FindSelectColumnMappingByObjectPropertyName(
          'EmployeeId'
        ).ColumnName,

        FTopLevelEmployeeMappings.AliasTableName,
        FTopLevelEmployeeMappings.PrimaryKeyColumnMappings[0].ColumnName
      ]
    );
    
end;

function TEmployeePostgresRepository.GetJoinWithEmployeeRoleAssociationTableExpression: String;
begin

  Result :=
    Format(
      'LEFT JOIN %s ON %s.%s=%s.%s',
      [
        EMPLOYEES_ROLES_TABLE_ASSOCIATION_NAME + ' as ' +
        EMPLOYEES_ROLES_TABLE_ASSOCIATION_NAME_ALIAS_1,
        EMPLOYEES_ROLES_TABLE_ASSOCIATION_NAME_ALIAS_1,
        EMPLOYEES_ROLES_TABLE_ASSOCIATION_EMPLOYEE_ID_FIELD,
        FDBTableMapping.AliasTableName,
        FDBTableMapping.PrimaryKeyColumnMappings[0].ColumnName
      ]
    );
    
end;

function TEmployeePostgresRepository.GetJoinWithEmployeeWorkGroupAssociationTableExpression: String;
begin

  Result :=
    Format(
      'LEFT JOIN %s ON %s.%s=%s.%s',
      [
        FEmployeeWorkGroupAssociationMappings.TableName,
        FEmployeeWorkGroupAssociationMappings.TableName,

        FEmployeeWorkGroupAssociationMappings.FindSelectColumnMappingByObjectPropertyName(
          'EmployeeId'
        ).ColumnName,

        FDBTableMapping.AliasTableName,
        FDBTableMapping.PrimaryKeyColumnMappings[0].ColumnName
      ]
    );
    
end;

function TEmployeePostgresRepository.GetJoinWithRoleTableExpression: String;
begin

  Result :=
    Format(
      'LEFT JOIN %s ON %s.%s=%s.%s',
      [
        FRoleMappings.TableName,
        FRoleMappings.TableName,
        FRoleMappings.PrimaryKeyColumnMappings[0].ColumnName,
        EMPLOYEES_ROLES_TABLE_ASSOCIATION_NAME_ALIAS_1,
        EMPLOYEES_ROLES_TABLE_ASSOCIATION_ROLE_ID_FIELD
      ]
    );

end;

function TEmployeePostgresRepository.GetEmployeeColumnNameList: String;
begin

  Result :=
    TableMapping.GetSelectColumnNameListWithoutTablePrefix + ',' +
    FRoleMappings.GetSelectColumnNameListWithoutTablePrefix + ',' +
    FEmployeeContactInfoMappings.GetSelectColumnNameListWithoutTablePrefix + ',' +
    FEmployeeWorkGroupAssociationMappings.GetSelectColumnNameListWithoutTablePrefix + ',' +

    FTopLevelEmployeeMappings.GetSelectColumnNameListWithoutTablePrefix + ',' +
    FTopLevelEmployeeRoleMappings.GetSelectColumnNameListWithoutTablePrefix + ',' +
    FTopLevelEmployeeContactInfoMappings.GetSelectColumnNameListWithoutTablePrefix + ',' +
    FTopLevelEmployeeWorkGroupAssociationMappings.GetSelectColumnNameListWithoutTablePrefix;

end;

procedure TEmployeePostgresRepository.GetSelectListFromTableMappingForSelectByIdentity(
  var SelectList, WhereClauseForSelectIdentity: String
);
var RoleSelectList, Placeholder: String;
    EmployeeContactInfoSelectList: String;
    TopLevelEmployeeSelectList,
    TopLevelEmployeeRoleSelectList,
    TopLevelEmployeeContactInfoSelectList: String;
    EmployeeWorkGroupAssociationSelectList: String;
    TopLevelEmployeeWorkGroupAssociationSelectList: String;
begin

  inherited;

  FRoleMappings.GetSelectListForSelectByIdentity(RoleSelectList, Placeholder);

  FEmployeeContactInfoMappings.GetSelectListForSelectByIdentity(
    EmployeeContactInfoSelectList, Placeholder
  );

  FEmployeeWorkGroupAssociationMappings.GetSelectListForSelectByIdentity(
    EmployeeWorkGroupAssociationSelectList, Placeholder
  );

  FTopLevelEmployeeMappings.GetSelectListForSelectByIdentity(
    TopLevelEmployeeSelectList, Placeholder
  );

  FTopLevelEmployeeRoleMappings.GetSelectListForSelectByIdentity(
    TopLevelEmployeeRoleSelectList, Placeholder
  );

  FTopLevelEmployeeContactInfoMappings.GetSelectListForSelectByIdentity(
    TopLevelEmployeeContactInfoSelectList, Placeholder
  );

  FTopLevelEmployeeWorkGroupAssociationMappings.
    GetSelectListForSelectByIdentity(
      TopLevelEmployeeWorkGroupAssociationSelectList, Placeholder
    );

  SelectList :=
    SelectList + ',' +
    RoleSelectList + ',' +
    EmployeeContactInfoSelectList + ',' +
    EmployeeWorkGroupAssociationSelectList + ',' +
    TopLevelEmployeeSelectList + ',' +
    TopLevelEmployeeRoleSelectList + ',' +
    TopLevelEmployeeContactInfoSelectList + ',' +
    TopLevelEmployeeWorkGroupAssociationSelectList;

end;

function TEmployeePostgresRepository.GetSelectListFromTableMappingForSelectGroup: String;
begin

  Result := inherited GetSelectListFromTableMappingForSelectGroup;

  Result :=
    Result + ',' +
    FRoleMappings.GetSelectListForSelectGroup + ',' +
    FEmployeeContactInfoMappings.GetSelectListForSelectGroup + ',' +
    FEmployeeWorkGroupAssociationMappings.GetSelectListForSelectGroup + ',' +

    FTopLevelEmployeeMappings.GetSelectListForSelectGroup + ',' +
    FTopLevelEmployeeRoleMappings.GetSelectListForSelectGroup + ',' +
    FTopLevelEmployeeContactInfoMappings.GetSelectListForSelectGroup + ',' +
    FTopLevelEmployeeWorkGroupAssociationMappings.GetSelectListForSelectGroup;
  
end;

function TEmployeePostgresRepository.GetTableNameFromTableMappingForSelect: String;
begin

  Result := inherited GetTableNameFromTableMappingForSelect + ' ' +
                      GetJoinWithEmployeeRoleAssociationTableExpression + ' ' +
                      GetJoinWithRoleTableExpression + ' ' +
                      GetJoinWithEmailTableExpression + ' ' +
                      GetJoinWithEmployeeWorkGroupAssociationTableExpression + ' ' +
                      GetJoinWithTopLevelEmployeeTableExpression + ' ' +
                      GetJoinWithTopLevelEmployeeRoleAssociationTableExpression + ' ' +
                      GetJoinWithTopLevelEmployeeRoleTableExpression + ' ' +
                      GetJoinWithTopLevelEmployeeEmailTableExpression + ' ' +
                      GetJoinWithTopLevelEmployeeWorkGroupAssociationTableExpression;

  
end;

function TEmployeePostgresRepository.
  GetQueryParameterValueFromDomainObject(
    DomainObject: TDomainObject;
    const DomainObjectPropertyName: String
  ): Variant;
var Employee: TEmployee;
begin

  if DomainObjectPropertyName <> 'LeaderIdentity' then begin

    Result :=
      inherited GetQueryParameterValueFromDomainObject(
                  DomainObject, DomainObjectPropertyName
                );

    Exit;
    
  end;

  Employee := DomainObject as TEmployee;

  if Assigned(Employee.TopLevelEmployee) then
    Result := Employee.TopLevelEmployee.Identity

  else Result := Null;

end;

procedure TEmployeePostgresRepository.Initialize;
begin

  inherited;

  FEmployeeReplacementPostgresRepository :=
    TEmployeeReplacementPostgresRepository.Create;
    
end;

procedure TEmployeePostgresRepository.InitializeTableMappings(
  TableDef: TTableDef);
begin

  inherited InitializeTableMappings(TableDef);

  FRoleCompiler :=
    TDomainObjectCompiler.Create(
      FRoleMappings.ColumnMappingsForSelect
    );

  FTopLevelEmployeeCompiler :=
    TDomainObjectCompiler.Create(
      FTopLevelEmployeeMappings.ColumnMappingsForSelect
    );

  FTopLevelEmployeeRoleCompiler :=
    TDomainObjectCompiler.Create(
      FTopLevelEmployeeRoleMappings.ColumnMappingsForSelect
    );
    
end;

procedure TEmployeePostgresRepository.PrepareAllLeadersForEmployeeFetchingQuery(
  const EmployeeId: Variant;
  var QueryPattern: String;
  var QueryParams: TQueryParams
);
begin

  QueryPattern := FIND_ALL_LEADERS_FOR_EMPLOYEE_QUERY;

  QueryParams := TQueryParams.Create;

  QueryParams.Add(EMPLOYEE_ID_PARAM_NAME, EmployeeId);

end;

procedure TEmployeePostgresRepository.
  PrepareAllTopLevelEmployeesForEmployeeFetchingQuery(
    const EmployeeId: Variant;
    var QueryPattern: String;
    var QueryParams: TQueryParams
  );
var ColumnNameList, SelectGroupList, JoinTableName: String;
    QueryText: String;
begin

  ColumnNameList := GetEmployeeColumnNameList;
  SelectGroupList := GetSelectListFromTableMappingForSelectGroup;
  JoinTableName := GetTableNameFromTableMappingForSelect;

  QueryPattern :=
    Format(
      'WITH RECURSIVE get_all_top_level_employees (%s,level) AS (' +
      'SELECT ' +
      '%s,' +
      '0 as level ' +
      'FROM %s ' +
      'JOIN %s b ON b.%s=%s.%s ' +
      'WHERE b.%s=%s' +
      'UNION ' +
      'SELECT ' +
      '%s,' +
      'b.level + 1 as level ' +
      'FROM %s ' +
      'JOIN get_all_top_level_employees b ON b.%s=%s.%s' +
      ') ' +
      'SELECT * FROM get_all_top_level_employees ' +
      'ORDER BY level ASC',
      [
        ColumnNameList,

        SelectGroupList,

        JoinTableName,

        TableMapping.TableName,
        EMPLOYEE_TABLE_LEADER_ID_FIELD,
        TableMapping.AliasTableName,
        EMPLOYEE_TABLE_ID_FIELD,

        EMPLOYEE_TABLE_ID_FIELD,
        VarToStr(EmployeeId),

        SelectGroupList,

        JoinTableName,

        EMPLOYEE_TABLE_LEADER_ID_FIELD,
        TableMapping.AliasTableName,
        EMPLOYEE_TABLE_ID_FIELD
      ]
    );

end;

procedure TEmployeePostgresRepository.
  PrepareAllTopLevelEmployeesFromSameHeadKindredDepartmentForEmployeeFetchingQuery(
    const EmployeeId: Variant;
    var QueryPattern: String;
    var QueryParams: TQueryParams
  );
var ColumnNameList, SelectGroupList, JoinTableName: String;
    QueryText: String;
begin

  ColumnNameList := GetEmployeeColumnNameList;
  SelectGroupList := GetSelectListFromTableMappingForSelectGroup;
  JoinTableName := GetTableNameFromTableMappingForSelect;

  QueryPattern :=
    Format(
      'WITH RECURSIVE get_all_top_level_employees (%s,level) AS (' +
      'SELECT ' +
      '%s,' +
      '0 as level ' +
      'FROM %s ' +
      'JOIN %s b ON b.%s=%s.%s ' +
      'WHERE b.%s=%s AND b.%s=%s.%s ' +
      'UNION ' +
      'SELECT ' +
      '%s,' +
      'b.level + 1 as level ' +
      'FROM %s ' +
      'JOIN get_all_top_level_employees b ON b.%s=%s.%s ' +
      'WHERE b.%s=%s.%s' +
      ') ' +
      'SELECT * FROM get_all_top_level_employees ' +
      'ORDER BY level ASC',
      [
        ColumnNameList,

        SelectGroupList,

        JoinTableName,

        TableMapping.TableName,
        EMPLOYEE_TABLE_LEADER_ID_FIELD,
        TableMapping.AliasTableName,
        EMPLOYEE_TABLE_ID_FIELD,

        EMPLOYEE_TABLE_ID_FIELD,
        VarToStr(EmployeeId),

        EMPLOYEE_TABLE_HEAD_KINDRED_DEPARTMENT_ID_FIELD,
        TableMapping.AliasTableName,
        EMPLOYEE_TABLE_HEAD_KINDRED_DEPARTMENT_ID_FIELD,

        SelectGroupList,

        JoinTableName,

        EMPLOYEE_TABLE_LEADER_ID_FIELD,
        TableMapping.AliasTableName,
        EMPLOYEE_TABLE_ID_FIELD,

        EMPLOYEE_TABLE_HEAD_KINDRED_DEPARTMENT_ID_FIELD,
        TableMapping.AliasTableName,
        EMPLOYEE_TABLE_HEAD_KINDRED_DEPARTMENT_ID_FIELD
      ]
    );

end;

procedure TEmployeePostgresRepository.PrepareAndExecuteAddDomainObjectQuery(
  DomainObject: TDomainObject);
var AddedEmployee: TEmployee;
begin

  inherited;

  AddedEmployee := DomainObject as TEmployee;

  TRepositoryRegistry.Current.GetRoleRepository.AddRoleForEmployee(
    AddedEmployee
  );

  FEmployeeReplacementPostgresRepository.AddEmployeeReplacements(
    AddedEmployee.EmployeeReplacements
  );

  FEmployeeReplacementPostgresRepository.
    ThrowExceptionIfErrorIsNotUnknown;

end;

procedure TEmployeePostgresRepository.PrepareAndExecuteRemoveDomainObjectQuery(
  DomainObject: TDomainObject);
var RemovableEmployee: TEmployee;
begin

  RemovableEmployee := DomainObject as TEmployee;

  TRepositoryRegistry.Current.GetRoleRepository.RemoveRoleFromEmployee(
    RemovableEmployee
  );

  FEmployeeReplacementPostgresRepository.RemoveAllEmployeeReplacements(
    RemovableEmployee.Identity
  );

  FEmployeeReplacementPostgresRepository.
    ThrowExceptionIfErrorIsNotUnknown;
  
  inherited;

end;

procedure TEmployeePostgresRepository.PrepareAndExecuteUpdateDomainObjectQuery(
  DomainObject: TDomainObject);
var UpdatedEmployee: TEmployee;
    RoleRepository: IRoleRepository;
begin

  inherited;

  UpdatedEmployee := DomainObject as TEmployee;

  RoleRepository := TRepositoryRegistry.Current.GetRoleRepository;

  RoleRepository.RemoveAllRolesFromEmployee(UpdatedEmployee);
  RoleRepository.AddRoleForEmployee(UpdatedEmployee);

  FEmployeeReplacementPostgresRepository.RemoveAllEmployeeReplacements(
    UpdatedEmployee.Identity
  );

  FEmployeeReplacementPostgresRepository.
    ThrowExceptionIfErrorIsNotUnknown;

  FEmployeeReplacementPostgresRepository.AddEmployeeReplacements(
    UpdatedEmployee.EmployeeReplacements
  );

  FEmployeeReplacementPostgresRepository.
    ThrowExceptionIfErrorIsNotUnknown;

end;

procedure TEmployeePostgresRepository.PrepareFindDomainObjectsByCriteria(
  Criteria: TAbstractRepositoryCriterion;
  var QueryPattern: String;
  var QueryParams: TQueryParams
);
var
    FindAllLeadersForEmployeeCriterion: TFindAllLeadersForEmployeeCriterion;
    FindAllTopLevelEmployeesForEmployeeCriterion: TFindAllTopLevelEmployeesForEmployeeCriterion;
begin

  if Criteria is TFindAllLeadersForEmployeeCriterion then begin

    FindAllLeadersForEmployeeCriterion :=
      Criteria as TFindAllLeadersForEmployeeCriterion;

    PrepareAllLeadersForEmployeeFetchingQuery(
      FindAllLeadersForEmployeeCriterion.EmployeeId,
      QueryPattern,
      QueryParams
    );

  end

  else if Criteria is TFindAllTopLevelEmployeesForEmployeeCriterion
  then begin

    FindAllTopLevelEmployeesForEmployeeCriterion :=
      Criteria as TFindAllTopLevelEmployeesForEmployeeCriterion;

    if Criteria is TFindAllTopLevelEmployeesFromSameHeadKindredDepartmentForEmployeeCriterion
    then begin

      PrepareAllTopLevelEmployeesFromSameHeadKindredDepartmentForEmployeeFetchingQuery(
        FindAllTopLevelEmployeesForEmployeeCriterion.EmployeeId,
        QueryPattern,
        QueryParams
      );

    end

    else begin

      PrepareAllTopLevelEmployeesForEmployeeFetchingQuery(
        FindAllTopLevelEmployeesForEmployeeCriterion.EmployeeId,
        QueryPattern,
        QueryParams
      );

    end;
    
  end

  else inherited;
  
end;

function TEmployeePostgresRepository.FindAllTopLevelEmployeesForEmployee(
  const EmployeeId: Variant): TEmployees;
var FindAllTopLevelEmployeesForEmployeeCriterion:
      TFindAllTopLevelEmployeesForEmployeeCriterion;
begin

  FindAllTopLevelEmployeesForEmployeeCriterion :=
    TFindAllTopLevelEmployeesForEmployeeCriterion.Create(
      EmployeeId, Self
    );

  try

    Result := FindEmployeesByCriteria(FindAllTopLevelEmployeesForEmployeeCriterion);

    ThrowExceptionIfErrorIsNotUnknown;
    
  finally

    FreeAndNil(FindAllTopLevelEmployeesForEmployeeCriterion);

  end;

end;

function TEmployeePostgresRepository.
  FindAllTopLevelEmployeesFromSameHeadKindredDepartmentForEmployee(
    const EmployeeId: Variant
  ): TEmployees;
var Criteria:
  TFindAllTopLevelEmployeesFromSameHeadKindredDepartmentForEmployeeCriterion;
begin

  Criteria :=
    TFindAllTopLevelEmployeesFromSameHeadKindredDepartmentForEmployeeCriterion.Create(
      EmployeeId, Self
    );

  try

    Result := FindEmployeesByCriteria(Criteria);

    ThrowExceptionIfErrorIsNotUnknown;
    
  finally

    FreeAndNil(Criteria);

  end;

end;

function TEmployeePostgresRepository.FindEmployeeById(
  const Id: Variant
): TEmployee;
var DomainObject: TDomainObject;
begin

   DomainObject := FindDomainObjectByIdentity(Id);

   ThrowExceptionIfErrorIsNotUnknown;
   
   if DomainObject = nil then begin

     Result := nil;
     Exit;

   end;

   Result := DomainObject as TEmployee;

end;

function TEmployeePostgresRepository.FindEmployeesByCriteria(
  Criteria: TEmployeePostgresRepositoryCriterion
): TEmployees;
var DomainObjectList: TDomainObjectList;
begin

  DomainObjectList := FindDomainObjectsByCriteria(Criteria);

  if DomainObjectList = nil then
    Result := nil

  else Result := DomainObjectList as TEmployees;
  
end;

function TEmployeePostgresRepository.FindEmployeesByIdentities(
  const Identities: TVariantList
): TEmployees;
var FindEmployeesByIdentitiesCriterion:
      TFindEmployeesByIdentitiesCriterion;
begin

  FindEmployeesByIdentitiesCriterion :=
    TFindEmployeesByIdentitiesCriterion.Create(
      Identities, Self
    );

  try

    Result := FindEmployeesByCriteria(FindEmployeesByIdentitiesCriterion);

    ThrowExceptionIfErrorIsNotUnknown;
    
  finally

    FreeAndNil(FindEmployeesByIdentitiesCriterion);
    
  end;

end;

function TEmployeePostgresRepository.FindEmployeesByIdentitiesAndRoles(
  const Identities, RoleIds: TVariantList): TEmployees;
var
    Roles: TRoleList;
    FreeEmployees: IDomainObjectBaseList;
    FreeRoles: IDomainObjectBaseList;
begin

  Roles :=
    TRepositoryRegistry
      .Current
        .GetRoleRepository
          .FindRolesByIds(RoleIds);

  FreeRoles := Roles;

  Result := FindEmployeesByIdentities(Identities);

  FreeEmployees := Result;
    
  Result := Result.FindEmployeesByRoles(Roles);

end;

function TEmployeePostgresRepository.FindEmployeesForLeaderByRoles(
  const LeaderId: Variant;
  const RoleIds: TVariantList
): TEmployees;
var
    RoleIdArray: TRoleIdArray;
begin

  RoleIdArray := RoleIds.ToVariantArray;

  Result := FindEmployeesForLeaderByRoles(LeaderId, RoleIdArray);
  
end;

function TEmployeePostgresRepository.LoadAllEmployees: TEmployees;
var DomainObjectList: TDomainObjectList;
begin

  DomainObjectList := LoadAll;

  ThrowExceptionIfErrorIsNotUnknown;
  
  if DomainObjectList = nil then
    Result := nil

  else Result := DomainObjectList as TEmployees;

end;

function TEmployeePostgresRepository.FindLeaderByDepartmentCode(
  const DepartmentCode: String
): TEmployee;
var
    FindLeaderByDepartmentCodeCriterion: TFindLeaderByDepartmentCodeCriterion;
begin

  FindLeaderByDepartmentCodeCriterion :=
    TFindLeaderByDepartmentCodeCriterion.Create(DepartmentCode, Self);

  try

    Result := FindLeaderByDepartmentPropertyCriterion(FindLeaderByDepartmentCodeCriterion);

    ThrowExceptionIfErrorIsNotUnknown;
    
  finally

    FreeAndNil(FindLeaderByDepartmentCodeCriterion);

  end;

end;

function TEmployeePostgresRepository.FindLeaderByDepartmentId(
  const DepartmentId: Variant
): TEmployee;
var
    FindLeaderByDepartmentIdCriterion: TFindLeaderByDepartmentIdCriterion;
begin

  FindLeaderByDepartmentIdCriterion :=
    TFindLeaderByDepartmentIdCriterion.Create(DepartmentId, Self);

  try

    Result := FindLeaderByDepartmentPropertyCriterion(FindLeaderByDepartmentIdCriterion);

    ThrowExceptionIfErrorIsNotUnknown;
    
  finally

    FreeAndNil(FindLeaderByDepartmentIdCriterion);
    
  end;

end;

function TEmployeePostgresRepository.FindLeaderByDepartmentPropertyCriterion(
  const Criterion: TFindLeaderByDepartmentPropertyCriterion
): TEmployee;
var
    Employees: TEmployees;
begin

  Employees := FindEmployeesByCriteria(Criterion);
  
  try

    if not Assigned(Employees) or Employees.IsEmpty then
      Result := nil

    else if Employees.Count > 1 then begin

      raise Exception.Create(
        'Для подразделения в БД было найдено ' +
        'более одного руководителя'
      );

    end

    else Result := TEmployee(Employees[0].Clone);

  finally

    FreeAndNil(Employees);

  end;

end;

function TEmployeePostgresRepository.FindLeadersByIdentities(
  const Identities: TVariantList
): TEmployees;
var
    LeaderRoleIds: TVariantList;
begin

  LeaderRoleIds := TVariantList.CreateFrom(TRoleMemento.GetLeaderRole.Identity);

  try

    Result := FindEmployeesByIdentitiesAndRoles(Identities, LeaderRoleIds);
    
  finally

    FreeAndNil(LeaderRoleIds);
    
  end;

end;

function TEmployeePostgresRepository.FindLeadersForEmployee(
  const EmployeeId: Variant
): TEmployees;
var FindAllLeadersForEmployeeCriterion: TFindAllLeadersForEmployeeCriterion;
begin

  try

    FindAllLeadersForEmployeeCriterion :=
      TFindAllLeadersForEmployeeCriterion.Create(
        EmployeeId, Self
      );

    Result := FindEmployeesByCriteria(FindAllLeadersForEmployeeCriterion);

    ThrowExceptionIfErrorIsNotUnknown;

  finally

    FreeAndNil(FindAllLeadersForEmployeeCriterion);
    
  end;

end;

function TEmployeePostgresRepository.FindLeadershipEmployeesForLeader(
  const LeaderId: Variant): TEmployees;
var
    LeadershipRoleIds: TVariantList;
begin

  LeadershipRoleIds := TRoleMemento.GetLeadershipRoleIds;

  try


    Result :=
      FindEmployeesForLeaderByRoles(
        LeaderId,
        LeadershipRoleIds.ToVariantArray
      );

    ThrowExceptionIfErrorIsNotUnknown;

  finally

    FreeAndNil(LeadershipRoleIds);

  end;

end;

function TEmployeePostgresRepository.
  FindEmployeesForLeaderByRoles(
    const LeaderId: Variant;
    const EmployeeRoleIds: TRoleIdArray
  ): TEmployees;
var
    Criterion: TFindEmployeesForLeaderByRolesCritertion;
begin

  Criterion := TFindEmployeesForLeaderByRolesCritertion.Create(Self, LeaderId, EmployeeRoleIds);

  try

    Result := FindEmployeesByCriteria(Criterion);
    
  finally

    FreeAndNil(Criterion);

  end;

end;

procedure TEmployeePostgresRepository.AddEmployee(Employee: TEmployee);
begin

  Add(Employee);

  ThrowExceptionIfErrorIsNotUnknown;
  
end;

procedure TEmployeePostgresRepository.UpdateEmployee(Employee: TEmployee);
begin

  Update(Employee);

  ThrowExceptionIfErrorIsNotUnknown;
  
end;

procedure TEmployeePostgresRepository.RemoveEmployee(Employee: TEmployee);
begin

  Remove(Employee);

  ThrowExceptionIfErrorIsNotUnknown;

end;

procedure TEmployeePostgresRepository.SetQueryExecutor(const Value: IQueryExecutor);
begin

  inherited;

  FEmployeeReplacementPostgresRepository.QueryExecutor := Value;
  
end;

{ TEmployeePostgresRepositoryCriterion }

constructor TEmployeePostgresRepositoryCriterion.Create(
  EmployeePostgresRepository: TEmployeePostgresRepository);
begin

  inherited Create;

  FEmployeePostgresRepository := EmployeePostgresRepository;

end;

{ TFindAllTopLevelEmployeesForEmployeeCriterion }

constructor TFindAllTopLevelEmployeesForEmployeeCriterion.Create(
  const EmployeeId: Variant;
  EmployeePostgresRepository: TEmployeePostgresRepository);
begin

  inherited Create(EmployeePostgresRepository);

  FEmployeeId := EmployeeId;
  
end;

destructor TFindAllTopLevelEmployeesForEmployeeCriterion.Destroy;
begin

  inherited;

end;

function TFindAllTopLevelEmployeesForEmployeeCriterion.GetExpression: String;
var EmployeeIdColumnName: String;
begin

  EmployeeIdColumnName :=
    FEmployeePostgresRepository.
      TableMapping.
        ColumnMappingsForSelect.
          FindColumnMappingByObjectPropertyName('Identity').
            ColumnName;

  Result := EmployeeIdColumnName + '=' + VarToStr(EmployeeId);
  
end;

{ TFindEmployeesByIdentitiesCriterion }

constructor TFindEmployeesByIdentitiesCriterion.Create(
  EmployeeIdentities: TVariantList;
  Repository: TEmployeePostgresRepository
);
begin

  inherited Create(Repository);

  FEmployeeIdentities := EmployeeIdentities;

end;

function TFindEmployeesByIdentitiesCriterion.GetExpression: String;
var IdentityColumnName: String;
    TableName: String;
    TableColumnMapping: TDBTableColumnMapping;
begin

  TableColumnMapping :=
    FEmployeePostgresRepository.TableMapping.PrimaryKeyColumnMappings[0];

  if TableColumnMapping.AliasColumnName <> '' then
    IdentityColumnName := TableColumnMapping.AliasColumnName

  else begin

    if FEmployeePostgresRepository.TableMapping.AliasTableName <> '' then
      TableName := FEmployeePostgresRepository.TableMapping.AliasTableName

    else
      TableName := FEmployeePostgresRepository.TableMapping.TableName;
      
    IdentityColumnName :=
      TableName + '.' + TableColumnMapping.ColumnName;

  end;

  Result :=
    Format(
      '%s IN (%s)',
      [
        IdentityColumnName,
        CreateStringFromVariantList(FEmployeeIdentities)
      ]
    );
    
end;

{ TFindLeaderByDepartmentIdCriterion }

constructor TFindLeaderByDepartmentPropertyCriterion.Create(
  const DepartmentProperty: Variant;
  const DepartmentPropertyColumnName: String;
  Repository: TEmployeePostgresRepository
);
begin

  inherited Create(Repository);

  FDepartmentProperty := DepartmentProperty;
  FDepartmentPropertyColumnName := DepartmentPropertyColumnName;
  
end;

function TFindLeaderByDepartmentPropertyCriterion.GetExpression: String;
var
    DepartmentIdColumnName: String;
    RoleIdColumnName: String;
begin

  DepartmentIdColumnName :=
    FEmployeePostgresRepository
      .TableMapping
        .AliasTableName +

        '.'

    + FEmployeePostgresRepository
      .TableMapping
        .FindSelectColumnMappingByObjectPropertyName('DepartmentIdentity')
          .ColumnName;

  RoleIdColumnName :=
    EMPLOYEES_ROLES_TABLE_ASSOCIATION_NAME_ALIAS_1 +

        '.'

    + FEmployeePostgresRepository
      .FRoleMappings
        .FindSelectColumnMappingByObjectPropertyName('Identity')
          .AliasColumnName;

  Result :=
    Format(
      '%s=%s AND %s=(SELECT %s FROM %s WHERE %s=%s AND %s IS NULL)',
      [
        RoleIdColumnName,
        AsSQLString(TRoleMemento.GetLeaderRole.Identity),

        DepartmentIdColumnName,
        DEPARTMENT_TABLE_ID_FIELD,
        DEPARTMENT_TABLE_NAME,
        FDepartmentPropertyColumnName,
        AsSQLString(FDepartmentProperty),
        DEPARTMENT_TABLE_INACTIVE_STATUS_FIELD
      ]
    );
    
end;

{ TFindLeaderByDepartmentIdCriterion }

constructor TFindLeaderByDepartmentIdCriterion.Create(
  const DepartmentId: Variant;
  Repository: TEmployeePostgresRepository
);
begin

  inherited Create(DepartmentId, DEPARTMENT_TABLE_ID_FIELD, Repository);

end;

{ TFindLeaderByDepartmentCodeCriterion }

constructor TFindLeaderByDepartmentCodeCriterion.Create(
  const DepartmentCode: String;
  Repository: TEmployeePostgresRepository
);
begin

  inherited Create(DepartmentCode, DEPARTMENT_TABLE_CODE_FIELD, Repository);

end;

{ TFindEmployeesForLeaderByRolesCritertion }

constructor TFindEmployeesForLeaderByRolesCritertion.Create(
  EmployeePostgresRepository: TEmployeePostgresRepository;
  const LeaderId: Variant;
  const EmployeeRoleIds: TRoleIdArray
);
begin

  inherited Create(EmployeePostgresRepository);

  FLeaderId := LeaderId;
  FEmployeeRoleIds := EmployeeRoleIds;
  
end;

function TFindEmployeesForLeaderByRolesCritertion.GetExpression: String;
var

    LeaderIdColumnName, LeaderRoleIdColumnName, EmployeeRoleIdColumnName: String;
    LeaderDepartmentIdColumnName, EmployeeDepartmentIdColumnName: String;
begin

  EmployeeRoleIdColumnName :=
    FEmployeePostgresRepository
      .FRoleMappings
        .GetTableNameOrAliasName
        
    + '.' +

    FEmployeePostgresRepository
      .FRoleMappings
        .FindSelectColumnMappingByObjectPropertyName('Identity')
          .ColumnName;

  LeaderIdColumnName :=
    FEmployeePostgresRepository
      .FTopLevelEmployeeMappings
        .GetTableNameOrAliasName

    + '.' +
    
    FEmployeePostgresRepository
      .FTopLevelEmployeeMappings
        .FindSelectColumnMappingByObjectPropertyName('Identity')
          .ColumnName;

  LeaderRoleIdColumnName :=
    FEmployeePostgresRepository
      .FTopLevelEmployeeRoleMappings
        .GetTableNameOrAliasName

    + '.' +
    
    FEmployeePostgresRepository
      .FTopLevelEmployeeRoleMappings
        .FindSelectColumnMappingByObjectPropertyName('Identity')
          .ColumnName;

  LeaderDepartmentIdColumnName :=
    FEmployeePostgresRepository
      .FTopLevelEmployeeMappings
        .GetTableNameOrAliasName

    + '.' +

    FEmployeePostgresRepository
      .FTopLevelEmployeeMappings
        .FindSelectColumnMappingByObjectPropertyName('DepartmentIdentity')
          .ColumnName;

  EmployeeDepartmentIdColumnName :=
    FEmployeePostgresRepository
      .TableMapping
        .GetTableNameOrAliasName

    + '.' +

    FEmployeePostgresRepository
      .TableMapping
        .FindSelectColumnMappingByObjectPropertyName('DepartmentIdentity')
          .ColumnName;
    
  Result :=
    Format(
      '%s=%s AND %s=%s AND %s IN (%s) AND %s=%s',
      [
        LeaderIdColumnName,
        VarToStr(FLeaderId),

        LeaderRoleIdColumnName,
        VarToStr(TRoleMemento.GetLeaderRole.Identity),

        EmployeeRoleIdColumnName,
        CreateStringFromVariantArray(FEmployeeRoleIds),

        LeaderDepartmentIdColumnName,
        EmployeeDepartmentIdColumnName
      ]
    );
    
end;

end.
