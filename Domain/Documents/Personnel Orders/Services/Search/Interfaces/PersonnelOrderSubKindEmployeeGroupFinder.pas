unit PersonnelOrderSubKindEmployeeGroupFinder;

interface

uses

  PersonnelOrderSubKindEmployeeGroup,
  PersonnelOrderEmployeeGroupFinder,
  SysUtils;

type

  IPersonnelOrderSubKindEmployeeGroupFinder = interface (IPersonnelOrderEmployeeGroupFinder)

    function FindPersonnelOrderSubKindEmployeeGroup(const GroupId: Variant): TPersonnelOrderSubKindEmployeeGroup;
    function FindPersonnelOrderSubKindEmployeeGroupBySubKind(const PersonnelOrderSubKindId: Variant): TPersonnelOrderSubKindEmployeeGroup;
    function IsPersonnelOrderEmployeeGroupIncludesEmployeeBySubKind(const PersonnelOrderSubKindId, EmployeeId: Variant): Boolean;
    
  end;

implementation

end.
