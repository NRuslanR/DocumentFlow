unit StandardDocumentPerformingService;

interface

uses

  DocumentPerformingService,
  DocumentChargeSheet,
  IDocumentChargeSheetUnit,
  Document,
  Employee,
  SysUtils;

type

  TStandardDocumentPerformingService =
    class (TInterfacedObject, IDocumentPerformingService)

      public

        procedure PerformDocument(
          Document: TDocument;
          DocumentChargeSheet: IDocumentChargeSheet
        );
      
    end;

implementation

procedure TStandardDocumentPerformingService.PerformDocument(
  Document: TDocument;
  DocumentChargeSheet: IDocumentChargeSheet
);
begin

  Document.PerformCharge(DocumentChargeSheet.Charge);

end;

end.
