unit DocumentSigningAppService;

interface

uses

  ApplicationService;

type

  TDocumentSigningAppServiceException = class (TApplicationServiceException)

  end;

  IDocumentSigningAppService = interface (IApplicationService)

    procedure SignDocument(const DocumentId: Variant; const SignerId: Variant);

  end;
  
implementation

end.
