unit BasedOnVclZeosEmployeeStaffsAdminPrivilegeServicesFactory;

interface

uses

  AbstractDocumentFlowAdminPrivilegeServicesFactory,
  DocumentFlowAdminPrivilegeServices,
  DocumentFlowAdminPrivileges,
  ZConnection,
  SysUtils;

type

  TBasedOnVclZeosEmployeeStaffsAdminPrivilegeServicesFactory =
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

  EmployeeStaffsAdminPrivilegeServices,
  BasedOnVclZeosEmployeeStaffsAdminReferenceControlService;
  
{ TBasedOnVclZeosEmployeeStaffsAdminPrivilegeServicesFactory }

constructor TBasedOnVclZeosEmployeeStaffsAdminPrivilegeServicesFactory.Create(
  const DocumentFlowAdminPrivilege: TDocumentFlowAdminPrivilege;
  ZConnection: TZConnection
);
begin

  inherited Create(DocumentFlowAdminPrivilege);

  FZConnection := ZConnection;
  
end;

function TBasedOnVclZeosEmployeeStaffsAdminPrivilegeServicesFactory.
  CreateDocumentFlowAdminPrivilegeServices: TDocumentFlowAdminPrivilegeServices;
begin

  Result :=
    TEmployeeStaffsAdminPrivilegeServices.Create(
      FPrivilegeId,
      FWorkingPrivilegeId,
      TBasedOnVclZeosEmployeeStaffsAdminReferenceControlService.Create(FZConnection)
    );

end;

end.
