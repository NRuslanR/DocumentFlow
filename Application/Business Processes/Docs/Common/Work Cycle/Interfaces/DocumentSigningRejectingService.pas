unit DocumentSigningRejectingService;

interface

uses

  ApplicationService;

type

  IDocumentSigningRejectingService = interface (IApplicationService)

    procedure RejectSigningDocument(
      const DocumentId: Variant;
      const RejectingSigningEmployeeId: Variant
    );

  end;

implementation

end.
