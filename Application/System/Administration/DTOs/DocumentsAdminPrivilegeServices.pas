unit DocumentsAdminPrivilegeServices;

interface

uses

  DocumentFlowAdminPrivilegeServices,
  AdminDocumentSetReadService,
  SysUtils;

type

  TDocumentsAdminPrivilegeServices = class (TDocumentFlowAdminPrivilegeServices)

    public

      DocumentSetReadService: IAdminDocumentSetReadService;

      constructor Create(
        const PrivilegeId: Variant;
        const WorkingPrivilegeId: Variant;
        DocumentSetReadService: IAdminDocumentSetReadService
      );

  end;

  
implementation

{ TDocumentsAdminPrivilegeServices }

constructor TDocumentsAdminPrivilegeServices.Create(
  const PrivilegeId, WorkingPrivilegeId: Variant;
  DocumentSetReadService: IAdminDocumentSetReadService
);
begin

  inherited Create(PrivilegeId, WorkingPrivilegeId);

  Self.DocumentSetReadService := DocumentSetReadService;
  
end;

end.
