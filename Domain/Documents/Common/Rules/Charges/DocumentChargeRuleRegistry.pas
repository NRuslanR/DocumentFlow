unit DocumentChargeRuleRegistry;

interface

uses

  DocumentChargeListChangingRule,
  DocumentChargeChangingRule,
  DocumentChargeWorkingRules,
  DocumentCharges,
  Document,
  TypeObjectRegistry,
  SysUtils;

type

  TDocumentChargeRuleRegistry = class

    private

      class var FInstance: TDocumentChargeRuleRegistry;

      class function GetInstance: TDocumentChargeRuleRegistry; static;

    private

      FDocumentChargeListChangingRuleRegistry: TTypeObjectRegistry;
      FChargeRules: TTypeObjectRegistry;

    public

      procedure RegisterDocumentChargeListChangingRule(
        DocumentKind: TDocumentClass;
        DocumentChargeListChangingRule: IDocumentChargeListChangingRule
      );

      procedure RegisterStandardDocumentChargeListChangingRule(
        DocumentKind: TDocumentClass
      );

      function GetDocumentChargeListChangingRule(
        DocumentKind: TDocumentClass
      ): IDocumentChargeListChangingRule;

    public

      procedure RegisterDocumentChargeChangingRule(
        DocumentChargeKind: TDocumentChargeClass;
        DocumentChargeChangingRule: IDocumentChargeChangingRule
      );

      procedure RegisterStandardDocumentChargeChangingRule(
        DocumentChargeKind: TDocumentChargeClass
      );
      
      function GetDocumentChargeChangingRule(
        DocumentChargeKind: TDocumentChargeClass
      ): IDocumentChargeChangingRule;
      
    public

      function GetDocumentChargeWorkingRules(DocumentChargeKind: TDocumentChargeClass): TDocumentChargeWorkingRules;

    public

      destructor Destroy; override;
      constructor Create;

      class property Instance: TDocumentChargeRuleRegistry
      read GetInstance;

  end;


implementation

uses

  InternalDocument,
  IncomingInternalDocument,
  StandardDocumentChargeListChangingRule,
  StandardDocumentChargeChangingRule,
  StandardInternalDocumentChargeListChangingRule,
  EmployeeDistributionServiceRegistry,
  EmployeeSubordinationSpecificationRegistry,
  DocumentFormalizationServiceRegistry,
  EmployeeDistributionSpecificationRegistry;

{ TDocumentChargeRuleRegistry }

constructor TDocumentChargeRuleRegistry.Create;
begin

  inherited;

  FDocumentChargeListChangingRuleRegistry := TTypeObjectRegistry.CreateInMemoryTypeObjectRegistry;
  FChargeRules := TTypeObjectRegistry.CreateInMemoryTypeObjectRegistry;

  FDocumentChargeListChangingRuleRegistry.UseSearchByNearestAncestorTypeIfTargetObjectNotFound := True;
  FChargeRules.UseSearchByNearestAncestorTypeIfTargetObjectNotFound := True;

end;

destructor TDocumentChargeRuleRegistry.Destroy;
begin

  FreeAndNil(FDocumentChargeListChangingRuleRegistry);
  FreeAndNil(FChargeRules);
  
  inherited;

end;

function TDocumentChargeRuleRegistry.GetDocumentChargeChangingRule(
  DocumentChargeKind: TDocumentChargeClass): IDocumentChargeChangingRule;
begin

  Result :=
    IDocumentChargeChangingRule(
      FChargeRules.GetInterface(DocumentChargeKind)
    );
    
end;

function TDocumentChargeRuleRegistry.GetDocumentChargeListChangingRule(
  DocumentKind: TDocumentClass): IDocumentChargeListChangingRule;
begin

  Result :=
    IDocumentChargeListChangingRule(
      FDocumentChargeListChangingRuleRegistry.GetInterface(
        DocumentKind
      )
    );
    
end;

function TDocumentChargeRuleRegistry.GetDocumentChargeWorkingRules(
  DocumentChargeKind: TDocumentChargeClass): TDocumentChargeWorkingRules;
begin

  Result :=
    TDocumentChargeWorkingRules.Create(
      GetDocumentChargeChangingRule(DocumentChargeKind)
    );

end;

class function TDocumentChargeRuleRegistry.
  GetInstance: TDocumentChargeRuleRegistry;
begin

  if not Assigned(FInstance) then
    FInstance := TDocumentChargeRuleRegistry.Create;

  Result := FInstance;

end;

procedure TDocumentChargeRuleRegistry.RegisterDocumentChargeChangingRule(
  DocumentChargeKind: TDocumentChargeClass;
  DocumentChargeChangingRule: IDocumentChargeChangingRule
);
begin

  FChargeRules.RegisterInterface(DocumentChargeKind, DocumentChargeChangingRule);
  
end;

procedure TDocumentChargeRuleRegistry.RegisterDocumentChargeListChangingRule(
  DocumentKind: TDocumentClass;
  DocumentChargeListChangingRule: IDocumentChargeListChangingRule);
begin

  FDocumentChargeListChangingRuleRegistry.RegisterInterface(
    DocumentKind,
    DocumentChargeListChangingRule
  );
  
end;

procedure TDocumentChargeRuleRegistry.RegisterStandardDocumentChargeChangingRule(
  DocumentChargeKind: TDocumentChargeClass);
begin

  RegisterDocumentChargeChangingRule(
    DocumentChargeKind,
    TStandardDocumentChargeChangingRule.Create(
      TEmployeeSubordinationSpecificationRegistry
        .Instance
          .GetEmployeeIsSameAsOrReplacingSignerForOthersSpecification
    )
  );
  
end;

procedure TDocumentChargeRuleRegistry.RegisterStandardDocumentChargeListChangingRule(
  DocumentKind: TDocumentClass);
var Rule: IDocumentChargeListChangingRule;
begin

  if
    DocumentKind.InheritsFrom(TInternalDocument) or
    DocumentKind.InheritsFrom(TIncomingInternalDocument)
  then begin

    Rule :=
      TStandardInternalDocumentChargeListChangingRule.Create(
        TEmployeeDistributionServiceRegistry.Instance.GetDepartmentEmployeeDistributionService,
        TDocumentFormalizationServiceRegistry.Instance.GetDocumentFullNameCompilationService,
        TEmployeeSubordinationSpecificationRegistry.Instance.GetEmployeeIsSameAsOrDeputyOfEmployeesSpecification,
        TEmployeeSubordinationSpecificationRegistry.Instance.GetAreEmployeesSubLeadersOfSameLeaderSpecification,
        TEmployeeSubordinationSpecificationRegistry.Instance.GetAreEmployeesSecretariesOfSameLeaderSpecification,
        TEmployeeDistributionSpecificationRegistry.Instance.GetDepartmentEmployeeDistributionSpecification
      );
      
  end

  else begin

    Rule :=
      TStandardEmployeeDocumentChargeListChangingRule.Create(
        TEmployeeDistributionServiceRegistry.Instance.GetDepartmentEmployeeDistributionService,
        TDocumentFormalizationServiceRegistry.Instance.GetDocumentFullNameCompilationService,
        TEmployeeSubordinationSpecificationRegistry.Instance.GetEmployeeIsSameAsOrDeputyOfEmployeesSpecification,
        TEmployeeSubordinationSpecificationRegistry.Instance.GetAreEmployeesSubLeadersOfSameLeaderSpecification,
        TEmployeeSubordinationSpecificationRegistry.Instance.GetAreEmployeesSecretariesOfSameLeaderSpecification
      );
      
  end;
  
  RegisterDocumentChargeListChangingRule(DocumentKind, Rule);
  
end;

end.
