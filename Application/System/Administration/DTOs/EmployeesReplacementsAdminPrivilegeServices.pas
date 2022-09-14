unit EmployeesReplacementsAdminPrivilegeServices;

interface

uses

  DocumentFlowAdminPrivilegeServices,
  EmployeesReplacementsAdminReferenceControlService;

type

  TEmployeesReplacementsAdminPrivilegeServices =
    class (TDocumentFlowAdminPrivilegeServices)

      public

        EmployeesReplacementsAdminReferenceControlService:
          IEmployeesReplacementsAdminReferenceControlService;

        constructor Create(
          const PrivilegeId: Variant;
          const WorkingPrivilegeId: Variant;
          EmployeesReplacementsAdminReferenceControlService:
            IEmployeesReplacementsAdminReferenceControlService
        );

    end;

implementation

{ TEmployeesReplacementsAdminPrivilegeServices }

constructor TEmployeesReplacementsAdminPrivilegeServices.Create(
  const PrivilegeId: Variant;
  const WorkingPrivilegeId: Variant;
  EmployeesReplacementsAdminReferenceControlService: IEmployeesReplacementsAdminReferenceControlService);
begin

  inherited Create(PrivilegeId, WorkingPrivilegeId);

  Self.EmployeesReplacementsAdminReferenceControlService :=
    EmployeesReplacementsAdminReferenceControlService;
    
end;

end.
