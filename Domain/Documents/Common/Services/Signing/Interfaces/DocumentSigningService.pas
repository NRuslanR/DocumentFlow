unit DocumentSigningService;

interface

uses

  DomainException,
  Document,
  Employee,
  SysUtils;

type

  TDocumentSigningServiceException = class (TDomainException)

  end;

  IDocumentSigningService = interface

    procedure SignDocument(Document: TDocument; Signer: TEmployee);
    
  end;

implementation

end.
