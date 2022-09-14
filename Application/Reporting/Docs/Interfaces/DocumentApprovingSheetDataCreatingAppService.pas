unit DocumentApprovingSheetDataCreatingAppService;

interface

uses

  DocumentApprovingSheetDataDto,
  ApplicationService,
  SysUtils;

type

  IDocumentApprovingSheetDataCreatingAppService = interface (IApplicationService)

    function CreateDocumentApprovingSheetData(const DocumentId: Variant): TDocumentApprovingSheetDataDto;
    
  end;
  
implementation

end.
