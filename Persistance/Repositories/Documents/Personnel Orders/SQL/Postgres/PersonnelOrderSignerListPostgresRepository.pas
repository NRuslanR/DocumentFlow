unit PersonnelOrderSignerListPostgresRepository;

interface

uses

  PersonnelOrderSingleEmployeeListPostgresRepository,
  PersonnelOrderEmployeeListRepository,
  PersonnelOrderSignerListRepository,
  PersonnelOrderSignerList,
  PersonnelOrderEmployeeList,
  PersonnelOrderEmployeeListTableDef,
  PersonnelOrderSignerListTableDef,
  DataReader,
  QueryExecutor,
  DBTableMapping,
  SysUtils;

type

  TPersonnelOrderSignerListPostgresRepository =
    class (
      TPersonnelOrderSingleEmployeeListPostgresRepository,
      IPersonnelOrderSignerListRepository
    )

      protected

        procedure CustomizeTableMapping(
          TableMapping: TDBTableMapping
        ); override;

        procedure AddEmployeesToListFromDataReader(
          EmployeeList: TPersonnelOrderEmployeeList;
          DataReader: IDataReader
        ); override;

      public

        constructor Create(
          QueryExecutor: IQueryExecutor;
          SignerListTableDef: TPersonnelOrderSignerListTableDef
        );
        
        function GetPersonnelOrderSignerList: TPersonnelOrderSignerList;

        procedure UpdatePersonnelOrderSignerList(
          SignerList: TPersonnelOrderSignerList
        );

    end;

implementation

uses

  PostgresTypeNameConstants;

{ TPersonnelOrderSignerListPostgresRepository }

procedure TPersonnelOrderSignerListPostgresRepository.AddEmployeesToListFromDataReader(
  EmployeeList: TPersonnelOrderEmployeeList;
  DataReader: IDataReader
);
begin

  inherited AddEmployeesToListFromDataReader(EmployeeList, DataReader);

  DataReader.Restart;

  with TPersonnelOrderSignerListTableDef(FTableDef) do begin

    while DataReader.Next and not DataReader[IsDefaultColumnName] do;

    if not DataReader.AtEnd then begin

      TPersonnelOrderSignerList(EmployeeList).DefaultSignerId :=
        DataReader[EmployeeIdColumnName];

    end;

  end;

end;

constructor TPersonnelOrderSignerListPostgresRepository.Create(
  QueryExecutor: IQueryExecutor;
  SignerListTableDef: TPersonnelOrderSignerListTableDef
);
begin

  inherited Create(
    QueryExecutor,
    SignerListTableDef,
    TPersonnelOrderSignerList
  );

end;

procedure TPersonnelOrderSignerListPostgresRepository.CustomizeTableMapping(
  TableMapping: TDBTableMapping);
begin

  inherited CustomizeTableMapping(TableMapping);

  if not Assigned(FTableDef) then Exit;
  
  with TPersonnelOrderSignerListTableDef(FTableDef) do begin

    TableMapping.AddColumnMappingForSelect(IsDefaultColumnName, 'IsDefaultSigner');

    TableMapping.AddColumnMappingForModification(
      IsDefaultColumnName,
      'IsDefaultSigner',
      PostgresTypeNameConstants.BOOLEAN_TYPE_NAME
    );
    
  end;

end;

function TPersonnelOrderSignerListPostgresRepository.GetPersonnelOrderSignerList: TPersonnelOrderSignerList;
begin

  Result := TPersonnelOrderSignerList(GetPersonnelOrderSingleEmployeeList);
  
end;

procedure TPersonnelOrderSignerListPostgresRepository.UpdatePersonnelOrderSignerList(
  SignerList: TPersonnelOrderSignerList);
begin

  UpdatePersonnelOrderSingleEmployeeList(SignerList);

end;

end.
