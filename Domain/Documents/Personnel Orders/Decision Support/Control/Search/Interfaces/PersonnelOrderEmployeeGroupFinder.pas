unit PersonnelOrderEmployeeGroupFinder;

interface

uses

  PersonnelOrderEmployeeGroup,
  SysUtils;

type

  IPersonnelOrderEmployeeGroupFinder = interface

    function FindPersonnelOrderEmployeeGroup(const GroupId: Variant): TPersonnelOrderEmployeeGroup;
    function IsPersonnelOrderEmployeeGroupIncludesEmployee(const GroupId, EmployeeId: Variant): Boolean;
    
  end;

implementation

end.
