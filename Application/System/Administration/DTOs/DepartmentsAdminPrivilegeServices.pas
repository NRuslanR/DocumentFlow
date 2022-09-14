unit DepartmentsAdminPrivilegeServices;

interface

uses

  DocumentFlowAdminPrivilegeServices,
  DepartmentsAdminReferenceControlService;

type

  TDepartmentsAdminPrivilegeServices = class (TDocumentFlowAdminPrivilegeServices)

    public

      DepartmentsAdminReferenceControlService: IDepartmentsAdminReferenceControlService;

      constructor Create(
        const PrivilegeId: Variant;
        const WorkingPrivilegeId: Variant;
        DepartmentsAdminReferenceControlService: IDepartmentsAdminReferenceControlService
      );
      
  end;

  
implementation

{ TDepartmentsAdminPrivilegeServices }

constructor TDepartmentsAdminPrivilegeServices.Create(
  const PrivilegeId: Variant;
  const WorkingPrivilegeId: Variant;
  DepartmentsAdminReferenceControlService: IDepartmentsAdminReferenceControlService);
begin

  inherited Create(PrivilegeId, WorkingPrivilegeId);

  Self.DepartmentsAdminReferenceControlService :=
    DepartmentsAdminReferenceControlService;
    
end;

end.
