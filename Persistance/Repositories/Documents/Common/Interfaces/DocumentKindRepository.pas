unit DocumentKindRepository;

interface

uses

  DocumentKind,
  Document,
  VariantListUnit;

type

  IDocumentKindRepository = interface

    function LoadAllDocumentKinds: TDocumentKinds;
    function FindDocumentKindByIdentity(const DocumentKindIdentity: Variant): TDocumentKind;
    function FindDocumentKindsByIdentities(const Identities: TVariantList): TDocumentKinds;
    function FindDocumentKindByServiceName(const ServiceName: String): TDocumentKind;
    function FindDocumentKindByClassType(DocumentType: TDocumentClass): TDocumentKind;

  end;
  
implementation

end.
