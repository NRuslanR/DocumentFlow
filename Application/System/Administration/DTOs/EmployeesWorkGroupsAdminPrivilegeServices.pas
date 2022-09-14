unit EmployeesWorkGroupsAdminPrivilegeServices;

interface

uses

  DocumentFlowAdminPrivilegeServices,
  EmployeesWorkGroupsAdminReferenceControlService;

type

  TEmployeesWorkGroupsAdminPrivilegeServices =
    class (TDocumentFlowAdminPrivilegeServices)

      public

        EmployeesWorkGroupsAdminReferenceControlService:
          IEmployeesWorkGroupsAdminReferenceControlService;

        constructor Create(
          const PrivilegeId: Variant;
          const WorkingPrivilegeId: Variant;
          EmployeesWorkGroupsAdminReferenceControlService:
            IEmployeesWorkGroupsAdminReferenceControlService
        );

    end;
  
implementation

{ TEmployeesWorkGroupsAdminPrivilegeServices }

constructor TEmployeesWorkGroupsAdminPrivilegeServices.Create(
  const PrivilegeId: Variant;
  const WorkingPrivilegeId: Variant;
  EmployeesWorkGroupsAdminReferenceControlService: IEmployeesWorkGroupsAdminReferenceControlService);
begin

  inherited Create(PrivilegeId, WorkingPrivilegeId);

  Self.EmployeesWorkGroupsAdminReferenceControlService :=
    EmployeesWorkGroupsAdminReferenceControlService;
    
end;

end.
