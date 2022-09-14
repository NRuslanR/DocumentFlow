unit SendingDocumentToApprovingService;

interface

uses

  ApplicationService;
  
type

  ISendingDocumentToApprovingService = interface (IApplicationService)

    procedure SendDocumentToApproving(
      const DocumentId: Variant;
      const SendingEmployeeId: Variant
    );
    
  end;

implementation

end.
