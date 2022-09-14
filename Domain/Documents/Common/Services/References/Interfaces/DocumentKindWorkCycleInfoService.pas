unit DocumentKindWorkCycleInfoService;

interface

uses

  Document,
  DocumentKindWorkCycleInfo,
  DomainException,
  SysUtils;

type

  TDocumentKindWorkCycleInfoServiceException = class (TDomainException)

  end;

  IDocumentKindWorkCycleInfoService = interface

    function GetDocumentKindWorkCycleInfo(
      const DocumentKind: TDocumentClass
    ): TDocumentKindWorkCycleInfo;

    function GetDocumentKindWorkCycleInfos(
      const DocumentKinds:  array of TDocumentClass
    ): TDocumentKindWorkCycleInfos;

    function GetAllDocumentKindWorkCycleInfos: TDocumentKindWorkCycleInfos;

  end;

implementation

end.
