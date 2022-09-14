unit AbstractPersonnelOrderEmployeeListFinder;

interface

uses

  PersonnelOrderEmployeeList,
  PersonnelOrderEmployeeListFinder,
  SysUtils;

type

  TAbstractPersonnelOrderEmployeeListFinder =
    class abstract (TInterfacedObject, IPersonnelOrderEmployeeListFinder)

      public

        function FindPersonnelOrderEmployeeList(const EmployeeListId: Variant): TPersonnelOrderEmployeeList; virtual; abstract;
    
        function IsPersonnelOrderEmployeeListIncludesEmployee(
          const EmployeeListId, EmployeeId: Variant
        ): Boolean;

    end;

implementation

uses

  IDomainObjectBaseUnit;

{ TAbstractPersonnelOrderEmployeeListFinder }

function TAbstractPersonnelOrderEmployeeListFinder.
  IsPersonnelOrderEmployeeListIncludesEmployee(
    const EmployeeListId, EmployeeId: Variant
  ): Boolean;
var
    EmployeeList: TPersonnelOrderEmployeeList;
    Free: IDomainObjectBase;
begin

  EmployeeList := FindPersonnelOrderEmployeeList(EmployeeListId);

  Free := EmployeeList;

  Result := Assigned(EmployeeList) and EmployeeList.Contains(EmployeeId);

end;

end.
