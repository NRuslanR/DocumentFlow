unit StandardDocumentKindReferenceFinder;

interface

uses

  DocumentKindReference,
  DocumentKindReferenceFinder,
  SysUtils,
  Classes;

type

  TStandardDocumentKindReference = class (TInterfacedObject, IDocumentKindReferenceFinder)

    public

      function FindDocumentKindReference: TDocumentKindReference; virtual;

  end;

implementation

{ TStandardDocumentKindReference }

function TStandardDocumentKindReference.FindDocumentKindReference: TDocumentKindReference;
begin

end;

end.
