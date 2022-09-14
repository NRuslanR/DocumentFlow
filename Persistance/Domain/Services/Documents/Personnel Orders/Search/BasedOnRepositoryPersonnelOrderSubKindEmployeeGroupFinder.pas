unit BasedOnRepositoryPersonnelOrderSubKindEmployeeGroupFinder;

interface

uses

  BasedOnRepositoryPersonnelOrderEmployeeGroupFinder,
  AbstractPersonnelOrderSubKindEmployeeGroupFinder,
  PersonnelOrderSubKindEmployeeGroupRepository,
  PersonnelOrderEmployeeGroupRepository,
  PersonnelOrderSubKindEmployeeGroupFinder,
  PersonnelOrderEmployeeGroupFinder,
  PersonnelOrderSubKindEmployeeGroup,
  PersonnelOrderEmployeeGroup;

type

  TBasedOnRepositoryPersonnelOrderSubKindEmployeeGroupFinder =
    class (TAbstractPersonnelOrderSubKindEmployeeGroupFinder)

      private

        FRepository: IPersonnelOrderSubKindEmployeeGroupRepository;
        
      private

        FBasedOnRepositoryPersonnelOrderEmployeeGroupFinder:
          TBasedOnRepositoryPersonnelOrderEmployeeGroupFinder;

        Free: IPersonnelOrderEmployeeGroupFinder;

      public

        constructor Create(
          PersonnelOrderSubKindEmployeeGroupRepository: IPersonnelOrderSubKindEmployeeGroupRepository
        );

        function FindPersonnelOrderEmployeeGroup(const GroupId: Variant): TPersonnelOrderEmployeeGroup; override;
        function FindPersonnelOrderSubKindEmployeeGroupBySubKind(const PersonnelOrderSubKindId: Variant): TPersonnelOrderSubKindEmployeeGroup; override;
    
    end;

implementation

{ TBasedOnRepositoryPersonnelOrderSubKindEmployeeGroupFinder }

constructor TBasedOnRepositoryPersonnelOrderSubKindEmployeeGroupFinder.Create(
  PersonnelOrderSubKindEmployeeGroupRepository: IPersonnelOrderSubKindEmployeeGroupRepository);
begin

  inherited Create;

  FRepository := PersonnelOrderSubKindEmployeeGroupRepository;

  FBasedOnRepositoryPersonnelOrderEmployeeGroupFinder :=
    TBasedOnRepositoryPersonnelOrderEmployeeGroupFinder.Create(
      PersonnelOrderSubKindEmployeeGroupRepository
    );

  Free := FBasedOnRepositoryPersonnelOrderEmployeeGroupFinder;
    
end;

function TBasedOnRepositoryPersonnelOrderSubKindEmployeeGroupFinder.FindPersonnelOrderEmployeeGroup(
  const GroupId: Variant): TPersonnelOrderEmployeeGroup;
begin

  Result :=
    FBasedOnRepositoryPersonnelOrderEmployeeGroupFinder
      .FindPersonnelOrderEmployeeGroup(GroupId) as TPersonnelOrderSubKindEmployeeGroup;

end;

function TBasedOnRepositoryPersonnelOrderSubKindEmployeeGroupFinder.
  FindPersonnelOrderSubKindEmployeeGroupBySubKind(
    const PersonnelOrderSubKindId: Variant
  ): TPersonnelOrderSubKindEmployeeGroup;
begin

  Result :=
    FRepository.FindPersonnelOrderSubKindEmployeeGroupBySubKind(PersonnelOrderSubKindId);
    
end;

end.
