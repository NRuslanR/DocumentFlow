 unit PersonnelOrderSubKindEmployeeGroupPostgresRepository;

interface

uses

  AbstractPostgresRepository,
  PersonnelOrderSubKindEmployeeGroup,
  PersonnelOrderEmployeeGroupPostgresRepository,
  PersonnelOrderSubKindEmployeeGroupRepository,
  PersonnelOrderEmployeeGroupRepository,
  PersonnelOrderEmployeeGroupSubKindAssociationRepository,
  PersonnelOrderEmployeeGroupSubKindAssociationPostgresRepository,
  PersonnelOrderEmployeeGroupEmployeeAssociationPostgresRepository,
  PersonnelOrderEmployeeGroupTableDef,
  PersonnelOrderEmployeeGroup,
  DomainObjectUnit,
  DBTableMapping,
  QueryExecutor,
  DomainObjectListUnit,
  DataReader,
  Disposable,
  SysUtils;

type

  TPersonnelOrderSubKindEmployeeGroupPostgresRepository =
    class (
      TPersonnelOrderEmployeeGroupPostgresRepository,
      IPersonnelOrderSubKindEmployeeGroupRepository,
      IPersonnelOrderEmployeeGroupRepository
    )

      protected

        FPersonnelOrderEmployeeGroupSubKindAssociationRepository:
          IPersonnelOrderEmployeeGroupSubKindAssociationRepository;

        FIsFindPersonnelOrderSubKindEmployeeGroupBySubKindCalled: Boolean;
        
      protected

        procedure FillDomainObjectFromDataReader(
          DomainObject: TDomainObject;
          DataReader: IDataReader
        ); override;

      protected

        procedure LoadAndAddSubKindAssociationsToSubKindEmployeeGroup(
          SubKindEmployeeGroup: TPersonnelOrderSubKindEmployeeGroup
        );
        
        procedure AddSubKindAssociationsToSubKindEmployeeGroup(
          SubKindAssociations: TPersonnelOrderEmployeeGroupSubKindAssociations;
          SubKindEmployeeGroup: TPersonnelOrderSubKindEmployeeGroup
        );

        procedure AddSubKindAssociationsFor(SubKindEmployeeGroup: TPersonnelOrderSubKindEmployeeGroup);
        procedure RemoveSubKindAssociationsFor(SubKindEmployeeGroup: TPersonnelOrderSubKindEmployeeGroup);
        procedure UpdateSubKindAssociationsFor(SubKindEmployeeGroup: TPersonnelOrderSubKindEmployeeGroup);

        function CreateSubKindAssociationsFrom(
          SubKindEmployeeGroup: TPersonnelOrderSubKindEmployeeGroup
        ): TPersonnelOrderEmployeeGroupSubKindAssociations;
          
      protected

        procedure PrepareAndExecuteAddDomainObjectQuery(DomainObject: TDomainObject); override;
        procedure PrepareAndExecuteAddDomainObjectListQuery(DomainObjectList: TDomainObjectList); override;
        procedure PrepareAndExecuteUpdateDomainObjectQuery(DomainObject: TDomainObject); override;
        procedure PrepareAndExecuteUpdateDomainObjectListQuery(DomainObjectList: TDomainObjectList); override;
        procedure PrepareAndExecuteRemoveDomainObjectQuery(DomainObject: TDomainObject); override;
        procedure PrepareAndExecuteRemoveDomainObjectListQuery(DomainObjectList: TDomainObjectList); override;

      public

        constructor Create(

          PersonnelOrderEmployeeGroupSubKindAssociationRepository:
            TPersonnelOrderEmployeeGroupSubKindAssociationPostgresRepository;

          PersonnelOrderEmployeeGroupEmployeeAssociationRepository:
            TPersonnelOrderEmployeeGroupEmployeeAssociationPostgresRepository;

          QueryExecutor: IQueryExecutor;
          TableDef: TPersonnelOrderEmployeeGroupTableDef;
          SubKindEmployeeGroupClass: TPersonnelOrderSubKindEmployeeGroupClass;
          SubKindEmployeeGroupsClass: TPersonnelOrderSubKindEmployeeGroupsClass
        );

          
        function FindPersonnelOrderSubKindEmployeeGroupById(
          const Id: Variant
        ): TPersonnelOrderSubKindEmployeeGroup;

        function FindAllPersonnelOrderSubKindEmployeeGroups: TPersonnelOrderSubKindEmployeeGroups;
    
        function FindPersonnelOrderSubKindEmployeeGroupBySubKind(
          const PersonnelOrderSubKindId: Variant
        ): TPersonnelOrderSubKindEmployeeGroup;

        procedure AddPersonnelOrderSubKindEmployeeGroup(
          SubKindEmployeeGroup: TPersonnelOrderSubKindEmployeeGroup
        );

        procedure AddPersonnelOrderSubKindEmployeeGroups(
          SubKindEmployeeGroups: TPersonnelOrderSubKindEmployeeGroups
        );

        procedure UpdatePersonnelOrderSubKindEmployeeGroup(
          SubKindEmployeeGroup: TPersonnelOrderSubKindEmployeeGroup
        );

        procedure UpdatePersonnelOrderSubKindEmployeeGroups(
          SubKindEmployeeGroups: TPersonnelOrderSubKindEmployeeGroups
        );

        procedure RemovePersonnelOrderSubKindEmployeeGroup(
          SubKindEmployeeGroup: TPersonnelOrderSubKindEmployeeGroup
        );

        procedure RemovePersonnelOrderSubKindEmployeeGroups(
          SubKindEmployeeGroups: TPersonnelOrderSubKindEmployeeGroups
        );

    end;

implementation

uses

  TableMapping,
  PostgresTypeNameConstants,
  IDomainObjectBaseUnit,
  IDomainObjectBaseListUnit,
  AbstractRepository,
  AbstractDBRepository,
  AbstractRepositoryCriteriaUnit,
  TableColumnMappings,
  Variants,
  SQLCastingFunctions;


{ TPersonnelOrderSubKindEmployeeGroupPostgresRepository }

constructor TPersonnelOrderSubKindEmployeeGroupPostgresRepository.Create(

  PersonnelOrderEmployeeGroupSubKindAssociationRepository:
    TPersonnelOrderEmployeeGroupSubKindAssociationPostgresRepository;
    
  PersonnelOrderEmployeeGroupEmployeeAssociationRepository:
    TPersonnelOrderEmployeeGroupEmployeeAssociationPostgresRepository;

  QueryExecutor: IQueryExecutor;
  TableDef: TPersonnelOrderEmployeeGroupTableDef;
  SubKindEmployeeGroupClass: TPersonnelOrderSubKindEmployeeGroupClass;
  SubKindEmployeeGroupsClass: TPersonnelOrderSubKindEmployeeGroupsClass
);
begin

  inherited Create(
    PersonnelOrderEmployeeGroupEmployeeAssociationRepository,
    QueryExecutor,
    TableDef,
    SubKindEmployeeGroupClass,
    SubKindEmployeeGroupsClass
  );

  FPersonnelOrderEmployeeGroupSubKindAssociationRepository  :=
    PersonnelOrderEmployeeGroupSubKindAssociationRepository;

end;

function TPersonnelOrderSubKindEmployeeGroupPostgresRepository.
  FindAllPersonnelOrderSubKindEmployeeGroups: TPersonnelOrderSubKindEmployeeGroups;
begin

  Result := TPersonnelOrderSubKindEmployeeGroups(FindAllPersonnelOrderEmployeeGroups);
  
end;

function TPersonnelOrderSubKindEmployeeGroupPostgresRepository.FindPersonnelOrderSubKindEmployeeGroupById(
  const Id: Variant): TPersonnelOrderSubKindEmployeeGroup;
begin

  Result := TPersonnelOrderSubKindEmployeeGroup(FindPersonnelOrderEmployeeGroupById(Id));

end;

function TPersonnelOrderSubKindEmployeeGroupPostgresRepository.FindPersonnelOrderSubKindEmployeeGroupBySubKind(
  const PersonnelOrderSubKindId: Variant
): TPersonnelOrderSubKindEmployeeGroup;
var
    SubKindAssociations: TPersonnelOrderEmployeeGroupSubKindAssociations;
    Free: IDomainObjectBaseList;
begin

  SubKindAssociations :=
    FPersonnelOrderEmployeeGroupSubKindAssociationRepository
      .FindPersonnelOrderEmployeeGroupSubKindAssociationsBySubKinds(
        [PersonnelOrderSubKindId]
      );

  if not Assigned(SubKindAssociations) then begin

    Result := nil;
    Exit;
    
  end;

  Free := SubKindAssociations;

  FIsFindPersonnelOrderSubKindEmployeeGroupBySubKindCalled := True;

  try
  
    Result := 
      FindPersonnelOrderSubKindEmployeeGroupById(SubKindAssociations[0].GroupId);

    if Assigned(Result) then
      AddSubKindAssociationsToSubKindEmployeeGroup(SubKindAssociations, Result);

  finally

    FIsFindPersonnelOrderSubKindEmployeeGroupBySubKindCalled := False;
    
  end;
  
end;

procedure TPersonnelOrderSubKindEmployeeGroupPostgresRepository.
  AddPersonnelOrderSubKindEmployeeGroup(
    SubKindEmployeeGroup: TPersonnelOrderSubKindEmployeeGroup
  );
begin

  AddPersonnelOrderEmployeeGroup(SubKindEmployeeGroup);

end;

procedure TPersonnelOrderSubKindEmployeeGroupPostgresRepository.
  AddPersonnelOrderSubKindEmployeeGroups(
    SubKindEmployeeGroups: TPersonnelOrderSubKindEmployeeGroups
  );
begin

  AddPersonnelOrderEmployeeGroups(SubKindEmployeeGroups);
  
end;

procedure TPersonnelOrderSubKindEmployeeGroupPostgresRepository.
  LoadAndAddSubKindAssociationsToSubKindEmployeeGroup(
    SubKindEmployeeGroup: TPersonnelOrderSubKindEmployeeGroup
  );
var
    SubKindAssociations: TPersonnelOrderEmployeeGroupSubKindAssociations;
    Free: IDomainObjectBaseList;
begin

  SubKindAssociations :=
    FPersonnelOrderEmployeeGroupSubKindAssociationRepository
      .FindPersonnelOrderEmployeeGroupSubKindAssociationsByGroup(
        SubKindEmployeeGroup.Identity
      );

  if not Assigned(SubKindEmployeeGroup) then Exit;

  Free := SubKindAssociations;

  AddSubKindAssociationsToSubKindEmployeeGroup(
    SubKindAssociations, SubKindEmployeeGroup
  );
  
end;

procedure TPersonnelOrderSubKindEmployeeGroupPostgresRepository.
  AddSubKindAssociationsToSubKindEmployeeGroup(
    SubKindAssociations: TPersonnelOrderEmployeeGroupSubKindAssociations;
    SubKindEmployeeGroup: TPersonnelOrderSubKindEmployeeGroup
  );
var
    SubKindAssociation: TPersonnelOrderEmployeeGroupSubKindAssociation;
begin

  for SubKindAssociation in SubKindAssociations do begin

    SubKindEmployeeGroup.AddPersonnelOrderSubKind(
      SubKindAssociation.PersonnelOrderSubKindId
    );

  end;

end;

procedure TPersonnelOrderSubKindEmployeeGroupPostgresRepository.RemovePersonnelOrderSubKindEmployeeGroup(
  SubKindEmployeeGroup: TPersonnelOrderSubKindEmployeeGroup);
begin

  RemovePersonnelOrderEmployeeGroup(SubKindEmployeeGroup);

end;

procedure TPersonnelOrderSubKindEmployeeGroupPostgresRepository.RemovePersonnelOrderSubKindEmployeeGroups(
  SubKindEmployeeGroups: TPersonnelOrderSubKindEmployeeGroups);
begin

  RemovePersonnelOrderEmployeeGroups(SubKindEmployeeGroups);

end;

procedure TPersonnelOrderSubKindEmployeeGroupPostgresRepository.UpdatePersonnelOrderSubKindEmployeeGroup(
  SubKindEmployeeGroup: TPersonnelOrderSubKindEmployeeGroup
);
begin

  UpdatePersonnelOrderEmployeeGroup(SubKindEmployeeGroup);
  
end;

procedure TPersonnelOrderSubKindEmployeeGroupPostgresRepository.UpdatePersonnelOrderSubKindEmployeeGroups(
  SubKindEmployeeGroups: TPersonnelOrderSubKindEmployeeGroups);
begin

  UpdatePersonnelOrderEmployeeGroups(SubKindEmployeeGroups);
  
end;

procedure TPersonnelOrderSubKindEmployeeGroupPostgresRepository.
  FillDomainObjectFromDataReader(
    DomainObject: TDomainObject;
    DataReader: IDataReader
  );
begin

  inherited;

  if not FIsFindPersonnelOrderSubKindEmployeeGroupBySubKindCalled then begin

    LoadAndAddSubKindAssociationsToSubKindEmployeeGroup(
      TPersonnelOrderSubKindEmployeeGroup(DomainObject)
    );

  end;
  
end;

procedure TPersonnelOrderSubKindEmployeeGroupPostgresRepository.
  PrepareAndExecuteAddDomainObjectListQuery(DomainObjectList: TDomainObjectList);
var
    SubKindEmployeeGroup: TPersonnelOrderSubKindEmployeeGroup;
begin

  inherited;

  for SubKindEmployeeGroup in TPersonnelOrderSubKindEmployeeGroups(DomainObjectList) do
    AddSubKindAssociationsFor(SubKindEmployeeGroup);
    
end;

procedure TPersonnelOrderSubKindEmployeeGroupPostgresRepository.PrepareAndExecuteAddDomainObjectQuery(
  DomainObject: TDomainObject);
begin

  inherited;

  AddSubKindAssociationsFor(TPersonnelOrderSubKindEmployeeGroup(DomainObject));
  
end;

procedure TPersonnelOrderSubKindEmployeeGroupPostgresRepository.PrepareAndExecuteRemoveDomainObjectListQuery(
  DomainObjectList: TDomainObjectList);
var
    SubKindEmployeeGroup: TPersonnelOrderSubKindEmployeeGroup;
begin

  for SubKindEmployeeGroup in TPersonnelOrderSubKindEmployeeGroups(DomainObjectList) do
    RemoveSubKindAssociationsFor(SubKindEmployeeGroup);
    
  inherited;

end;

procedure TPersonnelOrderSubKindEmployeeGroupPostgresRepository.PrepareAndExecuteRemoveDomainObjectQuery(
  DomainObject: TDomainObject);
begin

  RemoveSubKindAssociationsFor(TPersonnelOrderSubKindEmployeeGroup(DomainObject));
  
  inherited;

end;

procedure TPersonnelOrderSubKindEmployeeGroupPostgresRepository.PrepareAndExecuteUpdateDomainObjectListQuery(
  DomainObjectList: TDomainObjectList);
var
    SubKindEmployeeGroup: TPersonnelOrderSubKindEmployeeGroup;
begin

  inherited;

  for SubKindEmployeeGroup in TPersonnelOrderSubKindEmployeeGroups(DomainObjectList) do
    UpdateSubKindAssociationsFor(SubKindEmployeeGroup);
    
end;

procedure TPersonnelOrderSubKindEmployeeGroupPostgresRepository.PrepareAndExecuteUpdateDomainObjectQuery(
  DomainObject: TDomainObject);
begin

  inherited;

  UpdateSubKindAssociationsFor(TPersonnelOrderSubKindEmployeeGroup(DomainObject));
  
end;

procedure TPersonnelOrderSubKindEmployeeGroupPostgresRepository.UpdateSubKindAssociationsFor(
  SubKindEmployeeGroup: TPersonnelOrderSubKindEmployeeGroup);
begin

  RemoveSubKindAssociationsFor(SubKindEmployeeGroup);
  AddSubKindAssociationsFor(SubKindEmployeeGroup);

end;

procedure TPersonnelOrderSubKindEmployeeGroupPostgresRepository.RemoveSubKindAssociationsFor(
  SubKindEmployeeGroup: TPersonnelOrderSubKindEmployeeGroup);
begin

  FPersonnelOrderEmployeeGroupSubKindAssociationRepository
    .RemovePersonnelOrderEmployeeGroupSubKindAssociationsByGroup(
      SubKindEmployeeGroup.Identity
    );
    
end;

procedure TPersonnelOrderSubKindEmployeeGroupPostgresRepository.AddSubKindAssociationsFor(
  SubKindEmployeeGroup: TPersonnelOrderSubKindEmployeeGroup
);
var
    SubKindAssociations: TPersonnelOrderEmployeeGroupSubKindAssociations;
    Free: IDomainObjectBaseList;
begin

  SubKindAssociations := CreateSubKindAssociationsFrom(SubKindEmployeeGroup);

  Free := SubKindAssociations;

  FPersonnelOrderEmployeeGroupSubKindAssociationRepository
    .AddPersonnelOrderEmployeeGroupSubKindAssociations(
      SubKindAssociations
    );

end;

function TPersonnelOrderSubKindEmployeeGroupPostgresRepository.CreateSubKindAssociationsFrom(
  SubKindEmployeeGroup: TPersonnelOrderSubKindEmployeeGroup
): TPersonnelOrderEmployeeGroupSubKindAssociations;
var
    SubKindAssociation: TPersonnelOrderEmployeeGroupSubKindAssociation;
    Free: IDomainObjectBase;
    SubKindId: Variant;
begin

  Result := TPersonnelOrderEmployeeGroupSubKindAssociations.Create;

  try

    for SubKindId in SubKindEmployeeGroup.PersonnelOrderSubKindIds do begin

      SubKindAssociation :=
        TPersonnelOrderEmployeeGroupSubKindAssociation.Create(
          SubKindEmployeeGroup.Identity, SubKindId
        );

      Free := SubKindAssociation;

      Result.AddDomainObject(SubKindAssociation);
      
    end;

  except

    FreeAndNil(Result);

    Raise;

  end;

end;

end.
