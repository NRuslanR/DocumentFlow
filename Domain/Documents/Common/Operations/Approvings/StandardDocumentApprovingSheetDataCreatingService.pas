unit StandardDocumentApprovingSheetDataCreatingService;

interface

uses

  DocumentApprovingSheetDataCreatingService,
  DocumentApprovingSheetData,
  DocumentApprovings,
  DocumentApprovingsPicker,
  DocumentApprovingsCollector,
  SysUtils;

type

  TStandardDocumentApprovingSheetDataCreatingService =
    class (TInterfacedObject, IDocumentApprovingSheetDataCreatingService)

      protected

        FDocumentApprovingsCollector: IDocumentApprovingsCollector;
        FDocumentApprovingsPicker: IDocumentApprovingsPicker;

      public

        constructor Create(
          DocumentApprovingsCollector: IDocumentApprovingsCollector;
          DocumentApprovingsPicker: IDocumentApprovingsPicker
        );

        function CreateDocumentApprovingSheet(
          const DocumentId: Variant
        ): TDocumentApprovingSheetData;
      
    end;
    

implementation

uses

  IDomainObjectBaseUnit,
  IDomainObjectBaseListUnit;
  
{ TStandardDocumentApprovingSheetDataCreatingService }

constructor TStandardDocumentApprovingSheetDataCreatingService.Create(
  DocumentApprovingsCollector: IDocumentApprovingsCollector;
  DocumentApprovingsPicker: IDocumentApprovingsPicker
);
begin

  inherited Create;

  FDocumentApprovingsCollector := DocumentApprovingsCollector;
  FDocumentApprovingsPicker := DocumentApprovingsPicker;

end;

function TStandardDocumentApprovingSheetDataCreatingService.CreateDocumentApprovingSheet(
  const DocumentId: Variant
): TDocumentApprovingSheetData;

var
    DocumentApprovingCollectingResult: TDocumentApprovingCollectingResult;
    Free: IDomainObjectBase;

    PickedDocumentApprovings: TDocumentApprovings;
    FreePickedDocumentApprovings: IDomainObjectBaseList;
begin

  DocumentApprovingCollectingResult :=
    FDocumentApprovingsCollector.CollectDocumentApprovings(DocumentId);

  if not Assigned(DocumentApprovingCollectingResult) then begin
  
    Result := nil;

    Exit;
    
  end;

  Free := DocumentApprovingCollectingResult;

  PickedDocumentApprovings :=
    FDocumentApprovingsPicker.PickDocumentApprovingsFrom(
      DocumentApprovingCollectingResult.CurrentDocumentApprovings,
      DocumentApprovingCollectingResult.DocumentApprovingCycleResults
    );

  FreePickedDocumentApprovings := PickedDocumentApprovings;

  Result := 
    TDocumentApprovingSheetData.Create(
      DocumentApprovingCollectingResult.Document, 
      PickedDocumentApprovings
    );
  
  
end;

end.
