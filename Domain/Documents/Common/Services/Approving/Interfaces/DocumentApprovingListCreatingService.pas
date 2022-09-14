unit DocumentApprovingListCreatingService;

interface

uses

  SysUtils,
  DocumentApprovingList,
  DomainException,
  Classes;

type

  TDocumentApprovingListCreatingServiceException = class (TDomainException)
  
  end;

  IDocumentApprovingListCreatingService = interface

    function CreateDocumentApprovingLists(const DocumentId: Variant): TDocumentApprovingLists;
    
  end;
  
implementation

end.
