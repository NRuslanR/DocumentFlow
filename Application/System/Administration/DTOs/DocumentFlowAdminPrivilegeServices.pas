unit DocumentFlowAdminPrivilegeServices;

interface

uses

  SystemAdministrationPrivilegeServices;

type

  TDocumentFlowAdminPrivilegeServices = class (TSystemAdministrationPrivilegeServices)

    public

      WorkingPrivilegeId: Variant;

      constructor Create(
        const PrivilegeId: Variant;
        const WorkingPrivilegeId: Variant
      );
      
  end;
  
implementation

uses

  Variants;

{ TDocumentFlowAdminPrivilegeServices }

{ TDocumentFlowAdminPrivilegeServices }

constructor TDocumentFlowAdminPrivilegeServices.Create(const PrivilegeId,
  WorkingPrivilegeId: Variant);
begin

  inherited Create(PrivilegeId);

  Self.WorkingPrivilegeId := WorkingPrivilegeId;
  
end;

end.
