unit SendingDocumentToSigningService;

interface

uses

  ApplicationService;
  
type

  ISendingDocumentToSigningService = interface (IApplicationService)

    procedure SendDocumentToSigning(
      const DocumentId: Variant;
      const SendingEmployeeId: Variant
    ); overload;
    
    procedure SendDocumentToSigning(
      const DocumentId: Variant;
      const SendingEmployeeId: Variant;
      const SigningEmployeeId: Variant
    ); overload;

  end;

implementation

end.
