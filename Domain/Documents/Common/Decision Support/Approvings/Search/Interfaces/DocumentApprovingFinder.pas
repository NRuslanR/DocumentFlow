unit DocumentApprovingFinder;

interface

uses

  SysUtils,
  DocumentApprovings,
  DomainException;

type

  TDocumentApprovingFinderException = class (TDomainException)

  end;
  
  IDocumentApprovingFinder = interface

    function FindAllApprovingsForDocument(const DocumentId: Variant): TDocumentApprovings;

  end;

implementation

end.
