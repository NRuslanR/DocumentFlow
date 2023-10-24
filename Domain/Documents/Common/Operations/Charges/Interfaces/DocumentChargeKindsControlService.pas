unit DocumentChargeKindsControlService;

interface

uses

  DocumentChargeKind,
  Document,
  DomainException,
  SysUtils;

type

  TDocumentChargeKindsControlServiceException = class (TDomainException)

  end;
  
  IDocumentChargeKindsControlService = interface

    function GetAllDocumentChargeKinds: TDocumentChargeKinds;
    function FindDocumentChargeKindById(const ChargeKindId: Variant): TDocumentChargeKind;
    function FindMainDocumentChargeKindForDocumentKind(const DocumentKindId: Variant): TDocumentChargeKind;
    function FindAllowedDocumentChargeKindsForDocument(Document: TDocument): TDocumentChargeKinds;
    function FindAllowedDocumentChargeKindsForDocumentKind(const DocumentKindId: Variant): TDocumentChargeKinds;

  end;

implementation

end.
