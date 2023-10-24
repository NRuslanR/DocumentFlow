unit AbstractPersonnelOrderControlGroupFinder;

interface

uses

  AbstractPersonnelOrderSubKindEmployeeGroupFinder,
  PersonnelOrderControlGroupFinder,
  PersonnelOrderControlGroup,
  SysUtils;

type

  TAbstractPersonnelOrderControlGroupFinder =
    class abstract (
      TAbstractPersonnelOrderSubKindEmployeeGroupFinder,
      IPersonnelOrderControlGroupFinder
    )

      public

        function FindPersonnelOrderControlGroup(const GroupId: Variant): TPersonnelOrderControlGroup;
        function FindPersonnelOrderControlGroupBySubKind(const PersonnelOrderSubKindId: Variant): TPersonnelOrderControlGroup;
      
    end;

  
implementation

{ TAbstractPersonnelOrderControlGroupFinder }

function TAbstractPersonnelOrderControlGroupFinder.FindPersonnelOrderControlGroup(
  const GroupId: Variant): TPersonnelOrderControlGroup;
begin

  Result := TPersonnelOrderControlGroup(FindPersonnelOrderSubKindEmployeeGroup(GroupId));
  
end;

function TAbstractPersonnelOrderControlGroupFinder.FindPersonnelOrderControlGroupBySubKind(
  const PersonnelOrderSubKindId: Variant): TPersonnelOrderControlGroup;
begin

  Result :=
    TPersonnelOrderControlGroup(
      FindPersonnelOrderSubKindEmployeeGroupBySubKind(PersonnelOrderSubKindId)
    );
  
end;

end.
