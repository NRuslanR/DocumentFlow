unit DocumentApprovingSheetData;

interface

uses

  DomainObjectValueUnit,
  DomainObjectValueListUnit,
  Document,
  DocumentApprovings,
  IDomainObjectBaseUnit,
  IDocumentUnit,
  IDomainObjectBaseListUnit,
  SysUtils;

type

  TDocumentApprovingSheetData = class (TDomainObjectValue)

    protected

      FDocument: IDocument;

      FDocumentApprovings: TDocumentApprovings;
      FFreeDocumentApprovings: IDomainObjectBaseList;

      function GetDocument: IDocument;
      function GetDocumentApprovings: TDocumentApprovings;

      procedure SetDocument(const Value: IDocument);
      procedure SetDocumentApprovings(const Value: TDocumentApprovings);
    
    public

      constructor Create(
        Document: IDocument;
        DocumentApprovings: TDocumentApprovings
      );
      
      property Document: IDocument read GetDocument write SetDocument;

      property DocumentApprovings: TDocumentApprovings
      read GetDocumentApprovings write SetDocumentApprovings;

  end;

implementation


{ TDocumentApprovingSheetData }

constructor TDocumentApprovingSheetData.Create(
  Document: IDocument;
  DocumentApprovings: TDocumentApprovings
);
begin

  inherited Create;

  Self.Document := Document;
  Self.DocumentApprovings := DocumentApprovings;
  
end;

function TDocumentApprovingSheetData.GetDocument: IDocument;
begin

  Result := FDocument;
  
end;

function TDocumentApprovingSheetData.GetDocumentApprovings: TDocumentApprovings;
begin

  Result := FDocumentApprovings;

end;

procedure TDocumentApprovingSheetData.SetDocument(const Value: IDocument);
begin

  FDocument := Value;
  
end;

procedure TDocumentApprovingSheetData.SetDocumentApprovings(
  const Value: TDocumentApprovings);
begin

  FDocumentApprovings := Value;
  FFreeDocumentApprovings := FDocumentApprovings;
  
end;

end.
