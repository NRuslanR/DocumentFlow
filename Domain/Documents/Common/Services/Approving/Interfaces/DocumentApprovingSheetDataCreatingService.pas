unit DocumentApprovingSheetDataCreatingService;

interface

uses

  DocumentApprovingSheetData,
  DomainException;

type

  TDocumentApprovingSheetCreatingServiceException = class (TDomainException)

  end;
  
  IDocumentApprovingSheetDataCreatingService = interface

    function CreateDocumentApprovingSheet(
      const DocumentId: Variant
    ): TDocumentApprovingSheetData;
    
  end;

implementation

end.
