unit StandardGeneralDocumentChargeSheetAccessRightsService;

interface

uses

  GeneralDocumentChargeSheetAccessRightsService,
  Document,
  Employee,
  DocumentChargeSheet,
  IDocumentChargeSheetUnit,
  GeneralDocumentChargeSheetsUsageEmployeeAccessRightsInfo,
  EmployeeIsSameAsOrDeputySpecification,
  DocumentChargeSheetIssuingAccessRightsService,
  DocumentChargeSheetFinder,
  SysUtils,
  Classes;

type

  TStandardGeneralDocumentChargeSheetAccessRightsService =
    class (TInterfacedObject, IGeneralDocumentChargeSheetAccessRightsService)

      protected

        FDocumentChargeSheetFinder: IDocumentChargeSheetFinder;
        FIssuingAccessRightsService: IDocumentChargeSheetIssuingAccessRightsService;
        
        procedure SetDocumentChargeSheetsUsageAccessRights(
          AccessRights: TGeneralDocumentChargeSheetsUsageEmployeeAccessRightsInfo;
          Document: TDocument;
          DocumentChargeSheets: IDocumentChargeSheets;
          Employee: TEmployee
        ); virtual;

        function FindAllChargeSheetsForDocument(Document: TDocument): TDocumentChargeSheets; virtual;

        function InternalGetDocumentChargeSheetsUsageAccessRights(
          Document: TDocument;
          Employee: TEmployee
        ): TGeneralDocumentChargeSheetsUsageEmployeeAccessRightsInfo;
        
      public

        constructor Create(
          DocumentChargeSheetFinder: IDocumentChargeSheetFinder;
          IssuingAccessRightsService: IDocumentChargeSheetIssuingAccessRightsService
        );

        function EnsureEmployeeHasDocumentChargeSheetsAccessRights(
          Document: TDocument;
          Employee: TEmployee
        ): TGeneralDocumentChargeSheetsUsageEmployeeAccessRightsInfo;

        function GetDocumentChargeSheetsUsageAccessRights(
          Document: TDocument;
          Employee: TEmployee
        ): TGeneralDocumentChargeSheetsUsageEmployeeAccessRightsInfo;

        function AnyChargeSheetsCanBeViewedFor(
          Document: TDocument;
          Employee: TEmployee
        ): Boolean;

    end;

implementation

uses

  AuxDebugFunctionsUnit,
  VariantFunctions,
  DocumentChargeSheetViewingRule,
  IDomainObjectBaseUnit;
  
{ TStandardGeneralDocumentChargeSheetAccessRightsService }

function TStandardGeneralDocumentChargeSheetAccessRightsService
  .AnyChargeSheetsCanBeViewedFor(
    Document: TDocument;
    Employee: TEmployee
  ): Boolean;
var
    AccessRightsInfo: TGeneralDocumentChargeSheetsUsageEmployeeAccessRightsInfo;
    Free: IDomainObjectBase;
begin

  AccessRightsInfo :=
    GetDocumentChargeSheetsUsageAccessRights(Document, Employee);

  Free := AccessRightsInfo;

  Result := AccessRightsInfo.AnyChargeSheetsCanBeViewed;

end;

constructor TStandardGeneralDocumentChargeSheetAccessRightsService.Create(
  DocumentChargeSheetFinder: IDocumentChargeSheetFinder;
  IssuingAccessRightsService: IDocumentChargeSheetIssuingAccessRightsService
);
begin

  inherited Create;

  FDocumentChargeSheetFinder := DocumentChargeSheetFinder;
  FIssuingAccessRightsService := IssuingAccessRightsService;

end;

function TStandardGeneralDocumentChargeSheetAccessRightsService
  .EnsureEmployeeHasDocumentChargeSheetsAccessRights(
    Document: TDocument;
    Employee: TEmployee
  ): TGeneralDocumentChargeSheetsUsageEmployeeAccessRightsInfo;
begin

  Result := InternalGetDocumentChargeSheetsUsageAccessRights(Document, Employee);

  try
  
    Result.IssuingAccessRights :=
      FIssuingAccessRightsService.EnsureEmployeeHasDocumentChargeSheetIssuingAccessRights(
        Document, Employee, Result
      );

    if Result.AllChargeSheetsAccessRightsAbsent then begin

      raise TGeneralDocumentChargeSheetAccessRightsServiceException.Create(
        'ќтсутствуют права дл€ работы с поручени€ми документа'
      );

    end;

  except

    FreeAndNil(Result);

    Raise;

  end;

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

  Result := InternalGetDocumentChargeSheetsUsageAccessRights(Document, Employee);

  try

    Result.IssuingAccessRights :=
      FIssuingAccessRightsService.GetDocumentChargeSheetIssuingAccessRights(
        Document, Employee, Result
      );

  except

    FreeAndNil(Result);

    Raise;

  end;

end;

function TStandardGeneralDocumentChargeSheetAccessRightsService
  .InternalGetDocumentChargeSheetsUsageAccessRights(
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

  //общие правила дл€ удалени€, выдачи, изменени€

  for ChargeSheet in TDocumentChargeSheets(DocumentChargeSheets.Self)
  do begin

    ChargeSheetObj := TDocumentChargeSheet(ChargeSheet.Self);

    if
      not AccessRights.AnyChargeSheetsCanBeViewedAsPerformer
      or not AccessRights.AnyChargeSheetsCanBeViewedAsIssuer
      or not AccessRights.AnyChargeSheetsCanBeViewedAsAuthorized
    then begin

      ChargeSheetViewingRuleEnsuringResult :=
        ChargeSheetObj
          .WorkingRules
            .DocumentChargeSheetViewingRule.MayEmployeeViewDocumentChargeSheet(
              Employee, ChargeSheetObj
            );

      if not AccessRights.AnyChargeSheetsCanBeViewedAsAuthorized then begin

        AccessRights.AnyChargeSheetsCanBeViewedAsAuthorized :=
          ChargeSheetViewingRuleEnsuringResult = EmployeeMayViewDocumentChargeSheetAsAuthorized;

      end;

      if not AccessRights.AnyChargeSheetsCanBeViewedAsIssuer then begin

        AccessRights.AnyChargeSheetsCanBeViewedAsIssuer :=
          ChargeSheetViewingRuleEnsuringResult = EmployeeMayViewDocumentChargeSheetAsIssuer;
          
      end;

      if not AccessRights.AnyChargeSheetsCanBeViewedAsPerformer then begin

        AccessRights.AnyChargeSheetsCanBeViewedAsPerformer :=
          ChargeSheetViewingRuleEnsuringResult = EmployeeMayViewDocumentChargeSheetAsPerformer;
          
      end;

    end;

    if not AccessRights.AnyChargeSheetsCanBeViewed then Continue;

    if
      not AccessRights.AnyChargeSheetsCanBeChanged
      and ChargeSheetObj
            .WorkingRules
              .DocumentChargeSheetChangingRule
                .MayEmployeeChangeDocumentChargeSheet(
                  Employee, ChargeSheetObj, []
                )
    then begin

      AccessRights.AnyChargeSheetsCanBeChanged := True;

    end;

    if
      not AccessRights.AnyChargeSheetsCanBeRemoved
      and ChargeSheetObj
            .WorkingRules
              .DocumentChargeSheetRemovingRule.IsSatisfiedBy(
                Employee, ChargeSheetObj
              )
    then begin

      AccessRights.AnyChargeSheetsCanBeRemoved := True;

    end;
    
    if
      not AccessRights.AnyChargeSheetsCanBePerformed
      and ChargeSheetObj
            .WorkingRules
              .DocumentChargeSheetPerformingRule.IsSatisfiedBy(
                Employee, ChargeSheetObj
              )
    then begin

      AccessRights.AnyChargeSheetsCanBePerformed := True;

    end;

    if AccessRights.AllChargeSheetsAccessRightsAllowed then Break;

  end;

end;

end.
