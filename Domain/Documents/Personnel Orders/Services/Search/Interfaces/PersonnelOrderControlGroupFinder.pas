unit PersonnelOrderControlGroupFinder;

interface

uses

  PersonnelOrderControlGroup,
  PersonnelOrderSubKindEmployeeGroupFinder,
  SysUtils;

type

  IPersonnelOrderControlGroupFinder = interface (IPersonnelOrderSubKindEmployeeGroupFinder)

    function FindPersonnelOrderControlGroup(const GroupId: Variant): TPersonnelOrderControlGroup;
    function FindPersonnelOrderControlGroupBySubKind(const PersonnelOrderSubKindId: Variant): TPersonnelOrderControlGroup;
    
  end;
  
implementation

end.
