unit BasedOnRepositoryPersonnelOrderEmployeeGroupFinder;

interface

uses

  AbstractPersonnelOrderEmployeeGroupFinder,
  PersonnelOrderEmployeeGroup,
  PersonnelOrderEmployeeGroupRepository;

type

  TBasedOnRepositoryPersonnelOrderEmployeeGroupFinder =
    class (TAbstractPersonnelOrderEmployeeGroupFinder)

      private

        FRepository: IPersonnelOrderEmployeeGroupRepository;

      public

        constructor Create(
          PersonnelOrderEmployeeGroupRepository: IPersonnelOrderEmployeeGroupRepository
        );

        function FindPersonnelOrderEmployeeGroup(const GroupId: Variant): TPersonnelOrderEmployeeGroup; override;
      
    end;


implementation

{ TBasedOnRepositoryPersonnelOrderEmployeeGroupFinder }

constructor TBasedOnRepositoryPersonnelOrderEmployeeGroupFinder.Create(
  PersonnelOrderEmployeeGroupRepository: IPersonnelOrderEmployeeGroupRepository);
begin

  inherited Create;

  FRepository := PersonnelOrderEmployeeGroupRepository;
  
end;

function TBasedOnRepositoryPersonnelOrderEmployeeGroupFinder.FindPersonnelOrderEmployeeGroup(
  const GroupId: Variant): TPersonnelOrderEmployeeGroup;
begin

  Result :=
    FRepository.FindPersonnelOrderEmployeeGroupById(GroupId);
    
end;

end.
