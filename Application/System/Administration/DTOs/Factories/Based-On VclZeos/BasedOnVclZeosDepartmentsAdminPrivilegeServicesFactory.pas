unit BasedOnVclZeosDepartmentsAdminPrivilegeServicesFactory;

interface

uses

  DepartmentInfoDTO,
  DocumentFlowAdminPrivilegeServices,
  DocumentFlowAdminPrivilegeServicesFactory,
  DocumentFlowAdminPrivileges,
  AbstractDocumentFlowAdminPrivilegeServicesFactory,
  ZConnection,
  SysUtils;

type

  TBasedOnVclZeosDepartmentsAdminPrivilegeServicesFactory =
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

  DepartmentsAdminPrivilegeServices,
  BasedOnVclZeosDepartmentsAdminReferenceControlService;
  
{ TBasedOnVclZeosDepartmentsAdminPrivilegeServicesFactory }

constructor TBasedOnVclZeosDepartmentsAdminPrivilegeServicesFactory.Create(
  const DocumentFlowAdminPrivilege: TDocumentFlowAdminPrivilege;
  ZConnection: TZConnection
);
begin

  inherited Create(DocumentFlowAdminPrivilege);

  FZConnection := ZConnection;
  
end;

function TBasedOnVclZeosDepartmentsAdminPrivilegeServicesFactory.
  CreateDocumentFlowAdminPrivilegeServices: TDocumentFlowAdminPrivilegeServices;
begin

  Result :=
    TDepartmentsAdminPrivilegeServices.Create(
      FPrivilegeId,
      FWorkingPrivilegeId,
      TBasedOnVclZeosDepartmentsAdminReferenceControlService.Create(FZConnection)
    );
  
end;

end.
