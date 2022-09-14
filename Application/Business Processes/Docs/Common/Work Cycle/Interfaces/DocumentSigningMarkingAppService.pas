unit DocumentSigningMarkingAppService;

interface

uses

  ApplicationService;

type

  IDocumentSigningMarkingAppService = interface (IApplicationService)

    procedure MarkDocumentAsSigned(
      const DocumentId: Variant;
      const MarkingEmployeeId: Variant;
      const SigningDateTime: TDateTime
    );
    
  end;
  
implementation

end.
