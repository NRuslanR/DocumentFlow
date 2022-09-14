unit BasedOnRepositoryPersonnelOrderEmployeeListFinder;

interface

uses

  PersonnelOrderEmployeeListRepository,
  PersonnelOrderEmployeeList,
  AbstractPersonnelOrderEmployeeListFinder;

type

  TBasedOnRepositoryPersonnelOrderEmployeeListFinder =
    class (TAbstractPersonnelOrderEmployeeListFinder)

      protected                                                                                       

        FRepository: IPersonnelOrderEmployeeListRepository;
        
      public

        constructor Create(Repository: IPersonnelOrderEmployeeListRepository);
        
        function FindPersonnelOrderEmployeeList(const EmployeeListId: Variant): TPersonnelOrderEmployeeList; override;

    end;
    
implementation

{ TBasedOnRepositoryPersonnelOrderEmployeeListFinder }

constructor TBasedOnRepositoryPersonnelOrderEmployeeListFinder.Create(
  Repository: IPersonnelOrderEmployeeListRepository);
begin

  inherited Create;

  FRepository := Repository;
  
end;

function TBasedOnRepositoryPersonnelOrderEmployeeListFinder.FindPersonnelOrderEmployeeList(
  const EmployeeListId: Variant): TPersonnelOrderEmployeeList;
begin

  Result := FRepository.FindPersonnelOrderEmployeeList(EmployeeListId);
  
end;

end.
