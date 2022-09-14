unit GlobalDocumentKindsReadService;

interface

uses

  ApplicationService,
  GlobalDocumentKindDto,
  SysUtils;

type

  TGlobalDocumentKindsReadServiceException = class (TApplicationServiceException)

  end;
  
  IGlobalDocumentKindsReadService = interface (IApplicationService)

    function GetGlobalDocumentKindDtos(const ClientId: Variant): TGlobalDocumentKindDtos;
    
  end;


implementation

end.
