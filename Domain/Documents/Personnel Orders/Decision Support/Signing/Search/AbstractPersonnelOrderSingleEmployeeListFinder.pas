unit AbstractPersonnelOrderSingleEmployeeListFinder;

interface

uses

  PersonnelOrderSingleEmployeeListFinder,
  PersonnelOrderEmployeeList,
  SysUtils;

type

  TAbstractPersonnelOrderSingleEmployeeListFinder =
    class abstract (TInterfacedObject, IPersonnelOrderSingleEmployeeListFinder)

      function FindPersonnelOrderSingleEmployeeList: TPersonnelOrderEmployeeList; virtual; abstract;
      function IsPersonnelOrderEmployeeListIncludesEmployee(const EmployeeId: Variant): Boolean;

    end;
    
implementation

uses

  IDomainObjectBaseUnit;
  
{ TAbstractPersonnelOrderSingleEmployeeListFinder }

function TAbstractPersonnelOrderSingleEmployeeListFinder.
  IsPersonnelOrderEmployeeListIncludesEmployee(const EmployeeId: Variant): Boolean;
var
    EmployeeList: TPersonnelOrderEmployeeList;
    Free: IDomainObjectBase;
begin

  EmployeeList := FindPersonnelOrderSingleEmployeeList;

  Free := EmployeeList;

  Result := Assigned(EmployeeList) and EmployeeList.Contains(EmployeeId);
  
end;

end.
