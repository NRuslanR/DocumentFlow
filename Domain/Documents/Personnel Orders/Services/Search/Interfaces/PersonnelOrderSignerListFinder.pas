unit PersonnelOrderSignerListFinder;

interface

uses

  PersonnelOrderSignerList,
  PersonnelOrderSingleEmployeeListFinder,
  SysUtils;

type

  IPersonnelOrderSignerListFinder = interface (IPersonnelOrderSingleEmployeeListFinder)

    function FindPersonnelOrderSignerList: TPersonnelOrderSignerList;
    
  end;

implementation

end.
