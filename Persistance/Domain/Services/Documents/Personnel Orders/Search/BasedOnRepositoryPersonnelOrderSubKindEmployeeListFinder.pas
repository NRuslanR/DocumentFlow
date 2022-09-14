unit BasedOnRepositoryPersonnelOrderSubKindEmployeeListFinder;

interface

uses

  AbstractPersonnelOrderSubKindEmployeeListFinder,
  BasedOnRepositoryPersonnelOrderEmployeeListFinder,
  PersonnelOrderSubKindEmployeeListRepository,
  PersonnelOrderEmployeeListFinder,
  PersonnelOrderEmployeeList,
  PersonnelOrderSubKindEmployeeList,
  SysUtils;

type

  TBasedOnRepositoryPersonnelOrderSubKindEmployeeListFinder =
    class (TAbstractPersonnelOrderSubKindEmployeeListFinder)

      private

        FBasedOnRepositoryPersonnelOrderEmployeeListFinder:
          TBasedOnRepositoryPersonnelOrderEmployeeListFinder;

        Free: IPersonnelOrderEmployeeListFinder;
        
      public

        constructor Create(
          PersonnelOrderSubKindEmployeeListRepository: IPersonnelOrderSubKindEmployeeListRepository
        );

        function FindPersonnelOrderEmployeeList(const EmployeeListId: Variant): TPersonnelOrderEmployeeList; override;

    end;

implementation

{ TBasedOnRepositoryPersonnelOrderSubKindEmployeeListFinder }

constructor TBasedOnRepositoryPersonnelOrderSubKindEmployeeListFinder.Create(
  PersonnelOrderSubKindEmployeeListRepository: IPersonnelOrderSubKindEmployeeListRepository
);
begin

  inherited Create;

  FBasedOnRepositoryPersonnelOrderEmployeeListFinder :=
    TBasedOnRepositoryPersonnelOrderEmployeeListFinder.Create(
      PersonnelOrderSubKindEmployeeListRepository
    );

  Free := FBasedOnRepositoryPersonnelOrderEmployeeListFinder;
  
end;

function TBasedOnRepositoryPersonnelOrderSubKindEmployeeListFinder.FindPersonnelOrderEmployeeList(
  const EmployeeListId: Variant): TPersonnelOrderEmployeeList;
begin

  Result :=
    FBasedOnRepositoryPersonnelOrderEmployeeListFinder.FindPersonnelOrderEmployeeList(
      EmployeeListId
    );
    
end;

end.
