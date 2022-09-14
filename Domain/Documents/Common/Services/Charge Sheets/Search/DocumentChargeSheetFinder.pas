unit DocumentChargeSheetFinder;

interface

uses

  DomainException,
  IDocumentUnit,
  IDocumentChargeSheetUnit,
  DocumentChargeSheet,
  VariantListUnit,
  IGetSelfUnit;

type

  TDocumentChargeSheetFinderException = class (TDomainException)

  end;
  
  IDocumentChargeSheetFinder = interface (IGetSelf)

    function FindAllSubordinateChargeSheetsFor(
      ChargeSheet: IDocumentChargeSheet
    ): TDocumentChargeSheets;

    function FindAllChargeSheetsForDocument(
      Document: IDocument
    ): TDocumentChargeSheets;

    function AreChargeSheetsExistsForDocument(
      Document: IDocument
    ): Boolean;

    function FindDocumentChargeSheetsForPerformer(
      const DocumentId: Variant;
      const PerformerId: Variant
    ): TDocumentChargeSheets;

    function FindOwnAndSubordinateDocumentChargeSheetsForPerformer(
      const DocumentId: Variant;
      const PerformerId: Variant
    ): TDocumentChargeSheets;

    function FindDocumentChargeSheetById(
      const DocumentChargeSheetId: Variant
    ): IDocumentChargeSheet;

    function FindDocumentChargeSheetsByIds(
      const ChargeSheetIds: TVariantList
    ): TDocumentChargeSheets;

  end;
  
implementation

end.
