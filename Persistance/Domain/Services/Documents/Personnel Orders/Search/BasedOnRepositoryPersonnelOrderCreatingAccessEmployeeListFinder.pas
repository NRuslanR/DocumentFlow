unit BasedOnRepositoryPersonnelOrderCreatingAccessEmployeeListFinder;

interface

uses

  AbstractPersonnelOrderCreatingAccessEmployeeListFinder,
  BasedOnRepositoryPersonnelOrderSingleEmployeeListFinder,
  PersonnelOrderSingleEmployeeListRepository,
  PersonnelOrderEmployeeList,
  PersonnelOrderCreatingAccessEmployeeList,
  PersonnelOrderSingleEmployeeListFinder,
  SysUtils;

type

  TBasedOnRepositoryPersonnelOrderCreatingAccessEmployeeListFinder =
    class (TAbstractPersonnelOrderCreatingAccessEmployeeListFinder)

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

{ TBasedOnRepositoryPersonnelOrderCreatingAccessEmployeeListFinder }

constructor TBasedOnRepositoryPersonnelOrderCreatingAccessEmployeeListFinder.Create(
  PersonnelOrderSingleEmployeeListRepository: IPersonnelOrderSingleEmployeeListRepository);
begin

  inherited Create;

  FBasedOnRepositoryPersonnelOrderSingleEmployeeListFinder :=
    TBasedOnRepositoryPersonnelOrderSingleEmployeeListFinder.Create(
      PersonnelOrderSingleEmployeeListRepository
    );

  Free := FBasedOnRepositoryPersonnelOrderSingleEmployeeListFinder;
  
end;

function TBasedOnRepositoryPersonnelOrderCreatingAccessEmployeeListFinder.
  FindPersonnelOrderSingleEmployeeList: TPersonnelOrderEmployeeList;
begin

  Result :=
    FBasedOnRepositoryPersonnelOrderSingleEmployeeListFinder
      .FindPersonnelOrderSingleEmployeeList as TPersonnelOrderCreatingAccessEmployeeList;
      
end;

end.
