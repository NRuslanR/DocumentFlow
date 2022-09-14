unit AbstractDocumentChargeSheetDirectory;

interface

uses

  Document,
  DocumentChargeSheetFinder,
  IDocumentChargeSheetUnit,
  DocumentChargeSheetDirectory,
  DocumentChargeSheet,
  VariantListUnit,
  SysUtils;

type

  TAbstractDocumentChargeSheetDirectory =
    class (TInterfacedObject, IDocumentChargeSheetDirectory)

      protected

        FDocumentChargeSheetFinder: IDocumentChargeSheetFinder;
        
      public

        constructor Create(DocumentChargeSheetFinder: IDocumentChargeSheetFinder);

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
        ); virtual; abstract;

        procedure PutDocumentChargeSheets(
          DocumentChargeSheets: TDocumentChargeSheets
        ); virtual; abstract;

        procedure ModifyDocumentChargeSheet(
          DocumentChargeSheet: IDocumentChargeSheet
        ); virtual; abstract;

        procedure ModifyDocumentChargeSheets(
          DocumentChargeSheets: TDocumentChargeSheets
        ); virtual; abstract;

        procedure RemoveDocumentChargeSheet(
          DocumentChargeSheet: IDocumentChargeSheet
        ); virtual; abstract;

        procedure RemoveDocumentChargeSheets(
          DocumentChargeSheets: TDocumentChargeSheets
        ); virtual; abstract;

        procedure RemoveDocumentChargeSheetWithAllSubordinates(
          DocumentChargeSheet: IDocumentChargeSheet
        ); virtual; abstract;

        procedure RemoveDocumentChargeSheetsWithAllSubordinates(
          DocumentChargeSheets: TDocumentChargeSheets
        ); virtual; abstract;

        procedure RemoveAllChargeSheetsForDocument(
          const DocumentId: Variant
        ); virtual; abstract;

    end;

implementation

constructor TAbstractDocumentChargeSheetDirectory.Create(
  DocumentChargeSheetFinder: IDocumentChargeSheetFinder
);
begin

  inherited Create;

  FDocumentChargeSheetFinder := DocumentChargeSheetFinder;
    
end;

function TAbstractDocumentChargeSheetDirectory.FindAllChargeSheetsForDocument(
  Document: TDocument): TDocumentChargeSheets;
begin

  Result :=
    FDocumentChargeSheetFinder.FindAllChargeSheetsForDocument(Document);

end;

function TAbstractDocumentChargeSheetDirectory.AreChargeSheetsExistsForDocument(
  Document: TDocument): Boolean;
begin

  Result :=
    FDocumentChargeSheetFinder.AreChargeSheetsExistsForDocument(Document);

end;

function TAbstractDocumentChargeSheetDirectory.FindAllSubordinateChargeSheetsFor(
  ChargeSheet: IDocumentChargeSheet): TDocumentChargeSheets;
begin

  Result :=
    FDocumentChargeSheetFinder.FindAllSubordinateChargeSheetsFor(ChargeSheet);
    
end;

function TAbstractDocumentChargeSheetDirectory.FindDocumentChargeSheetById(
  const DocumentChargeSheetId: Variant): IDocumentChargeSheet;
begin

  Result :=
    FDocumentChargeSheetFinder.FindDocumentChargeSheetById(DocumentChargeSheetId);
    
end;

function TAbstractDocumentChargeSheetDirectory.FindDocumentChargeSheetsByIds(
  const ChargeSheetIds: TVariantList): TDocumentChargeSheets;
begin

  Result :=
    FDocumentChargeSheetFinder.FindDocumentChargeSheetsByIds(ChargeSheetIds)
    
end;

function TAbstractDocumentChargeSheetDirectory.FindDocumentChargeSheetsForPerformer(
  const DocumentId, PerformerId: Variant): TDocumentChargeSheets;
begin

  Result :=
    FDocumentChargeSheetFinder.FindDocumentChargeSheetsForPerformer(
      DocumentId, PerformerId
    );
    
end;

function TAbstractDocumentChargeSheetDirectory.
  FindOwnAndSubordinateDocumentChargeSheetsForPerformer(
    const DocumentId, PerformerId: Variant
  ): TDocumentChargeSheets;
begin

  Result :=
    FDocumentChargeSheetFinder.FindOwnAndSubordinateDocumentChargeSheetsForPerformer(
      DocumentId, PerformerId
    );

end;

end.
