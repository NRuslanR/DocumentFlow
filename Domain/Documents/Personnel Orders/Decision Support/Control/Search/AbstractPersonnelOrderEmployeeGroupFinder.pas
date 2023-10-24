unit AbstractPersonnelOrderEmployeeGroupFinder;

interface

uses

  PersonnelOrderEmployeeGroupFinder,
  PersonnelOrderEmployeeGroup,
  SysUtils;

type

  TAbstractPersonnelOrderEmployeeGroupFinder =
    class abstract (TInterfacedObject, IPersonnelOrderEmployeeGroupFinder)

      public

        function FindPersonnelOrderEmployeeGroup(const GroupId: Variant): TPersonnelOrderEmployeeGroup; virtual; abstract;
        function IsPersonnelOrderEmployeeGroupIncludesEmployee(const GroupId, EmployeeId: Variant): Boolean;
    
    end;
  
implementation

uses

  IDomainObjectBaseUnit;
  
{ TAbstractPersonnelOrderEmployeeGroupFinder }

function TAbstractPersonnelOrderEmployeeGroupFinder.
  IsPersonnelOrderEmployeeGroupIncludesEmployee(
    const GroupId, EmployeeId: Variant
  ): Boolean;
var
    EmployeeGroup: TPersonnelOrderEmployeeGroup;
    Free: IDomainObjectBase;
begin

  EmployeeGroup := FindPersonnelOrderEmployeeGroup(GroupId);

  Free := EmployeeGroup;

  Result := Assigned(EmployeeGroup) and EmployeeGroup.ContainsEmployee(EmployeeId);
  
end;

end.
