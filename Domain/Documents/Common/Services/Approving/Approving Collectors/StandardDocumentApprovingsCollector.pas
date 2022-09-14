unit StandardDocumentApprovingsCollector;

interface

uses

  Document,
  DocumentApprovings,
  IDocumentUnit,
  DocumentApprovingCycleResult,
  DocumentApprovingsCollector,
  DocumentFinder,
  DocumentApprovingCycleResultFinder,
  IDomainObjectBaseUnit,
  IDomainObjectBaseListUnit,
  SysUtils;

type

  TStandardDocumentApprovingsCollector =
    class (TInterfacedObject, IDocumentApprovingsCollector)

      protected

        FDocumentFinder: IDocumentFinder;
        FDocumentApprovingCycleResultFinder: IDocumentApprovingCycleResultFinder;

      public

        constructor Create(
          DocumentFinder: IDocumentFinder;
          DocumentApprovingCycleResultFinder: IDocumentApprovingCycleResultFinder
        );

        function CollectDocumentApprovings(
          const DocumentId: Variant
        ): TDocumentApprovingCollectingResult;
        
    end;

implementation

{ TStandardDocumentApprovingsCollector }

function TStandardDocumentApprovingsCollector.CollectDocumentApprovings(
  const DocumentId: Variant): TDocumentApprovingCollectingResult;
var

    Document: IDocument;
    
    DocumentApprovingCycleResults: TDocumentApprovingCycleResults;
    FreeDocumentApprovingCycleResults: IDomainObjectBaseList;

    CurrentDocumentApprovings: TDocumentApprovings;

    PickedDocumentApprovings: TDocumentApprovings;
    DocumentApproving: TDocumentApproving;
begin

  Document := FDocumentFinder.FindDocumentById(DocumentId);

  if not Assigned(Document) then begin

    raise TDocumentApprovingsCollectorException.Create(
      'Не найден документ для сбора данных ' +
      'по согласованиям'
    );

  end;

  DocumentApprovingCycleResults :=
    FDocumentApprovingCycleResultFinder
      .FindAllApprovingCycleResultsForDocument(DocumentId);

  FreeDocumentApprovingCycleResults := DocumentApprovingCycleResults;
  
  CurrentDocumentApprovings := Document.Approvings;

  {
  if
    not Assigned(DocumentApprovingCycleResults) and
    not (
      Assigned(CurrentDocumentApprovings) and
      Document.IsApproving
    )
  then
    Result := nil

  else begin

    Result :=
      TDocumentApprovingCollectingResult.Create(
        Document,
        CurrentDocumentApprovings,
        DocumentApprovingCycleResults
      );

  end;
            }
  Result :=
    TDocumentApprovingCollectingResult.Create(
      Document,
      CurrentDocumentApprovings,
      DocumentApprovingCycleResults
    );

end;

constructor TStandardDocumentApprovingsCollector.Create(
  DocumentFinder: IDocumentFinder;
  DocumentApprovingCycleResultFinder: IDocumentApprovingCycleResultFinder);
begin

  inherited Create;

  FDocumentFinder := DocumentFinder;
  FDocumentApprovingCycleResultFinder := DocumentApprovingCycleResultFinder;

end;

end.
