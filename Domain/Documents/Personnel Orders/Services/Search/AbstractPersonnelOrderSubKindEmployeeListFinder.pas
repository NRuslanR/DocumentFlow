unit AbstractPersonnelOrderSubKindEmployeeListFinder;

interface

uses

  AbstractPersonnelOrderEmployeeListFinder,
  PersonnelOrderSubKindEmployeeListFinder,
  PersonnelOrderSubKindEmployeeList;

type

  TAbstractPersonnelOrderSubKindEmployeeListFinder =
    class abstract (
      TAbstractPersonnelOrderEmployeeListFinder,
      IPersonnelOrderSubKindEmployeeListFinder
    )

      public

        function FindPersonnelOrderSubKindEmployeeList(const PersonnelOrderSubKindId: Variant): TPersonnelOrderSubKindEmployeeList;
    
        function IsPersonnelOrderSubKindEmployeeListIncludesEmployee(
          const PersonnelOrderSubKindId, EmployeeId: Variant
        ): Boolean;

    end;


implementation

{ TAbstractPersonnelOrderSubKindEmployeeListFinder }

function TAbstractPersonnelOrderSubKindEmployeeListFinder.
  FindPersonnelOrderSubKindEmployeeList(
    const PersonnelOrderSubKindId: Variant
  ): TPersonnelOrderSubKindEmployeeList;
begin

  Result :=
    TPersonnelOrderSubKindEmployeeList(
      FindPersonnelOrderEmployeeList(PersonnelOrderSubKindId)
    );

end;

function TAbstractPersonnelOrderSubKindEmployeeListFinder.
  IsPersonnelOrderSubKindEmployeeListIncludesEmployee(
    const PersonnelOrderSubKindId, EmployeeId: Variant
  ): Boolean;
begin

  Result :=
    IsPersonnelOrderEmployeeListIncludesEmployee(
      PersonnelOrderSubKindId, EmployeeId
    );

end;

end.
