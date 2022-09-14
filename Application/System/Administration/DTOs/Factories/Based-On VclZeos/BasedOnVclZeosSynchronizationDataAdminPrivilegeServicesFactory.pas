unit BasedOnVclZeosSynchronizationDataAdminPrivilegeServicesFactory;

interface

uses

  DocumentFlowAdminPrivilegeServices,
  DocumentFlowAdminPrivilegeServicesFactory,
  AbstractDocumentFlowAdminPrivilegeServicesFactory,
  DocumentFlowAdminPrivileges,
  ZConnection,
  SysUtils;

type

  TBasedOnVclZeosSynchronizationDataAdminPrivilegeServicesFactory =
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

  SynchronizationDataAdminPrivilegeServices,
  BasedOnVclZeosSynchronizationDataControlService;
  
{ TBasedOnVclZeosSynchronizationDataAdminPrivilegeServicesFactory }

constructor TBasedOnVclZeosSynchronizationDataAdminPrivilegeServicesFactory.Create(
  const DocumentFlowAdminPrivilege: TDocumentFlowAdminPrivilege;
  ZConnection: TZConnection
);
begin

  inherited Create(DocumentFlowAdminPrivilege);

  FZConnection := ZConnection;

end;

function TBasedOnVclZeosSynchronizationDataAdminPrivilegeServicesFactory.
  CreateDocumentFlowAdminPrivilegeServices: TDocumentFlowAdminPrivilegeServices;
begin

  Result :=
    TSynchronizationDataAdminPrivilegeServices.Create(
      FPrivilegeId,
      FWorkingPrivilegeId,
      TBasedOnVclZeosSynchronizationDataControlService.Create(FZConnection)
    );

end;

end.
