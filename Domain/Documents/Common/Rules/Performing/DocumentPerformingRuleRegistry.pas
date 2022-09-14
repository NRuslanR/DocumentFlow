unit DocumentPerformingRuleRegistry;

interface

uses

  Document,
  EmployeeDocumentWorkingRule,
  DocumentPerformingRule,
  TypeObjectRegistry,
  SysUtils;
  
type

  TDocumentPerformingRuleRegistry = class

    private

      class var FInstance: TDocumentPerformingRuleRegistry;

      class function GetInstance: TDocumentPerformingRuleRegistry; static;

    private

      FPerformingSendingRuleRegistry: TTypeObjectRegistry;
      FDocumentPerformingRuleRegistry: TTypeObjectRegistry;

    public

      procedure RegisterDocumentPerformingRule(
        DocumentKind: TDocumentClass;
        DocumentPerformingRule: IDocumentPerformingRule
      );

      procedure RegisterStandardDocumentPerformingRule(
        DocumentKind: TDocumentClass
      );

      function GetDocumentPerformingRule(
        DocumentKind: TDocumentClass
      ): IDocumentPerformingRule;
      
    public

      procedure RegisterPerformingDocumentSendingRule(
        DocumentKind: TDocumentClass;
        PerformingDocumentSendingRule: IEmployeeDocumentWorkingRule
      );

      procedure RegisterStandardPerformingDocumentSendingRule(
        DocumentKind: TDocumentClass
      );

      function GetPerformingDocumentSendingRule(
        DocumentKind: TDocumentClass
      ): IEmployeeDocumentWorkingRule;

    public

      procedure RegisterAllStandardDocumentPerformingRules(
        DocumentKind: TDocumentClass
      );

    public

      destructor Destroy; override;
      constructor Create;

      class property Instance: TDocumentPerformingRuleRegistry
      read GetInstance;
      
  end;

implementation

uses

  StandardDocumentPerformingRule,
  StandardPerformingDocumentSendingRule,
  DocumentFormalizationServiceRegistry,
  EmployeeSubordinationSpecificationRegistry,
  EmployeeDistributionSpecificationRegistry;

{ TDocumentPerformingRuleRegistry }

constructor TDocumentPerformingRuleRegistry.Create;
begin

  inherited;

  FPerformingSendingRuleRegistry := TTypeObjectRegistry.CreateInMemoryTypeObjectRegistry;
  FDocumentPerformingRuleRegistry := TTypeObjectRegistry.CreateInMemoryTypeObjectRegistry;

  FPerformingSendingRuleRegistry.UseSearchByNearestAncestorTypeIfTargetObjectNotFound := True;
  FDocumentPerformingRuleRegistry.UseSearchByNearestAncestorTypeIfTargetObjectNotFound := True;
end;

destructor TDocumentPerformingRuleRegistry.Destroy;
begin

  FreeAndNil(FPerformingSendingRuleRegistry);
  FreeAndNil(FDocumentPerformingRuleRegistry);
  
  inherited;
  
end;

function TDocumentPerformingRuleRegistry.GetDocumentPerformingRule(
  DocumentKind: TDocumentClass): IDocumentPerformingRule;
begin

  Result :=
    IDocumentPerformingRule(
      FDocumentPerformingRuleRegistry.GetInterface(DocumentKind)
    );

end;

class function TDocumentPerformingRuleRegistry.GetInstance: TDocumentPerformingRuleRegistry;
begin

  if not Assigned(FInstance) then
    FInstance := TDocumentPerformingRuleRegistry.Create;

  Result := FInstance;
  
end;

function TDocumentPerformingRuleRegistry.GetPerformingDocumentSendingRule(
  DocumentKind: TDocumentClass): IEmployeeDocumentWorkingRule;
begin

  Result :=
    IEmployeeDocumentWorkingRule(
      FPerformingSendingRuleRegistry.GetInterface(DocumentKind)
    );
    
end;

procedure TDocumentPerformingRuleRegistry.RegisterPerformingDocumentSendingRule(
  DocumentKind: TDocumentClass;
  PerformingDocumentSendingRule: IEmployeeDocumentWorkingRule);
begin

  FPerformingSendingRuleRegistry.RegisterInterface(
    DocumentKind, PerformingDocumentSendingRule
  );
  
end;

procedure TDocumentPerformingRuleRegistry.RegisterStandardDocumentPerformingRule(
  DocumentKind: TDocumentClass);
begin

  RegisterDocumentPerformingRule(
    DocumentKind,
    TStandardDocumentPerformingRule.Create(
      TEmployeeSubordinationSpecificationRegistry.Instance.GetEmployeeIsSameAsOrReplacingSignerForOthersSpecification,
      TDocumentFormalizationServiceRegistry.Instance.GetDocumentFullNameCompilationService
    )
  );
  
end;

procedure TDocumentPerformingRuleRegistry.RegisterStandardPerformingDocumentSendingRule(
  DocumentKind: TDocumentClass);
begin

  RegisterPerformingDocumentSendingRule(
    DocumentKind,
    TStandardPerformingDocumentSendingRule.Create(
      TEmployeeSubordinationSpecificationRegistry.Instance.GetEmployeeIsSameAsOrDeputyOfEmployeesSpecification,
      TDocumentFormalizationServiceRegistry.Instance.GetDocumentFullNameCompilationService
    )
  );
  
end;

procedure TDocumentPerformingRuleRegistry.RegisterAllStandardDocumentPerformingRules(
  DocumentKind: TDocumentClass);
begin

  RegisterStandardPerformingDocumentSendingRule(DocumentKind);
  RegisterStandardDocumentPerformingRule(DocumentKind);
  
end;

procedure TDocumentPerformingRuleRegistry.RegisterDocumentPerformingRule(
  DocumentKind: TDocumentClass;
  DocumentPerformingRule: IDocumentPerformingRule);
begin

  FDocumentPerformingRuleRegistry.RegisterInterface(
    DocumentKind,
    DocumentPerformingRule
  );
  
end;

end.
