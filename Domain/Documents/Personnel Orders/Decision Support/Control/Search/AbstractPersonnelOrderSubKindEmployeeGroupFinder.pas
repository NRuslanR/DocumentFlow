unit AbstractPersonnelOrderSubKindEmployeeGroupFinder;

interface

uses

  AbstractPersonnelOrderEmployeeGroupFinder,
  PersonnelOrderSubKindEmployeeGroupFinder,
  PersonnelOrderSubKindEmployeeGroup,
  SysUtils;

type

  TAbstractPersonnelOrderSubKindEmployeeGroupFinder =
    class abstract (
      TAbstractPersonnelOrderEmployeeGroupFinder,
      IPersonnelOrderSubKindEmployeeGroupFinder
    )

      public

        function FindPersonnelOrderSubKindEmployeeGroup(const GroupId: Variant): TPersonnelOrderSubKindEmployeeGroup;
        function FindPersonnelOrderSubKindEmployeeGroupBySubKind(const PersonnelOrderSubKindId: Variant): TPersonnelOrderSubKindEmployeeGroup; virtual; abstract;
        function IsPersonnelOrderEmployeeGroupIncludesEmployeeBySubKind(const PersonnelOrderSubKindId, EmployeeId: Variant): Boolean;
    
    end;

implementation

uses

  IDomainObjectBaseUnit;
  
{ TAbstractPersonnelOrderSubKindEmployeeGroupFinder }

function TAbstractPersonnelOrderSubKindEmployeeGroupFinder.FindPersonnelOrderSubKindEmployeeGroup(
  const GroupId: Variant): TPersonnelOrderSubKindEmployeeGroup;
begin

  Result := TPersonnelOrderSubKindEmployeeGroup(FindPersonnelOrderEmployeeGroup(GroupId));

end;

function TAbstractPersonnelOrderSubKindEmployeeGroupFinder.IsPersonnelOrderEmployeeGroupIncludesEmployeeBySubKind(
  const PersonnelOrderSubKindId, EmployeeId: Variant
): Boolean;
var
    EmployeeGroup: TPersonnelOrderSubKindEmployeeGroup;
    Free: IDomainObjectBase;
begin

  EmployeeGroup := FindPersonnelOrderSubKindEmployeeGroupBySubKind(PersonnelOrderSubKindId);

  Free := EmployeeGroup;

  Result := Assigned(EmployeeGroup) and EmployeeGroup.ContainsEmployee(EmployeeId);
  
end;

end.
