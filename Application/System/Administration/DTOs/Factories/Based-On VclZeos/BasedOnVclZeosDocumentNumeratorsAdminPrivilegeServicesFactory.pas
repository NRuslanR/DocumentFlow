unit BasedOnVclZeosDocumentNumeratorsAdminPrivilegeServicesFactory;

interface

uses

  AbstractDocumentFlowAdminPrivilegeServicesFactory,
  ZConnection,
  DocumentFlowAdminPrivileges,
  DocumentFlowAdminPrivilegeServices,
  SysUtils;

type

  TBasedOnVclZeosDocumentNumeratorsAdminPrivilegeServicesFactory =
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

  DocumentNumeratorsAdminPrivilegeServices,
  BasedOnVclZeosDocumentNumeratorsAdminReferenceControlService;

{ TBasedOnVclZeosDocumentNumeratorsAdminPrivilegeServicesFactory }

constructor TBasedOnVclZeosDocumentNumeratorsAdminPrivilegeServicesFactory.Create(
  const DocumentFlowAdminPrivilege: TDocumentFlowAdminPrivilege;
  ZConnection: TZConnection);
begin

  inherited Create(DocumentFlowAdminPrivilege);

  FZConnection := ZConnection;
  
end;

function TBasedOnVclZeosDocumentNumeratorsAdminPrivilegeServicesFactory.
  CreateDocumentFlowAdminPrivilegeServices: TDocumentFlowAdminPrivilegeServices;
begin

  Result :=
    TDocumentNumeratorsAdminPrivilegeServices.Create(
      FPrivilegeId,
      FWorkingPrivilegeId,
      TBasedOnVclZeosDocumentNumeratorsAdminReferenceControlService.Create(
        FZConnection
      )
    );
    
end;

end.
