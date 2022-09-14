unit BasedOnVclZeosEmployeesReplacementsAdminPrivilegeServicesFactory;

interface

uses

  DocumentFlowAdminPrivilegeServices,
  DocumentFlowAdminPrivileges,
  AbstractDocumentFlowAdminPrivilegeServicesFactory,
  ZConnection,
  SysUtils;

type

  TBasedOnVclZeosEmployeesReplacementsAdminPrivilegeServicesFactory =
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

  EmployeesReplacementsAdminPrivilegeServices,
  BasedOnVclZeosEmployeesReplacementsAdminReferenceControlService;
  
{ TBasedOnVclZeosEmployeesReplacementsAdminPrivilegeServicesFactory }

constructor TBasedOnVclZeosEmployeesReplacementsAdminPrivilegeServicesFactory.Create(
  const DocumentFlowAdminPrivilege: TDocumentFlowAdminPrivilege;
  ZConnection: TZConnection
);
begin

  inherited Create(DocumentFlowAdminPrivilege);

  FZConnection := ZConnection;
  
end;

function TBasedOnVclZeosEmployeesReplacementsAdminPrivilegeServicesFactory.
  CreateDocumentFlowAdminPrivilegeServices: TDocumentFlowAdminPrivilegeServices;
begin

  Result :=
    TEmployeesReplacementsAdminPrivilegeServices.Create(
      FPrivilegeId,
      FWorkingPrivilegeId,
      TBasedOnVclZeosEmployeesReplacementsAdminReferenceControlService.Create(
        FZConnection
      )
    );
    
end;

end.
