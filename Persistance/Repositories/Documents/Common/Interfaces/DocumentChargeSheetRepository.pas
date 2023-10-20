unit DocumentChargeSheetRepository;

interface

uses

  DocumentChargeSheet,
  IGetSelfUnit,
  VariantListUnit;

type

  IDocumentChargeSheetRepository = interface (IGetSelf)

    function LoadAllDocumentChargeSheets: TDocumentChargeSheets;

    function FindAllChargeSheetsForDocument(
      const DocumentId: Variant
    ): TDocumentChargeSheets;

    function AreChargeSheetsExistsForDocument(
      const DocumentId: Variant
    ): Boolean;
    
    function FindDocumentChargeSheetById(
      const DocumentChargeSheetId: Variant
    ): TDocumentChargeSheet;

    function FindDocumentChargeSheetsByIds(
      const DocumentChargeSheetIds: TVariantList
    ): TDocumentChargeSheets;

    function FindAllSubordinateChargeSheetsForGivenChargeSheet(
      const TargetChargeSheetId: Variant
    ): TDocumentChargeSheets;

    function FindDocumentChargeSheetsForPerformer(
      const DocumentId: Variant;
      const PerformerId: Variant
    ): TDocumentChargeSheets;

    function FindOwnAndSubordinateDocumentChargeSheetsForPerformer(
      const DocumentId: Variant;
      const PerformerId: Variant
    ): TDocumentChargeSheets;

    procedure AddDocumentChargeSheet(
      DocumentChargeSheet: TDocumentChargeSheet
    );

    procedure AddDocumentChargeSheets(
      DocumentChargeSheets: TDocumentChargeSheets
    );

    procedure UpdateDocumentChargeSheet(
      DocumentChargeSheet: TDocumentChargeSheet
    );

    procedure UpdateDocumentChargeSheets(
      DocumentChargeSheets: TDocumentChargeSheets
    );

    procedure RemoveDocumentChargeSheet(
      DocumentChargeSheet: TDocumentChargeSheet
    );

    procedure RemoveDocumentChargeSheets(
      DocumentChargeSheets: TDocumentChargeSheets
    );

    procedure RemoveDocumentChargeSheetWithAllSubordinates(
      DocumentChargeSheet: TDocumentChargeSheet
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
