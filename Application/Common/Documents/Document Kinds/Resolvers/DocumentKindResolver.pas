unit DocumentKindResolver;

interface

uses

  DocumentKinds;

type

  IDocumentKindResolver = interface

    function ResolveIdForDocumentKind(
      DocumentKind: TDocumentKindClass
    ): Variant;

    function ResovleDocumentKindById(
      const DocumentKindId: Variant
    ): TDocumentKindClass;
    
  end;

implementation

end.
