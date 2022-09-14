unit StandardGeneralDocumentChargeSheetAccessRightsService;

interface

uses

  GeneralDocumentChargeSheetAccessRightsService,
  Document,
  Employee,
  DocumentChargeSheet,
  IDocumentChargeSheetUnit,
  GeneralDocumentChargeSheetsUsageEmployeeAccessRightsInfo,
  DocumentChargeKindsControlService,
  EmployeeIsSameAsOrDeputySpecification,
  DocumentChargeSheetFinder,
  SysUtils,
  Classes;

type

  TStandardGeneralDocumentChargeSheetAccessRightsService =
    class (TInterfacedObject, IGeneralDocumentChargeSheetAccessRightsService)

      protected

        FDocumentChargeSheetFinder: IDocumentChargeSheetFinder;
        FDocumentChargeKindsControlService: IDocumentChargeKindsControlService;

        procedure SetDocumentChargeSheetsUsageAccessRights(
          AccessRights: TGeneralDocumentChargeSheetsUsageEmployeeAccessRightsInfo;
          Document: TDocument;
          DocumentChargeSheets: IDocumentChargeSheets;
          Employee: TEmployee
        ); virtual;

        function FindAllChargeSheetsForDocument(Document: TDocument): TDocumentChargeSheets; virtual;

      public

        constructor Create(
          DocumentChargeSheetFinder: IDocumentChargeSheetFinder;
          DocumentChargeKindsControlService: IDocumentChargeKindsControlService
        );
        
        function GetDocumentChargeSheetsUsageAccessRights(
          Document: TDocument;
          Employee: TEmployee
        ): TGeneralDocumentChargeSheetsUsageEmployeeAccessRightsInfo;

    end;

implementation

uses

  AuxDebugFunctionsUnit,
  VariantFunctions,
  DocumentChargeSheetViewingRule;
  
{ TStandardGeneralDocumentChargeSheetAccessRightsService }

constructor TStandardGeneralDocumentChargeSheetAccessRightsService.Create(
  DocumentChargeSheetFinder: IDocumentChargeSheetFinder;
  DocumentChargeKindsControlService: IDocumentChargeKindsControlService
);
begin

  inherited Create;

  FDocumentChargeSheetFinder := DocumentChargeSheetFinder;
  FDocumentChargeKindsControlService := DocumentChargeKindsControlService;

end;

function TStandardGeneralDocumentChargeSheetAccessRightsService.FindAllChargeSheetsForDocument(
  Document: TDocument): TDocumentChargeSheets;
begin

  Result := FDocumentChargeSheetFinder.FindAllChargeSheetsForDocument(Document);
  
end;

function TStandardGeneralDocumentChargeSheetAccessRightsService
  .GetDocumentChargeSheetsUsageAccessRights(
    Document: TDocument;
    Employee: TEmployee
  ): TGeneralDocumentChargeSheetsUsageEmployeeAccessRightsInfo;
var
    DocumentChargeSheets: IDocumentChargeSheets;
begin

  Result := TGeneralDocumentChargeSheetsUsageEmployeeAccessRightsInfo.Create;

  try

    DocumentChargeSheets := FindAllChargeSheetsForDocument(Document);

    if not Assigned(DocumentChargeSheets) then  Exit;

    SetDocumentChargeSheetsUsageAccessRights(
      Result, Document, DocumentChargeSheets, Employee
    );

  except

    FreeAndNil(Result);

    Raise;

  end;

end;

procedure TStandardGeneralDocumentChargeSheetAccessRightsService.
  SetDocumentChargeSheetsUsageAccessRights(
    AccessRights: TGeneralDocumentChargeSheetsUsageEmployeeAccessRightsInfo;
    Document: TDocument;
    DocumentChargeSheets: IDocumentChargeSheets;
    Employee: TEmployee
  );
var
    ChargeSheet: IDocumentChargeSheet;
    ChargeSheetObj: TDocumentChargeSheet;

    ChargeSheetViewingRuleEnsuringResult: TDocumentChargeSheetViewingRuleEnsuringResult;
begin

  //общие правила для удаления, выдачи, изменения

  for ChargeSheet in TDocumentChargeSheets(DocumentChargeSheets.Self)
  do begin

    ChargeSheetObj := TDocumentChargeSheet(ChargeSheet.Self);

    if
      not AccessRights.AnyChargeSheetsCanBeViewed
      or not AccessRights.AnyChargeSheetsCanBeIssued
    then begin

      ChargeSheetViewingRuleEnsuringResult :=
        ChargeSheetObj
          .WorkingRules
            .DocumentChargeSheetViewingRule.MayEmployeeViewDocumentChargeSheet(
              Employee, ChargeSheetObj, Document
            );

      if not AccessRights.AnyChargeSheetsCanBeViewed then begin

        AccessRights.AnyChargeSheetsCanBeViewed :=
          ChargeSheetViewingRuleEnsuringResult <> EmployeeMayNotViewDocumentChargeSheet;

      end;


      AccessRights.AnyChargeSheetsCanBeIssued :=
        ChargeSheetViewingRuleEnsuringResult
        in [
          EmployeeMayViewDocumentChargeSheetAsIssuer,
          EmployeeMayViewDocumentChargeSheetAsPerformer
        ];

    end;

    if not AccessRights.AnyChargeSheetsCanBeViewed then Continue;

    if
      not AccessRights.AnyChargeSheetsCanBeChanged
      and ChargeSheetObj
            .WorkingRules
              .DocumentChargeSheetChangingRule
                .MayEmployeeChangeDocumentChargeSheet(
                  Employee, ChargeSheetObj, Document, []
                )
    then begin

      AccessRights.AnyChargeSheetsCanBeChanged := True;

    end;

    if
      not AccessRights.AnyChargeSheetsCanBeRemoved
      and ChargeSheetObj
            .WorkingRules
              .DocumentChargeSheetRemovingRule.IsSatisfiedBy(
                Employee, ChargeSheetObj, Document
              )
    then begin

      AccessRights.AnyChargeSheetsCanBeRemoved := True;

    end;
    
    if
      not AccessRights.AnyChargeSheetsCanBePerformed
      and ChargeSheetObj
            .WorkingRules
              .DocumentChargeSheetPerformingRule.IsSatisfiedBy(
                Employee, ChargeSheetObj, Document
              )
    then begin

      AccessRights.AnyChargeSheetsCanBePerformed := True;

    end;

    if AccessRights.AllChargeSheetsAccessRightsAllowed then Break;

  end;
  
  AccessRights.AnyChargeSheetsCanBeIssued :=
    AccessRights.AnyChargeSheetsCanBeIssued
    and (
      AccessRights.AnyChargeSheetsCanBeChanged
      or AccessRights.AnyChargeSheetsCanBePerformed
      or AccessRights.AnyChargeSheetsCanBeRemoved
    );

end;

end.
