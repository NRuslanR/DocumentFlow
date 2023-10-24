unit DocumentKindFinder;

interface

uses

  VariantListUnit,
  Document,
  DocumentKind;
  
type

  IDocumentKindFinder = interface
    ['{975C46FC-20D4-44C4-879B-1225DD417F0F}']

    function LoadAllDocumentKinds: TDocumentKinds;
    function FindDocumentKindByServiceName(const ServiceName: String): TDocumentKind;
    function FindDocumentKindByClassType(DocumentType: TDocumentClass): TDocumentKind;
    function FindDocumentKindByIdentity(const DocumentKindIdentity: Variant): TDocumentKind;
    function FindDocumentKindsByIdentities(const Identities: TVariantList): TDocumentKinds;
    
  end;

implementation

end.
