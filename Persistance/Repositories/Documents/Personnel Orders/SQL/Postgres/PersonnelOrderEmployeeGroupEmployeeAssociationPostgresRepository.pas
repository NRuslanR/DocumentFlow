unit PersonnelOrderEmployeeGroupEmployeeAssociationPostgresRepository;

interface

uses

  AbstractPostgresRepository,
  PersonnelOrderEmployeeGroupEmployeeAssociationRepository,
  PersonnelOrderEmployeeGroupEmployeeAssociationTableDef,
  DBTableMapping,
  QueryExecutor,
  Disposable,
  SysUtils;

type

  TPersonnelOrderEmployeeGroupEmployeeAssociationPostgresRepository =
    class (
      TAbstractPostgresRepository,
      IPersonnelOrderEmployeeGroupEmployeeAssociationRepository
    )

      protected

        FTableDef: TPersonnelOrderEmployeeGroupEmployeeAssociationTableDef;
        FFreeTableDef: IDisposable;

        FAssociationClass: TPersonnelOrderEmployeeGroupEmployeeAssociationClass;
        FAssociationsClass: TPersonnelOrderEmployeeGroupEmployeeAssociationsClass;

        procedure CustomizeTableMapping(
          TableMapping: TDBTableMapping
        ); override;
        
      public

        constructor Create(
          QueryExecutor: IQueryExecutor;
          TableDef: TPersonnelOrderEmployeeGroupEmployeeAssociationTableDef;
          AssociationClass: TPersonnelOrderEmployeeGroupEmployeeAssociationClass;
          AssociationsClass: TPersonnelOrderEmployeeGroupEmployeeAssociationsClass
        );

        function FindPersonnelOrderEmployeeGroupEmployeeAssociationsByGroup(
          const GroupId: Variant
        ): TPersonnelOrderEmployeeGroupEmployeeAssociations;

        procedure AddPersonnelOrderEmployeeGroupEmployeeAssociations(
          PersonnelOrderEmployeeGroupEmployeeAssociations: TPersonnelOrderEmployeeGroupEmployeeAssociations
        );

        procedure RemovePersonnelOrderEmployeeGroupEmployeeAssociations(
          PersonnelOrderEmployeeGroupEmployeeAssociations: TPersonnelOrderEmployeeGroupEmployeeAssociations
        );

        procedure RemovePersonnelOrderEmployeeGroupEmployeeAssociationsByGroup(
          const GroupId: Variant
        );

    end;

implementation

uses

  PostgresTypeNameConstants,
  AbstractRepository,
  AbstractDBRepository,
  IDomainObjectBaseListUnit,
  SQLAllMultiFieldsEqualityCriterion;
  
{ TPersonnelOrderEmployeeGroupEmployeeAssociationPostgresRepository }

constructor TPersonnelOrderEmployeeGroupEmployeeAssociationPostgresRepository.Create(
  QueryExecutor: IQueryExecutor;
  TableDef: TPersonnelOrderEmployeeGroupEmployeeAssociationTableDef;
  AssociationClass: TPersonnelOrderEmployeeGroupEmployeeAssociationClass;
  AssociationsClass: TPersonnelOrderEmployeeGroupEmployeeAssociationsClass
);
begin

  inherited Create(QueryExecutor);

  FTableDef := TableDef;
  FFreeTableDef := FTableDef;

  FAssociationClass := AssociationClass;
  FAssociationsClass := AssociationsClass;

  CustomizeTableMapping(FDBTableMapping);

end;

procedure TPersonnelOrderEmployeeGroupEmployeeAssociationPostgresRepository.CustomizeTableMapping(
  TableMapping: TDBTableMapping);
begin

  if not Assigned(FTableDef) then Exit;

  with TableMapping, FTableDef do begin

    SetTableNameMapping(TableName, FAssociationClass, FAssociationsClass);

    AddColumnMappingForSelect(IdColumnName, 'Identity');
    AddColumnMappingForSelect(GroupIdColumnName, 'GroupId');
    AddColumnMappingForSelect(EmployeeIdColumnName, 'EmployeeId');

    AddColumnMappingForModification(
      GroupIdColumnName, 'GroupId', PostgresTypeNameConstants.INTEGER_TYPE_NAME
    );

    AddColumnMappingForModification(
      EmployeeIdColumnName, 'EmployeeId', PostgresTypeNameConstants.INTEGER_TYPE_NAME
    );

    AddPrimaryKeyColumnMapping(IdColumnName, 'Identity');

  end;
  
end;

procedure TPersonnelOrderEmployeeGroupEmployeeAssociationPostgresRepository.
  AddPersonnelOrderEmployeeGroupEmployeeAssociations(
    PersonnelOrderEmployeeGroupEmployeeAssociations: TPersonnelOrderEmployeeGroupEmployeeAssociations
  );
begin

  AddDomainObjectList(PersonnelOrderEmployeeGroupEmployeeAssociations);

  ThrowExceptionIfErrorIsNotUnknown;
  
end;

function TPersonnelOrderEmployeeGroupEmployeeAssociationPostgresRepository.
  FindPersonnelOrderEmployeeGroupEmployeeAssociationsByGroup(
    const GroupId: Variant
  ): TPersonnelOrderEmployeeGroupEmployeeAssociations;
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
      TPersonnelOrderEmployeeGroupEmployeeAssociations(
        FindDomainObjectsByCriteria(Criteria)
      );

    ThrowExceptionIfErrorIsNotUnknown;
    
  finally

    FreeAndNil(Criteria);

  end;
  
end;

procedure TPersonnelOrderEmployeeGroupEmployeeAssociationPostgresRepository.
  RemovePersonnelOrderEmployeeGroupEmployeeAssociations(
    PersonnelOrderEmployeeGroupEmployeeAssociations: TPersonnelOrderEmployeeGroupEmployeeAssociations
  );
begin

  RemoveDomainObjectList(PersonnelOrderEmployeeGroupEmployeeAssociations);

  ThrowExceptionIfErrorIsNotUnknown;
  
end;

procedure TPersonnelOrderEmployeeGroupEmployeeAssociationPostgresRepository.
  RemovePersonnelOrderEmployeeGroupEmployeeAssociationsByGroup(
    const GroupId: Variant
  );
var
    Associations: TPersonnelOrderEmployeeGroupEmployeeAssociations;
    Free: IDomainObjectBaseList;
begin

  Associations :=
    FindPersonnelOrderEmployeeGroupEmployeeAssociationsByGroup(GroupId);

  if not Assigned(Associations) then Exit;

  Free := Associations;

  RemovePersonnelOrderEmployeeGroupEmployeeAssociations(Associations);
  
end;

end.
