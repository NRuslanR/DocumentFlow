unit DocumentInfoReadService;

interface

uses

  ApplicationService,
  DocumentFullInfoDTO;
  
type

  IDocumentInfoReadService = interface (IApplicationService)

    function GetDocumentFullInfo(const DocumentId: Variant): TDocumentFullInfoDTO;
    
  end;
  
implementation

end.
