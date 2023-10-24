unit DocumentCreatingService;

interface

uses

  IDocumentUnit,
  Document,
  Employee,
  DomainException;
  
type

  IDocumentCreatingServiceException = class (TDomainException)

  end;

  IDocumentCreatingService = interface

    function CreateDocumentInstanceForEmployee(const Employee: TEmployee): IDocument;
    function CreateDefaultDraftedDocumentForEmployee(const Employee: TEmployee): IDocument;

  end;
  
implementation

end.
