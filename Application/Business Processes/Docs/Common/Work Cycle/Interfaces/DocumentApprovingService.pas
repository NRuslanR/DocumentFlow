unit DocumentApprovingService;

interface

uses

  ApplicationService;
  
type

  IDocumentApprovingService = interface (IApplicationService)

    procedure ApproveDocument(
      const DocumentId: Variant;
      const ApproverId: Variant
    );

  end;
  
implementation

end.
