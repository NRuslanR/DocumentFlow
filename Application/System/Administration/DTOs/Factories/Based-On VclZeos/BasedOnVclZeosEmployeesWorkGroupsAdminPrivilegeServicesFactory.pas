unit BasedOnVclZeosEmployeesWorkGroupsAdminPrivilegeServicesFactory;

interface

uses

  DocumentFlowAdminPrivilegeServices,
  DocumentFlowAdminPrivileges,
  AbstractDocumentFlowAdminPrivilegeServicesFactory,
  ZConnection,
  SysUtils;

type

  TBasedOnVclZeosEmployeesWorkGroupsAdminPrivilegeServicesFactory =
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

  EmployeesWorkGroupsAdminPrivilegeServices,
  BasedOnVclZeosEmployeesWorkGroupsAdminReferenceControlService;
  
{ TBasedOnVclZeosEmployeesWorkGroupsAdminPrivilegeServicesFactory }

constructor TBasedOnVclZeosEmployeesWorkGroupsAdminPrivilegeServicesFactory.Create(
  const DocumentFlowAdminPrivilege: TDocumentFlowAdminPrivilege;
  ZConnection: TZConnection
);
begin

  inherited Create(DocumentFlowAdminPrivilege);

  FZConnection := ZConnection;
  
end;

function TBasedOnVclZeosEmployeesWorkGroupsAdminPrivilegeServicesFactory.
  CreateDocumentFlowAdminPrivilegeServices: TDocumentFlowAdminPrivilegeServices;
begin

  Result :=
    TEmployeesWorkGroupsAdminPrivilegeServices.Create(
      FPrivilegeId,
      FWorkingPrivilegeId,
      TBasedOnVclZeosEmployeesWorkGroupsAdminReferenceControlService.Create(
        FZConnection
      )
    );
    
end;

end.
