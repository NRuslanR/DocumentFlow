unit DocumentDraftingRuleRegistry;

interface

uses

  EmployeeDocumentWorkingRule,
  DocumentDraftingRule,
  Document,
  TypeObjectRegistry,
  SysUtils;

type

  TDocumentDraftingRuleRegistry = class

    private

      class var FInstance: TDocumentDraftingRuleRegistry;

      class function GetInstance: TDocumentDraftingRuleRegistry; static;

    private

      FDraftingRuleRegistry: TTypeObjectRegistry;
      FSelfRegisteredDocumentMarkingRuleRegistry: TTypeObjectRegistry;

    public

      procedure RegisterDocumentDraftingRule(
        DocumentKind: TDocumentClass;
        DocumentDraftingRule: IDocumentDraftingRule
      );

      procedure RegisterStandardDocumentDraftingRule(
        DocumentKind: TDocumentClass
      );

      function GetDocumentDraftingRule(
        DocumentKind: TDocumentClass
      ): IDocumentDraftingRule;

    public

      procedure RegisterSelfRegisteredDocumentMarkingRule(
        DocumentKind: TDocumentClass;
        SelfRegisteredDocumentMarkingRule: IEmployeeDocumentWorkingRule
      );

      procedure RegisterStandardSelfRegisteredDocumentMarkingRule(
        DocumentKind: TDocumentClass
      );

      function GetSelfRegisteredDocumentMarkingRule(
        DocumentKind: TDocumentClass
      ): IEmployeeDocumentWorkingRule;

    public

      procedure RegisterAllStandardDocumentDraftingRules(
        DocumentKind: TDocumentClass
      );
      
    public

      destructor Destroy; override;
      constructor Create;

      class property Instance: TDocumentDraftingRuleRegistry
      read GetInstance;

  end;

  
implementation

uses

  InternalDocument,
  PersonnelOrder,
  IncomingInternalDocument,
  DocumentSpecificationRegistry,
  StandardAsSelfRegisteredDocumentMarkingRule,
  StandardDocumentDraftingRule,
  StandardInternalDocumentDraftingRule,
  StandardDocumentDraftingRuleOptions,
  DocumentFormalizationServiceRegistry,
  EmployeeDistributionSpecificationRegistry,
  EmployeeSubordinationSpecificationRegistry;

{ TDocumentDraftingRuleRegistry }

constructor TDocumentDraftingRuleRegistry.Create;
begin

  inherited;

  FSelfRegisteredDocumentMarkingRuleRegistry := TTypeObjectRegistry.CreateInMemoryTypeObjectRegistry;
  FDraftingRuleRegistry := TTypeObjectRegistry.CreateInMemoryTypeObjectRegistry;

  FSelfRegisteredDocumentMarkingRuleRegistry.UseSearchByNearestAncestorTypeIfTargetObjectNotFound := True;
  FDraftingRuleRegistry.UseSearchByNearestAncestorTypeIfTargetObjectNotFound := True;
  
end;

destructor TDocumentDraftingRuleRegistry.Destroy;
begin

  FreeAndNil(FSelfRegisteredDocumentMarkingRuleRegistry);
  FreeAndNil(FDraftingRuleRegistry);
  
  inherited;

end;

function TDocumentDraftingRuleRegistry.GetDocumentDraftingRule(
  DocumentKind: TDocumentClass): IDocumentDraftingRule;
begin

  Result :=
    IDocumentDraftingRule(
      FDraftingRuleRegistry.GetInterface(DocumentKind)
    );
    
end;

class function TDocumentDraftingRuleRegistry.GetInstance: TDocumentDraftingRuleRegistry;
begin

  if not Assigned(FInstance) then
    FInstance := TDocumentDraftingRuleRegistry.Create;

  Result := FInstance;
  
end;

function TDocumentDraftingRuleRegistry.GetSelfRegisteredDocumentMarkingRule(
  DocumentKind: TDocumentClass): IEmployeeDocumentWorkingRule;
begin

  Result :=
    IEmployeeDocumentWorkingRule(
      FSelfRegisteredDocumentMarkingRuleRegistry.GetInterface(
        DocumentKind
      )
    );
    
end;

procedure TDocumentDraftingRuleRegistry.RegisterDocumentDraftingRule(
  DocumentKind: TDocumentClass; DocumentDraftingRule: IDocumentDraftingRule);
begin

  FDraftingRuleRegistry.RegisterInterface(
    DocumentKind,
    DocumentDraftingRule
  );
  
end;

procedure TDocumentDraftingRuleRegistry.RegisterSelfRegisteredDocumentMarkingRule(
  DocumentKind: TDocumentClass;
  SelfRegisteredDocumentMarkingRule: IEmployeeDocumentWorkingRule
);
begin

  FSelfRegisteredDocumentMarkingRuleRegistry.RegisterInterface(
    DocumentKind,
    SelfRegisteredDocumentMarkingRule
  );
  
end;

procedure TDocumentDraftingRuleRegistry.RegisterStandardDocumentDraftingRule(
  DocumentKind: TDocumentClass);
var Rule: IDocumentDraftingRule;
begin

  if
    DocumentKind.InheritsFrom(TInternalDocument) or
    DocumentKind.InheritsFrom(TIncomingInternalDocument)
  then begin

    Rule :=
      TStandardInternalDocumentDraftingRule.Create(
        TDocumentFormalizationServiceRegistry.Instance.GetDocumentResponsibleFinder(
          DocumentKind
        ),
        TDocumentSpecificationRegistry.Instance.GetDocumentSigningSpecification(DocumentKind),
        TEmployeeDistributionSpecificationRegistry.Instance.GetDepartmentEmployeeDistributionSpecification,
        TDocumentDraftingRuleCompoundOptions.Builder.BuildFor(DocumentKind)
      );
      
  end

  else begin

    Rule :=
      TStandardDocumentDraftingRule.Create(
        TDocumentFormalizationServiceRegistry.Instance.GetDocumentResponsibleFinder(
          DocumentKind
        ),
        TDocumentSpecificationRegistry.Instance.GetDocumentSigningSpecification(DocumentKind),
        TDocumentDraftingRuleCompoundOptions.Builder.BuildFor(DocumentKind)

      );

  end;
  
  RegisterDocumentDraftingRule(DocumentKind, Rule);

end;

procedure TDocumentDraftingRuleRegistry.RegisterStandardSelfRegisteredDocumentMarkingRule(
  DocumentKind: TDocumentClass);
begin

  RegisterSelfRegisteredDocumentMarkingRule(
    DocumentKind,
    TStandardAsSelfRegisteredDocumentMarkingRule.Create(
      TEmployeeSubordinationSpecificationRegistry.Instance.GetEmployeeIsSameAsOrReplacingSignerForOthersSpecification,
      TDocumentFormalizationServiceRegistry.Instance.GetDocumentFullNameCompilationService,
      TEmployeeSubordinationSpecificationRegistry.Instance.GetAreEmployeesSecretariesOfSameLeaderSpecification
    )
  );

end;

procedure TDocumentDraftingRuleRegistry.RegisterAllStandardDocumentDraftingRules(
  DocumentKind: TDocumentClass);
begin

  RegisterStandardDocumentDraftingRule(DocumentKind);
  RegisterStandardSelfRegisteredDocumentMarkingRule(DocumentKind);

end;

end.
