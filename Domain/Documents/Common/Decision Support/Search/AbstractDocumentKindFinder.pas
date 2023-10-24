unit AbstractDocumentKindFinder;

interface

uses

  DocumentKind,
  Document,
  VariantListUnit,
  DocumentKindFinder,
  SysUtils,
  Classes;

type

  TAbstractDocumentKindFinder = class abstract (TInterfacedObject, IDocumentKindFinder)

    public

      function LoadAllDocumentKinds: TDocumentKinds; virtual; abstract;
      function FindDocumentKindByClassType(DocumentType: TDocumentClass): TDocumentKind; virtual;
      function FindDocumentKindByServiceName(const ServiceName: String): TDocumentKind; virtual; abstract;
      function FindDocumentKindByIdentity(const DocumentKindIdentity: Variant): TDocumentKind; virtual; abstract;
      function FindDocumentKindsByIdentities(const Identities: TVariantList): TDocumentKinds; virtual; abstract;

  end;

implementation

uses

  IDomainObjectBaseListUnit;
  
{ TAbstractDocumentKindFinder }

function TAbstractDocumentKindFinder.FindDocumentKindByClassType(
  DocumentType: TDocumentClass
): TDocumentKind;
var
    DocumentKinds: TDocumentKinds;
    DocumentKind: TDocumentKind;
    Free: IDomainObjectBaseList;
begin

  DocumentKinds := LoadAllDocumentKinds;

  Free := DocumentKinds;

  for DocumentKind in DocumentKinds do begin
  
    if DocumentKind.DocumentClass = DocumentType then begin

      Result := DocumentKind.Clone as TDocumentKind;
      Exit;

    end;

  end;

  Result := nil;

end;

end.
