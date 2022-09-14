unit PersonnelOrderEmployeeGroupPostgresRepository;

interface

uses

  AbstractPostgresRepository,
  PersonnelOrderEmployeeGroupRepository,
  PersonnelOrderEmployeeGroupEmployeeAssociationRepository,
  PersonnelOrderEmployeeGroupEmployeeAssociationPostgresRepository,
  PersonnelOrderEmployeeGroup,
  PersonnelOrderEmployeeGroupTableDef,
  DBTableMapping,
  QueryExecutor,
  DomainObjectUnit,
  DomainObjectListUnit,
  DataReader,
  Disposable,
  SysUtils;

type

  TPersonnelOrderEmployeeGroupPostgresRepository =
    class (
      TAbstractPostgresRepository,
      IPersonnelOrderEmployeeGroupRepository
    )

      protected

        FTableDef: TPersonnelOrderEmployeeGroupTableDef;
        FFreeTableDef: IDisposable;
        
        FEmployeeGroupClass: TPersonnelOrderEmployeeGroupClass;
        FEmployeeGroupsClass: TPersonnelOrderEmployeeGroupsClass;
        
      protected

        FPersonnelOrderEmployeeGroupEmployeeAssociationRepository:
          IPersonnelOrderEmployeeGroupEmployeeAssociationRepository;

      protected

        procedure CustomizeTableMapping(
          TableMapping: TDBTableMapping
        ); override;

        procedure FillDomainObjectFromDataReader(
          DomainObject: TDomainObject;
          DataReader: IDataReader
        ); override;

        procedure LoadAndAddEmployeeAssociationsToEmployeeGroup(
          EmployeeGroup: TPersonnelOrderEmployeeGroup
        );
        
        procedure AddEmployeeAssociationsToEmployeeGroup(
          EmployeeAssociations: TPersonnelOrderEmployeeGroupEmployeeAssociations;
          EmployeeGroup: TPersonnelOrderEmployeeGroup
        ); virtual;
        
        procedure AddEmployeeAssociationsFor(
          EmployeeGroup: TPersonnelOrderEmployeeGroup
        );

        procedure RemoveEmployeeAssociationsFor(
          EmployeeGroup: TPersonnelOrderEmployeeGroup
        );

        procedure UpdateEmployeeAssociationsFor(
          EmployeeGroup: TPersonnelOrderEmployeeGroup
        );
        
      protected

        procedure PrepareAndExecuteAddDomainObjectQuery(DomainObject: TDomainObject); override;
        procedure PrepareAndExecuteAddDomainObjectListQuery(DomainObjectList: TDomainObjectList); override;
        procedure PrepareAndExecuteUpdateDomainObjectQuery(DomainObject: TDomainObject); override;
        procedure PrepareAndExecuteUpdateDomainObjectListQuery(DomainObjectList: TDomainObjectList); override;
        procedure PrepareAndExecuteRemoveDomainObjectQuery(DomainObject: TDomainObject); override;
        procedure PrepareAndExecuteRemoveDomainObjectListQuery(DomainObjectList: TDomainObjectList); override;

      protected

        function CreateEmployeeAssociationsFrom(
          EmployeeGroup: TPersonnelOrderEmployeeGroup
        ): TPersonnelOrderEmployeeGroupEmployeeAssociations; virtual;
        
      public

        constructor Create(
        
          PersonnelOrderEmployeeGroupEmployeeAssociationRepository:
            TPersonnelOrderEmployeeGroupEmployeeAssociationPostgresRepository;

          QueryExecutor: IQueryExecutor;
          TableDef: TPersonnelOrderEmployeeGroupTableDef;
          EmployeeGroupClass: TPersonnelOrderEmployeeGroupClass;
          EmployeeGroupsClass: TPersonnelOrderEmployeeGroupsClass
        );

        function FindPersonnelOrderEmployeeGroupById(
          const Id: Variant
        ): TPersonnelOrderEmployeeGroup;

        function FindAllPersonnelOrderEmployeeGroups: TPersonnelOrderEmployeeGroups;

        procedure AddPersonnelOrderEmployeeGroup(
          EmployeeGroup: TPersonnelOrderEmployeeGroup
        );

        procedure AddPersonnelOrderEmployeeGroups(
          EmployeeGroups: TPersonnelOrderEmployeeGroups
        );

        procedure UpdatePersonnelOrderEmployeeGroup(
          EmployeeGroup: TPersonnelOrderEmployeeGroup
        );

        procedure UpdatePersonnelOrderEmployeeGroups(
          EmployeeGroups: TPersonnelOrderEmployeeGroups
        );

        procedure RemovePersonnelOrderEmployeeGroup(
          EmployeeGroup: TPersonnelOrderEmployeeGroup
        );

        procedure RemovePersonnelOrderEmployeeGroups(
          EmployeeGroups: TPersonnelOrderEmployeeGroups
        );

    end;

implementation

uses

  PostgresTypeNameConstants,
  AbstractRepository,
  AbstractDBRepository,
  IDomainObjectBaseUnit,
  IDomainObjectBaseListUnit;
  
{ TPersonnelOrderEmployeeGroupPostgresRepository }

constructor TPersonnelOrderEmployeeGroupPostgresRepository.Create(

  PersonnelOrderEmployeeGroupEmployeeAssociationRepository:
    TPersonnelOrderEmployeeGroupEmployeeAssociationPostgresRepository;

  QueryExecutor: IQueryExecutor;
  TableDef: TPersonnelOrderEmployeeGroupTableDef;
  EmployeeGroupClass: TPersonnelOrderEmployeeGroupClass;
  EmployeeGroupsClass: TPersonnelOrderEmployeeGroupsClass
);
begin

  inherited Create(QueryExecutor);

  FPersonnelOrderEmployeeGroupEmployeeAssociationRepository :=
    PersonnelOrderEmployeeGroupEmployeeAssociationRepository;
    
  FTableDef := TableDef;
  FFreeTableDef := FTableDef;

  FEmployeeGroupClass := EmployeeGroupClass;
  FEmployeeGroupsClass := EmployeeGroupsClass;

  CustomizeTableMapping(FDBTableMapping);

end;

procedure TPersonnelOrderEmployeeGroupPostgresRepository.CustomizeTableMapping(
  TableMapping: TDBTableMapping);
begin

  if not Assigned(FTableDef) then Exit;

  inherited CustomizeTableMapping(TableMapping);
  
  with TableMapping, FTableDef do begin

    TableMapping.SetTableNameMapping(TableName, FEmployeeGroupClass, FEmployeeGroupsClass);
    
    AddColumnMappingForSelect(IdColumnName, 'Identity');
    AddColumnMappingForSelect(NameColumnName, 'Name');

    AddColumnMappingForModification(
      NameColumnName, 'Name', PostgresTypeNameConstants.VARCHAR_TYPE_NAME
    );

    AddPrimaryKeyColumnMapping(IdColumnName, 'Identity');

  end;

end;

procedure TPersonnelOrderEmployeeGroupPostgresRepository.AddPersonnelOrderEmployeeGroup(
  EmployeeGroup: TPersonnelOrderEmployeeGroup);
begin

  Add(EmployeeGroup);

  ThrowExceptionIfErrorIsNotUnknown;
  
end;

procedure TPersonnelOrderEmployeeGroupPostgresRepository.AddPersonnelOrderEmployeeGroups(
  EmployeeGroups: TPersonnelOrderEmployeeGroups);
begin

  AddDomainObjectList(EmployeeGroups);

  ThrowExceptionIfErrorIsNotUnknown;
  
end;

procedure TPersonnelOrderEmployeeGroupPostgresRepository.FillDomainObjectFromDataReader(
  DomainObject: TDomainObject;
  DataReader: IDataReader
);
begin

  inherited;

  LoadAndAddEmployeeAssociationsToEmployeeGroup(TPersonnelOrderEmployeeGroup(DomainObject));
  
end;

procedure TPersonnelOrderEmployeeGroupPostgresRepository.LoadAndAddEmployeeAssociationsToEmployeeGroup(
  EmployeeGroup: TPersonnelOrderEmployeeGroup
);
var
    EmployeeAssociations: TPersonnelOrderEmployeeGroupEmployeeAssociations;
    Free: IDomainObjectBaseList;
begin

  inherited;

  EmployeeAssociations :=
    FPersonnelOrderEmployeeGroupEmployeeAssociationRepository.
      FindPersonnelOrderEmployeeGroupEmployeeAssociationsByGroup(
        EmployeeGroup.Identity
      );

  if not Assigned(EmployeeAssociations) then Exit;

  Free := EmployeeAssociations;

  AddEmployeeAssociationsToEmployeeGroup(
    EmployeeAssociations, EmployeeGroup
  );
  
end;

procedure TPersonnelOrderEmployeeGroupPostgresRepository.AddEmployeeAssociationsToEmployeeGroup(
  EmployeeAssociations: TPersonnelOrderEmployeeGroupEmployeeAssociations;
  EmployeeGroup: TPersonnelOrderEmployeeGroup
);
var
    EmployeeAssociation: TPersonnelOrderEmployeeGroupEmployeeAssociation;
begin

  for EmployeeAssociation in EmployeeAssociations do
    EmployeeGroup.AddEmployee(EmployeeAssociation.EmployeeId);
    
end;

function TPersonnelOrderEmployeeGroupPostgresRepository.
  FindAllPersonnelOrderEmployeeGroups: TPersonnelOrderEmployeeGroups;
begin

  Result := TPersonnelOrderEmployeeGroups(LoadAll);
  
  ThrowExceptionIfErrorIsNotUnknown;
  
end;

function TPersonnelOrderEmployeeGroupPostgresRepository.FindPersonnelOrderEmployeeGroupById(
  const Id: Variant): TPersonnelOrderEmployeeGroup;
begin

  Result := TPersonnelOrderEmployeeGroup(FindDomainObjectByIdentity(Id));

  ThrowExceptionIfErrorIsNotUnknown;
  
end;

procedure TPersonnelOrderEmployeeGroupPostgresRepository.RemovePersonnelOrderEmployeeGroup(
  EmployeeGroup: TPersonnelOrderEmployeeGroup);
begin

  Remove(EmployeeGroup);

  ThrowExceptionIfErrorIsNotUnknown;
  
end;

procedure TPersonnelOrderEmployeeGroupPostgresRepository.RemovePersonnelOrderEmployeeGroups(
  EmployeeGroups: TPersonnelOrderEmployeeGroups);
begin

  RemoveDomainObjectList(EmployeeGroups);

  ThrowExceptionIfErrorIsNotUnknown;
  
end;

procedure TPersonnelOrderEmployeeGroupPostgresRepository.UpdatePersonnelOrderEmployeeGroup(
  EmployeeGroup: TPersonnelOrderEmployeeGroup);
begin

  Update(EmployeeGroup);

  ThrowExceptionIfErrorIsNotUnknown;
  
end;

procedure TPersonnelOrderEmployeeGroupPostgresRepository.UpdatePersonnelOrderEmployeeGroups(
  EmployeeGroups: TPersonnelOrderEmployeeGroups);
begin

  UpdateDomainObjectList(EmployeeGroups);

  ThrowExceptionIfErrorIsNotUnknown;

end;

procedure TPersonnelOrderEmployeeGroupPostgresRepository.PrepareAndExecuteAddDomainObjectListQuery(
  DomainObjectList: TDomainObjectList
);
var
    EmployeeGroups: TPersonnelOrderEmployeeGroups;
    EmployeeGroup: TPersonnelOrderEmployeeGroup;
begin

  inherited;

  for EmployeeGroup in EmployeeGroups do
    AddEmployeeAssociationsFor(EmployeeGroup);

end;

procedure TPersonnelOrderEmployeeGroupPostgresRepository.
  PrepareAndExecuteAddDomainObjectQuery(DomainObject: TDomainObject);
begin

  inherited;

  AddEmployeeAssociationsFor(TPersonnelOrderEmployeeGroup(DomainObject));

end;

procedure TPersonnelOrderEmployeeGroupPostgresRepository.PrepareAndExecuteRemoveDomainObjectListQuery(
  DomainObjectList: TDomainObjectList
);
var
    EmployeeGroup: TPersonnelOrderEmployeeGroup;
begin

  for EmployeeGroup in TPersonnelOrderEmployeeGroups(DomainObjectList) do 
    RemoveEmployeeAssociationsFor(EmployeeGroup);
    
  inherited;

end;

procedure TPersonnelOrderEmployeeGroupPostgresRepository.PrepareAndExecuteRemoveDomainObjectQuery(
  DomainObject: TDomainObject);
begin

  RemoveEmployeeAssociationsFor(TPersonnelOrderEmployeeGroup(DomainObject));
  
  inherited;

end;

procedure TPersonnelOrderEmployeeGroupPostgresRepository.PrepareAndExecuteUpdateDomainObjectListQuery(
  DomainObjectList: TDomainObjectList);
var
    EmployeeGroup: TPersonnelOrderEmployeeGroup;
begin

  inherited;

  for EmployeeGroup in TPersonnelOrderEmployeeGroups(DomainObjectList) do
    UpdateEmployeeAssociationsFor(EmployeeGroup);
    
end;

procedure TPersonnelOrderEmployeeGroupPostgresRepository.PrepareAndExecuteUpdateDomainObjectQuery(
  DomainObject: TDomainObject);
begin

  inherited;

  UpdateEmployeeAssociationsFor(TPersonnelOrderEmployeeGroup(DomainObject));
  
end;

procedure TPersonnelOrderEmployeeGroupPostgresRepository.UpdateEmployeeAssociationsFor(
  EmployeeGroup: TPersonnelOrderEmployeeGroup);
begin

  RemoveEmployeeAssociationsFor(EmployeeGroup);
  AddEmployeeAssociationsFor(EmployeeGroup);
  
end;

procedure TPersonnelOrderEmployeeGroupPostgresRepository.AddEmployeeAssociationsFor(
  EmployeeGroup: TPersonnelOrderEmployeeGroup);
var
    EmployeeAssociations: TPersonnelOrderEmployeeGroupEmployeeAssociations;
    FreeAssociations: IDomainObjectBaseList;
begin

  EmployeeAssociations := CreateEmployeeAssociationsFrom(EmployeeGroup);

  FreeAssociations := EmployeeAssociations;

  FPersonnelOrderEmployeeGroupEmployeeAssociationRepository
    .AddPersonnelOrderEmployeeGroupEmployeeAssociations(EmployeeAssociations);

end;

procedure TPersonnelOrderEmployeeGroupPostgresRepository.RemoveEmployeeAssociationsFor(
  EmployeeGroup: TPersonnelOrderEmployeeGroup);
begin

  FPersonnelOrderEmployeeGroupEmployeeAssociationRepository 
    .RemovePersonnelOrderEmployeeGroupEmployeeAssociationsByGroup(
      EmployeeGroup.Identity
    );
    
end;

function TPersonnelOrderEmployeeGroupPostgresRepository.
  CreateEmployeeAssociationsFrom(
    EmployeeGroup: TPersonnelOrderEmployeeGroup
  ): TPersonnelOrderEmployeeGroupEmployeeAssociations;
var
    EmployeeAssociation: TPersonnelOrderEmployeeGroupEmployeeAssociation;
    Free: IDomainObjectBase;
    EmployeeId: Variant;
begin

  Result := TPersonnelOrderEmployeeGroupEmployeeAssociations.Create;

  try

    for EmployeeId in EmployeeGroup.EmployeeIds do begin
    
      EmployeeAssociation := 
        TPersonnelOrderEmployeeGroupEmployeeAssociation.Create(
          EmployeeGroup.Identity, EmployeeId
        );

      Free := EmployeeAssociation;

      Result.AddDomainObject(EmployeeAssociation);
      
    end;

  except

    FreeAndNil(Result);

    Raise;
    
  end;
  
end;

end.
