unit PersonnelOrderApproverListFinder;

interface

uses

  PersonnelOrderSubKindEmployeeListFinder,
  PersonnelOrderApproverList;

type

  IPersonnelOrderApproverListFinder = interface (IPersonnelOrderSubKindEmployeeListFinder)

    function FindPersonnelOrderApproverEmployeeList(const PersonnelOrderSubKindId: Variant): TPersonnelOrderApproverList;
    
    function IsPersonnelOrderApproverEmployeeListIncludesEmployee(
      const PersonnelOrderSubKindId, EmployeeId: Variant
    ): Boolean;
    
  end;

implementation

end.
