unit DocumentApprovingsCollector;

interface

uses

  DomainException,
  DomainObjectValueUnit,
  DocumentApprovings,
  IDocumentUnit,
  DocumentApprovingCycleResult,
  IDomainObjectBaseListUnit,
  IDomainObjectBaseUnit,
  Document,
  SysUtils;

type

  TDocumentApprovingCollectingResult = class (TDomainObjectValue)

    protected

      FDocument: IDocument;

      FCurrentDocumentApprovings: TDocumentApprovings;
      FFreeCurrentDocumentApprovings: IDomainObjectBaseList;
      
      FDocumentApprovingCycleResults: TDocumentApprovingCycleResults;
      FFreeDocumentApprovingCycleResults: IDomainObjectBaseList;

      procedure SetDocument(const Value: IDocument);
      
      procedure SetCurrentDocumentApprovings(const Value: TDocumentApprovings);

      procedure SetDocumentApprovingCycleResults(
        const Value: TDocumentApprovingCycleResults
      );

    public

      constructor Create(
        Document: IDocument;
        CurrentDocumentApprovings: TDocumentApprovings;
        DocumentApprovingCycleResults: TDocumentApprovingCycleResults
      );

      property Document: IDocument read FDocument write SetDocument;

      property CurrentDocumentApprovings: TDocumentApprovings
      read FCurrentDocumentApprovings write SetCurrentDocumentApprovings;

      property DocumentApprovingCycleResults: TDocumentApprovingCycleResults
      read FDocumentApprovingCycleResults write SetDocumentApprovingCycleResults;
      
  end;

  TDocumentApprovingsCollectorException = class (TDomainException)

  end;

  IDocumentApprovingsCollector = interface

    function CollectDocumentApprovings(const DocumentId: Variant): TDocumentApprovingCollectingResult;
    
  end;

implementation

{ TDocumentApprovingCollectingResult }

constructor TDocumentApprovingCollectingResult.Create(
  Document: IDocument;
  CurrentDocumentApprovings: TDocumentApprovings;
  DocumentApprovingCycleResults: TDocumentApprovingCycleResults);
begin

  inherited Create;

  Self.Document := Document;
  Self.CurrentDocumentApprovings := CurrentDocumentApprovings;
  Self.DocumentApprovingCycleResults := DocumentApprovingCycleResults;
  
end;

procedure TDocumentApprovingCollectingResult.SetCurrentDocumentApprovings(
  const Value: TDocumentApprovings);
begin

  FCurrentDocumentApprovings := Value;
  FFreeCurrentDocumentApprovings := Value;
  
end;

procedure TDocumentApprovingCollectingResult.SetDocument(
  const Value: IDocument);
begin

  FDocument := Value;
  
end;

procedure TDocumentApprovingCollectingResult.SetDocumentApprovingCycleResults(
  const Value: TDocumentApprovingCycleResults);
begin

  FDocumentApprovingCycleResults := Value;
  FFreeDocumentApprovingCycleResults := FDocumentApprovingCycleResults;
  
end;

end.
