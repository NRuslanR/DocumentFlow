unit PersonnelOrderEmployeeListFinder;

interface

uses

  PersonnelOrderEmployeeList,
  SysUtils;

type

  IPersonnelOrderEmployeeListFinder = interface

    function FindPersonnelOrderEmployeeList(const EmployeeListId: Variant): TPersonnelOrderEmployeeList;
    
    function IsPersonnelOrderEmployeeListIncludesEmployee(
      const EmployeeListId, EmployeeId: Variant
    ): Boolean;

  end;
  
implementation

end.
