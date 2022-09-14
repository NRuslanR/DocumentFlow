unit AbstractDocumentChargeSheetFinder;

interface

uses

  DocumentChargeSheetFinder,
  IDocumentChargeSheetUnit,
  DocumentChargeSheet,
  IDocumentUnit,
  DocumentChargeSheetWorkingRules,
  VariantListUnit;

type

  TAbstractDocumentChargeSheetFinder =
    class abstract (TInterfacedObject, IDocumentChargeSheetFinder)

      protected

        function InternalFindAllSubordinateChargeSheetsFor(
          ChargeSheet: IDocumentChargeSheet
        ): TDocumentChargeSheets; virtual; abstract;

        function InternalFindAllChargeSheetsForDocument(
          Document: IDocument
        ): TDocumentChargeSheets; virtual; abstract;

        function InternalFindDocumentChargeSheetById(
          const DocumentChargeSheetId: Variant
        ): IDocumentChargeSheet; virtual; abstract;

        function InternalFindDocumentChargeSheetsByIds(
          ChargeSheetIds: TVariantList
        ): TDocumentChargeSheets; virtual; abstract;

        function InternalFindDocumentChargeSheetsForPerformer(
          const DocumentId: Variant;
          const PerformerId: Variant
        ): TDocumentChargeSheets; virtual; abstract;

        function InternalFindOwnAndSubordinateDocumentChargeSheetsForPerformer(
          const DocumentId: Variant;
          const PerformerId: Variant
        ): TDocumentChargeSheets; virtual; abstract;

      protected

        procedure AssignWorkingRulesToDocumentChargeSheets(
          DocumentChargeSheets: TDocumentChargeSheets
        );

        procedure AssignWorkingRulesToDocumentChargeSheet(
          DocumentChargeSheet: IDocumentChargeSheet
        );
        
      public

        constructor Create; virtual;

        function FindAllSubordinateChargeSheetsFor(
          ChargeSheet: IDocumentChargeSheet
        ): TDocumentChargeSheets;

        function FindAllChargeSheetsForDocument(
          Document: IDocument
        ): TDocumentChargeSheets;

        function AreChargeSheetsExistsForDocument(
          Document: IDocument
        ): Boolean; virtual; abstract;

        function FindDocumentChargeSheetById(
          const DocumentChargeSheetId: Variant
        ): IDocumentChargeSheet;

        function FindDocumentChargeSheetsByIds(
          const ChargeSheetIds: TVariantList
        ): TDocumentChargeSheets;

        function FindDocumentChargeSheetsForPerformer(
          const DocumentId: Variant;
          const PerformerId: Variant
        ): TDocumentChargeSheets;

        function FindOwnAndSubordinateDocumentChargeSheetsForPerformer(
          const DocumentId: Variant;
          const PerformerId: Variant
        ): TDocumentChargeSheets;

        function GetSelf: TObject;

    end;

implementation

uses

  DomainRegistries, DocumentsDomainRegistries, DocumentRuleRegistry,
  DocumentChargeSheetRuleRegistry;
  
{ TAbstractDocumentChargeSheetFinder }

function TAbstractDocumentChargeSheetFinder.FindAllChargeSheetsForDocument(
  Document: IDocument): TDocumentChargeSheets;
begin

  Result :=
    InternalFindAllChargeSheetsForDocument(Document);

  AssignWorkingRulesToDocumentChargeSheets(Result);
  
end;

function TAbstractDocumentChargeSheetFinder.FindAllSubordinateChargeSheetsFor(
  ChargeSheet: IDocumentChargeSheet): TDocumentChargeSheets;
begin

  Result :=
    InternalFindAllSubordinateChargeSheetsFor(ChargeSheet);

  if Assigned(Result) then
    AssignWorkingRulesToDocumentChargeSheets(Result);

end;

function TAbstractDocumentChargeSheetFinder.FindDocumentChargeSheetById(
  const DocumentChargeSheetId: Variant
): IDocumentChargeSheet;
begin

  Result := InternalFindDocumentChargeSheetById(DocumentChargeSheetId);

  if Assigned(Result) then
    AssignWorkingRulesToDocumentChargeSheet(Result);
    
end;

function TAbstractDocumentChargeSheetFinder.FindDocumentChargeSheetsByIds(
  const ChargeSheetIds: TVariantList): TDocumentChargeSheets;
begin

  Result := InternalFindDocumentChargeSheetsByIds(ChargeSheetIds);

  if Assigned(Result) then
    AssignWorkingRulesToDocumentChargeSheets(Result);

end;

function TAbstractDocumentChargeSheetFinder.FindDocumentChargeSheetsForPerformer(
  const DocumentId, PerformerId: Variant
): TDocumentChargeSheets;
begin

  Result := InternalFindDocumentChargeSheetsForPerformer(DocumentId, PerformerId);

  if Assigned(Result) then
    AssignWorkingRulesToDocumentChargeSheets(Result);
    
end;

function TAbstractDocumentChargeSheetFinder.FindOwnAndSubordinateDocumentChargeSheetsForPerformer(
  const DocumentId, PerformerId: Variant
): TDocumentChargeSheets;
begin

  Result := InternalFindOwnAndSubordinateDocumentChargeSheetsForPerformer(DocumentId, PerformerId);

  if Assigned(Result) then
    AssignWorkingRulesToDocumentChargeSheets(Result);
    
end;

procedure TAbstractDocumentChargeSheetFinder.AssignWorkingRulesToDocumentChargeSheet(
  DocumentChargeSheet: IDocumentChargeSheet
);
var
    ChargeSheetObj: TDocumentChargeSheet;
begin

  ChargeSheetObj := TDocumentChargeSheet(DocumentChargeSheet.Self);

  ChargeSheetObj
    .WorkingRules :=
      TDomainRegistries
        .DocumentsDomainRegistries
          .RuleRegistry
            .ChargeSheetRuleRegistry
              .GetDocumentChargeSheetWorkingRules(
                ChargeSheetObj.ClassType
              );

end;

procedure TAbstractDocumentChargeSheetFinder.AssignWorkingRulesToDocumentChargeSheets(
  DocumentChargeSheets: TDocumentChargeSheets
);
var
    DocumentChargeSheet: IDocumentChargeSheet;
begin

  if not Assigned(DocumentChargeSheets) then Exit;
  
  for DocumentChargeSheet in DocumentChargeSheets do
    AssignWorkingRulesToDocumentChargeSheet(DocumentChargeSheet);

end;

constructor TAbstractDocumentChargeSheetFinder.Create;
begin

  inherited;
  
end;

function TAbstractDocumentChargeSheetFinder.GetSelf: TObject;
begin

  Result := Self;
  
end;

end.
