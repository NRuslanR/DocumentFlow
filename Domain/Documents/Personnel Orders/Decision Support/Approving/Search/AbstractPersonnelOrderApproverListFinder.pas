unit AbstractPersonnelOrderApproverListFinder;

interface

uses

  PersonnelOrderApproverListFinder,
  AbstractPersonnelOrderSubKindEmployeeListFinder,
  PersonnelOrderApproverList;

type

  TAbstractPersonnelOrderApproverListFinder =
    class abstract (
      TAbstractPersonnelOrderSubKindEmployeeListFinder,
      IPersonnelOrderApproverListFinder
    )

      public

        function FindPersonnelOrderApproverEmployeeList(const PersonnelOrderSubKindId: Variant): TPersonnelOrderApproverList;

        function IsPersonnelOrderApproverEmployeeListIncludesEmployee(
          const PersonnelOrderSubKindId, EmployeeId: Variant
        ): Boolean;

    end;
  
implementation

{ TAbstractPersonnelOrderApproverListFinder }

function TAbstractPersonnelOrderApproverListFinder.FindPersonnelOrderApproverEmployeeList(
  const PersonnelOrderSubKindId: Variant): TPersonnelOrderApproverList;
begin

  Result :=
    TPersonnelOrderApproverList(
      FindPersonnelOrderSubKindEmployeeList(PersonnelOrderSubKindId)
    );

end;

function TAbstractPersonnelOrderApproverListFinder.IsPersonnelOrderApproverEmployeeListIncludesEmployee(
  const PersonnelOrderSubKindId, EmployeeId: Variant): Boolean;
begin

  Result :=
    IsPersonnelOrderSubKindEmployeeListIncludesEmployee(
      PersonnelOrderSubKindId, EmployeeId
    );

end;

end.
