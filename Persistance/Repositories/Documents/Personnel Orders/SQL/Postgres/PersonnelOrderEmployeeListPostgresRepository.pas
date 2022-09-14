 unit PersonnelOrderEmployeeListPostgresRepository;

interface

uses

  AbstractPostgresRepository,
  PersonnelOrderEmployeeList,
  PersonnelOrderEmployeeListRepository,
  PersonnelOrderEmployeeListTableDef,
  DomainObjectUnit,
  DomainObjectListUnit,
  DBTableMapping,
  QueryExecutor,
  DataReader,
  Disposable,
  SysUtils;

type

  TPersonnelOrderEmployeeListPostgresRepository =
    class (
      TAbstractPostgresRepository,
      IPersonnelOrderEmployeeListRepository
    )

      protected

        FTableDef: TPersonnelOrderEmployeeListTableDef;
        FFreeTableDef: IDisposable;
        
        FPersonnelOrderEmployeeListClass: TPersonnelOrderEmployeeListClass;

      protected

        procedure CustomizeTableMapping(
          TableMapping: TDBTableMapping
        ); override;

        function GetCustomTrailingSelectQueryTextPart: String; override;
        
      protected

        procedure FillDomainObjectFromDataReader(
          DomainObject: TDomainObject;
          DataReader: IDataReader
        ); override;

        procedure AddEmployeesToListFromDataReader(
          EmployeeList: TPersonnelOrderEmployeeList;
          DataReader: IDataReader
        ); virtual;
        
        function CheckThatSingleRecordSelected(
          DataReader: IDataReader
        ): Boolean; override;

      public

        constructor Create(
          QueryExecutor: IQueryExecutor;
          TableDef: TPersonnelOrderEmployeeListTableDef;
          PersonnelOrderEmployeeListClass: TPersonnelOrderEmployeeListClass
        );
          
        function FindPersonnelOrderEmployeeList(
          const Id: Variant
        ): TPersonnelOrderEmployeeList; virtual;

        function FindAllPersonnelOrderEmployeeLists: TPersonnelOrderEmployeeLists; virtual;

        procedure AddPersonnelOrderEmployeeList(
          EmployeeList: TPersonnelOrderEmployeeList
        ); virtual;

        procedure AddPersonnelOrderEmployeeLists(
          EmployeeLists: TPersonnelOrderEmployeeLists
        ); virtual;

        procedure UpdatePersonnelOrderEmployeeList(
          EmployeeList: TPersonnelOrderEmployeeList
        ); virtual;

        procedure UpdatePersonnelOrderEmployeeLists(
          EmployeeLists: TPersonnelOrderEmployeeLists
        ); virtual;

        procedure RemovePersonnelOrderEmployeeList(
          EmployeeList: TPersonnelOrderEmployeeList
        ); virtual;

        procedure RemovePersonnelOrderEmployeeLists(
          EmployeeLists: TPersonnelOrderEmployeeLists
        ); virtual;

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

{ TPersonnelOrderEmployeeListPostgresRepository }

constructor TPersonnelOrderEmployeeListPostgresRepository.Create(
  QueryExecutor: IQueryExecutor;
  TableDef: TPersonnelOrderEmployeeListTableDef;
  PersonnelOrderEmployeeListClass: TPersonnelOrderEmployeeListClass
);
begin

  inherited Create(QueryExecutor);

  FTableDef := TableDef;
  FFreeTableDef := FTableDef;

  FPersonnelOrderEmployeeListClass := PersonnelOrderEmployeeListClass;

  CustomizeTableMapping(FDBTableMapping);
  
end;

procedure TPersonnelOrderEmployeeListPostgresRepository.CustomizeTableMapping(
  TableMapping: TDBTableMapping);
begin

  if not Assigned(FTableDef) then Exit;
  
  with TableMapping, FTableDef do begin

    SetTableNameMapping(
      TableName,
      FPersonnelOrderEmployeeListClass,
      FPersonnelOrderEmployeeListClass.ListType
    );

    AddColumnMappingForSelect(IdColumnName, 'Identity');
    AddColumnMappingForSelect(EmployeeIdColumnName, 'FictiveEmployeeId', False);

    AddColumnMappingForModification(
      IdColumnName,
      'Identity',
      PostgresTypeNameConstants.INTEGER_TYPE_NAME
    );

    AddColumnMappingForModification(
      EmployeeIdColumnName,
      'EmployeeId',
      PostgresTypeNameConstants.INTEGER_TYPE_NAME
    );

    AddPrimaryKeyColumnMapping(IdColumnName, 'Identity');
    
  end;

end;

function TPersonnelOrderEmployeeListPostgresRepository.
  FindAllPersonnelOrderEmployeeLists: TPersonnelOrderEmployeeLists;
begin

  Result := TPersonnelOrderEmployeeLists(LoadAll);

  ThrowExceptionIfErrorIsNotUnknown;

end;

function TPersonnelOrderEmployeeListPostgresRepository.FindPersonnelOrderEmployeeList(
  const Id: Variant): TPersonnelOrderEmployeeList;
begin

  Result := TPersonnelOrderEmployeeList(FindDomainObjectByIdentity(Id));

  ThrowExceptionIfErrorIsNotUnknown;

end;

function TPersonnelOrderEmployeeListPostgresRepository.GetCustomTrailingSelectQueryTextPart: String;
begin

  Result := 'ORDER BY ' + FTableDef.IdColumnName;
  
end;

procedure TPersonnelOrderEmployeeListPostgresRepository.AddEmployeesToListFromDataReader(
  EmployeeList: TPersonnelOrderEmployeeList;
  DataReader: IDataReader
);
begin

  while
    DataReader.Next and
    (EmployeeList.Identity = DataReader[FTableDef.IdColumnName])
  do begin

    EmployeeList.AddEmployee(DataReader[FTableDef.EmployeeIdColumnName]);
    
  end;

end;

procedure TPersonnelOrderEmployeeListPostgresRepository.
  AddPersonnelOrderEmployeeList(
    EmployeeList: TPersonnelOrderEmployeeList
  );
var
    Associations: TPersonnelOrderEmployeeListEmployeeAssociations;
    Free: IDomainObjectBaseList;
begin

  Associations :=
    TPersonnelOrderEmployeeListEmployeeAssociation.
      CreateAssociationsFrom(EmployeeList);
                                 
  Free := Associations;

  AddDomainObjectList(Associations);

  ThrowExceptionIfErrorIsNotUnknown;

end;

procedure TPersonnelOrderEmployeeListPostgresRepository.
  AddPersonnelOrderEmployeeLists(
    EmployeeLists: TPersonnelOrderEmployeeLists
  );
var
    Associations: TPersonnelOrderEmployeeListEmployeeAssociations;
    Free: IDomainObjectBaseList;
begin

  Associations :=
    TPersonnelOrderEmployeeListEmployeeAssociation.
      CreateAssociationsFrom(EmployeeLists);

  Free := Associations;

  AddDomainObjectList(Associations);

  ThrowExceptionIfErrorIsNotUnknown;
  
end;

procedure TPersonnelOrderEmployeeListPostgresRepository.
  RemovePersonnelOrderEmployeeList(
    EmployeeList: TPersonnelOrderEmployeeList
  );
begin

  Remove(EmployeeList);

  ThrowExceptionIfErrorIsNotUnknown;
  
end;

procedure TPersonnelOrderEmployeeListPostgresRepository.
  RemovePersonnelOrderEmployeeLists(
    EmployeeLists: TPersonnelOrderEmployeeLists
  );
begin

  RemoveDomainObjectList(EmployeeLists);

  ThrowExceptionIfErrorIsNotUnknown;
  
end;

procedure TPersonnelOrderEmployeeListPostgresRepository.UpdatePersonnelOrderEmployeeList(
  EmployeeList: TPersonnelOrderEmployeeList);
begin

  RemovePersonnelOrderEmployeeList(EmployeeList);
  AddPersonnelOrderEmployeeList(EmployeeList);

end;

procedure TPersonnelOrderEmployeeListPostgresRepository.
  UpdatePersonnelOrderEmployeeLists(
    EmployeeLists: TPersonnelOrderEmployeeLists
  );
begin

  RemovePersonnelOrderEmployeeLists(EmployeeLists);
  AddPersonnelOrderEmployeeLists(EmployeeLists);
  
end;

function TPersonnelOrderEmployeeListPostgresRepository.CheckThatSingleRecordSelected(
  DataReader: IDataReader): Boolean;
begin

  Result := DataReader.RecordCount > 0;
  
end;

procedure TPersonnelOrderEmployeeListPostgresRepository.
  FillDomainObjectFromDataReader(
    DomainObject: TDomainObject;
    DataReader: IDataReader
  );
var
    EmployeeList: TPersonnelOrderEmployeeList;
begin

  inherited FillDomainObjectFromDataReader(DomainObject, DataReader);

  EmployeeList := TPersonnelOrderEmployeeList(DomainObject);

  AddEmployeesToListFromDataReader(EmployeeList, DataReader);

end;

end.
