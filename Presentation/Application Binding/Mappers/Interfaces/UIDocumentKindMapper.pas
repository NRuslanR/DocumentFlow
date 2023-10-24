unit UIDocumentKindMapper;

interface

uses

  DocumentKinds,
  UIDocumentKinds,
  SysUtils;

type

  IUIDocumentKindMapper = interface

    function MapDocumentKindFrom(
      UIDocumentKind: TUIDocumentKindClass
    ): TDocumentKindClass;

    function MapUIDocumentKindFrom(
      DocumentKind: TDocumentKindClass
    ): TUIDocumentKindClass;

  end;

implementation

end.
