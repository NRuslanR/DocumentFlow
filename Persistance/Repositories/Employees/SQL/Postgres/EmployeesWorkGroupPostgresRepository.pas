unit EmployeesWorkGroupPostgresRepository;

interface

uses

  AbstractPostgresRepository,
  AbstractRepositoryCriteriaUnit,
  EmployeesWorkGroup,
  EmployeesWorkGroupRepository,
  VariantListUnit,
  DBTableMapping,
  ZConnection,
  SysUtils,
  Classes;

type

  TEmployeesWorkGroupPostgresRepository =
    class (TAbstractPostgresRepository, IEmployeesWorkGroupRepository)

      protected

        procedure Initialize; override;

      protected

        procedure CustomizeTableMapping(
          TableMapping: TDBTableMapping
        ); override;

      public

        function FindEmployeesWorkGroupByIdentity(const Identity: Variant): TEmployeesWorkGroup;
        function FindEmployeesWorkGroupsByIdentities(const Identities: TVariantList): TEmployeesWorkGroups;

    end;

implementation

uses

  EmployeeWorkGroupTableDef,
  AbstractRepository,
  AuxiliaryStringFunctions,
  AbstractDBRepository;

type

  TFindEmployeesWorkGroupsByIdentitiesCriterion = class (TAbstractRepositoryCriterion)

    protected

      FRepository: TEmployeesWorkGroupPostgresRepository;
      
    protected

      FWorkGroupIdentities: TVariantList;

    protected

      function GetExpression: String; override;
      
    public

      constructor Create(
        const WorkGroupIdentities: TVariantList;
        Repository: TEmployeesWorkGroupPostgresRepository
      );

      property WorkGroupIdentities: TVariantList
      read FWorkGroupIdentities;

  end;
  
{ TEmployeesWorkGroupPostgresRepository }

procedure TEmployeesWorkGroupPostgresRepository.CustomizeTableMapping(
  TableMapping: TDBTableMapping);
begin

  inherited;

  TableMapping.SetTableNameMapping(
    EMPLOYEE_WORK_GROUP_TABLE_NAME,
    TEmployeesWorkGroup,
    TEmployeesWorkGroups
  );

  TableMapping.AddColumnMappingForSelect(EMPLOYEE_WORK_GROUP_TABLE_ID_FIELD, 'Identity');
  TableMapping.AddColumnMappingForSelect(EMPLOYEE_WORK_GROUP_TABLE_NAME_FIELD, 'Name');
  TableMapping.AddColumnMappingForSelect(EMPLOYEE_WORK_GROUP_TABLE_LEADER_ID_FIELD, 'LeaderIdentity');

  TableMapping.AddPrimaryKeyColumnMapping(EMPLOYEE_WORK_GROUP_TABLE_ID_FIELD, 'Identity');

end;

function TEmployeesWorkGroupPostgresRepository.
  FindEmployeesWorkGroupByIdentity(
    const Identity: Variant
  ): TEmployeesWorkGroup;
begin

  Result := TEmployeesWorkGroup(FindDomainObjectByIdentity(Identity));

  ThrowExceptionIfErrorIsNotUnknown;
  
end;

function TEmployeesWorkGroupPostgresRepository.
  FindEmployeesWorkGroupsByIdentities(
    const Identities: TVariantList
  ): TEmployeesWorkGroups;
var FindEmployeesWorkGroupsByIdentitiesCriterion:
      TFindEmployeesWorkGroupsByIdentitiesCriterion;
begin

  FindEmployeesWorkGroupsByIdentitiesCriterion :=
    TFindEmployeesWorkGroupsByIdentitiesCriterion.Create(
      Identities, Self
    );

  try

    Result :=
      TEmployeesWorkGroups(
        FindDomainObjectsByCriteria(
          FindEmployeesWorkGroupsByIdentitiesCriterion
        )
      );

    ThrowExceptionIfErrorIsNotUnknown;
      
  finally

    FreeAndNil(FindEmployeesWorkGroupsByIdentitiesCriterion);
    
  end;

end;

procedure TEmployeesWorkGroupPostgresRepository.Initialize;
begin

  inherited;

  ReturnIdOfDomainObjectAfterAdding := True;

end;

{ TFindEmployeesWorkGroupsByIdentitiesCriterion }

constructor TFindEmployeesWorkGroupsByIdentitiesCriterion.Create(
  const WorkGroupIdentities: TVariantList;
  Repository: TEmployeesWorkGroupPostgresRepository);
begin

  inherited Create;

  FWorkGroupIdentities := WorkGroupIdentities;
  FRepository := Repository;
  
end;

function TFindEmployeesWorkGroupsByIdentitiesCriterion.GetExpression: String;
var WorkGroupIdColumnName: String;
begin

  WorkGroupIdColumnName :=
    FRepository.TableMapping.PrimaryKeyColumnMappings[0].ColumnName;

  Result :=
    Format(
      '%s IN (%s)',
      [
        WorkGroupIdColumnName,
        CreateStringFromVariantList(FWorkGroupIdentities)
      ]
    );

end;

end.
