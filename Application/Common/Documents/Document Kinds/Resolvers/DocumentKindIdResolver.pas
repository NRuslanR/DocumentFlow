unit DocumentKindIdResolver;

interface

uses

  DocumentKinds;

type

  IDocumentKindIdResolver = interface

    function ResolveIdForDocumentKind(
      DocumentKind: TDocumentKindClass
    ): Variant;

    function ResolveIdForDocumentKindAsApproveable(
      DocumentKind: TDocumentKindClass
    ): Variant;

  end;

implementation

end.
