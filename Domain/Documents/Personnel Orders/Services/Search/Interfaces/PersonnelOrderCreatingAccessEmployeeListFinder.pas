unit PersonnelOrderCreatingAccessEmployeeListFinder;

interface

uses

  PersonnelOrderCreatingAccessEmployeeList,
  PersonnelOrderSingleEmployeeListFinder,
  SysUtils;

type

  IPersonnelOrderCreatingAccessEmployeeListFinder = interface (IPersonnelOrderSingleEmployeeListFinder)

    function FindPersonnelOrderCreatingAccessEmployeeList: TPersonnelOrderCreatingAccessEmployeeList;
    
  end;


implementation

end.
