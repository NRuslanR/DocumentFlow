unit DocumentInfoReadService;

interface

uses

  ApplicationService,
  DocumentFullInfoDTO;
  
type

  TDocumentInfoReadServiceException = class (TApplicationServiceException)

  end;
  
  IDocumentInfoReadService = interface (IApplicationService)

    function GetDocumentFullInfo(const DocumentId: Variant): TDocumentFullInfoDTO;
    
  end;
  
implementation

end.
