unit BasedOnRepositoryDocumentChargeSheetFinder;

interface

uses

  DocumentChargeSheet,
  AbstractDocumentChargeSheetFinder,
  DocumentChargeSheetRepository,
  DocumentChargeSheetWorkingRules,
  VariantListUnit,
  IDocumentChargeSheetUnit,
  IDocumentUnit,
  SysUtils,
  Classes;

type

  TBasedOnRepositoryDocumentChargeSheetFinder =
    class (TAbstractDocumentChargeSheetFinder)

      protected

        FDocumentChargeSheetRepository: IDocumentChargeSheetRepository;

        function InternalFindAllSubordinateChargeSheetsFor(
          ChargeSheet: IDocumentChargeSheet
        ): TDocumentChargeSheets; override;

        function InternalFindAllChargeSheetsForDocument(
          Document: IDocument
        ): TDocumentChargeSheets; override;

        function InternalFindDocumentChargeSheetById(
          const DocumentChargeSheetId: Variant
        ): IDocumentChargeSheet; override;

        function InternalFindDocumentChargeSheetsByIds(
          ChargeSheetIds: TVariantList
        ): TDocumentChargeSheets; override;

        function InternalFindDocumentChargeSheetsForPerformer(
          const DocumentId: Variant;
          const PerformerId: Variant
        ): TDocumentChargeSheets; override;

        function InternalFindOwnAndSubordinateDocumentChargeSheetsForPerformer(
          const DocumentId: Variant;
          const PerformerId: Variant
        ): TDocumentChargeSheets; override;

      public

        constructor Create(
          DocumentChargeSheetRepository: IDocumentChargeSheetRepository
        );

        function AreChargeSheetsExistsForDocument(
          Document: IDocument
        ): Boolean; override;
        
    end;

implementation
  
{ TBasedOnRepositoryDocumentChargeSheetFinder }

constructor TBasedOnRepositoryDocumentChargeSheetFinder.Create(
  DocumentChargeSheetRepository: IDocumentChargeSheetRepository
);
begin

  FDocumentChargeSheetRepository := DocumentChargeSheetRepository;
  
end;

function TBasedOnRepositoryDocumentChargeSheetFinder.
  InternalFindAllChargeSheetsForDocument(
    Document: IDocument
  ): TDocumentChargeSheets;
begin

  Result :=
    FDocumentChargeSheetRepository.FindAllChargeSheetsForDocument(
      Document.Identity
    );

end;

function TBasedOnRepositoryDocumentChargeSheetFinder.AreChargeSheetsExistsForDocument(
  Document: IDocument): Boolean;
begin

  Result :=
    FDocumentChargeSheetRepository.AreChargeSheetsExistsForDocument(
      Document.Identity
    );

end;

function TBasedOnRepositoryDocumentChargeSheetFinder.
  InternalFindAllSubordinateChargeSheetsFor(
    ChargeSheet: IDocumentChargeSheet
  ): TDocumentChargeSheets;
begin

  Result :=
    FDocumentChargeSheetRepository.
      FindAllSubordinateChargeSheetsForGivenChargeSheet(ChargeSheet.Identity);
    
end;

function TBasedOnRepositoryDocumentChargeSheetFinder.InternalFindDocumentChargeSheetById(
  const DocumentChargeSheetId: Variant
): IDocumentChargeSheet;
begin

  Result :=
    FDocumentChargeSheetRepository.FindDocumentChargeSheetById(
      DocumentChargeSheetId
    );

end;

function TBasedOnRepositoryDocumentChargeSheetFinder.InternalFindDocumentChargeSheetsByIds(
  ChargeSheetIds: TVariantList): TDocumentChargeSheets;
begin

  Result :=
    FDocumentChargeSheetRepository
      .FindDocumentChargeSheetsByIds(ChargeSheetIds);
      
end;

function TBasedOnRepositoryDocumentChargeSheetFinder.
  InternalFindDocumentChargeSheetsForPerformer(
    const DocumentId, PerformerId: Variant
  ): TDocumentChargeSheets;
begin

  Result :=
    FDocumentChargeSheetRepository
      .FindDocumentChargeSheetsForPerformer(DocumentId, PerformerId);

end;

function TBasedOnRepositoryDocumentChargeSheetFinder.
  InternalFindOwnAndSubordinateDocumentChargeSheetsForPerformer(
    const DocumentId, PerformerId: Variant
  ): TDocumentChargeSheets;
begin

  Result :=
    FDocumentChargeSheetRepository
      .FindOwnAndSubordinateDocumentChargeSheetsForPerformer(
        DocumentId, PerformerId
      );
      
end;

end.
