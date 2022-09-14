unit PersonnelOrderEmployeeGroupSubKindAssociationPostgresRepository;

interface

uses

  PersonnelOrderEmployeeGroupSubKindAssociationRepository,
  PersonnelOrderEmployeeGroupSubKindAssociationTableDef,
  AbstractPostgresRepository,
  DBTableMapping,
  QueryExecutor,
  Disposable,
  VariantListUnit,
  SysUtils;


type

  TPersonnelOrderEmployeeGroupSubKindAssociationPostgresRepository =
    class(
      TAbstractPostgresRepository,
      IPersonnelOrderEmployeeGroupSubKindAssociationRepository
    )

      protected

        FTableDef: TPersonnelOrderEmployeeGroupSubKindAssociationTableDef;
        FFreeTableDef: IDisposable;

        FAssociationClass: TPersonnelOrderEmployeeGroupSubKindAssociationClass;
        FAssociationsClass: TPersonnelOrderEmployeeGroupSubKindAssociationsClass;
        
        procedure CustomizeTableMapping(
          TableMapping: TDBTableMapping
        ); override;

      public

        constructor Create(
          QueryExecutor: IQueryExecutor;
          TableDef: TPersonnelOrderEmployeeGroupSubKindAssociationTableDef;
          AssociationClass: TPersonnelOrderEmployeeGroupSubKindAssociationClass;
          AssociationsClass: TPersonnelOrderEmployeeGroupSubKindAssociationsClass
        );

        function FindPersonnelOrderEmployeeGroupSubKindAssociationsByGroup(
          const GroupId: Variant
        ): TPersonnelOrderEmployeeGroupSubKindAssociations;

        function FindPersonnelOrderEmployeeGroupSubKindAssociationsBySubKinds(
          const PersonnelOrderSubKindIds: array of Variant
        ): TPersonnelOrderEmployeeGroupSubKindAssociations; overload;

        function FindPersonnelOrderEmployeeGroupSubKindAssociationsBySubKinds(
          const PersonnelOrderSubKindIds: TVariantList
        ): TPersonnelOrderEmployeeGroupSubKindAssociations; overload;

        procedure AddPersonnelOrderEmployeeGroupSubKindAssociations(
          PersonnelOrderEmployeeGroupSubKindAssociations: TPersonnelOrderEmployeeGroupSubKindAssociations
        );

        procedure RemovePersonnelOrderEmployeeGroupSubKindAssociations(
          PersonnelOrderEmployeeGroupSubKindAssociations: TPersonnelOrderEmployeeGroupSubKindAssociations
        );

        procedure RemovePersonnelOrderEmployeeGroupSubKindAssociationsByGroup(
          const GroupId: Variant
        );

    end;

implementation

uses

  IDomainObjectBaseListUnit,
  SQLAllMultiFieldsEqualityCriterion,
  SQLAnyMatchingCriterion,
  AbstractRepository,
  TableMapping, AbstractDBRepository;
  
{ TPersonnelOrderEmployeeGroupSubKindAssociationPostgresRepository }

constructor TPersonnelOrderEmployeeGroupSubKindAssociationPostgresRepository.Create(
  QueryExecutor: IQueryExecutor;
  TableDef: TPersonnelOrderEmployeeGroupSubKindAssociationTableDef;
  AssociationClass: TPersonnelOrderEmployeeGroupSubKindAssociationClass;
  AssociationsClass: TPersonnelOrderEmployeeGroupSubKindAssociationsClass
);
begin

  inherited Create(QueryExecutor);

  FTableDef := TableDef;
  FFreeTableDef := FTableDef;

  FAssociationClass := AssociationClass;
  FAssociationsClass := AssociationsClass;
  
  CustomizeTableMapping(FDBTableMapping);

end;

procedure TPersonnelOrderEmployeeGroupSubKindAssociationPostgresRepository.CustomizeTableMapping(
  TableMapping: TDBTableMapping);
begin

  if not Assigned(FTableDef) then Exit;

  with TableMapping, FTableDef do begin

    SetTableNameMapping(TableName, FAssociationClass, FAssociationsClass);

    AddColumnMappingForSelect(IdColumnName, 'Identity');
    AddColumnMappingForSelect(GroupIdColumnName, 'GroupId');
    AddColumnMappingForSelect(SubKindIdColumnName, 'PersonnelOrderSubKindId');

    AddColumnMappingForModification(GroupIdColumnName, 'GroupId');
    AddColumnMappingForSelect(SubKindIdColumnName, 'PersonnelOrderSubKindId');

    AddPrimaryKeyColumnMapping(IdColumnName, 'Identity');
    
  end;

end;

procedure TPersonnelOrderEmployeeGroupSubKindAssociationPostgresRepository.
  AddPersonnelOrderEmployeeGroupSubKindAssociations(
    PersonnelOrderEmployeeGroupSubKindAssociations: TPersonnelOrderEmployeeGroupSubKindAssociations
  );
begin

  AddDomainObjectList(PersonnelOrderEmployeeGroupSubKindAssociations);

  ThrowExceptionIfErrorIsNotUnknown;

end;

function TPersonnelOrderEmployeeGroupSubKindAssociationPostgresRepository.
  FindPersonnelOrderEmployeeGroupSubKindAssociationsByGroup(
    const GroupId: Variant
  ): TPersonnelOrderEmployeeGroupSubKindAssociations;
var
    Criteria: TSQLAllMultiFieldsEqualityCriterion;
begin

  Criteria :=
    TSQLAllMultiFieldsEqualityCriterion.Create(
      [FTableDef.GroupIdColumnName],
      [GroupId]
    );

  try

    Result :=
      TPersonnelOrderEmployeeGroupSubKindAssociations(
        FindDomainObjectsByCriteria(Criteria)
      );

    ThrowExceptionIfErrorIsNotUnknown;

  except

    FreeAndNil(Criteria);

    Raise;

  end;

end;

function TPersonnelOrderEmployeeGroupSubKindAssociationPostgresRepository.
  FindPersonnelOrderEmployeeGroupSubKindAssociationsBySubKinds(
    const PersonnelOrderSubKindIds: array of Variant
  ): TPersonnelOrderEmployeeGroupSubKindAssociations;
var
    PersonnelOrderSubKindIdList: TVariantList;
begin

  PersonnelOrderSubKindIdList := TVariantList.CreateFrom(PersonnelOrderSubKindIds);

  try

    Result := FindPersonnelOrderEmployeeGroupSubKindAssociationsBySubKinds(PersonnelOrderSubKindIdList);
    
  finally

    FreeAndNil(PersonnelOrderSubKindIdList);

  end;

end;

function TPersonnelOrderEmployeeGroupSubKindAssociationPostgresRepository.
  FindPersonnelOrderEmployeeGroupSubKindAssociationsBySubKinds(
    const PersonnelOrderSubKindIds: TVariantList
  ): TPersonnelOrderEmployeeGroupSubKindAssociations;
var
    Criteria: TSQLAnyMatchingCriterion;
begin

  Criteria :=
    TSQLAnyMatchingCriterion.Create(
      FTableDef.SubKindIdColumnName,
      PersonnelOrderSubKindIds
    );

  try

    Result :=
      TPersonnelOrderEmployeeGroupSubKindAssociations(
        FindDomainObjectsByCriteria(Criteria)
      );

  finally

    FreeAndNil(Criteria);
    
  end;
  
end;

procedure TPersonnelOrderEmployeeGroupSubKindAssociationPostgresRepository.
  RemovePersonnelOrderEmployeeGroupSubKindAssociations(
    PersonnelOrderEmployeeGroupSubKindAssociations: TPersonnelOrderEmployeeGroupSubKindAssociations
  );
begin

  RemoveDomainObjectList(PersonnelOrderEmployeeGroupSubKindAssociations);

  ThrowExceptionIfErrorIsNotUnknown;
  
end;

procedure TPersonnelOrderEmployeeGroupSubKindAssociationPostgresRepository.
  RemovePersonnelOrderEmployeeGroupSubKindAssociationsByGroup(
    const GroupId: Variant
  );
var
    Associations: TPersonnelOrderEmployeeGroupSubKindAssociations;
    Free: IDomainObjectBaseList;
begin

  Associations := FindPersonnelOrderEmployeeGroupSubKindAssociationsByGroup(GroupId);

  if not Assigned(Associations) then Exit;

  RemovePersonnelOrderEmployeeGroupSubKindAssociations(Associations);

end;

end.
