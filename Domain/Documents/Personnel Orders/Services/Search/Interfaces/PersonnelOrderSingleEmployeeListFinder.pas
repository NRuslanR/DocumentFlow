unit PersonnelOrderSingleEmployeeListFinder;

interface

uses

  PersonnelOrderEmployeeList,
  SysUtils;

type

  IPersonnelOrderSingleEmployeeListFinder = interface

    function FindPersonnelOrderSingleEmployeeList: TPersonnelOrderEmployeeList;
    function IsPersonnelOrderEmployeeListIncludesEmployee(const EmployeeId: Variant): Boolean;
    
  end;
  
implementation

end.
