unit DocumentApprovingListCreatingAppService;

interface

uses

  DocumentApprovingListCreatingService,
  ApplicationService,
  DocumentApprovingListDTO,
  SysUtils,
  Classes;

type

  IDocumentApprovingListCreatingAppService = interface (IApplicationService)
  
    function CreateDocumentApprovingListsForDocument(
      const DocumentId: Variant
    ): TDocumentApprovingListDTOs;

  end;

implementation

end.
