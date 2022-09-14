unit PersonnelOrderSubKindEmployeeListPostgresRepository;

interface

uses

  PersonnelOrderEmployeeListRepository,
  PersonnelOrderSubKindEmployeeListRepository,
  PersonnelOrderEmployeeListPostgresRepository,
  PersonnelOrderSubKindEmployeeList,
  QueryExecutor,
  PersonnelOrderSubKindEmployeeListTableDef,
  SysUtils;

type

  TPersonnelOrderSubKindEmployeeListPostgresRepository =
    class (
      TPersonnelOrderEmployeeListPostgresRepository,
      IPersonnelOrderSubKindEmployeeListRepository,
      IPersonnelOrderEmployeeListRepository
    )

      public

        constructor Create(
          QueryExecutor: IQueryExecutor;
          TableDef: TPersonnelOrderSubKindEmployeeListTableDef;
          PersonnelOrderSubKindEmployeeListClass: TPersonnelOrderSubKindEmployeeListClass
        );
        
        function FindPersonnelOrderSubKindEmployeeListBySubKind(
          const PersonnelOrderSubKindId: Variant
        ): TPersonnelOrderSubKindEmployeeList;

        function FindAllPersonnelOrderSubKindEmployeeLists: TPersonnelOrderSubKindEmployeeLists;

        procedure AddPersonnelOrderSubKindEmployeeList(
          SubKindEmployeeList: TPersonnelOrderSubKindEmployeeList
        );

        procedure AddPersonnelOrderSubKindEmployeeLists(
          SubKindEmployeeLists: TPersonnelOrderSubKindEmployeeLists
        );

        procedure UpdatePersonnelOrderSubKindEmployeeList(
          SubKindEmployeeList: TPersonnelOrderSubKindEmployeeList
        );

        procedure UpdatePersonnelOrderSubKindEmployeeLists(
          SubKindEmployeeLists: TPersonnelOrderSubKindEmployeeLists
        );

        procedure RemovePersonnelOrderSubKindEmployeeList(
          SubKindEmployeeList: TPersonnelOrderSubKindEmployeeList
        );

        procedure RemovePersonnelOrderSubKindEmployeeLists(
          SubKindEmployeeLists: TPersonnelOrderSubKindEmployeeLists
        );

    end;

implementation

{ TPersonnelOrderSubKindEmployeeListPostgresRepository }

procedure TPersonnelOrderSubKindEmployeeListPostgresRepository.
  AddPersonnelOrderSubKindEmployeeList(
    SubKindEmployeeList: TPersonnelOrderSubKindEmployeeList
  );
begin

  AddPersonnelOrderEmployeeList(SubKindEmployeeList);

end;

procedure TPersonnelOrderSubKindEmployeeListPostgresRepository.AddPersonnelOrderSubKindEmployeeLists(
  SubKindEmployeeLists: TPersonnelOrderSubKindEmployeeLists);
begin

  AddPersonnelOrderEmployeeLists(SubKindEmployeeLists);
  
end;

constructor TPersonnelOrderSubKindEmployeeListPostgresRepository.Create(
  QueryExecutor: IQueryExecutor;
  TableDef: TPersonnelOrderSubKindEmployeeListTableDef;
  PersonnelOrderSubKindEmployeeListClass: TPersonnelOrderSubKindEmployeeListClass);
begin

  inherited Create(QueryExecutor, TableDef, PersonnelOrderSubKindEmployeeListClass);
  
end;

function TPersonnelOrderSubKindEmployeeListPostgresRepository.
  FindAllPersonnelOrderSubKindEmployeeLists: TPersonnelOrderSubKindEmployeeLists;
begin

  Result := TPersonnelOrderSubKindEmployeeLists(FindAllPersonnelOrderEmployeeLists);
  
end;

function TPersonnelOrderSubKindEmployeeListPostgresRepository.
  FindPersonnelOrderSubKindEmployeeListBySubKind(
    const PersonnelOrderSubKindId: Variant
  ): TPersonnelOrderSubKindEmployeeList;
begin

  Result :=
    TPersonnelOrderSubKindEmployeeList(
      FindPersonnelOrderEmployeeList(PersonnelOrderSubKindId)
    );

end;

procedure TPersonnelOrderSubKindEmployeeListPostgresRepository.RemovePersonnelOrderSubKindEmployeeList(
  SubKindEmployeeList: TPersonnelOrderSubKindEmployeeList);
begin

  RemovePersonnelOrderEmployeeList(SubKindEmployeeList);

end;

procedure TPersonnelOrderSubKindEmployeeListPostgresRepository.RemovePersonnelOrderSubKindEmployeeLists(
  SubKindEmployeeLists: TPersonnelOrderSubKindEmployeeLists);
begin

  RemovePersonnelOrderEmployeeLists(SubKindEmployeeLists);
  
end;

procedure TPersonnelOrderSubKindEmployeeListPostgresRepository.UpdatePersonnelOrderSubKindEmployeeList(
  SubKindEmployeeList: TPersonnelOrderSubKindEmployeeList);
begin

  UpdatePersonnelOrderEmployeeList(SubKindEmployeeList);

end;

procedure TPersonnelOrderSubKindEmployeeListPostgresRepository.UpdatePersonnelOrderSubKindEmployeeLists(
  SubKindEmployeeLists: TPersonnelOrderSubKindEmployeeLists);
begin

  UpdatePersonnelOrderEmployeeLists(SubKindEmployeeLists);

end;

end.
