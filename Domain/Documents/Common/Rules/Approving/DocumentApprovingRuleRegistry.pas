unit DocumentApprovingRuleRegistry;

interface

uses

  DocumentApproverListChangingRule,
  DocumentApprovingPerformingRule,
  DocumentApprovingRejectingPerformingRule,
  EmployeeDocumentWorkingRule,
  Document,
  TypeObjectRegistry,
  SysUtils;

type

  TDocumentApprovingRuleRegistry = class

    private

      class var FInstance: TDocumentApprovingRuleRegistry;

      class function GetInstance: TDocumentApprovingRuleRegistry; static;

    private

      FApproverListChangingRuleRegistry: TTypeObjectRegistry;
      FApprovingPerformingRuleRegistry: TTypeObjectRegistry;
      FApprovingRejectingPerformingRuleRegistry: TTypeObjectRegistry;
      FApprovingDocumentSendingRuleRegistry: TTypeObjectRegistry;
      FApprovingPassingMarkingRuleRegistry: TTypeObjectRegistry;
      
    public

      procedure  RegisterDocumentApproverListChangingRule(
        DocumentKind: TDocumentClass;
        DocumentApproverListChangingRule: IDocumentApproverListChangingRule
      );

      procedure RegisterStandardDocumentApproverListChangingRule(
        DocumentKind: TDocumentClass
      );

      function GetDocumentApproverListChangingRule(
        DocumentKind: TDocumentClass
      ): IDocumentApproverListChangingRule;

    public

      procedure RegisterDocumentApprovingPerformingRule(
        DocumentKind: TDocumentClass;
        DocumentApprovingPerformingRule: IDocumentApprovingPerformingRule
      );

      function GetDocumentApprovingPerformingRule(
        DocumentKind: TDocumentClass
      ): IDocumentApprovingPerformingRule;

      procedure RegisterStandardDocumentApprovingPerformingRule(
        DocumentKind: TDocumentClass
      );

    public

      function GetDocumentApprovingRejectingPerformingRule(
        DocumentKind: TDocumentClass
      ): IDocumentApprovingRejectingPerformingRule;
        
      procedure RegisterDocumentApprovingRejectingPerformingRule(
        DocumentKind: TDocumentClass;
        DocumentApprovingRejectingPerformingRule: IDocumentApprovingRejectingPerformingRule
      );

      procedure RegisterStandardDocumentApprovingRejectingPerformingRule(
        DocumentKind: TDocumentClass
      );

    public

      function GetApprovingDocumentSendingRule(
        DocumentKind: TDocumentClass
      ): IEmployeeDocumentWorkingRule;

      procedure RegisterApprovingDocumentSendingRule(
        DocumentKind: TDocumentClass;
        ApprovingDocumentSendingRule: IEmployeeDocumentWorkingRule
      );

      procedure RegisterStandardApprovingDocumentSendingRule(
        DocumentKind: TDocumentClass
      );

    public

      function GetDocumentApprovingPassingMarkingRule(
        DocumentKind: TDocumentClass
      ): IEmployeeDocumentWorkingRule;

      procedure RegisterDocumentApprovingPassingMarkingRule(
        DocumentKind: TDocumentClass;
        DocumentApprovingPassingMarkingRule: IEmployeeDocumentWorkingRule
      );

      procedure RegisterStandardDocumentApprovingPassingMarkingRule(
        DocumentKind: TDocumentClass
      );

    public

      procedure RegisterAllStandardDocumentApprovingRules(
        DocumentKind: TDocumentClass
      );

    public

      destructor Destroy; override;
      constructor Create;

      class property Instance: TDocumentApprovingRuleRegistry
      read GetInstance;

  end;

  


implementation

uses

  StandardDocumentApproverListChangingRule,
  StandardDocumentApprovingPerformingRule,
  StandardDocumentApprovingRejectingPerformingRule,
  StandardApprovingDocumentSendingRule,
  StandardDocumentApprovingPassingMarkingRule,
  DocumentDraftingRuleRegistry,
  EmployeeSubordinationSpecificationRegistry,
  DocumentFormalizationServiceRegistry;

{ TDocumentApprovingRuleRegistry }

constructor TDocumentApprovingRuleRegistry.Create;
begin

  inherited;

  FApproverListChangingRuleRegistry := TTypeObjectRegistry.CreateInMemoryTypeObjectRegistry;
  FApprovingPerformingRuleRegistry := TTypeObjectRegistry.CreateInMemoryTypeObjectRegistry;
  FApprovingRejectingPerformingRuleRegistry := TTypeObjectRegistry.CreateInMemoryTypeObjectRegistry;
  FApprovingDocumentSendingRuleRegistry := TTypeObjectRegistry.CreateInMemoryTypeObjectRegistry;
  FApprovingPassingMarkingRuleRegistry := TTypeObjectRegistry.CreateInMemoryTypeObjectRegistry;

  FApproverListChangingRuleRegistry.UseSearchByNearestAncestorTypeIfTargetObjectNotFound := True;
  FApprovingPerformingRuleRegistry.UseSearchByNearestAncestorTypeIfTargetObjectNotFound := True;
  FApprovingRejectingPerformingRuleRegistry.UseSearchByNearestAncestorTypeIfTargetObjectNotFound := True;
  FApprovingDocumentSendingRuleRegistry.UseSearchByNearestAncestorTypeIfTargetObjectNotFound := True;
  FApprovingPassingMarkingRuleRegistry.UseSearchByNearestAncestorTypeIfTargetObjectNotFound := True;
   
end;

destructor TDocumentApprovingRuleRegistry.Destroy;
begin

  FreeAndNil(FApproverListChangingRuleRegistry);
  FreeAndNil(FApprovingPerformingRuleRegistry);
  FreeAndNil(FApprovingRejectingPerformingRuleRegistry);
  FreeAndNil(FApprovingDocumentSendingRuleRegistry);
  FreeAndNil(FApprovingPassingMarkingRuleRegistry);
  
  inherited;

end;

function TDocumentApprovingRuleRegistry.GetApprovingDocumentSendingRule(
  DocumentKind: TDocumentClass): IEmployeeDocumentWorkingRule;
begin

  Result :=
    IEmployeeDocumentWorkingRule(
      FApprovingDocumentSendingRuleRegistry.GetInterface(
        DocumentKind
      )
    );

end;

function TDocumentApprovingRuleRegistry.GetDocumentApproverListChangingRule(
  DocumentKind: TDocumentClass): IDocumentApproverListChangingRule;
begin

  Result :=
    IDocumentApproverListChangingRule(
      FApproverListChangingRuleRegistry.GetInterface(
        DocumentKind
      )
    );

end;

function TDocumentApprovingRuleRegistry.GetDocumentApprovingPassingMarkingRule(
  DocumentKind: TDocumentClass): IEmployeeDocumentWorkingRule;
begin

  Result :=
    IEmployeeDocumentWorkingRule(
      FApprovingPassingMarkingRuleRegistry.GetInterface(
        DocumentKind
      )
    );
    
end;

function TDocumentApprovingRuleRegistry.GetDocumentApprovingPerformingRule(
  DocumentKind: TDocumentClass): IDocumentApprovingPerformingRule;
begin

  Result :=
    IDocumentApprovingPerformingRule(
      FApprovingPerformingRuleRegistry.GetInterface(DocumentKind)
    );
    
end;

function TDocumentApprovingRuleRegistry.GetDocumentApprovingRejectingPerformingRule(
  DocumentKind: TDocumentClass): IDocumentApprovingRejectingPerformingRule;
begin

  Result :=
    IDocumentApprovingRejectingPerformingRule(
      FApprovingRejectingPerformingRuleRegistry.GetInterface(
        DocumentKind
      )
    );
    
end;

class function TDocumentApprovingRuleRegistry.
  GetInstance: TDocumentApprovingRuleRegistry;
begin

  if not Assigned(FInstance) then
    FInstance := TDocumentApprovingRuleRegistry.Create;

  Result := FInstance;

end;

procedure TDocumentApprovingRuleRegistry.RegisterApprovingDocumentSendingRule(
  DocumentKind: TDocumentClass;
  ApprovingDocumentSendingRule: IEmployeeDocumentWorkingRule
);
begin

  FApprovingDocumentSendingRuleRegistry.RegisterInterface(
    DocumentKind,
    ApprovingDocumentSendingRule
  );
  
end;

procedure TDocumentApprovingRuleRegistry.RegisterDocumentApproverListChangingRule(
  DocumentKind: TDocumentClass;
  DocumentApproverListChangingRule: IDocumentApproverListChangingRule);
begin

  FApproverListChangingRuleRegistry.RegisterInterface(
    DocumentKind,
    DocumentApproverListChangingRule
  );

end;

procedure TDocumentApprovingRuleRegistry.RegisterDocumentApprovingPassingMarkingRule(
  DocumentKind: TDocumentClass;
  DocumentApprovingPassingMarkingRule: IEmployeeDocumentWorkingRule);
begin

  FApprovingPassingMarkingRuleRegistry.RegisterInterface(
    DocumentKind,
    DocumentApprovingPassingMarkingRule
  );
  
end;

procedure TDocumentApprovingRuleRegistry.RegisterDocumentApprovingPerformingRule(
  DocumentKind: TDocumentClass;
  DocumentApprovingPerformingRule: IDocumentApprovingPerformingRule);
begin

  FApprovingPerformingRuleRegistry.RegisterInterface(
    DocumentKind,
    DocumentApprovingPerformingRule
  );

end;

procedure TDocumentApprovingRuleRegistry.RegisterDocumentApprovingRejectingPerformingRule(
  DocumentKind: TDocumentClass;
  DocumentApprovingRejectingPerformingRule: IDocumentApprovingRejectingPerformingRule);
begin

  FApprovingRejectingPerformingRuleRegistry.RegisterInterface(
    DocumentKind,
    DocumentApprovingRejectingPerformingRule
  );

end;

procedure TDocumentApprovingRuleRegistry.RegisterStandardApprovingDocumentSendingRule(
  DocumentKind: TDocumentClass
);
begin

  RegisterApprovingDocumentSendingRule(
    DocumentKind,
    TStandardApprovingDocumentSendingRule.Create(
      TDocumentDraftingRuleRegistry.Instance.GetDocumentDraftingRule(DocumentKind),
      TEmployeeSubordinationSpecificationRegistry.Instance.GetEmployeeIsSameAsOrReplacingSignerForOthersSpecification,
      TEmployeeSubordinationSpecificationRegistry.Instance.GetAreEmployeesSubLeadersOfSameLeaderSpecification,
      TEmployeeSubordinationSpecificationRegistry.Instance.GetAreEmployeesSecretariesOfSameLeaderSpecification,
      TDocumentFormalizationServiceRegistry.Instance.GetDocumentFullNameCompilationService
    )
  );
  
end;

procedure TDocumentApprovingRuleRegistry.RegisterStandardDocumentApproverListChangingRule(
  DocumentKind: TDocumentClass);
begin

  RegisterDocumentApproverListChangingRule(
    DocumentKind,
    TStandardDocumentApproverListChangingRule.Create(
      TEmployeeSubordinationSpecificationRegistry.Instance.GetEmployeeIsSameAsOrReplacingSignerForOthersSpecification,
      TDocumentFormalizationServiceRegistry.Instance.GetDocumentFullNameCompilationService,
      TEmployeeSubordinationSpecificationRegistry.Instance.GetAreEmployeesSubLeadersOfSameLeaderSpecification,
      TEmployeeSubordinationSpecificationRegistry.Instance.GetAreEmployeesSecretariesOfSameLeaderSpecification
    )
  );

end;

procedure TDocumentApprovingRuleRegistry.RegisterStandardDocumentApprovingPassingMarkingRule(
  DocumentKind: TDocumentClass);
begin

  RegisterDocumentApprovingPassingMarkingRule(
    DocumentKind,
    TStandardDocumentApprovingPassingMarkingRule.Create(
      TEmployeeSubordinationSpecificationRegistry.Instance.GetEmployeeIsSameAsOrReplacingSignerForOthersSpecification,
      TEmployeeSubordinationSpecificationRegistry.Instance.GetAreEmployeesSecretariesOfSameLeaderSpecification,
      TDocumentFormalizationServiceRegistry.Instance.GetDocumentFullNameCompilationService
    )
  );
  
end;

procedure TDocumentApprovingRuleRegistry.RegisterStandardDocumentApprovingPerformingRule(
  DocumentKind: TDocumentClass);
begin

  RegisterDocumentApprovingPerformingRule(
    DocumentKind,
    TStandardDocumentApprovingPerformingRule.Create(
      TEmployeeSubordinationSpecificationRegistry.Instance.GetEmployeeIsSameAsOrReplacingSignerForOthersSpecification,
      TDocumentFormalizationServiceRegistry.Instance.GetDocumentFullNameCompilationService
    )
  );
  
end;

procedure TDocumentApprovingRuleRegistry.RegisterStandardDocumentApprovingRejectingPerformingRule(
  DocumentKind: TDocumentClass);
begin

  RegisterDocumentApprovingRejectingPerformingRule(
    DocumentKind,
    TStandardDocumentApprovingRejectingPerformingRule.Create(
      TEmployeeSubordinationSpecificationRegistry.Instance.GetEmployeeIsSameAsOrReplacingSignerForOthersSpecification,
      TDocumentFormalizationServiceRegistry.Instance.GetDocumentFullNameCompilationService
    )
  );
  
end;

procedure TDocumentApprovingRuleRegistry.RegisterAllStandardDocumentApprovingRules(
  DocumentKind: TDocumentClass
);
begin

  RegisterStandardDocumentApproverListChangingRule(DocumentKind);
  RegisterStandardDocumentApprovingPerformingRule(DocumentKind);
  RegisterStandardApprovingDocumentSendingRule(DocumentKind);
  RegisterStandardDocumentApprovingPassingMarkingRule(DocumentKind);
  RegisterStandardDocumentApprovingRejectingPerformingRule(DocumentKind);

end;

end.
