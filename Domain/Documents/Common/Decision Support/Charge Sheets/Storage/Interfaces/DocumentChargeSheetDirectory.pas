unit DocumentChargeSheetDirectory;

interface

uses

  Document,
  IDocumentChargeSheetUnit,
  DocumentChargeSheet,
  VariantListUnit;

type

  IDocumentChargeSheetDirectory = interface

    function FindAllSubordinateChargeSheetsFor(
      ChargeSheet: IDocumentChargeSheet
    ): TDocumentChargeSheets;

    function FindAllChargeSheetsForDocument(
      Document: TDocument
    ): TDocumentChargeSheets;

    function AreChargeSheetsExistsForDocument(
      Document: TDocument
    ): Boolean;

    function FindDocumentChargeSheetsForPerformer(
      const DocumentId: Variant;
      const PerformerId: Variant
    ): TDocumentChargeSheets;

    function AreDocumentChargeSheetsExistsForPerformer(
      const DocumentId: Variant;
      const PerformerId: Variant
    ): Boolean;

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

    procedure PutDocumentChargeSheet(
      DocumentChargeSheet: IDocumentChargeSheet
    );

    procedure PutDocumentChargeSheets(
      DocumentChargeSheets: TDocumentChargeSheets
    );

    procedure ModifyDocumentChargeSheet(
      DocumentChargeSheet: IDocumentChargeSheet
    );

    procedure ModifyDocumentChargeSheets(
      DocumentChargeSheets: TDocumentChargeSheets
    );

    procedure RemoveDocumentChargeSheet(
      DocumentChargeSheet: IDocumentChargeSheet
    );

    procedure RemoveDocumentChargeSheets(
      DocumentChargeSheets: TDocumentChargeSheets
    );

    procedure RemoveDocumentChargeSheetWithAllSubordinates(
      DocumentChargeSheet: IDocumentChargeSheet
    );

    procedure RemoveDocumentChargeSheetsWithAllSubordinates(
      DocumentChargeSheets: TDocumentChargeSheets
    );

    procedure RemoveAllChargeSheetsForDocument(
      const DocumentId: Variant
    );

  end;
  
implementation

end.
