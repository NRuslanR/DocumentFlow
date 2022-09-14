unit BasedOnRepositoryPersonnelOrderSignerListFinder;

interface

uses

  BasedOnRepositoryPersonnelOrderSingleEmployeeListFinder,
  PersonnelOrderSignerList,
  PersonnelOrderEmployeeList,
  PersonnelOrderSingleEmployeeListFinder,
  PersonnelOrderSingleEmployeeListRepository,
  AbstractPersonnelOrderSignerListFinder;

type

  TBasedOnRepositoryPersonnelOrderSignerListFinder =
    class (TAbstractPersonnelOrderSignerListFinder)

      private

        FBasedOnRepositoryPersonnelOrderSingleEmployeeListFinder:
          TBasedOnRepositoryPersonnelOrderSingleEmployeeListFinder;

        Free: IPersonnelOrderSingleEmployeeListFinder;
        
      public

        constructor Create(
          PersonnelOrderSingleEmployeeListRepository: IPersonnelOrderSingleEmployeeListRepository
        );

        function FindPersonnelOrderSingleEmployeeList: TPersonnelOrderEmployeeList; override;
        
    end;

  
implementation

{ TBasedOnRepositoryPersonnelOrderSignerListFinder }

constructor TBasedOnRepositoryPersonnelOrderSignerListFinder.Create(
  PersonnelOrderSingleEmployeeListRepository: IPersonnelOrderSingleEmployeeListRepository);
begin

  inherited Create;

  FBasedOnRepositoryPersonnelOrderSingleEmployeeListFinder :=
    TBasedOnRepositoryPersonnelOrderSingleEmployeeListFinder.Create(
      PersonnelOrderSingleEmployeeListRepository
    );
    
end;

function TBasedOnRepositoryPersonnelOrderSignerListFinder.FindPersonnelOrderSingleEmployeeList: TPersonnelOrderEmployeeList;
begin

  Result :=
    FBasedOnRepositoryPersonnelOrderSingleEmployeeListFinder
      .FindPersonnelOrderSingleEmployeeList as TPersonnelOrderSignerList;
    
end;

end.
