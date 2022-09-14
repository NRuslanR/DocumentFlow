unit DocumentFlowAdministrationService;

interface

uses

  SystemAdministrationService,
  DocumentFlowAdminPrivileges,
  DocumentFlowAdminPrivilegeServices;

type

  TDocumentFlowAdministrationServiceException =
    class (TSystemAdministrationServiceException)

    end;

  IDocumentFlowAdministrationService = interface (ISystemAdministrationService)
    ['{506D8C0B-D51B-485E-9045-A285AB9BAC37}']

    function HasClientDocumentFlowAdministrationPrivileges(
      const ClientIdentity: Variant
    ): Boolean;
    
    function GetAllDocumentFlowAdministrationPrivileges(
      const ClientIdentity: Variant
    ): TDocumentFlowAdminPrivileges;

    function GetDocumentFlowAdministrationPrivilegeServices(
      const ClientIdentity: Variant;
      const PrivilegeIdentity: Variant
    ): TDocumentFlowAdminPrivilegeServices;
    
  end;

implementation

end.
