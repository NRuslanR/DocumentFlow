unit DocumentRuleRegistry;

interface

uses

  DocumentAccessRuleRegistry,
  DocumentApprovingRuleRegistry,
  DocumentChargeSheetRuleRegistry,
  DocumentChargeRuleRegistry,
  DocumentDraftingRuleRegistry,
  DocumentPerformingRuleRegistry,
  DocumentSigningRuleRegistry,
  EmployeeDocumentWorkingRules,
  Document,
  DocumentChargeSheet,
  SysUtils;

type

  TDocumentRuleRegistry = class

    public

      class procedure Destroy;
      
      class function AccessRuleRegistry: TDocumentAccessRuleRegistry; 
      class function ApprovingRuleRegistry: TDocumentApprovingRuleRegistry;
      class function ChargeSheetRuleRegistry: TDocumentChargeSheetRuleRegistry;
      class function ChargeRuleRegistry: TDocumentChargeRuleRegistry;
      class function DraftingRuleRegistry: TDocumentDraftingRuleRegistry;
      class function PerformingRuleRegistry: TDocumentPerformingRuleRegistry;
      class function SigningRuleRegistry: TDocumentSigningRuleRegistry;

      class procedure RegisterAllStandardDocumentRules(
        DocumentKind: TDocumentClass
      );

      class function GetEmployeeDocumentWorkingRules(
        DocumentKind: TDocumentClass
      ): TEmployeeDocumentWorkingRules; 
      
  end;

  TDocumentRuleRegistryClass = class of TDocumentRuleRegistry;
  
implementation

uses

  DocumentCharges,
  DocumentAcquaitance,
  DocumentPerforming,
  DocumentAcquaitanceSheet,
  DocumentPerformingSheet;

{ TDocumentRuleRegistry }

class function TDocumentRuleRegistry.AccessRuleRegistry: TDocumentAccessRuleRegistry;
begin

  Result := TDocumentAccessRuleRegistry.Instance;
  
end;

class function TDocumentRuleRegistry.ApprovingRuleRegistry: TDocumentApprovingRuleRegistry;
begin

  Result := TDocumentApprovingRuleRegistry.Instance;
  
end;

class function TDocumentRuleRegistry.ChargeRuleRegistry: TDocumentChargeRuleRegistry;
begin

  Result := TDocumentChargeRuleRegistry.Instance;
  
end;

class function TDocumentRuleRegistry.ChargeSheetRuleRegistry: TDocumentChargeSheetRuleRegistry;
begin

  Result := TDocumentChargeSheetRuleRegistry.Instance;
  
end;

class procedure TDocumentRuleRegistry.Destroy;
begin

  AccessRuleRegistry.Free;
  ApprovingRuleRegistry.Free;
  ChargeSheetRuleRegistry.Free;
  ChargeRuleRegistry.Free;
  DraftingRuleRegistry.Free;
  PerformingRuleRegistry.Free;
  SigningRuleRegistry.Free;
  
end;

class function TDocumentRuleRegistry.DraftingRuleRegistry: TDocumentDraftingRuleRegistry;
begin

  Result := TDocumentDraftingRuleRegistry.Instance;
  
end;

class function TDocumentRuleRegistry.GetEmployeeDocumentWorkingRules(
  DocumentKind: TDocumentClass
): TEmployeeDocumentWorkingRules;
begin

  Result :=
    TEmployeeDocumentWorkingRules.Create(
      AccessRuleRegistry.GetDocumentViewingRule(DocumentKind),
      AccessRuleRegistry.GetDocumentRemovingRule(DocumentKind),
      ApprovingRuleRegistry.GetDocumentApproverListChangingRule(DocumentKind),
      ApprovingRuleRegistry.GetDocumentApprovingPerformingRule(DocumentKind),
      ApprovingRuleRegistry.GetDocumentApprovingRejectingPerformingRule(DocumentKind),
      ApprovingRuleRegistry.GetApprovingDocumentSendingRule(DocumentKind),
      ApprovingRuleRegistry.GetDocumentApprovingPassingMarkingRule(DocumentKind),
      SigningRuleRegistry.GetSigningPerformingRule(DocumentKind),
      SigningRuleRegistry.GetSigningRejectingPerformingRule(DocumentKind),
      SigningRuleRegistry.GetSigningSendingRule(DocumentKind),
      PerformingRuleRegistry.GetPerformingDocumentSendingRule(DocumentKind),
      SigningRuleRegistry.GetSignerListChangingRule(DocumentKind),
      PerformingRuleRegistry.GetDocumentPerformingRule(DocumentKind),
      ChargeRuleRegistry.GetDocumentChargeListChangingRule(DocumentKind),
      DraftingRuleRegistry.GetDocumentDraftingRule(DocumentKind),
      AccessRuleRegistry.GetDocumentEditingRule(DocumentKind),
      DraftingRuleRegistry.GetSelfRegisteredDocumentMarkingRule(DocumentKind),
      SigningRuleRegistry.GetDocumentSigningMarkingRule(DocumentKind)
    );
    
end;

class function TDocumentRuleRegistry.PerformingRuleRegistry: TDocumentPerformingRuleRegistry;
begin

  Result := TDocumentPerformingRuleRegistry.Instance;

end;

class procedure TDocumentRuleRegistry.RegisterAllStandardDocumentRules(
  DocumentKind: TDocumentClass);
begin

  DraftingRuleRegistry.RegisterAllStandardDocumentDraftingRules(DocumentKind);
  AccessRuleRegistry.RegisterAllStandardDocumentAccessRules(DocumentKind);
  ApprovingRuleRegistry.RegisterAllStandardDocumentApprovingRules(DocumentKind);
  ChargeRuleRegistry.RegisterStandardDocumentChargeListChangingRule(DocumentKind);
  ChargeRuleRegistry.RegisterStandardDocumentChargeChangingRule(TDocumentCharge);
  ChargeSheetRuleRegistry.RegisterAllStandardDocumentChargeSheetRules(TDocumentAcquaitanceSheet);
  ChargeSheetRuleRegistry.RegisterAllStandardDocumentChargeSheetRules(TDocumentPerformingSheet);
  PerformingRuleRegistry.RegisterAllStandardDocumentPerformingRules(DocumentKind);
  SigningRuleRegistry.RegisterAllStandardDocumentSigningRules(DocumentKind);
  ChargeRuleRegistry.RegisterStandardDocumentChargeListChangingRule(DocumentKind);

end;

class function TDocumentRuleRegistry.SigningRuleRegistry: TDocumentSigningRuleRegistry;
begin

  Result := TDocumentSigningRuleRegistry.Instance;

end;

end.
