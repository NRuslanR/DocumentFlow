unit PersonnelOrderSignerListFinder;

interface

uses

  PersonnelOrderSignerList,
  PersonnelOrderSingleEmployeeListFinder;

type

  IPersonnelOrderSignerListFinder = interface (IPersonnelOrderSingleEmployeeListFinder)

    function FindPersonnelOrderSignerList: TPersonnelOrderSignerList;
    
  end;

implementation

end.
