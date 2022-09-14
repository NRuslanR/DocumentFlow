unit BasedOnVclZeosPersonnelOrderKindApproversAdminPrivilegeServicesFactory;

interface

uses

  AbstractDocumentFlowAdminPrivilegeServicesFactory,
  DocumentFlowAdminPrivilegeServices,
  DocumentFlowAdminPrivileges,
  ZConnection,
  SysUtils;

type

  TBasedOnVclZeosPersonnelOrderKindApproversAdminPrivilegeServicesFactory =
    class (TAbstractDocumentFlowAdminPrivilegeServicesFactory)

      private

        FZConnection: TZConnection;
        
      public

        constructor Create(
          const DocumentFlowAdminPrivilege: TDocumentFlowAdminPrivilege;
          ZConnection: TZConnection
        );

        function CreateDocumentFlowAdminPrivilegeServices:
          TDocumentFlowAdminPrivilegeServices; override;

    end;

  
implementation

uses

  PersonnelOrderKindApproversAdminPrivilegeServices,
  BasedOnVclZeosPersonnelOrderKindApproversControlService;

{ TBasedOnVclZeosPersonnelOrderKindApproversAdminPrivilegeServicesFactory }

constructor TBasedOnVclZeosPersonnelOrderKindApproversAdminPrivilegeServicesFactory.Create(
  const DocumentFlowAdminPrivilege: TDocumentFlowAdminPrivilege;
  ZConnection: TZConnection);
begin

  inherited Create(DocumentFlowAdminPrivilege);

  FZConnection := ZConnection;

end;

function TBasedOnVclZeosPersonnelOrderKindApproversAdminPrivilegeServicesFactory.CreateDocumentFlowAdminPrivilegeServices: TDocumentFlowAdminPrivilegeServices;
begin

  Result :=
    TPersonnelOrderKindApproversAdminPrivilegeServices.Create(
      FPrivilegeId,
      FWorkingPrivilegeId,
      TBasedOnVclZeosPersonnelOrderKindApproversControlService.Create(
        FZConnection
      )
    );
    
end;

end.
