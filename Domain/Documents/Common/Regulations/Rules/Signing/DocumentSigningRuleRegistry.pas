unit DocumentSigningRuleRegistry;

interface

uses

  DocumentSignerListChangingRule,
  DocumentSigningPerformingRule,
  DocumentSigningRejectingPerformingRule,
  EmployeeDocumentWorkingRule,
  Document,
  DocumentSigningMarkingRule,
  TypeObjectRegistry,
  SysUtils;

type

  TDocumentSigningRuleRegistry = class

    private

      class var FInstance: TDocumentSigningRuleRegistry;

      class function GetInstance: TDocumentSigningRuleRegistry; static;

    private

      FSignerListChangingRuleRegistry: TTypeObjectRegistry;
      FSigningPerformingRuleRegistry: TTypeObjectRegistry;
      FSigningRejectingPerformingRuleRegistry: TTypeObjectRegistry;
      FSigningSendingRuleRegistry: TTypeObjectRegistry;
      FSigningMarkingRuleRegistry: TTypeObjectRegistry;

    public

      procedure RegisterSignerListChangingRule(
        DocumentKind: TDocumentClass;
        SignerListChangingRule: IDocumentSignerListChangingRule
      );

      procedure RegisterStandardSignerListChangingRule(
        DocumentKind: TDocumentClass
      );

      function GetSignerListChangingRule(
        DocumentKind: TDocumentClass
      ): IDocumentSignerListChangingRule;

    public

      procedure RegisterSigningPerformingRule(
        DocumentKind: TDocumentClass;
        SigningPerformingRule: IDocumentSigningPerformingRule
      );

      procedure RegisterStandardSigningPerformingRule(
        DocumentKind: TDocumentClass
      );

      function GetSigningPerformingRule(
        DocumentKind: TDocumentClass
      ): IDocumentSigningPerformingRule;

    public

      procedure RegisterDocumentSigningMarkingRule(
        DocumentKind: TDocumentClass;
        DocumentSigningMarkingRule: IDocumentSigningMarkingRule
      );

      function GetDocumentSigningMarkingRule(
        DocumentKind: TDocumentClass
      ): IDocumentSigningMarkingRule;

      procedure RegisterStandardDocumentSigningMarkingRule(DocumentKind: TDocumentClass);

    public

      procedure RegisterSigningRejectingPerformingRule(
        DocumentKind: TDocumentClass;
        SigningRejectingPerformingRule: IDocumentSigningRejectingPerformingRule
      );

      procedure RegisterStandardSigningRejectingPerformingRule(
        DocumentKind: TDocumentClass
      );

      function GetSigningRejectingPerformingRule(
        DocumentKind: TDocumentClass
      ): IDocumentSigningRejectingPerformingRule;

    public

      procedure RegisterSigningSendingRule(
        DocumentKind: TDocumentClass;
        SigningSendingRule: IEmployeeDocumentWorkingRule
      );

      procedure RegisterStandardSigningSendingRule(
        DocumentKind: TDocumentClass
      );

      function GetSigningSendingRule(
        DocumentKind: TDocumentClass
      ): IEmployeeDocumentWorkingRule;
      
    public

      procedure RegisterAllStandardDocumentSigningRules(
        DocumentKind: TDocumentClass
      );

    public

      destructor Destroy; override;
      constructor Create;

      class property Instance: TDocumentSigningRuleRegistry
      read GetInstance;
      
  end;

implementation

uses

  InternalDocument,
  IncomingInternalDocument,
  StandardDocumentSignerListChangingRule,
  StandardEmployeeDocumentSigningPerformingRule,
  StandardEmployeeDocumentSigningRejectingPerformingRule,
  StandardInternalDocumentSignerListChangingRule,
  StandardSigningDocumentSendingRule,
  DocumentFormalizationServiceRegistry,
  EmployeeDistributionSpecificationRegistry,
  EmployeeSubordinationSpecificationRegistry,
  PersonnelOrderSignerListChangingRule,
  PersonnelOrderControlServiceRegistry,
  StandardDocumentSigningMarkingRule,
  PersonnelOrderSearchServiceRegistry,
  PersonnelOrderSigningRejectingRule,
  PersonnelOrder,
  DocumentDraftingRuleRegistry;

{ TDocumentSigningRuleRegistry }

constructor TDocumentSigningRuleRegistry.Create;
begin

  inherited;

  FSignerListChangingRuleRegistry := TTypeObjectRegistry.CreateInMemoryTypeObjectRegistry;
  FSigningPerformingRuleRegistry := TTypeObjectRegistry.CreateInMemoryTypeObjectRegistry;
  FSigningRejectingPerformingRuleRegistry := TTypeObjectRegistry.CreateInMemoryTypeObjectRegistry;
  FSigningSendingRuleRegistry := TTypeObjectRegistry.CreateInMemoryTypeObjectRegistry;
  FSigningMarkingRuleRegistry := TTypeObjectRegistry.CreateInMemoryTypeObjectRegistry;

  FSignerListChangingRuleRegistry.UseSearchByNearestAncestorTypeIfTargetObjectNotFound := True;
  FSigningPerformingRuleRegistry.UseSearchByNearestAncestorTypeIfTargetObjectNotFound := True;
  FSigningRejectingPerformingRuleRegistry.UseSearchByNearestAncestorTypeIfTargetObjectNotFound := True;
  FSigningSendingRuleRegistry.UseSearchByNearestAncestorTypeIfTargetObjectNotFound := True;
  FSigningMarkingRuleRegistry.UseSearchByNearestAncestorTypeIfTargetObjectNotFound := True;
  
end;

destructor TDocumentSigningRuleRegistry.Destroy;
begin

  FreeAndNil(FSignerListChangingRuleRegistry);
  FreeAndNil(FSigningPerformingRuleRegistry);
  FreeAndNil(FSigningRejectingPerformingRuleRegistry);
  FreeAndNil(FSigningSendingRuleRegistry);
  FreeAndNil(FSigningMarkingRuleRegistry);
  
  inherited;
  
end;

function TDocumentSigningRuleRegistry.GetDocumentSigningMarkingRule(
  DocumentKind: TDocumentClass): IDocumentSigningMarkingRule;
begin

  Result :=
    IDocumentSigningMarkingRule(
      FSigningMarkingRuleRegistry.GetInterface(DocumentKind)
    );
    
end;

class function TDocumentSigningRuleRegistry.GetInstance: TDocumentSigningRuleRegistry;
begin

  if not Assigned(FInstance) then
    FInstance := TDocumentSigningRuleRegistry.Create;

  Result := FInstance;
  
end;

function TDocumentSigningRuleRegistry.GetSignerListChangingRule(
  DocumentKind: TDocumentClass): IDocumentSignerListChangingRule;
begin

  Result :=
    IDocumentSignerListChangingRule(
      FSignerListChangingRuleRegistry.GetInterface(DocumentKind)
    );
    
end;

function TDocumentSigningRuleRegistry.GetSigningPerformingRule(
  DocumentKind: TDocumentClass): IDocumentSigningPerformingRule;
begin

  Result :=
    IDocumentSigningPerformingRule(
      FSigningPerformingRuleRegistry.GetInterface(DocumentKind)
    );
    
end;

function TDocumentSigningRuleRegistry.GetSigningRejectingPerformingRule(
  DocumentKind: TDocumentClass): IDocumentSigningRejectingPerformingRule;
begin

  Result :=
    IDocumentSigningRejectingPerformingRule(
      FSigningRejectingPerformingRuleRegistry.GetInterface(DocumentKind)
    );
    
end;

function TDocumentSigningRuleRegistry.GetSigningSendingRule(
  DocumentKind: TDocumentClass): IEmployeeDocumentWorkingRule;
begin

  Result :=
    IEmployeeDocumentWorkingRule(
      FSigningSendingRuleRegistry.GetInterface(DocumentKind)
    );
    
end;

procedure TDocumentSigningRuleRegistry.RegisterSignerListChangingRule(
  DocumentKind: TDocumentClass;
  SignerListChangingRule: IDocumentSignerListChangingRule);
begin

  FSignerListChangingRuleRegistry.RegisterInterface(
    DocumentKind,
    SignerListChangingRule
  );
  
end;

procedure TDocumentSigningRuleRegistry.RegisterSigningPerformingRule(
  DocumentKind: TDocumentClass;
  SigningPerformingRule: IDocumentSigningPerformingRule);
begin

  FSigningPerformingRuleRegistry.RegisterInterface(
    DocumentKind,
    SigningPerformingRule
  );
  
end;

procedure TDocumentSigningRuleRegistry.RegisterSigningRejectingPerformingRule(
  DocumentKind: TDocumentClass;
  SigningRejectingPerformingRule: IDocumentSigningRejectingPerformingRule);
begin

  FSigningRejectingPerformingRuleRegistry.RegisterInterface(
    DocumentKind,
    SigningRejectingPerformingRule
  );
  
end;

procedure TDocumentSigningRuleRegistry.RegisterSigningSendingRule(
  DocumentKind: TDocumentClass;
  SigningSendingRule: IEmployeeDocumentWorkingRule);
begin

  FSigningSendingRuleRegistry.RegisterInterface(
    DocumentKind,
    SigningSendingRule
  );

end;

procedure TDocumentSigningRuleRegistry.
  RegisterStandardDocumentSigningMarkingRule(
    DocumentKind: TDocumentClass
  );
begin

  RegisterDocumentSigningMarkingRule(
    DocumentKind,
    TStandardDocumentSigningMarkingRule.Create(

      TEmployeeSubordinationSpecificationRegistry
        .Instance
          .GetEmployeeIsSameAsOrReplacingSignerForOthersSpecification,

      TDocumentFormalizationServiceRegistry
        .Instance
          .GetDocumentFullNameCompilationService,

      TDocumentDraftingRuleRegistry.Instance.GetDocumentDraftingRule(
        DocumentKind
      )
    )
  );

end;

procedure TDocumentSigningRuleRegistry.RegisterStandardSignerListChangingRule(
  DocumentKind: TDocumentClass);
var Rule: IDocumentSignerListChangingRule;
begin

  if
    DocumentKind.InheritsFrom(TInternalDocument) or
    DocumentKind.InheritsFrom(TIncomingInternalDocument)
  then begin

    Rule :=
      TStandardInternalDocumentSignerListChangingRule.Create(
        TDocumentFormalizationServiceRegistry.Instance.GetDocumentFullNameCompilationService,
        TEmployeeSubordinationSpecificationRegistry.Instance.GetEmployeeIsSameAsOrReplacingSignerForOthersSpecification,
        TEmployeeSubordinationSpecificationRegistry.Instance.GetAreEmployeesSubLeadersOfSameLeaderSpecification,
        TEmployeeSubordinationSpecificationRegistry.Instance.GetAreEmployeesSecretariesOfSameLeaderSpecification,
        TEmployeeSubordinationSpecificationRegistry.Instance.GetEmployeeIsLeaderForOtherSpecification,
        TEmployeeDistributionSpecificationRegistry.Instance.GetEmployeesWorkGroupMembershipSpecification
      );

  end

  else if DocumentKind.InheritsFrom(TPersonnelOrder) then begin

    Rule :=
      TPersonnelOrderSignerListChangingRule.Create(
        TDocumentFormalizationServiceRegistry.Instance.GetDocumentFullNameCompilationService,
        TEmployeeSubordinationSpecificationRegistry.Instance.GetEmployeeIsSameAsOrReplacingSignerForOthersSpecification,
        TEmployeeSubordinationSpecificationRegistry.Instance.GetAreEmployeesSubLeadersOfSameLeaderSpecification,
        TEmployeeSubordinationSpecificationRegistry.Instance.GetAreEmployeesSecretariesOfSameLeaderSpecification,
        TEmployeeSubordinationSpecificationRegistry.Instance.GetEmployeeIsLeaderForOtherSpecification,
        TEmployeeDistributionSpecificationRegistry.Instance.GetEmployeesWorkGroupMembershipSpecification,
        TPersonnelOrderSearchServiceRegistry.Instance.GetPersonnelOrderSignerListFinder
      );

  end

  else begin

    Rule :=
      TStandardEmployeeDocumentSignerListChangingRule.Create(
        TDocumentFormalizationServiceRegistry.Instance.GetDocumentFullNameCompilationService,
        TEmployeeSubordinationSpecificationRegistry.Instance.GetEmployeeIsSameAsOrReplacingSignerForOthersSpecification,
        TEmployeeSubordinationSpecificationRegistry.Instance.GetAreEmployeesSubLeadersOfSameLeaderSpecification,
        TEmployeeSubordinationSpecificationRegistry.Instance.GetAreEmployeesSecretariesOfSameLeaderSpecification,
        TEmployeeSubordinationSpecificationRegistry.Instance.GetEmployeeIsLeaderForOtherSpecification,
        TEmployeeDistributionSpecificationRegistry.Instance.GetEmployeesWorkGroupMembershipSpecification
      );
      
  end;

  RegisterSignerListChangingRule(DocumentKind, Rule);
  
end;

procedure TDocumentSigningRuleRegistry.RegisterStandardSigningPerformingRule(
  DocumentKind: TDocumentClass);
begin

  RegisterSigningPerformingRule(
    DocumentKind,
    TStandardEmployeeDocumentSigningPerformingRule.Create(
      TEmployeeSubordinationSpecificationRegistry.Instance.GetEmployeeIsSameAsOrReplacingSignerForOthersSpecification,
      TDocumentFormalizationServiceRegistry.Instance.GetDocumentFullNameCompilationService,
      TDocumentDraftingRuleRegistry.Instance.GetDocumentDraftingRule(DocumentKind)
    )
  );
  
end;

procedure TDocumentSigningRuleRegistry.RegisterStandardSigningRejectingPerformingRule(
  DocumentKind: TDocumentClass);
begin

  if DocumentKind.InheritsFrom(TPersonnelOrder) then begin

    RegisterSigningRejectingPerformingRule(
      DocumentKind,
      TPersonnelOrderSigningRejectingRule.Create(
        TEmployeeSubordinationSpecificationRegistry.Instance.GetEmployeeIsSameAsOrReplacingSignerForOthersSpecification,
        TDocumentFormalizationServiceRegistry.Instance.GetDocumentFullNameCompilationService,
        TPersonnelOrderControlServiceRegistry.Instance.GetPersonnelOrderControlService
      )
    );

  end

  else begin

    RegisterSigningRejectingPerformingRule(
      DocumentKind,
      TStandardEmployeeDocumentSigningRejectingPerformingRule.Create(
        TEmployeeSubordinationSpecificationRegistry.Instance.GetEmployeeIsSameAsOrReplacingSignerForOthersSpecification,
        TDocumentFormalizationServiceRegistry.Instance.GetDocumentFullNameCompilationService
      )
    );

  end;

end;

procedure TDocumentSigningRuleRegistry.RegisterStandardSigningSendingRule(
  DocumentKind: TDocumentClass);
begin

  RegisterSigningSendingRule(
    DocumentKind,
    TStandardSigningDocumentSendingRule.Create(
      TDocumentDraftingRuleRegistry.Instance.GetDocumentDraftingRule(DocumentKind),
      TEmployeeSubordinationSpecificationRegistry.Instance.GetEmployeeIsSameAsOrDeputyOfEmployeesSpecification,
      TDocumentFormalizationServiceRegistry.Instance.GetDocumentFullNameCompilationService,
      TEmployeeSubordinationSpecificationRegistry.Instance.GetAreEmployeesSubLeadersOfSameLeaderSpecification,
      TEmployeeSubordinationSpecificationRegistry.Instance.GetAreEmployeesSecretariesOfSameLeaderSpecification
    )
  );
  
end;

procedure TDocumentSigningRuleRegistry.RegisterAllStandardDocumentSigningRules(
  DocumentKind: TDocumentClass);
begin

  RegisterStandardSignerListChangingRule(DocumentKind);
  RegisterStandardSigningPerformingRule(DocumentKind);
  RegisterStandardSigningRejectingPerformingRule(DocumentKind);
  RegisterStandardSigningSendingRule(DocumentKind);
  RegisterStandardDocumentSigningMarkingRule(DocumentKind);

end;

procedure TDocumentSigningRuleRegistry.RegisterDocumentSigningMarkingRule(
  DocumentKind: TDocumentClass;
  DocumentSigningMarkingRule: IDocumentSigningMarkingRule);
begin

  FSigningMarkingRuleRegistry.RegisterInterface(
    DocumentKind,
    DocumentSigningMarkingRule
  );
  
end;

end.
