unit StandardDocumentPerformingService;

interface

uses

  DocumentPerformingService,
  DocumentChargeSheet,
  IDocumentChargeSheetUnit,
  DocumentFinder,
  Document,
  IDocumentUnit,
  Employee,
  SysUtils;

type

  TStandardDocumentPerformingService =
    class (TInterfacedObject, IDocumentPerformingService)

      private

        FDocumentFinder: IDocumentFinder;

        function CreateChargeSheetsFrom(
          ChargeSheet: IDocumentChargeSheet
        ): TDocumentChargeSheets;

      public

        constructor Create(DocumentFinder: IDocumentFinder);
        
        procedure PerformDocument(
          Document: IDocument;
          DocumentChargeSheet: IDocumentChargeSheet
        ); overload;

        function PerformDocument(
          const DocumentId: Variant;
          DocumentChargeSheet: IDocumentChargeSheet
        ): IDocument; overload;

        procedure PerformDocument(
          Document: IDocument;
          DocumentChargeSheets: TDocumentChargeSheets
        ); overload;

        function PerformDocument(
          const DocumentId: Variant;
          DocumentChargeSheets: TDocumentChargeSheets
        ): IDocument; overload;

    end;

implementation

constructor TStandardDocumentPerformingService.Create(
  DocumentFinder: IDocumentFinder);
begin

  inherited Create;

  FDocumentFinder := DocumentFinder;
  
end;

function TStandardDocumentPerformingService.PerformDocument(
  const DocumentId: Variant;
  DocumentChargeSheet: IDocumentChargeSheet
): IDocument;
var
    ChargeSheets: TDocumentChargeSheets;
    Free: IDocumentChargeSheets;
begin

  ChargeSheets := CreateChargeSheetsFrom(DocumentChargeSheet);

  Free := ChargeSheets;
  
  Result := PerformDocument(DocumentId, ChargeSheets);

end;

procedure TStandardDocumentPerformingService.PerformDocument(
  Document: IDocument;
  DocumentChargeSheet: IDocumentChargeSheet
);
var
    ChargeSheets: TDocumentChargeSheets;
    Free: IDocumentChargeSheets;
begin

  ChargeSheets := CreateChargeSheetsFrom(DocumentChargeSheet);

  Free := ChargeSheets;

  PerformDocument(Document, ChargeSheets);

end;

function TStandardDocumentPerformingService
  .CreateChargeSheetsFrom(
    ChargeSheet: IDocumentChargeSheet
  ): TDocumentChargeSheets;
begin

  Result := TDocumentChargeSheets.Create;

  Result.AddDocumentChargeSheet(ChargeSheet);

end;

function TStandardDocumentPerformingService.PerformDocument(
  const DocumentId: Variant;
  DocumentChargeSheets: TDocumentChargeSheets
): IDocument;
begin

  Result := FDocumentFinder.FindDocumentById(DocumentId);

  if not Assigned(Result) then begin

    Raise TDocumentPerformingServiceException.Create(
      'Не найден документ для исполнения'
    );

  end;

  PerformDocument(Result, DocumentChargeSheets);
  
end;

procedure TStandardDocumentPerformingService.PerformDocument(
  Document: IDocument;
  DocumentChargeSheets: TDocumentChargeSheets
);
var
    ChargeSheet: IDocumentChargeSheet;
begin
                            
  for ChargeSheet in DocumentChargeSheets do
    Document.PerformCharge(ChargeSheet.Charge);
    
end;

end.
