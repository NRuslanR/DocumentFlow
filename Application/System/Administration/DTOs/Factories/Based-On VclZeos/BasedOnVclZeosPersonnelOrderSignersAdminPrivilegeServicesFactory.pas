unit BasedOnVclZeosPersonnelOrderSignersAdminPrivilegeServicesFactory;

interface

uses

  AbstractDocumentFlowAdminPrivilegeServicesFactory,
  DocumentFlowAdminPrivileges,
  DocumentFlowAdminPrivilegeServices,
  ZConnection,
  SysUtils;

type

  TBasedOnVclZeosPersonnelOrderSignersAdminPrivilegeServicesFactory =
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

  BasedOnVclZeosPersonnelOrderSignersControlService,
  PersonnelOrderSignersAdminPrivilegeServices;

{ TBasedOnVclZeosPersonnelOrderSignersAdminPrivilegeServicesFactory }

constructor TBasedOnVclZeosPersonnelOrderSignersAdminPrivilegeServicesFactory.Create(
  const DocumentFlowAdminPrivilege: TDocumentFlowAdminPrivilege;
  ZConnection: TZConnection);
begin

  inherited Create(DocumentFlowAdminPrivilege);

  FZConnection := ZConnection;
  
end;

function TBasedOnVclZeosPersonnelOrderSignersAdminPrivilegeServicesFactory.
  CreateDocumentFlowAdminPrivilegeServices: TDocumentFlowAdminPrivilegeServices;
begin

  Result :=
    TPersonnelOrderSignersAdminPrivilegeServices.Create(
      FPrivilegeId,
      FWorkingPrivilegeId,
      TBasedOnVclZeosPersonnelOrderSignersControlService.Create(
        FZConnection
      )
    );

end;

end.
