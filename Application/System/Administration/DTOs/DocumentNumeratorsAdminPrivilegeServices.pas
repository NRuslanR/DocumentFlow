unit DocumentNumeratorsAdminPrivilegeServices;

interface

uses

  DocumentFlowAdminPrivilegeServices,
  DocumentNumeratorsAdminReferenceControlService,
  SysUtils;

type

  TDocumentNumeratorsAdminPrivilegeServices = class (TDocumentFlowAdminPrivilegeServices)

    public

      DocumentNumeratorsAdminReferenceControlService: IDocumentNumeratorsAdminReferenceControlService;

      constructor Create(
        const PrivilegeId: Variant;
        const WorkingPrivilegeId: Variant;
        DocumentNumeratorsAdminReferenceControlService: IDocumentNumeratorsAdminReferenceControlService
      );
      
  end;

implementation

{ TDocumentNumeratorsAdminPrivilegeServices }

constructor TDocumentNumeratorsAdminPrivilegeServices.Create(const PrivilegeId,
  WorkingPrivilegeId: Variant;
  DocumentNumeratorsAdminReferenceControlService: IDocumentNumeratorsAdminReferenceControlService);
begin

  inherited Create(PrivilegeId, WorkingPrivilegeId);

  Self.DocumentNumeratorsAdminReferenceControlService := DocumentNumeratorsAdminReferenceControlService;

end;

end.
