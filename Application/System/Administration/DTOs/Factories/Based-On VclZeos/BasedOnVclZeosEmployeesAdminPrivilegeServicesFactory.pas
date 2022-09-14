unit BasedOnVclZeosEmployeesAdminPrivilegeServicesFactory;

interface

uses

  DocumentFlowAdminPrivilegeServices,
  DocumentFlowAdminPrivileges,
  AbstractDocumentFlowAdminPrivilegeServicesFactory,
  ZConnection,
  SysUtils;

type

  TBasedOnVclZeosEmployeesAdminPrivilegeServicesFactory =
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

  EmployeesAdminPrivilegeServices,
  BasedOnVclZeosEmployeesAdminReferenceControlService;

{ TBasedOnVclZeosEmployeesAdminPrivilegeServicesFactory }

constructor TBasedOnVclZeosEmployeesAdminPrivilegeServicesFactory.Create(
  const DocumentFlowAdminPrivilege: TDocumentFlowAdminPrivilege;
  ZConnection: TZConnection
);
begin

  inherited Create(DocumentFlowAdminPrivilege);

  FZConnection := ZConnection;
  
end;

function TBasedOnVclZeosEmployeesAdminPrivilegeServicesFactory.
  CreateDocumentFlowAdminPrivilegeServices: TDocumentFlowAdminPrivilegeServices;
begin

  Result :=
    TEmployeesAdminPrivilegeServices.Create(
      FPrivilegeId,
      FWorkingPrivilegeId,
      TBasedOnVclZeosEmployeesAdminReferenceControlService.Create(FZConnection)
    );
  
end;

end.
