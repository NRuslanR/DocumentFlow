unit BasedOnRepositoryPersonnelOrderSingleEmployeeListFinder;

interface

uses

  AbstractPersonnelOrderSingleEmployeeListFinder,
  PersonnelOrderSingleEmployeeListRepository,
  PersonnelOrderEmployeeList;

type

  TBasedOnRepositoryPersonnelOrderSingleEmployeeListFinder =
    class (TAbstractPersonnelOrderSingleEmployeeListFinder)

      private

        FRepository: IPersonnelOrderSingleEmployeeListRepository;

      public

        constructor Create(
          PersonnelOrderSingleEmployeeListRepository: IPersonnelOrderSingleEmployeeListRepository
        );

        function FindPersonnelOrderSingleEmployeeList: TPersonnelOrderEmployeeList;
        
    end;

implementation

{ TBasedOnRepositoryPersonnelOrderSingleEmployeeListFinder }

constructor TBasedOnRepositoryPersonnelOrderSingleEmployeeListFinder.Create(
  PersonnelOrderSingleEmployeeListRepository: IPersonnelOrderSingleEmployeeListRepository);
begin

  inherited Create;

  FRepository := PersonnelOrderSingleEmployeeListRepository;

end;

function TBasedOnRepositoryPersonnelOrderSingleEmployeeListFinder.FindPersonnelOrderSingleEmployeeList: TPersonnelOrderEmployeeList;
begin

  Result := FRepository.GetPersonnelOrderSingleEmployeeList;
  
end;

end.
