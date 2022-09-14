unit UIDocumentKindResolver;

interface

uses

  UIDocumentKinds,
  SysUtils;

type

  TUIDocumentKindResolverException = class (Exception)

  end;
  
  IUIDocumentKindResolver = interface

    function ResolveUIDocumentKindFromId(
      const DocumentKindId: Variant
    ): TUIDocumentKindClass;

    function ResolveIdForUIDocumentKind(
      UIDocumentKind: TUIDocumentKindClass
    ): Variant;

  end;
  
implementation

end.
