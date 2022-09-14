unit DocumentChargeKindRepository;

interface

uses

  DocumentChargeKind,
  IGetSelfUnit,
  SysUtils;

type

  IDocumentChargeKindRepository = interface (IGetSelf)

    function FindAllDocumentChargeKinds: TDocumentChargeKinds;
    function FindDocumentChargeKindById(const ChargeKindId: Variant): TDocumentChargeKind;
    function FindAllowedDocumentChargeKindsForDocumentKind(const DocumentKindId: Variant): TDocumentChargeKinds;

    procedure AddDocumentChargeKind(DocumentChargeKind: TDocumentChargeKind);
    procedure AddDocumentChargeKinds(DocumentChargeKinds: TDocumentChargeKinds);

    procedure UpdateDocumentChargeKind(DocumentChargeKind: TDocumentChargeKind);
    procedure UpdateDocumentChargeKinds(DocumentChargeKinds: TDocumentChargeKinds);

    procedure RemoveDocumentChargeKind(DocumentChargeKind: TDocumentChargeKind);
    procedure RemoveDocumentChargeKinds(DocumentChargeKinds: TDocumentChargeKinds);

  end;
  
implementation

end.
