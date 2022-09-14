unit PersonnelOrderKindApproversAdminPrivilegeServices;

interface

uses

  DocumentFlowAdminPrivilegeServices,
  PersonnelOrderKindApproversControlService,
  SysUtils;

type

  TPersonnelOrderKindApproversAdminPrivilegeServices =
    class (TDocumentFlowAdminPrivilegeServices)

      public

        PersonnelOrderKindApproversControlService: IPersonnelOrderKindApproversControlService;

        constructor Create(
          const PrivilegeId: Variant;
          const WorkingPrivilegeId: Variant;
          PersonnelOrderKindApproversControlService: IPersonnelOrderKindApproversControlService
        );
      
    end;
    
implementation

{ TPersonnelOrderKindApproversAdminPrivilegeServices }

constructor TPersonnelOrderKindApproversAdminPrivilegeServices.Create(
  const PrivilegeId, WorkingPrivilegeId: Variant;
  PersonnelOrderKindApproversControlService: IPersonnelOrderKindApproversControlService);
begin

  inherited Create(PrivilegeId, WorkingPrivilegeId);

  Self.PersonnelOrderKindApproversControlService := PersonnelOrderKindApproversControlService;
  
end;

end.
