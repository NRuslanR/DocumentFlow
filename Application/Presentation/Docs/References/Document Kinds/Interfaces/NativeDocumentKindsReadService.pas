unit NativeDocumentKindsReadService;

interface

uses

  ApplicationService,
  NativeDocumentKindDto,
  SysUtils;

type

  TNativeDocumentKindsReadServiceException = class (TApplicationServiceException)

  end;

  INativeDocumentKindsReadService = interface (IApplicationService)

    function GetNativeDocumentKindDtos: TNativeDocumentKindDtos;
    function GetServicedDocumentKindDtos: TNativeDocumentKindDtos;
    
  end;

implementation

end.
