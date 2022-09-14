unit BasedOnVclZeosPersonnelOrderEmployeesAdminPrivilegeServicesFactory;

interface

uses

  AbstractDocumentFlowAdminPrivilegeServicesFactory,
  DocumentFlowAdminPrivileges,
  DocumentFlowAdminPrivilegeServices,
  ZConnection,
  SysUtils;

type

  TBasedOnVclZeosPersonnelOrderEmployeesAdminPrivilegeServicesFactory =
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

  PersonnelOrderEmployeesAdminPrivilegeServices,
  BasedOnVclZeosPersonnelOrderEmployeesControlService;

{ TBasedOnVclZeosPersonnelOrderEmployeesAdminPrivilegeServicesFactory }

constructor TBasedOnVclZeosPersonnelOrderEmployeesAdminPrivilegeServicesFactory.Create(
  const DocumentFlowAdminPrivilege: TDocumentFlowAdminPrivilege;
  ZConnection: TZConnection);
begin

  inherited Create(DocumentFlowAdminPrivilege);

  FZConnection := ZConnection;
  
end;

function TBasedOnVclZeosPersonnelOrderEmployeesAdminPrivilegeServicesFactory.CreateDocumentFlowAdminPrivilegeServices: TDocumentFlowAdminPrivilegeServices;
begin

  Result :=
    TPersonnelOrderEmployeesAdminPrivilegeServices.Create(
      FPrivilegeId,
      FWorkingPrivilegeId,
      TBasedOnVclZeosPersonnelOrderEmployeesControlService.Create(
        FZConnection
      )
    );

end;

end.
