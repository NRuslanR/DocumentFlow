unit DocumentAccessRuleRegistry;

interface

uses

  DocumentRemovingRule,
  EmployeeDocumentWorkingRule,
  Document,
  TypeObjectRegistry,
  SysUtils;

type

  TDocumentAccessRuleRegistry = class

    private

      class var FInstance: TDocumentAccessRuleRegistry;

      class function GetInstance: TDocumentAccessRuleRegistry; static;

    private

      FRemovingRuleRegistry: TTypeObjectRegistry;
      FEditingRuleRegistry: TTypeObjectRegistry;
      FViewingRuleRegistry: TTypeObjectRegistry;
      
    public

      procedure RegisterDocumentRemovingRule(
        DocumentKind: TDocumentClass;
        DocumentRemovingRule: IDocumentRemovingRule
      );

      procedure RegisterStandardDocumentRemovingRule(
        DocumentKind: TDocumentClass
      );

      function GetDocumentRemovingRule(DocumentKind: TDocumentClass): IDocumentRemovingRule;

    public

      procedure RegisterDocumentEditingRule(
        DocumentKind: TDocumentClass;
        DocumentEditingRule: IEmployeeDocumentWorkingRule
      );

      procedure RegisterStandardDocumentEditingRule(
        DocumentKind: TDocumentClass
      );

      function GetDocumentEditingRule(
        DocumentKind: TDocumentClass
      ): IEmployeeDocumentWorkingRule;

    public

      procedure RegisterDocumentViewingRule(
        DocumentKind: TDocumentClass;
        DocumentViewingRule: IEmployeeDocumentWorkingRule
      );

      procedure RegisterStandardDocumentViewingRule(
        DocumentKind: TDocumentClass
      );

      function GetDocumentViewingRule(
        DocumentKind: TDocumentClass
      ): IEmployeeDocumentWorkingRule;

    public

      procedure RegisterAllStandardDocumentAccessRules(
        DocumentKind: TDocumentClass
      );

    public

      destructor Destroy; override;
      constructor Create;

      class property Instance: TDocumentAccessRuleRegistry
      read GetInstance;
      
  end;

implementation

uses

  PersonnelOrder,
  PersonnelOrderViewingRule,
  PersonnelOrderEditingRule,
  StandardDocumentRemovingRule,
  StandardEmployeeDocumentEditingRule,
  StandardEmployeeDocumentViewingRule,
  DocumentFormalizationServiceRegistry,
  PersonnelOrderControlServiceRegistry,
  EmployeeSubordinationSpecificationRegistry,
  EmployeeDistributionSpecificationRegistry,
  DocumentApprovingServiceRegistry;

{ TDocumentAccessRuleRegistry }

constructor TDocumentAccessRuleRegistry.Create;
begin

  inherited;

  FRemovingRuleRegistry := TTypeObjectRegistry.CreateInMemoryTypeObjectRegistry;
  FEditingRuleRegistry := TTypeObjectRegistry.CreateInMemoryTypeObjectRegistry;
  FViewingRuleRegistry := TTypeObjectRegistry.CreateInMemoryTypeObjectRegistry;

  FRemovingRuleRegistry.UseSearchByNearestAncestorTypeIfTargetObjectNotFound := True;
  FEditingRuleRegistry.UseSearchByNearestAncestorTypeIfTargetObjectNotFound := True;
  FViewingRuleRegistry.UseSearchByNearestAncestorTypeIfTargetObjectNotFound := True;
  
end;

destructor TDocumentAccessRuleRegistry.Destroy;
begin

  FreeAndNil(FRemovingRuleRegistry);
  FreeAndNil(FEditingRuleRegistry);
  FreeAndNil(FViewingRuleRegistry);
  
  inherited;
  
end;

function TDocumentAccessRuleRegistry.GetDocumentEditingRule(
  DocumentKind: TDocumentClass): IEmployeeDocumentWorkingRule;
begin

  Result :=
    IEmployeeDocumentWorkingRule(
      FEditingRuleRegistry.GetInterface(DocumentKind)
    );

end;

function TDocumentAccessRuleRegistry.GetDocumentRemovingRule(
  DocumentKind: TDocumentClass): IDocumentRemovingRule;
begin

  Result :=
    IDocumentRemovingRule(
      FRemovingRuleRegistry.GetInterface(DocumentKind)
    );
    
end;

function TDocumentAccessRuleRegistry.GetDocumentViewingRule(
  DocumentKind: TDocumentClass): IEmployeeDocumentWorkingRule;
begin

  Result :=
    IEmployeeDocumentWorkingRule(
      FViewingRuleRegistry.GetInterface(DocumentKind)
    );
    
end;

class function TDocumentAccessRuleRegistry.GetInstance: TDocumentAccessRuleRegistry;
begin

  if not Assigned(FInstance) then
    FInstance := TDocumentAccessRuleRegistry.Create;

  Result := FInstance;
  
end;

procedure TDocumentAccessRuleRegistry.RegisterDocumentEditingRule(
  DocumentKind: TDocumentClass;
  DocumentEditingRule: IEmployeeDocumentWorkingRule);
begin

  FEditingRuleRegistry.RegisterInterface(
    DocumentKind,
    DocumentEditingRule
  );
  
end;

procedure TDocumentAccessRuleRegistry.RegisterDocumentRemovingRule(
  DocumentKind: TDocumentClass;
  DocumentRemovingRule: IDocumentRemovingRule
);
begin

  FRemovingRuleRegistry.RegisterInterface(
    DocumentKind,
    DocumentRemovingRule
  );
  
end;

procedure TDocumentAccessRuleRegistry.RegisterDocumentViewingRule(
  DocumentKind: TDocumentClass;
  DocumentViewingRule: IEmployeeDocumentWorkingRule);
begin

  FViewingRuleRegistry.RegisterInterface(
    DocumentKind,
    DocumentViewingRule
  );
  
end;

procedure TDocumentAccessRuleRegistry.RegisterStandardDocumentEditingRule(
  DocumentKind: TDocumentClass);
begin

  if DocumentKind.InheritsFrom(TPersonnelOrder) then begin

    RegisterDocumentEditingRule(
      DocumentKind,
      TPersonnelOrderEditingRule.Create(
        TEmployeeSubordinationSpecificationRegistry.Instance.GetEmployeeIsSameAsOrReplacingSignerForOthersSpecification,
        TDocumentFormalizationServiceRegistry.Instance.GetDocumentFullNameCompilationService,
        TEmployeeSubordinationSpecificationRegistry.Instance.GetAreEmployeesSubLeadersOfSameLeaderSpecification,
        TEmployeeSubordinationSpecificationRegistry.Instance.GetAreEmployeesSecretariesOfSameLeaderSpecification,
        TPersonnelOrderControlServiceRegistry.Instance.GetPersonnelOrderControlService
      )
    );
    
  end

  else begin

    RegisterDocumentEditingRule(
      DocumentKind,
      TStandardEmployeeDocumentEditingRule.Create(
        TEmployeeSubordinationSpecificationRegistry.Instance.GetEmployeeIsSameAsOrReplacingSignerForOthersSpecification,
        TDocumentFormalizationServiceRegistry.Instance.GetDocumentFullNameCompilationService,
        TEmployeeSubordinationSpecificationRegistry.Instance.GetAreEmployeesSubLeadersOfSameLeaderSpecification,
        TEmployeeSubordinationSpecificationRegistry.Instance.GetAreEmployeesSecretariesOfSameLeaderSpecification
      )
    );

  end;

end;

procedure TDocumentAccessRuleRegistry.RegisterStandardDocumentRemovingRule(
  DocumentKind: TDocumentClass);
begin

  RegisterDocumentRemovingRule(
    DocumentKind,
    TStandardDocumentRemovingRule.Create(
      TEmployeeSubordinationSpecificationRegistry.Instance.GetEmployeeIsSameAsOrDeputyOfEmployeesSpecification,
      TDocumentFormalizationServiceRegistry.Instance.GetDocumentFullNameCompilationService
    )
  );

end;

procedure TDocumentAccessRuleRegistry.RegisterStandardDocumentViewingRule(
  DocumentKind: TDocumentClass);
begin

  if DocumentKind.InheritsFrom(TPersonnelOrder) then begin

    RegisterDocumentViewingRule(
      DocumentKind,
      TPersonnelOrderViewingRule.Create(
        TDocumentApprovingServiceRegistry.Instance.GetDocumentApprovingCycleResultFinder(DocumentKind),
        TDocumentFormalizationServiceRegistry.Instance.GetDocumentFullNameCompilationService,
        TEmployeeSubordinationSpecificationRegistry.Instance.GetEmployeeIsSecretaryForAnyOfEmployeesSpecification,
        TEmployeeSubordinationSpecificationRegistry.Instance.GetEmployeeIsSameAsOrDeputyOfEmployeesSpecification,
        TEmployeeSubordinationSpecificationRegistry.Instance.GetAreEmployeesSubLeadersOfSameLeaderSpecification,
        TEmployeeSubordinationSpecificationRegistry.Instance.GetAreEmployeesSecretariesOfSameLeaderSpecification,
        TEmployeeDistributionSpecificationRegistry.Instance.GetWorkspaceEmployeeDistributionSpecification,
        TPersonnelOrderControlServiceRegistry.Instance.GetPersonnelOrderControlService
      )
    );
    
  end

  else begin

    RegisterDocumentViewingRule(
      DocumentKind,
      TStandardEmployeeDocumentViewingRule.Create(
        TDocumentApprovingServiceRegistry.Instance.GetDocumentApprovingCycleResultFinder(DocumentKind),
        TDocumentFormalizationServiceRegistry.Instance.GetDocumentFullNameCompilationService,
        TEmployeeSubordinationSpecificationRegistry.Instance.GetEmployeeIsSecretaryForAnyOfEmployeesSpecification,
        TEmployeeSubordinationSpecificationRegistry.Instance.GetEmployeeIsSameAsOrDeputyOfEmployeesSpecification,
        TEmployeeSubordinationSpecificationRegistry.Instance.GetAreEmployeesSubLeadersOfSameLeaderSpecification,
        TEmployeeSubordinationSpecificationRegistry.Instance.GetAreEmployeesSecretariesOfSameLeaderSpecification,
        TEmployeeDistributionSpecificationRegistry.Instance.GetWorkspaceEmployeeDistributionSpecification
      )
    );

  end;

end;

procedure TDocumentAccessRuleRegistry.RegisterAllStandardDocumentAccessRules(
  DocumentKind: TDocumentClass);
begin

  RegisterStandardDocumentEditingRule(DocumentKind);
  RegisterStandardDocumentRemovingRule(DocumentKind);
  RegisterStandardDocumentViewingRule(DocumentKind);

end;

end.
