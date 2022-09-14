unit PersonnelOrderSubKindEmployeeListFinder;

interface

uses

  PersonnelOrderEmployeeListFinder,
  PersonnelOrderSubKindEmployeeList;

type

  IPersonnelOrderSubKindEmployeeListFinder = interface (IPersonnelOrderEmployeeListFinder)

    function FindPersonnelOrderSubKindEmployeeList(const PersonnelOrderSubKindId: Variant): TPersonnelOrderSubKindEmployeeList;
    
    function IsPersonnelOrderSubKindEmployeeListIncludesEmployee(
      const PersonnelOrderSubKindId, EmployeeId: Variant
    ): Boolean;

  end;

implementation

end.
