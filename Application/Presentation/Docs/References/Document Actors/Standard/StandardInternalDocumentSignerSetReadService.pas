unit StandardInternalDocumentSignerSetReadService;

interface

uses

  StandardDocumentSignerSetReadService,
  Employee,
  SysUtils,
  Classes;

type

  TStandardInternalDocumentSignerSetReadService =
    class (TStandardDocumentSignerSetReadService)

      protected

        function FindAllBusinessLeadersForEmployee(Employee: TEmployee): TEmployees; override;

    end;
    
implementation

uses

  IDomainObjectUnit;
  
{ TStandardInternalDocumentSignerSetReadService }

function TStandardInternalDocumentSignerSetReadService.
  FindAllBusinessLeadersForEmployee(
    Employee: TEmployee
  ): TEmployees;
var DirectBusinessLeader: TEmployee;
    FreeEmployee: IDomainObject;
begin

  DirectBusinessLeader :=
    FEmployeeSubordinationService.
      FindSameHeadKindredDepartmentDirectBusinessLeaderForEmployee(
        Employee
      );

  FreeEmployee := DirectBusinessLeader;

  Result := TEmployees.Create;

  Result.Add(DirectBusinessLeader);
  
end;

end.
