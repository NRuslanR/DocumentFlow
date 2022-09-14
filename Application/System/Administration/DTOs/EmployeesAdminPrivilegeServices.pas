unit EmployeesAdminPrivilegeServices;

interface

uses

  DocumentFlowAdminPrivilegeServices,
  EmployeesAdminReferenceControlService;

type

  TEmployeesAdminPrivilegeServices = class (TDocumentFlowAdminPrivilegeServices)

    public

      EmployeesAdminReferenceControlService: IEmployeesAdminReferenceControlService;

      constructor Create(
        const PrivilegeId: Variant;
        const WorkingPrivilegeId: Variant;
        EmployeesAdminReferenceControlService: IEmployeesAdminReferenceControlService
      );
      
  end;

implementation

{ TEmployeesAdminPrivilegeServices }

constructor TEmployeesAdminPrivilegeServices.Create(
  const PrivilegeId: Variant;
  const WorkingPrivilegeId: Variant;
  EmployeesAdminReferenceControlService: IEmployeesAdminReferenceControlService
);
begin

  inherited Create(PrivilegeId, WorkingPrivilegeId);

  Self.EmployeesAdminReferenceControlService := EmployeesAdminReferenceControlService;
  
end;

end.
