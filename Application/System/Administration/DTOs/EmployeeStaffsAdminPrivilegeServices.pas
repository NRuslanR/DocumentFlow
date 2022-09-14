unit EmployeeStaffsAdminPrivilegeServices;

interface

uses

  DocumentFlowAdminPrivilegeServices,
  EmployeeStaffsAdminReferenceControlService;

type

  TEmployeeStaffsAdminPrivilegeServices = class (TDocumentFlowAdminPrivilegeServices)

    public

      EmployeeStaffsAdminReferenceControlService:
        IEmployeeStaffsAdminReferenceControlService;

      constructor Create(
        const PrivilegeId: Variant;
        const WorkingPrivilegeId: Variant;
        EmployeeStaffsAdminReferenceControlService:
          IEmployeeStaffsAdminReferenceControlService
      );

  end;

implementation

{ TEmployeeStaffsAdminPrivilegeServices }

constructor TEmployeeStaffsAdminPrivilegeServices.Create(
  const PrivilegeId: Variant;
  const WorkingPrivilegeId: Variant;
  EmployeeStaffsAdminReferenceControlService: IEmployeeStaffsAdminReferenceControlService);
begin

  inherited Create(PrivilegeId, WorkingPrivilegeId);

  Self.EmployeeStaffsAdminReferenceControlService :=
    EmployeeStaffsAdminReferenceControlService;
    
end;

end.
