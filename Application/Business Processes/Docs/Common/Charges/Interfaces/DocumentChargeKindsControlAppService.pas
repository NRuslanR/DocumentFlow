unit DocumentChargeKindsControlAppService;

interface

uses

  DocumentChargeKindDto,
  ApplicationService,
  SysUtils;

type

  TDocumentChargeKindsControlAppServiceException = class (TApplicationServiceException)

  end;
  
  IDocumentChargeKindsControlAppService = interface (IApplicationService)

    function FindMainDocumentChargeKindForDocumentKind(const DocumentKindId: Variant): TDocumentChargeKindDto;
    function FindAllowedDocumentChargeKindsForDocumentKind(const DocumentKindId: Variant): TDocumentChargeKindDtos;

  end;

implementation

end.
