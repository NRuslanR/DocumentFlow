unit DocumentApprovingRejectingService;

interface

uses

  ApplicationService;
  
type

  IDocumentApprovingRejectingService = interface (IApplicationService)

    procedure RejectApprovingDocument(
      const DocumentId: Variant;
      const RejectingApprovingEmployeeId: Variant
    );
    
  end;

implementation

end.
