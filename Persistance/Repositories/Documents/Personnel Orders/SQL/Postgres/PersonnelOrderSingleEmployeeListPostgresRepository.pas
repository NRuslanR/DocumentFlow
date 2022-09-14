unit PersonnelOrderSingleEmployeeListPostgresRepository;

interface

uses

  PersonnelOrderEmployeeListPostgresRepository,
  PersonnelOrderSingleEmployeeListRepository,
  PersonnelOrderEmployeeList,
  DBTableMapping,
  QueryExecutor,
  TableColumnMappings,
  DomainObjectUnit,
  DataReader,
  SysUtils;

type

  TPersonnelOrderSingleEmployeeListPostgresRepository =
    class (
      TPersonnelOrderEmployeeListPostgresRepository,
      IPersonnelOrderSingleEmployeeListRepository
    )

      protected

        procedure CustomizeTableMapping(
          TableMapping: TDBTableMapping
        ); override;

      protected

        procedure GetSelectListFromTableMappingForSelectByIdentity(
          var SelectList, WhereClauseForSelectIdentity: String
        ); override;

        function GetCustomWhereClauseForDelete: String; override;

      protected

        procedure AddEmployeesToListFromDataReader(
          EmployeeList: TPersonnelOrderEmployeeList;
          DataReader: IDataReader
        ); override;

      public

        function GetPersonnelOrderSingleEmployeeList: TPersonnelOrderEmployeeList;

        procedure UpdatePersonnelOrderSingleEmployeeList(
          EmployeeList: TPersonnelOrderEmployeeList
        );

    end;

implementation

uses

  Variants;
  
{ TPersonnelOrderSingleEmployeeListPostgresRepository }

procedure TPersonnelOrderSingleEmployeeListPostgresRepository.CustomizeTableMapping(
  TableMapping: TDBTableMapping);
begin

  if not Assigned(FTableDef) then Exit;
  
  inherited CustomizeTableMapping(TableMapping);

  TableMapping.ColumnMappingsForSelect.RemoveColumnMapping(FTableDef.IdColumnName);
  TableMapping.ColumnMappingsForModification.RemoveColumnMapping(FTableDef.IdColumnName);

  TableMapping.PrimaryKeyColumnMappings.RemoveColumnMapping(FTableDef.IdColumnName);
  
end;

function TPersonnelOrderSingleEmployeeListPostgresRepository.
  GetPersonnelOrderSingleEmployeeList: TPersonnelOrderEmployeeList;
begin

  Result := FindPersonnelOrderEmployeeList(Null);

end;

procedure TPersonnelOrderSingleEmployeeListPostgresRepository.UpdatePersonnelOrderSingleEmployeeList(
  EmployeeList: TPersonnelOrderEmployeeList);
begin

  UpdatePersonnelOrderEmployeeList(EmployeeList);

end;

procedure TPersonnelOrderSingleEmployeeListPostgresRepository.
  AddEmployeesToListFromDataReader(
    EmployeeList: TPersonnelOrderEmployeeList;
    DataReader: IDataReader
  );
begin

  while DataReader.Next do
    EmployeeList.AddEmployee(DataReader[FTableDef.EmployeeIdColumnName]);

end;

procedure TPersonnelOrderSingleEmployeeListPostgresRepository.GetSelectListFromTableMappingForSelectByIdentity(
  var SelectList, WhereClauseForSelectIdentity: String);
begin

  inherited;

  WhereClauseForSelectIdentity := 'true';

end;

function TPersonnelOrderSingleEmployeeListPostgresRepository.GetCustomWhereClauseForDelete: String;
begin

  Result := 'true';

end;

end.
