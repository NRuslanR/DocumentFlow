unit BasedOnDatabaseEmployeeSetReadService;

interface

uses

  DB,
  DataReader,
  QueryExecutor,
  VariantListUnit,
  DataSetDataReader,
  EmployeeSetReadService,
  EmployeeStaffDto,
  EmployeeChargePerformingUnitDto,
  EmployeeSetHolder,
  EmployeeDbSchema,
  DepartmentDbSchema,
  DataSetQueryExecutor,
  EmployeeWorkGroupAssociationDbSchema,
  RoleDbSchema,
  SysUtils,
  Classes;

type

  TBasedOnDatabaseEmployeeSetReadService =
    class (TInterfacedObject, IEmployeeSetReadService)

      private

        FEmployeeDbSchema: TEmployeeDbSchema;
        FDepartmentDbSchema: TDepartmentDbSchema;
        FRoleDbSchema: TRoleDbSchema;
        FEmployeeWorkGroupAssociationDbSchema: TEmployeeWorkGroupAssociationDbSchema;

        FQueryExecutor: IQueryExecutor;
        
        FFetchingEmployeeSetFromHeadKindredDepartmentOfOtherEmployeeQueryPattern: String;
        FFetchingAllEmployeeSetQueryPattern: String;
        FFetchingAllEmployeeSetByGivenRolesQueryPattern: String;
        FFetchingLeaderSetForEmployeeFromSameHeadKindredDepartmentQueryPattern: String;
        FFetchingAllPlantEmployeeSetQueryPattern: String;
        FFetchingAllPlantEmployeeSetFromHeadKindredDepartmentOfOtherEmployee: String;
        FFetchingAllNotForeignEmployeeSetQueryPattern: String;
        FFetchingAllEmployeeWithRoleSetQueryPattern: String;
        FFetchingEmployeeSetByIdsQueryPattern: String;
        FFetchingEmployeeSetFromEmployeeStaffsQueryPattern: String;
        FFetchingEmployeeSetFromChargePerformingUnitQueryPattern: String;
        FFetchingLeadershipEmployeeSetForLeaderQueryPattern: String;
        
      protected

        function CreateDefaultSelectColumnList(
          EmployeeDbSchema: TEmployeeDbSchema;
          DepartmentDbSchema: TDepartmentDbSchema
        ): String; virtual;

        function CreateDefaultTableLayout(
          EmployeeDbSchema: TEmployeeDbSchema;
          DepartmentDbSchema: TDepartmentDbSchema
        ): String; virtual;

        function CreateJoinTableLayout(
          EmployeeDbSchema: TEmployeeDbSchema;
          DepartmentDbSchema: TDepartmentDbSchema;
          const EmployeeIdJoinExpr: String;
          const AliasTableName, DepartmentTableAliasName: String
        ): String;

        function CreateJoinRoleLayout(
          RoleDbSchema: TRoleDbSchema;
          const RoleIdJoinExpr: String;
          const AliasTableName: String = ''
        ): String;

        function CreateJoinDepartmentTableLayout(
          DepartmentDbSchema: TDepartmentDbSchema;
          const DepartmentIdJoinExpr: String;
          const AliasTableName: String = ''
        ): String;

        function CreateDefaultFilterLayout(
          EmployeeDbSchema: TEmployeeDbSchema;
          DepartmentDbSchema: TDepartmentDbSchema
        ): String; virtual;

        function CreateDefaultEmployeeSetQueryLayoutFrom(
          EmployeeDbSchema: TEmployeeDbSchema;
          DepartmentDbSchema: TDepartmentDbSchema
        ): String; overload;

        function CreateDefaultEmployeeSetQueryLayoutFrom(
          EmployeeDbSchema: TEmployeeDbSchema;
          DepartmentDbSchema: TDepartmentDbSchema;
          RoleDbSchema: TRoleDbSchema
        ): String; overload;

        function CreateDefaultEmployeeSetQueryLayoutWithoutWhereExpressionFrom(
          EmployeeDbSchema: TEmployeeDbSchema;
          DepartmentDbSchema: TDepartmentDbSchema;
          RoleDbSchema: TRoleDbSchema
        ): String; overload;

        function CreateDefaultEmployeeSetQueryLayoutFrom(
          EmployeeDbSchema: TEmployeeDbSchema;
          DepartmentDbSchema: TDepartmentDbSchema;
          RoleDbSchema: TRoleDbSchema;
          EmployeeWorkGroupAssociationDbSchema: TEmployeeWorkGroupAssociationDbSchema 
        ): String; overload;
        
        function CreateFetchingEmployeeSetFromEmployeeStaffsQuery(
          const QueryPattern: String;
          const EmployeeStaffDtos: TEmployeeStaffDtos
        ): String;

        function CreateFetchingEmployeeSetFromEmployeeStaffsWhereExpression(
          const QueryPattern: String;
          const EmployeeStaffDtos: TEmployeeStaffDtos
        ): String;

      protected

        function PrepareFetchingAllEmployeeSetQueryPattern(
          EmployeeDbSchema: TEmployeeDbSchema;
          DepartmentDbSchema: TDepartmentDbSchema
        ): String; virtual;

        function PrepareFetchingAllEmployeeSetByGivenRolesQueryPattern(
          EmployeeDbSchema: TEmployeeDbSchema;
          DepartmentDbSchema: TDepartmentDbSchema;
          RoleDbSchema: TRoleDbSchema
        ): String; virtual;
        
        function PrepareFetchingEmployeeSetFromHeadKindredDepartmentOfOtherEmployeeQueryPattern(
          EmployeeDbSchema: TEmployeeDbSchema;
          DepartmentDbSchema: TDepartmentDbSchema
        ): String; virtual;

        function PrepareFetchingLeaderSetForEmployeeFromSameHeadKindredDepartmentQueryPattern(
          EmployeeDbSchema: TEmployeeDbSchema;
          DepartmentDbSchema: TDepartmentDbSchema
        ): String; virtual;

        function PrepareFetchingAllNotForeignEmployeeSetQueryPattern(
          EmployeeDbSchema: TEmployeeDbSchema;
          DepartmentDbSchema: TDepartmentDbSchema
        ): String; virtual;
        
        function PrepareFetchingAllPlantEmployeeSetQueryPattern: String; virtual;

        function PrepareFetchingAllPlantEmployeeSetFromHeadKindredDepartmentOfOtherEmployeeQueryPattern: String; virtual;

        function PrepareFetchingAllEmployeeWithRoleSetQueryPattern(
          EmployeeDbSchema: TEmployeeDbSchema;
          DepartmentDbSchema: TDepartmentDbSchema;
          RoleDbSchema: TRoleDbSchema
        ): String; virtual;

        function PrepareFetchingEmployeeSetByIdsQueryPattern(
          EmployeeDbSchema: TEmployeeDbSchema;
          DepartmentDbSchema: TDepartmentDbSchema
        ): String; virtual;

        function PrepareFetchingEmployeeSetFromEmployeeStaffsQueryPattern(
          EmployeeDbSchema: TEmployeeDbSchema;
          DepartmentDbSchema: TDepartmentDbSchema;
          RoleDbSchema: TRoleDbSchema
        ): String; virtual;

        function PrepareFetchingEmployeeSetFromChargePerformingUnitQueryPattern(
          EmployeeDbSchema: TEmployeeDbSchema;
          DepartmentDbSchema: TDepartmentDbSchema;
          RoleDbSchema: TRoleDbSchema;
          EmployeeWorkGroupAssociationDbSchema: TEmployeeWorkGroupAssociationDbSchema
        ): String; virtual;

        function PrepareFetchingLeadershipEmployeeSetForLeaderQueryPattern(
          EmployeeDbSchema: TEmployeeDbSchema;
          DepartmentDbSchema: TDepartmentDbSchema;
          RoleDbSchema: TRoleDbSchema
        ): String; virtual;
        
      protected

        function ExecuteFetchingAllEmployeeSetQuery(
          const QueryPattern: String
        ): TDataSet; virtual;

        function ExecuteFetchingAllEmployeeSetByGivenRolesQuery(
          const QueryPattern: String;
          const EmployeeRoleIds: TVariantList
        ): TDataSet; virtual;

        function ExecuteFetchingAllNotForeignEmployeeSetQuery(
          const QueryPattern: String
        ): TDataSet; virtual;
        
        function ExecuteFetchingLeaderSetForEmployeeFromSameHeadKindredDepartmentQuery(
          const QueryPattern: String;
          const EmployeeIdParamName: String;
          const EmployeeId: Variant
        ): TDataSet; virtual;
        
        function ExecuteFetchingEmployeeSetFromHeadKindredDepartmentOfOtherEmployeeQuery(
          const QueryPattern: String;
          const OtherEmployeeIdParamName: String;
          const OtherEmployeeId: Variant
        ): TDataSet; virtual;

        function ExecuteFetchingAllPlantEmployeeSetQuery(
          const QueryPattern: String
        ): TDataSet; virtual;

        function ExecuteFetchingAllPlantEmployeeSetFromHeadKindredDepartmentOfOtherEmployee(
          const QueryPattern: String;
          const OtherEmployeeIdParamName: String;
          const OtherEmployeeId: Variant
        ): TDataSet; virtual;
        
        function ExecuteFetchingAllEmployeeWithRoleSetQuery(
          const QueryPattern: String
        ): TDataSet; virtual;
        
        function ExecuteFetchingEmployeeSetQuery(
          const QueryPattern: String;
          const QueryParams: TQueryParams = nil
        ): TDataSet;

        function ExecuteFetchingEmployeeSetByIdsQuery(
          const QueryPattern: String;
          const EmployeeIds: TVariantList
        ): TDataSet;

        function ExecuteFetchingEmployeeSetFromEmployeeStaffsQuery(
          const QueryPattern: String;
          const EmployeeStaffDtos: TEmployeeStaffDtos
        ): TDataSet;

        function ExecuteFetchingEmployeeSetFromChargePerformingUnitQuery(
          const QueryPattern: String;
          const EmployeeChargePerformingUnitDto: TEmployeeChargePerformingUnitDto
        ): TDataSet;

        function PrepareFetchingLeadershipEmployeeSetForLeaderQuery(
          const QueryPattern: String;
          const LeaderIdParamName: String;
          const LeaderId: Variant
        ): TDataSet;

      protected

        function CreateEmployeeSetFieldDefs: TEmployeeSetFieldDefs;

      public

        destructor Destroy; override;

        constructor Create(
          EmployeeDbSchema: TEmployeeDbSchema;
          DepartmentDbSchema: TDepartmentDbSchema;
          RoleDbSchema: TRoleDbSchema;
          EmployeeWorkGroupAssociationDbSchema: TEmployeeWorkGroupAssociationDbSchema;
          QueryExecutor: TDataSetQueryExecutor
        );

        function GetAllEmployeeSet: TEmployeeSetHolder;

        function GetAllLeaderSet: TEmployeeSetHolder;
        
        function GetAllEmployeeSetByGivenRoles(
          EmployeeRoleIds: TVariantList
        ): TEmployeeSetHolder;
        
        function GetEmployeeSetFromHeadKindredDepartmentOfOtherEmployee(
          const OtherEmployeeId: Variant
        ): TEmployeeSetHolder;

        function GetLeaderSetForEmployeeFromSameHeadKindredDepartment(
          const EmployeeId: Variant
        ): TEmployeeSetHolder;

        function GetEmployeeSetByIds(
          const EmployeeIds: TVariantList
        ): TEmployeeSetHolder;

        function GetEmployeeSetFromEmployeeStaffs(
          const EmployeeStaffDtos: TEmployeeStaffDtos
        ): TEmployeeSetHolder;

        function GetEmployeeSetFromChargePerformingUnit(
          EmployeeChargePerformingUnitDto: TEmployeeChargePerformingUnitDto
        ): TEmployeeSetHolder;

        function GetAllPlantEmployeeSet: TEmployeeSetHolder;

        function GetAllPlantEmployeeSetFromHeadKindredDepartmentOfOtherEmployee(
          const OtherEmployeeId: Variant
        ): TEmployeeSetHolder;

        function GetAllNotForeignEmployeeSet: TEmployeeSetHolder;

        function GetAllEmployeeWithRoleSet: TEmployeeSetHolder;

        function GetLeadershipEmployeeSetForLeader(const LeaderId: Variant): TEmployeeSetHolder;
        function PrepareLeadershipEmployeeSetForLeader(const LeaderId: Variant): TEmployeeSetHolder;
        
        function GetSelf: TObject;

    end;
    
implementation

uses

  Variants,
  Role,
  AuxiliaryStringFunctions,
  StrUtils,
  EmployeeViewDef;
  
{ TBasedOnDatabaseEmployeeSetReadService }

constructor TBasedOnDatabaseEmployeeSetReadService.Create(
  EmployeeDbSchema: TEmployeeDbSchema;
  DepartmentDbSchema: TDepartmentDbSchema;
  RoleDbSchema: TRoleDbSchema;
  EmployeeWorkGroupAssociationDbSchema: TEmployeeWorkGroupAssociationDbSchema;
  QueryExecutor: TDataSetQueryExecutor
);
begin

  inherited Create;

  FEmployeeDbSchema := EmployeeDbSchema;
  FDepartmentDbSchema := DepartmentDbSchema;
  FRoleDbSchema := RoleDbSchema;
  FEmployeeWorkGroupAssociationDbSchema := EmployeeWorkGroupAssociationDbSchema;

  FQueryExecutor := QueryExecutor;

  FFetchingEmployeeSetFromHeadKindredDepartmentOfOtherEmployeeQueryPattern :=
    PrepareFetchingEmployeeSetFromHeadKindredDepartmentOfOtherEmployeeQueryPattern(
      FEmployeeDbSchema,
      FDepartmentDbSchema
    );

  FFetchingAllEmployeeSetQueryPattern :=
    PrepareFetchingAllEmployeeSetQueryPattern(
      FEmployeeDbSchema,
      FDepartmentDbSchema
    );

  FFetchingAllEmployeeSetByGivenRolesQueryPattern :=
    PrepareFetchingAllEmployeeSetByGivenRolesQueryPattern(
      FEmployeeDbSchema,
      FDepartmentDbSchema,
      FRoleDbSchema
    );

  FFetchingLeaderSetForEmployeeFromSameHeadKindredDepartmentQueryPattern :=
    PrepareFetchingLeaderSetForEmployeeFromSameHeadKindredDepartmentQueryPattern(
      FEmployeeDbSchema,
      FDepartmentDbSchema
    );

  FFetchingAllPlantEmployeeSetQueryPattern :=
    PrepareFetchingAllPlantEmployeeSetQueryPattern;

  FFetchingAllPlantEmployeeSetFromHeadKindredDepartmentOfOtherEmployee :=
    PrepareFetchingAllPlantEmployeeSetFromHeadKindredDepartmentOfOtherEmployeeQueryPattern;
    
  FFetchingAllNotForeignEmployeeSetQueryPattern :=
    PrepareFetchingAllNotForeignEmployeeSetQueryPattern(
      FEmployeeDbSchema,
      FDepartmentDbSchema
    );

  FFetchingAllEmployeeWithRoleSetQueryPattern :=
    PrepareFetchingAllEmployeeWithRoleSetQueryPattern(
      FEmployeeDbSchema,
      FDepartmentDbSchema,
      FRoleDbSchema
    );

  FFetchingEmployeeSetByIdsQueryPattern :=
    PrepareFetchingEmployeeSetByIdsQueryPattern(
      EmployeeDbSchema, DepartmentDbSchema
    );

  FFetchingEmployeeSetFromEmployeeStaffsQueryPattern :=
    PrepareFetchingEmployeeSetFromEmployeeStaffsQueryPattern(
      FEmployeeDbSchema,
      FDepartmentDbSchema,
      FRoleDbSchema
    );

  FFetchingEmployeeSetFromChargePerformingUnitQueryPattern :=
    PrepareFetchingEmployeeSetFromChargePerformingUnitQueryPattern(
      EmployeeDbSchema,
      DepartmentDbSchema,
      RoleDbSchema,
      EmployeeWorkGroupAssociationDbSchema
    );

  FFetchingLeadershipEmployeeSetForLeaderQueryPattern :=
    PrepareFetchingLeadershipEmployeeSetForLeaderQueryPattern(
      FEmployeeDbSchema,
      FDepartmentDbSchema,
      FRoleDbSchema
    );

end;

destructor TBasedOnDatabaseEmployeeSetReadService.Destroy;
begin

  FreeAndNil(FEmployeeDbSchema);
  FreeAndNil(FDepartmentDbSchema);
  FreeAndNil(FRoleDbSchema);
  FreeAndNil(FEmployeeWorkGroupAssociationDbSchema);

  inherited;

end;

function TBasedOnDatabaseEmployeeSetReadService.
  ExecuteFetchingAllEmployeeSetByGivenRolesQuery(
    const QueryPattern: String;
    const EmployeeRoleIds: TVariantList
  ): TDataSet;
var QueryText: String;
begin

  QueryText :=
    Format(
      QueryPattern,
      [CreateStringFromVariantList(EmployeeRoleIds)]
    );

  Result := ExecuteFetchingEmployeeSetQuery(QueryText);
  
end;

function TBasedOnDatabaseEmployeeSetReadService.
  ExecuteFetchingAllEmployeeSetQuery(
    const QueryPattern: String
  ): TDataSet;
begin

  Result := ExecuteFetchingEmployeeSetQuery(QueryPattern);

end;

function TBasedOnDatabaseEmployeeSetReadService.
  ExecuteFetchingAllEmployeeWithRoleSetQuery(
    const QueryPattern: String
  ): TDataSet;
begin

  Result := ExecuteFetchingEmployeeSetQuery(QueryPattern);

end;

function TBasedOnDatabaseEmployeeSetReadService.
  ExecuteFetchingAllNotForeignEmployeeSetQuery(
    const QueryPattern: String
  ): TDataSet;
begin

  Result := ExecuteFetchingEmployeeSetQuery(QueryPattern);
  
end;

function TBasedOnDatabaseEmployeeSetReadService.
  ExecuteFetchingAllPlantEmployeeSetFromHeadKindredDepartmentOfOtherEmployee(
    const QueryPattern: String;
    const OtherEmployeeIdParamName: String;
    const OtherEmployeeId: Variant
  ): TDataSet;
var QueryParams: TQueryParams;
begin

  QueryParams := TQueryParams.Create;

  try

    QueryParams.Add(OtherEmployeeIdParamName, OtherEmployeeId);
    
    Result :=
      ExecuteFetchingEmployeeSetQuery(QueryPattern, QueryParams);
      
  finally

    FreeAndNil(QueryParams);
    
  end;

end;

function TBasedOnDatabaseEmployeeSetReadService.
  ExecuteFetchingAllPlantEmployeeSetQuery(
    const QueryPattern: String
  ): TDataSet;
begin

  Result := ExecuteFetchingEmployeeSetQuery(QueryPattern);

end;

function TBasedOnDatabaseEmployeeSetReadService.
  ExecuteFetchingEmployeeSetByIdsQuery(
    const QueryPattern: String;
    const EmployeeIds: TVariantList
  ): TDataSet;
var EmployeeIdsCommaString: String;

  function CreateEmployeeIdsCommaStringFrom(
    const EmployeeIds: TVariantList
  ): String;
  var EmployeeId: Variant;
  begin

    for EmployeeId in EmployeeIds do
      if Result = '' then
        Result := VarToStr(EmployeeId)

      else
        Result := Result + ',' + VarToStr(EmployeeId);

  end;

var FetchingEmployeeSetByIdsQuery: String;
begin

  FetchingEmployeeSetByIdsQuery :=
    Format(
      QueryPattern,
      [CreateEmployeeIdsCommaStringFrom(EmployeeIds)]
    );

  Result := ExecuteFetchingEmployeeSetQuery(FetchingEmployeeSetByIdsQuery);

end;

function TBasedOnDatabaseEmployeeSetReadService.
  ExecuteFetchingEmployeeSetFromChargePerformingUnitQuery(
    const QueryPattern: String;
    const EmployeeChargePerformingUnitDto: TEmployeeChargePerformingUnitDto
  ): TDataSet;
var QueryText: String;
    EmployeeWorkGroupIdsFilterExpression: String;
    FetchingEmployeeSetFromEmployeeStaffsWhereExpression: String;
begin

  EmployeeWorkGroupIdsFilterExpression :=
    CreateStringFromVariantList(
      EmployeeChargePerformingUnitDto.EmployeeWorkGroupIds
    );

  FetchingEmployeeSetFromEmployeeStaffsWhereExpression :=
    CreateFetchingEmployeeSetFromEmployeeStaffsWhereExpression(
      QueryPattern, EmployeeChargePerformingUnitDto.PerformingStaffDtos
    );
    
  QueryText :=
    QueryPattern + ' AND (';

  if FetchingEmployeeSetFromEmployeeStaffsWhereExpression <> ''
  then begin

    QueryText :=
      QueryText + '(' +
      FetchingEmployeeSetFromEmployeeStaffsWhereExpression + ')';

  end;

  if EmployeeWorkGroupIdsFilterExpression <> '' then begin

    if FetchingEmployeeSetFromEmployeeStaffsWhereExpression <> ''
    then QueryText := QueryText + ' OR ';

    QueryText :=
      QueryText + '(' +
      FEmployeeWorkGroupAssociationDbSchema.TableName + '.' +
      FEmployeeWorkGroupAssociationDbSchema.WorkGroupIdColumnName +
      ' IN (' +
      EmployeeWorkGroupIdsFilterExpression + '))';

  end;

  QueryText := QueryText + ')';

  Result := ExecuteFetchingEmployeeSetQuery(QueryText);
  
end;

function TBasedOnDatabaseEmployeeSetReadService.
  ExecuteFetchingEmployeeSetFromEmployeeStaffsQuery(
    const QueryPattern: String;
    const EmployeeStaffDtos: TEmployeeStaffDtos
  ): TDataSet;
var QueryText: String;
    EmployeeStaffsWhereExpression: String;
    EmployeeStaffFilterExpression: String;
    EmployeeStaffDto: TEmployeeStaffDto;
begin

  QueryText :=
    CreateFetchingEmployeeSetFromEmployeeStaffsQuery(
      QueryPattern,
      EmployeeStaffDtos
    );

  Result := ExecuteFetchingEmployeeSetQuery(QueryText);
  
end;

function TBasedOnDatabaseEmployeeSetReadService.
  ExecuteFetchingEmployeeSetFromHeadKindredDepartmentOfOtherEmployeeQuery(
    const QueryPattern: String;
    const OtherEmployeeIdParamName: String;
    const OtherEmployeeId: Variant
  ): TDataSet;
var QueryParams: TQueryParams;
begin

  QueryParams := TQueryParams.Create;

  try

    QueryParams.Add(OtherEmployeeIdParamName, OtherEmployeeId);

    Result :=
      ExecuteFetchingEmployeeSetQuery(
        QueryPattern,
        QueryParams
      );
      
  finally

    FreeAndNil(QueryParams);
    
  end;

end;

function TBasedOnDatabaseEmployeeSetReadService.
  ExecuteFetchingEmployeeSetQuery(
    const QueryPattern: String;
    const QueryParams: TQueryParams
  ): TDataSet;
var DataReader: IDataReader;
begin

  DataReader :=
    FQueryExecutor.ExecuteSelectionQuery(
      QueryPattern,
      QueryParams
    );

  Result := (DataReader.Self as TDataSetDataReader).ToDataSet;
  
end;

function TBasedOnDatabaseEmployeeSetReadService.
  ExecuteFetchingLeaderSetForEmployeeFromSameHeadKindredDepartmentQuery(
    const QueryPattern, EmployeeIdParamName: String;
    const EmployeeId: Variant
  ): TDataSet;
var QueryParams: TQueryParams;
begin

  QueryParams := TQueryParams.Create;

  try

    QueryParams.Add(EmployeeIdParamName, EmployeeId);

    Result := ExecuteFetchingEmployeeSetQuery(QueryPattern, QueryParams);

  finally

    FreeAndNil(QueryParams);
    
  end;

end;

function TBasedOnDatabaseEmployeeSetReadService.PrepareFetchingLeadershipEmployeeSetForLeaderQuery(
  const QueryPattern: String;
  const LeaderIdParamName: String;
  const LeaderId: Variant
): TDataSet;
var
    QueryText: String;
    DataReader: IDataReader;
begin

  QueryText := ReplaceStr(QueryPattern, LeaderIdParamName, VarToStr(LeaderId));

  Result := TDataSetQueryExecutor(FQueryExecutor.Self).PrepareDataSet(QueryText);

end;

function TBasedOnDatabaseEmployeeSetReadService.
  PrepareFetchingAllEmployeeSetByGivenRolesQueryPattern(
    EmployeeDbSchema: TEmployeeDbSchema;
    DepartmentDbSchema: TDepartmentDbSchema;
    RoleDbSchema: TRoleDbSchema
  ): String;
begin

  Result :=
    CreateDefaultEmployeeSetQueryLayoutFrom(
      EmployeeDbSchema,
      DepartmentDbSchema,
      RoleDbSchema
    ) +
    ' AND ' +
    RoleDbSchema.TableName + '.' + RoleDbSchema.IdColumnName +
    ' IN (%s)';
    
end;

function TBasedOnDatabaseEmployeeSetReadService.GetAllEmployeeSet: TEmployeeSetHolder;
begin

  Result :=
    TEmployeeSetHolder.CreateFrom(
      ExecuteFetchingAllEmployeeSetQuery(
        FFetchingAllEmployeeSetQueryPattern
      ),
      CreateEmployeeSetFieldDefs
    );
    
end;

function TBasedOnDatabaseEmployeeSetReadService.
  GetAllEmployeeSetByGivenRoles(
    EmployeeRoleIds: TVariantList
  ): TEmployeeSetHolder;
begin

  Result :=
    TEmployeeSetHolder.CreateFrom(
      ExecuteFetchingAllEmployeeSetByGivenRolesQuery(
        FFetchingAllEmployeeSetByGivenRolesQueryPattern,
        EmployeeRoleIds
      ),
      CreateEmployeeSetFieldDefs
    );

end;

function TBasedOnDatabaseEmployeeSetReadService.
  GetAllEmployeeWithRoleSet: TEmployeeSetHolder;
begin

  Result :=
    TEmployeeSetHolder.CreateFrom(
      ExecuteFetchingAllEmployeeWithRoleSetQuery(
        FFetchingAllEmployeeWithRoleSetQueryPattern
      ),
      CreateEmployeeSetFieldDefs
    );

end;

function TBasedOnDatabaseEmployeeSetReadService.GetAllLeaderSet: TEmployeeSetHolder;
var EmployeeRoleIds: TVariantList;
begin

  EmployeeRoleIds :=
    TVariantList.CreateFrom(TRoleMemento.GetLeaderRole.Identity);

  try

    Result := GetAllEmployeeSetByGivenRoles(EmployeeRoleIds);
      
  finally

    FreeAndNil(EmployeeRoleIds);

  end;

end;

function TBasedOnDatabaseEmployeeSetReadService.
  GetAllNotForeignEmployeeSet: TEmployeeSetHolder;
begin

  Result :=
    TEmployeeSetHolder.CreateFrom(
      ExecuteFetchingAllNotForeignEmployeeSetQuery(
        FFetchingAllNotForeignEmployeeSetQueryPattern
      ),
      CreateEmployeeSetFieldDefs
    );

end;

function TBasedOnDatabaseEmployeeSetReadService.
  GetAllPlantEmployeeSet: TEmployeeSetHolder;
begin

  Result :=
    TEmployeeSetHolder.CreateFrom(
      ExecuteFetchingAllPlantEmployeeSetQuery(
        FFetchingAllPlantEmployeeSetQueryPattern
      ),
      CreateEmployeeSetFieldDefs
    );

end;

function TBasedOnDatabaseEmployeeSetReadService.
  GetAllPlantEmployeeSetFromHeadKindredDepartmentOfOtherEmployee(
    const OtherEmployeeId: Variant
  ): TEmployeeSetHolder;
begin

  Result :=
    TEmployeeSetHolder.CreateFrom(
      ExecuteFetchingAllPlantEmployeeSetFromHeadKindredDepartmentOfOtherEmployee(
        FFetchingAllPlantEmployeeSetFromHeadKindredDepartmentOfOtherEmployee,
        'p' + FEmployeeDbSchema.IdColumnName,
        OtherEmployeeId
      ),
      CreateEmployeeSetFieldDefs
    );
    
end;

function TBasedOnDatabaseEmployeeSetReadService.GetEmployeeSetByIds(
  const EmployeeIds: TVariantList
): TEmployeeSetHolder;
begin

  Result :=
    TEmployeeSetHolder.CreateFrom(
      ExecuteFetchingEmployeeSetByIdsQuery(
        FFetchingEmployeeSetByIdsQueryPattern,
        EmployeeIds
      ),
      CreateEmployeeSetFieldDefs
    );

end;

function TBasedOnDatabaseEmployeeSetReadService.
  GetEmployeeSetFromChargePerformingUnit(
    EmployeeChargePerformingUnitDto: TEmployeeChargePerformingUnitDto
  ): TEmployeeSetHolder;
begin

  Result :=
    TEmployeeSetHolder.CreateFrom(
      ExecuteFetchingEmployeeSetFromChargePerformingUnitQuery(
        FFetchingEmployeeSetFromChargePerformingUnitQueryPattern,
        EmployeeChargePerformingUnitDto
      ),
      CreateEmployeeSetFieldDefs
    );
  
end;

function TBasedOnDatabaseEmployeeSetReadService.
  GetEmployeeSetFromEmployeeStaffs(
    const EmployeeStaffDtos: TEmployeeStaffDtos
  ): TEmployeeSetHolder;
begin

  Result :=
    TEmployeeSetHolder.CreateFrom(
      ExecuteFetchingEmployeeSetFromEmployeeStaffsQuery(
        FFetchingEmployeeSetFromEmployeeStaffsQueryPattern,
        EmployeeStaffDtos
      ),
      CreateEmployeeSetFieldDefs
    );
    
end;

function TBasedOnDatabaseEmployeeSetReadService.
  GetEmployeeSetFromHeadKindredDepartmentOfOtherEmployee(
    const OtherEmployeeId: Variant
  ): TEmployeeSetHolder;
begin

  Result :=
    TEmployeeSetHolder.CreateFrom(
      ExecuteFetchingEmployeeSetFromHeadKindredDepartmentOfOtherEmployeeQuery(
        FFetchingEmployeeSetFromHeadKindredDepartmentOfOtherEmployeeQueryPattern,
        'p' + FEmployeeDbSchema.IdColumnName,
        OtherEmployeeId
      ),
      CreateEmployeeSetFieldDefs
    );
  
end;

function TBasedOnDatabaseEmployeeSetReadService.
  GetLeaderSetForEmployeeFromSameHeadKindredDepartment(
    const EmployeeId: Variant
  ): TEmployeeSetHolder;
begin

  Result :=
    TEmployeeSetHolder.CreateFrom(
      ExecuteFetchingLeaderSetForEmployeeFromSameHeadKindredDepartmentQuery(
        FFetchingLeaderSetForEmployeeFromSameHeadKindredDepartmentQueryPattern,
        'p' + FEmployeeDbSchema.IdColumnName,
        EmployeeId
      ),
      CreateEmployeeSetFieldDefs
    );
    
end;

function TBasedOnDatabaseEmployeeSetReadService.GetLeadershipEmployeeSetForLeader(
  const LeaderId: Variant): TEmployeeSetHolder;
begin

  Result := PrepareLeadershipEmployeeSetForLeader(LeaderId);

  Result.Open;
  
end;

function TBasedOnDatabaseEmployeeSetReadService.PrepareLeadershipEmployeeSetForLeader(
  const LeaderId: Variant
): TEmployeeSetHolder;
begin

  Result :=
    TEmployeeSetHolder.CreateFrom(
      PrepareFetchingLeadershipEmployeeSetForLeaderQuery(
        FFetchingLeadershipEmployeeSetForLeaderQueryPattern,
        'pleader_id',
        LeaderId
      ),
      CreateEmployeeSetFieldDefs
    );

end;

function TBasedOnDatabaseEmployeeSetReadService.GetSelf: TObject;
begin

  Result := Self;
  
end;

function TBasedOnDatabaseEmployeeSetReadService.
  PrepareFetchingAllEmployeeSetQueryPattern(
    EmployeeDbSchema: TEmployeeDbSchema;
    DepartmentDbSchema: TDepartmentDbSchema
  ): String;
begin

  Result :=
    CreateDefaultSelectColumnList(EmployeeDbSchema, DepartmentDbSchema) + ' ' +
    CreateDefaultTableLayout(EmployeeDbSchema, DepartmentDbSchema) + ' ' +
    CreateDefaultFilterLayout(EmployeeDbSchema, DepartmentDbSchema);

end;

function TBasedOnDatabaseEmployeeSetReadService.
  PrepareFetchingAllEmployeeWithRoleSetQueryPattern(
    EmployeeDbSchema: TEmployeeDbSchema;
    DepartmentDbSchema: TDepartmentDbSchema;
    RoleDbSchema: TRoleDbSchema
  ): String;
begin

  Result :=
    CreateDefaultEmployeeSetQueryLayoutFrom(
      EmployeeDbSchema, DepartmentDbSchema, RoleDbSchema
    );

end;

function TBasedOnDatabaseEmployeeSetReadService.
  PrepareFetchingAllNotForeignEmployeeSetQueryPattern(
    EmployeeDbSchema: TEmployeeDbSchema;
    DepartmentDbSchema: TDepartmentDbSchema
  ): String;
begin

  Result :=
    CreateDefaultEmployeeSetQueryLayoutFrom(
      EmployeeDbSchema, DepartmentDbSchema
    ) +
    ' AND NOT ' + EmployeeDbSchema.TableName + '.' +
                 EmployeeDbSchema.IsForeignColumnName;
    
end;

function TBasedOnDatabaseEmployeeSetReadService.
  PrepareFetchingAllPlantEmployeeSetFromHeadKindredDepartmentOfOtherEmployeeQueryPattern: String;
begin

  Result :=
    'SELECT DISTINCT ' +
    'a.id AS ' + EMPLOYEE_VIEW_TABLE_ID_FIELD + ',' +
    'a.tab_nbr AS ' + EMPLOYEE_VIEW_TABLE_PERSONNEL_NUMBER_FIELD + ',' +
    '(upper(substring(a.name, 1, 1)) || lower(substring(a.name, 2, length(a.name) - 1))) AS ' + EMPLOYEE_VIEW_TABLE_NAME_FIELD + ',' +
    '(upper(substring(a.family, 1, 1)) || lower(substring(a.family, 2, length(a.family) - 1))) AS ' + EMPLOYEE_VIEW_TABLE_SURNAME_FIELD + ',' +
    '(upper(substring(a.patronymic, 1, 1)) || lower(substring(a.patronymic, 2, length(a.patronymic) - 1))) AS ' + EMPLOYEE_VIEW_TABLE_PATRONYMIC_FIELD + ',' +
    'a.job AS ' + EMPLOYEE_VIEW_TABLE_SPECIALITY_FIELD + ',' +
    'b.podr_code AS ' + EMPLOYEE_VIEW_TABLE_DEPARTMENT_CODE_FIELD + ',' +
    'b.podr_short_name AS ' + EMPLOYEE_VIEW_TABLE_DEPARTMENT_SHORT_NAME_FIELD + ',' +
    'b.podr_name AS ' + EMPLOYEE_VIEW_TABLE_DEPARTMENT_FULL_NAME_FIELD + ',' +
    'c.telephone_number AS ' + EMPLOYEE_VIEW_TABLE_TELEPHONE_NUMBER_FIELD +
    ' FROM ' +
    'exchange.spr_person a  ' +
    'JOIN nsi.spr_podr b ON a.podr_id = b.id ' +
    'JOIN doc.employees emp ON emp.id = :p' + FEmployeeDbSchema.IdColumnName +
    ' JOIN exchange.spr_person sp ON sp.id = emp.spr_person_id ' +
    'LEFT JOIN exchange.spr_person_telephone_numbers c ON c.person_id = a.id ' +
    'WHERE NOT a.dismissed ' +
    'AND b.end_isp_dt = ''9999-12-31''::::date AND ' +
    'a.podr_id_head = sp.podr_id_head';

end;

function TBasedOnDatabaseEmployeeSetReadService.
  PrepareFetchingAllPlantEmployeeSetQueryPattern: String;
begin

  Result :=
    'SELECT DISTINCT ' +
    'a.id AS ' + EMPLOYEE_VIEW_TABLE_ID_FIELD + ',' +
    'a.tab_nbr AS ' + EMPLOYEE_VIEW_TABLE_PERSONNEL_NUMBER_FIELD + ',' +
    '(upper(substring(a.name, 1, 1)) || lower(substring(a.name, 2, length(a.name) - 1))) AS ' + EMPLOYEE_VIEW_TABLE_NAME_FIELD + ',' +
    '(upper(substring(a.family, 1, 1)) || lower(substring(a.family, 2, length(a.family) - 1))) AS ' + EMPLOYEE_VIEW_TABLE_SURNAME_FIELD + ',' +
    '(upper(substring(a.patronymic, 1, 1)) || lower(substring(a.patronymic, 2, length(a.patronymic) - 1))) AS ' + EMPLOYEE_VIEW_TABLE_PATRONYMIC_FIELD + ',' +
    'a.job AS ' + EMPLOYEE_VIEW_TABLE_SPECIALITY_FIELD + ',' +
    'b.podr_code AS ' + EMPLOYEE_VIEW_TABLE_DEPARTMENT_CODE_FIELD + ',' +
    'b.podr_short_name AS ' + EMPLOYEE_VIEW_TABLE_DEPARTMENT_SHORT_NAME_FIELD + ',' +
    'b.podr_name AS ' + EMPLOYEE_VIEW_TABLE_DEPARTMENT_FULL_NAME_FIELD + ',' +
    'c.telephone_number AS ' + EMPLOYEE_VIEW_TABLE_TELEPHONE_NUMBER_FIELD +
    ' FROM  ' +
    'exchange.spr_person a  ' +
    'JOIN nsi.spr_podr b ON a.podr_id = b.id ' +
    'LEFT JOIN exchange.spr_person_telephone_numbers c ON c.person_id = a.id ' +
    'WHERE NOT a.dismissed AND b.end_isp_dt = ''9999-12-31''::::date';

end;

function TBasedOnDatabaseEmployeeSetReadService.PrepareFetchingEmployeeSetByIdsQueryPattern(
  EmployeeDbSchema: TEmployeeDbSchema;
  DepartmentDbSchema: TDepartmentDbSchema
): String;
begin

  Result :=
    CreateDefaultEmployeeSetQueryLayoutFrom(
      EmployeeDbSchema,
      DepartmentDbSchema
    ) +
    ' AND ' +
    EmployeeDbSchema.TableName + '.' + EmployeeDbSchema.IdColumnName +
    ' IN (%s)';

end;

function TBasedOnDatabaseEmployeeSetReadService.
  PrepareFetchingEmployeeSetFromChargePerformingUnitQueryPattern(
    EmployeeDbSchema: TEmployeeDbSchema;
    DepartmentDbSchema: TDepartmentDbSchema;
    RoleDbSchema: TRoleDbSchema;
    EmployeeWorkGroupAssociationDbSchema: TEmployeeWorkGroupAssociationDbSchema
  ): String;
begin

  Result :=
    CreateDefaultEmployeeSetQueryLayoutFrom(
      EmployeeDbSchema,
      DepartmentDbSchema,
      RoleDbSchema,
      EmployeeWorkGroupAssociationDbSchema
    );
    
end;

function TBasedOnDatabaseEmployeeSetReadService.
  PrepareFetchingEmployeeSetFromEmployeeStaffsQueryPattern(
    EmployeeDbSchema: TEmployeeDbSchema;
    DepartmentDbSchema: TDepartmentDbSchema;
    RoleDbSchema: TRoleDbSchema
  ): String;
begin

  Result :=
    CreateDefaultEmployeeSetQueryLayoutFrom(
      EmployeeDbSchema, DepartmentDbSchema, RoleDbSchema
    );

end;

function TBasedOnDatabaseEmployeeSetReadService.
  PrepareFetchingEmployeeSetFromHeadKindredDepartmentOfOtherEmployeeQueryPattern(
    EmployeeDbSchema: TEmployeeDbSchema;
    DepartmentDbSchema: TDepartmentDbSchema
  ): String;
begin

  Result :=
    CreateDefaultSelectColumnList(EmployeeDbSchema, DepartmentDbSchema) + ' ' +
    'FROM ' + EmployeeDbSchema.TableName + ' ' +
    'JOIN ' + DepartmentDbSchema.TableName + ' ON ' +
              DepartmentDbSchema.TableName + '.' +
              DepartmentDbSchema.IdColumnName + '=' +
              EmployeeDbSchema.TableName + '.' +
              EmployeeDbSchema.DepartmentIdColumnName + ' ' +
    'JOIN ' + EmployeeDbSchema.TableName + ' e1 ON e1.' +
              EmployeeDbSchema.IdColumnName + '=:p' +
              EmployeeDbSchema.IdColumnName + ' ' +
    CreateDefaultFilterLayout(EmployeeDbSchema, DepartmentDbSchema) +
    ' AND e1.' + EmployeeDbSchema.HeadKindredDepartmentIdColumnName +
    '=' + EmployeeDbSchema.TableName +
          '.' + EmployeeDbSchema.HeadKindredDepartmentIdColumnName;

end;

function TBasedOnDatabaseEmployeeSetReadService.
  PrepareFetchingLeaderSetForEmployeeFromSameHeadKindredDepartmentQueryPattern(
    EmployeeDbSchema: TEmployeeDbSchema;
    DepartmentDbSchema: TDepartmentDbSchema
  ): String;
begin

  Result :=
    'SELECT DISTINCT ' +
    '* ' +
    'FROM doc.find_all_same_head_kindred_department_leaders_for_employee(:p' + EmployeeDbSchema.IdColumnName + ') ' +
    'WHERE NOT ' + EmployeeDbSchema.IsForeignColumnName;

end;

function TBasedOnDatabaseEmployeeSetReadService.PrepareFetchingLeadershipEmployeeSetForLeaderQueryPattern(
  EmployeeDbSchema: TEmployeeDbSchema; DepartmentDbSchema: TDepartmentDbSchema;
  RoleDbSchema: TRoleDbSchema): String;
begin

  Result :=
    CreateDefaultSelectColumnList(EmployeeDbSchema, DepartmentDbSchema) + ' ' +
    CreateDefaultTableLayout(EmployeeDbSchema, DepartmentDbSchema) + ' ' +
    CreateJoinRoleLayout(
      RoleDbSchema,
      EmployeeDbSchema.TableName + '.' + EmployeeDbSchema.IdColumnName
    ) + ' ' +
    CreateJoinTableLayout(
      EmployeeDbSchema,
      DepartmentDbSchema,
      EmployeeDbSchema.TableName + '.' + EmployeeDbSchema.TopLevelEmployeeIdColumnName,
      'lse',
      'lse_d'
    ) + ' ' +
    CreateJoinRoleLayout(
      RoleDbSchema,
      'lse' + '.' + EmployeeDbSchema.IdColumnName,
      'lse_er'
    ) + ' ' +
    CreateDefaultFilterLayout(EmployeeDbSchema, DepartmentDbSchema) +
    ' AND ' + 
    'lse.id=pleader_id AND' + #13#10 +
    '(doc.is_employee_secretary_for(doc.employees.id, pleader_id)' + #13#10 + 
     'or doc.is_employee_secretary_signer_for_other(doc.employees.id, pleader_id)' + #13#10 + 
     'or doc.is_employee_subleader_for_other(doc.employees.id, pleader_id)' + #13#10 + 
    ')';

end;

function TBasedOnDatabaseEmployeeSetReadService.
  CreateDefaultEmployeeSetQueryLayoutFrom(
    EmployeeDbSchema: TEmployeeDbSchema;
    DepartmentDbSchema: TDepartmentDbSchema
  ): String;
begin

  Result :=
    CreateDefaultSelectColumnList(EmployeeDbSchema, DepartmentDbSchema) + ' ' +
    CreateDefaultTableLayout(EmployeeDbSchema, DepartmentDbSchema) + ' ' +
    CreateDefaultFilterLayout(EmployeeDbSchema, DepartmentDbSchema);
    
end;

function TBasedOnDatabaseEmployeeSetReadService.
CreateDefaultEmployeeSetQueryLayoutFrom(
  EmployeeDbSchema: TEmployeeDbSchema;
  DepartmentDbSchema: TDepartmentDbSchema;
  RoleDbSchema: TRoleDbSchema
): String;
begin

  Result :=
    CreateDefaultEmployeeSetQueryLayoutWithoutWhereExpressionFrom(
      EmployeeDbSchema, DepartmentDbSchema, RoleDbSchema
    ) + ' ' +
    CreateDefaultFilterLayout(EmployeeDbSchema, DepartmentDbSchema);

end;

function TBasedOnDatabaseEmployeeSetReadService.
  CreateDefaultEmployeeSetQueryLayoutFrom(
    EmployeeDbSchema: TEmployeeDbSchema;
    DepartmentDbSchema: TDepartmentDbSchema;
    RoleDbSchema: TRoleDbSchema;
    EmployeeWorkGroupAssociationDbSchema: TEmployeeWorkGroupAssociationDbSchema
  ): String;
begin

  Result :=
    CreateDefaultEmployeeSetQueryLayoutWithoutWhereExpressionFrom(
      EmployeeDbSchema, DepartmentDbSchema, RoleDbSchema
    ) + ' ' +
    'LEFT JOIN ' +
    EmployeeWorkGroupAssociationDbSchema.TableName + ' ON ' +
    EmployeeWorkGroupAssociationDbSchema.TableName + '.' +
    EmployeeWorkGroupAssociationDbSchema.EmployeeIdColumnName + '=' +
    EmployeeDbSchema.TableName + '.' + EmployeeDbSchema.IdColumnName +
    ' ' +
    CreateDefaultFilterLayout(EmployeeDbSchema, DepartmentDbSchema);

end;

function TBasedOnDatabaseEmployeeSetReadService.
CreateDefaultEmployeeSetQueryLayoutWithoutWhereExpressionFrom(
  EmployeeDbSchema: TEmployeeDbSchema;
  DepartmentDbSchema: TDepartmentDbSchema;
  RoleDbSchema: TRoleDbSchema
): String;
begin

  Result :=
    CreateDefaultSelectColumnList(EmployeeDbSchema, DepartmentDbSchema) + ',' +
    RoleDbSchema.TableName + '.' + RoleDbSchema.RoleNameColumnName + ' as role_name ' +
    CreateDefaultTableLayout(EmployeeDbSchema, DepartmentDbSchema) + ' ' +
    CreateJoinRoleLayout(RoleDbSchema, EmployeeDbSchema.TableName + '.' + EmployeeDbSchema.IdColumnName);
              
end;

function TBasedOnDatabaseEmployeeSetReadService.
  CreateDefaultFilterLayout(
    EmployeeDbSchema: TEmployeeDbSchema;
    DepartmentDbSchema: TDepartmentDbSchema
  ): String;
begin

  Result :=
    Format(
      'WHERE NOT (%s.%s OR %s.%s)',
      [
        EmployeeDbSchema.TableName,
        EmployeeDbSchema.WasDismissedColumnName,

        EmployeeDbSchema.TableName,
        EmployeeDbSchema.IsSDUserColumnName
      ]
    );
    
end;

function TBasedOnDatabaseEmployeeSetReadService.CreateDefaultSelectColumnList(
  EmployeeDbSchema: TEmployeeDbSchema;
  DepartmentDbSchema: TDepartmentDbSchema): String;
begin

  Result :=
    'SELECT DISTINCT ' +
    EmployeeDbSchema.TableName + '.' + EmployeeDbSchema.IdColumnName + ' as id,' +
    EmployeeDbSchema.TableName + '.' + EmployeeDbSchema.PersonnelNumberColumnName + ',' +
    EmployeeDbSchema.TableName + '.' + EmployeeDbSchema.NameColumnName + ',' +
    EmployeeDbSchema.TableName + '.' + EmployeeDbSchema.SurnameColumnName + ',' +
    EmployeeDbSchema.TableName + '.' + EmployeeDbSchema.PatronymicColumnName + ',' +
    EmployeeDbSchema.TableName + '.' + EmployeeDbSchema.SpecialityColumnName + ',' +
    EmployeeDbSchema.TableName + '.' + EmployeeDbSchema.TelephoneNumberColumnName + ',' +
    EmployeeDbSchema.TableName + '.' + EmployeeDbSchema.IsForeignColumnName + ',' +
    DepartmentDbSchema.TableName + '.' + DepartmentDbSchema.CodeColumnName + ' as department_code,' +
    DepartmentDbSchema.TableName + '.' + DepartmentDbSchema.ShortNameColumnName + ' as department_short_name';
  
end;

function TBasedOnDatabaseEmployeeSetReadService.
  CreateDefaultTableLayout(
    EmployeeDbSchema: TEmployeeDbSchema;
    DepartmentDbSchema: TDepartmentDbSchema
  ): String;
begin

  Result :=
    'FROM ' + EmployeeDbSchema.TableName + ' ' +
    CreateJoinDepartmentTableLayout(
      DepartmentDbSchema,
      EmployeeDbSchema.TableName + '.' + EmployeeDbSchema.DepartmentIdColumnName
    );

end;


function TBasedOnDatabaseEmployeeSetReadService.CreateEmployeeSetFieldDefs: TEmployeeSetFieldDefs;
begin

  Result := TEmployeeSetFieldDefs.Create;

  Result.RecordIdFieldName := 'id';
  Result.PersonnelNumberFieldName := FEmployeeDbSchema.PersonnelNumberColumnName;
  Result.NameFieldName := FEmployeeDbSchema.NameColumnName;
  Result.SurnameFieldName := FEmployeeDbSchema.SurnameColumnName;
  Result.PatronymicFieldName := FEmployeeDbSchema.PatronymicColumnName;
  Result.TelephoneNumberFieldName := FEmployeeDbSchema.TelephoneNumberColumnName;
  Result.IsForeignFieldName := FEmployeeDbSchema.IsForeignColumnName;
  Result.SpecialityFieldName := FEmployeeDbSchema.SpecialityColumnName;
  Result.DepartmentCodeFieldName := 'department_code';;
  Result.DepartmentShortNameFieldName := 'department_short_name';

end;

function TBasedOnDatabaseEmployeeSetReadService.
  CreateFetchingEmployeeSetFromEmployeeStaffsQuery(
    const QueryPattern: String;
    const EmployeeStaffDtos: TEmployeeStaffDtos
  ): String;
begin


  Result :=
    QueryPattern + ' AND ('
    +
    CreateFetchingEmployeeSetFromEmployeeStaffsWhereExpression(
      QueryPattern, EmployeeStaffDtos
    )
    + ')';

end;

function TBasedOnDatabaseEmployeeSetReadService.CreateFetchingEmployeeSetFromEmployeeStaffsWhereExpression(
  const QueryPattern: String;
  const EmployeeStaffDtos: TEmployeeStaffDtos): String;
var EmployeeStaffDto: TEmployeeStaffDto;
    EmployeeStaffFilterExpression: String;
    EmployeeStaffsWhereExpression: String;
begin

  if not Assigned(EmployeeStaffDtos) then begin

    Result := '';
    Exit;
    
  end;

  EmployeeStaffsWhereExpression := '';
  
  for EmployeeStaffDto in EmployeeStaffDtos do begin

    if EmployeeStaffDto.DepartmentIds.IsEmpty and
       EmployeeStaffDto.EmployeeRoleIds.IsEmpty
    then begin

      EmployeeStaffFilterExpression := 'true';

    end

    else if EmployeeStaffDto.DepartmentIds.IsEmpty then begin

      EmployeeStaffFilterExpression :=
        '(' +
        FRoleDbSchema.TableName + '.' + FRoleDbSchema.IdColumnName + ' IN (' +
        CreateStringFromVariantList(EmployeeStaffDto.EmployeeRoleIds) + ')' +
        ')';
        
    end

    else begin

      EmployeeStaffFilterExpression :=
        '(' +
        FDepartmentDbSchema.TableName + '.' + FDepartmentDbSchema.IdColumnName +
        ' IN (' + CreateStringFromVariantList(EmployeeStaffDto.DepartmentIds) +
        ') AND ' +
        FRoleDbSchema.TableName + '.' + FRoleDbSchema.IdColumnName + ' IN (' +
        CreateStringFromVariantList(EmployeeStaffDto.EmployeeRoleIds) + ')' +
        ')';

    end;
    
    if EmployeeStaffsWhereExpression = '' then
      EmployeeStaffsWhereExpression := EmployeeStaffFilterExpression

    else
      EmployeeStaffsWhereExpression :=
        EmployeeStaffsWhereExpression + ' OR ' +
          EmployeeStaffFilterExpression;

  end;

  Result := EmployeeStaffsWhereExpression;
  
end;


function TBasedOnDatabaseEmployeeSetReadService.CreateJoinDepartmentTableLayout(
  DepartmentDbSchema: TDepartmentDbSchema;
  const DepartmentIdJoinExpr,
  AliasTableName: String
): String;
var
    TableName: String;
begin

  TableName := IfThen(AliasTableName <> '',' AS ' + AliasTableName, '');

  Result :=
    'JOIN ' +
    DepartmentDbSchema.TableName + TableName + ' ON ' +
      IfThen(AliasTableName <> '', AliasTableName, DepartmentDbSchema.TableName)
      + '.' + DepartmentDbSchema.IdColumnName +
      '=' +
      DepartmentIdJoinExpr;

end;

function TBasedOnDatabaseEmployeeSetReadService.CreateJoinRoleLayout(
  RoleDbSchema: TRoleDbSchema;
  const RoleIdJoinExpr, AliasTableName: String
): String;
var
    AssociationTableName: String;
begin

  AssociationTableName := IfThen(AliasTableName <> '', 'e' + AliasTableName, 'er');

  Result :=
    'JOIN doc.employees_roles AS ' + AssociationTableName + ' ON ' +
    AssociationTableName + '.employee_id=' +
    RoleIdJoinExpr + ' ' +
    'JOIN ' + RoleDbSchema.TableName + IfThen(AliasTableName <> '', ' AS ' + AliasTableName, '') + ' ON ' +
    IfThen(AliasTableName <> '', AliasTableName, RoleDbSchema.TableName) + '.' + RoleDbSchema.IdColumnName +
    '=' + AssociationTableName + '.role_id';

end;

function TBasedOnDatabaseEmployeeSetReadService.CreateJoinTableLayout(
  EmployeeDbSchema: TEmployeeDbSchema; DepartmentDbSchema: TDepartmentDbSchema;
  const EmployeeIdJoinExpr, AliasTableName,
  DepartmentTableAliasName: String): String;
begin

  Result :=
    'JOIN ' + EmployeeDbSchema.TableName + ' AS ' + AliasTableName + ' ON ' +
    AliasTableName + '.' + EmployeeDbSchema.IdColumnName + '=' + EmployeeIdJoinExpr + ' ' +
    CreateJoinDepartmentTableLayout(
      DepartmentDbSchema,
      AliasTableName + '.' + EmployeeDbSchema.DepartmentIdColumnName,
      DepartmentTableAliasName
    );
    
end;

end.
