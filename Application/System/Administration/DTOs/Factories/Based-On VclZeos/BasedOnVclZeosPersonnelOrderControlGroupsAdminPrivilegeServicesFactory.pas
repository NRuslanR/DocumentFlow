unit BasedOnVclZeosPersonnelOrderControlGroupsAdminPrivilegeServicesFactory;

interface

uses

  AbstractDocumentFlowAdminPrivilegeServicesFactory,
  DocumentFlowAdminPrivilegeServices,
  DocumentFlowAdminPrivileges,
  ZConnection,
  SysUtils;

type

  TBasedOnVclZeosPersonnelOrderControlGroupsAdminPrivilegeServicesFactory =
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

  PersonnelOrderControlGroupsAdminPrivilegeServices,
  BasedOnVclZeosPersonnelOrderControlGroupsControlService;

{ TBasedOnVclZeosPersonnelOrderControlGroupsAdminPrivilegeServicesFactory }

constructor TBasedOnVclZeosPersonnelOrderControlGroupsAdminPrivilegeServicesFactory.Create(
  const DocumentFlowAdminPrivilege: TDocumentFlowAdminPrivilege;
  ZConnection: TZConnection);
begin

  inherited Create(DocumentFlowAdminPrivilege);

  FZConnection := ZConnection;

end;

function TBasedOnVclZeosPersonnelOrderControlGroupsAdminPrivilegeServicesFactory
  .CreateDocumentFlowAdminPrivilegeServices: TDocumentFlowAdminPrivilegeServices;
begin

  Result :=
    TPersonnelOrderControlGroupsAdminPrivilegeServices.Create(
      FPrivilegeId,
      FWorkingPrivilegeId,
      TBasedOnVclZeosPersonnelOrderControlGroupsControlService.Create(
        FZConnection
      )
    );

end;

end.
