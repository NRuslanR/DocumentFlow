unit BasedOnRepositoryPersonnelOrderControlGroupFinder;

interface

uses

  BasedOnRepositoryPersonnelOrderSubKindEmployeeGroupFinder,
  AbstractPersonnelOrderControlGroupFinder,
  PersonnelOrderSubKindEmployeeGroupFinder,
  PersonnelOrderSubKindEmployeeGroupRepository,
  PersonnelOrderControlGroupFinder,
  PersonnelOrderControlGroup,
  PersonnelOrderSubKindEmployeeGroup,
  PersonnelOrderEmployeeGroup;

type

  TBasedOnRepositoryPersonnelOrderControlGroupFinder =
    class (TAbstractPersonnelOrderControlGroupFinder)

      private

        FBasedOnRepositoryPersonnelOrderSubKindEmployeeGroupFinder:
          TBasedOnRepositoryPersonnelOrderSubKindEmployeeGroupFinder;

        Free: IPersonnelOrderSubKindEmployeeGroupFinder;

      public

        constructor Create(
          PersonnelOrderSubKindEmployeeGroupRepository: IPersonnelOrderSubKindEmployeeGroupRepository
        );

        function FindPersonnelOrderEmployeeGroup(const GroupId: Variant): TPersonnelOrderEmployeeGroup; override;
        function FindPersonnelOrderSubKindEmployeeGroupBySubKind(const PersonnelOrderSubKindId: Variant): TPersonnelOrderSubKindEmployeeGroup; override;

    end;

implementation

{ TBasedOnRepositoryPersonnelOrderControlGroupFinder }

constructor TBasedOnRepositoryPersonnelOrderControlGroupFinder.Create(
  PersonnelOrderSubKindEmployeeGroupRepository: IPersonnelOrderSubKindEmployeeGroupRepository);
begin

  inherited Create;

  FBasedOnRepositoryPersonnelOrderSubKindEmployeeGroupFinder :=
    TBasedOnRepositoryPersonnelOrderSubKindEmployeeGroupFinder.Create(
      PersonnelOrderSubKindEmployeeGroupRepository
    );

  Free := FBasedOnRepositoryPersonnelOrderSubKindEmployeeGroupFinder;
  
end;

function TBasedOnRepositoryPersonnelOrderControlGroupFinder.FindPersonnelOrderEmployeeGroup(
  const GroupId: Variant): TPersonnelOrderEmployeeGroup;
begin

  Result :=
    FBasedOnRepositoryPersonnelOrderSubKindEmployeeGroupFinder
      .FindPersonnelOrderEmployeeGroup(GroupId) as TPersonnelOrderControlGroup;
      
end;

function TBasedOnRepositoryPersonnelOrderControlGroupFinder.FindPersonnelOrderSubKindEmployeeGroupBySubKind(
  const PersonnelOrderSubKindId: Variant): TPersonnelOrderSubKindEmployeeGroup;
begin

  Result :=
    FBasedOnRepositoryPersonnelOrderSubKindEmployeeGroupFinder
      .FindPersonnelOrderSubKindEmployeeGroupBySubKind(PersonnelOrderSubKindId)
      as TPersonnelOrderControlGroup;
      
end;

end.
