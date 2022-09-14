unit DocumentKindWorkCycleInfoAppService;

interface

uses

  DocumentKindWorkCycleInfoDto,
  DocumentKinds,
  ApplicationService;

type

  IDocumentKindWorkCycleInfoAppService = interface (IApplicationService)

    function GetDocumentKindWorkCycleInfo(
      const DocumentKind: TDocumentKindClass
    ): TDocumentKindWorkCycleInfoDto;

    function GetDocumentKindWorkCycleInfos(
      const DocumentKinds:  array of TDocumentKindClass
    ): TDocumentKindWorkCycleInfoDtos;

    function GetAllDocumentKindWorkCycleInfos: TDocumentKindWorkCycleInfoDtos;

  end;

implementation

end.
