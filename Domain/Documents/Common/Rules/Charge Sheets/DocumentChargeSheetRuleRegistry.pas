unit DocumentChargeSheetRuleRegistry;

interface

uses

  DocumentChargeSheetOverlappedPerformingRule,
  DocumentChargeSheetWorkingRule,
  DocumentChargeSheetWorkingRules,
  DocumentChargeSheetViewingRule,
  DocumentChargeSheetChangingRule,
  DocumentChargeSheetPerformingRule,
  DocumentChargeSheetRemovingRule,
  DocumentChargeSheetIssuingRule,
  DomainException,
  Document,
  DocumentChargeSheet,
  TypeObjectRegistry,
  SysUtils;

type

  TDocumentChargeSheetRuleRegistry = class

    private

      class var FInstance: TDocumentChargeSheetRuleRegistry;

      class function GetInstance: TDocumentChargeSheetRuleRegistry; static;

    private

      FChargeSheetChangingRuleRegistry: TTypeObjectRegistry;
      FChargeSheetRemovingRuleRegistry: TTypeObjectRegistry;
      FChargeSheetOverlappedPerformingRuleRegistry: TTypeObjectRegistry;
      FChargeSheetPerformingRuleRegistry: TTypeObjectRegistry;
      FChargeSheetIssuingRuleRegistry: TTypeObjectRegistry;
      FChargeSheetViewingRuleRegistry: TTypeObjectRegistry;

    public

      procedure RegisterDocumentChargeSheetChangingRule(
        DocumentChargeSheetKind: TDocumentChargeSheetClass;
        DocumentChargeSheetChangingRule: IDocumentChargeSheetChangingRule
      );

      procedure RegisterStandardDocumentChargeSheetChangingRule(
        DocumentChargeSheetKind: TDocumentChargeSheetClass
      );

      function GetDocumentChargeSheetChangingRule(
        DocumentChargeSheetKind: TDocumentChargeSheetClass
      ): IDocumentChargeSheetChangingRule;

    public

      function GetDocumentChargeSheetRemovingRule(
        DocumentChargeSheetKind: TDocumentChargeSheetClass
      ): IDocumentChargeSheetRemovingRule;

      procedure RegisterDocumentChargeSheetRemovingRule(
        DocumentChargeSheetKind: TDocumentChargeSheetClass;
        DocumentChargeSheetChangingRule: IDocumentChargeSheetRemovingRule
      );

      procedure RegisterStandardDocumentChargeSheetRemovingRule(
        DocumentChargeSheetKind: TDocumentChargeSheetClass
      );
      
    public

      procedure RegisterDocumentChargeSheetOverlappedPerformingRule(
        DocumentChargeSheetKind: TDocumentChargeSheetClass;
        DocumentChargeSheetOverlappedPerformingRule: IDocumentChargeSheetOverlappedPerformingRule
      );

      procedure RegisterStandardDocumentChargeSheetOverlappedPerformingRule(
        DocumentChargeSheetKind: TDocumentChargeSheetClass
      );

      function GetDocumentChargeSheetOverlappedPerformingRule(
        DocumentChargeSheetKind: TDocumentChargeSheetClass
      ): IDocumentChargeSheetOverlappedPerformingRule;

    public

      procedure RegisterDocumentChargeSheetPerformingRule(
        DocumentChargeSheetKind: TDocumentChargeSheetClass;
        DocumentChargeSheetPerformingRule: IDocumentChargeSheetPerformingRule
      );

      procedure RegisterStandardDocumentChargeSheetPerformingRule(
        DocumentChargeSheetKind: TDocumentChargeSheetClass
      );

      function GetDocumentChargeSheetPerformingRule(
        DocumentChargeSheetKind: TDocumentChargeSheetClass
      ): IDocumentChargeSheetPerformingRule;

    public

      procedure RegisterDocumentChargeSheetViewingRule(
        DocumentChargeSheetKind: TDocumentChargeSheetClass;
        DocumentChargeSheetViewingRule: IDocumentChargeSheetViewingRule
      );

      procedure RegisterStandardDocumentChargeSheetViewingRule(
        DocumentChargeSheetKind: TDocumentChargeSheetClass
      );

      function GetDocumentChargeSheetViewingRule(
        DocumentChargeSheetKind: TDocumentChargeSheetClass
      ): IDocumentChargeSheetViewingRule;

    public

      procedure RegisterDocumentChargeSheetIssuingRule(
        DocumentChargeSheetKind: TDocumentChargeSheetClass;
        DocumentChargeSheetIssuingRule: IDocumentChargeSheetIssuingRule
      );

      procedure RegisterStandardDocumentChargeSheetIssuingRule(
        DocumentChargeSheetKind: TDocumentChargeSheetClass
      );

      function GetDocumentChargeSheetIssuingRule(
        DocumentChargeSheetKind: TDocumentChargeSheetClass
      ): IDocumentChargeSheetIssuingRule;

    public

      procedure RegisterAllStandardDocumentChargeSheetRules(
        DocumentChargeSheetKind: TDocumentChargeSheetClass
      );

      function GetDocumentChargeSheetWorkingRules(
        DocumentChargeSheetKind: TDocumentChargeSheetClass
      ): TDocumentChargeSheetWorkingRules;

    public

      destructor Destroy; override;
      constructor Create;

      class property Instance: TDocumentChargeSheetRuleRegistry
      read GetInstance;

  end;


implementation

uses

  DocumentAcquaitanceSheet,
  DocumentPerformingSheet,
  StandardDocumentChargeSheetChangingRule,
  StandardDocumentChargeSheetRemovingRule,
  StandardDocumentChargeSheetPerformingRule,
  StandardDocumentChargeSheetOverlappedPerformingRule,
  StandardDocumentChargeSheetViewingRule,
  StandardDocumentPerformingSheetIssuingRule,
  StandardDocumentAcquaitanceSheetIssuingRule,
  EmployeeSubordinationSpecificationRegistry,
  EmployeeDistributionSpecificationRegistry;

{ TDocumentChargeSheetRuleRegistry }

constructor TDocumentChargeSheetRuleRegistry.Create;
begin

  inherited;

  FChargeSheetChangingRuleRegistry := TTypeObjectRegistry.CreateInMemoryTypeObjectRegistry;
  FChargeSheetRemovingRuleRegistry := TTypeObjectRegistry.CreateInMemoryTypeObjectRegistry;
  FChargeSheetOverlappedPerformingRuleRegistry := TTypeObjectRegistry.CreateInMemoryTypeObjectRegistry;
  FChargeSheetPerformingRuleRegistry := TTypeObjectRegistry.CreateInMemoryTypeObjectRegistry;
  FChargeSheetViewingRuleRegistry := TTypeObjectRegistry.CreateInMemoryTypeObjectRegistry;
  FChargeSheetIssuingRuleRegistry := TTypeObjectRegistry.CreateInMemoryTypeObjectRegistry;
  
  FChargeSheetChangingRuleRegistry.UseSearchByNearestAncestorTypeIfTargetObjectNotFound := True;
  FChargeSheetOverlappedPerformingRuleRegistry.UseSearchByNearestAncestorTypeIfTargetObjectNotFound := True;
  FChargeSheetPerformingRuleRegistry.UseSearchByNearestAncestorTypeIfTargetObjectNotFound := True;
  FChargeSheetViewingRuleRegistry.UseSearchByNearestAncestorTypeIfTargetObjectNotFound := True;

end;

destructor TDocumentChargeSheetRuleRegistry.Destroy;
begin

  FreeAndNil(FChargeSheetChangingRuleRegistry);
  FreeAndNil(FChargeSheetRemovingRuleRegistry);
  FreeAndNil(FChargeSheetOverlappedPerformingRuleRegistry);
  FreeAndNil(FChargeSheetPerformingRuleRegistry);
  FreeAndNil(FChargeSheetViewingRuleRegistry);

  inherited;

end;

function TDocumentChargeSheetRuleRegistry.GetDocumentChargeSheetChangingRule(
  DocumentChargeSheetKind: TDocumentChargeSheetClass): IDocumentChargeSheetChangingRule;
begin

  Result :=
    IDocumentChargeSheetChangingRule(
      FChargeSheetChangingRuleRegistry.GetInterface(
        DocumentChargeSheetKind
      )
    );
    
end;

function TDocumentChargeSheetRuleRegistry.GetDocumentChargeSheetIssuingRule(
  DocumentChargeSheetKind: TDocumentChargeSheetClass): IDocumentChargeSheetIssuingRule;
begin

  Result :=
    IDocumentChargeSheetIssuingRule(
      FChargeSheetIssuingRuleRegistry.GetInterface(DocumentChargeSheetKind)
    );

end;

function TDocumentChargeSheetRuleRegistry.GetDocumentChargeSheetOverlappedPerformingRule(
  DocumentChargeSheetKind: TDocumentChargeSheetClass): IDocumentChargeSheetOverlappedPerformingRule;
begin

  Result :=
    IDocumentChargeSheetOverlappedPerformingRule(
      FChargeSheetOverlappedPerformingRuleRegistry.GetInterface(
        DocumentChargeSheetKind
      )
    );
    
end;

function TDocumentChargeSheetRuleRegistry.GetDocumentChargeSheetPerformingRule(
  DocumentChargeSheetKind: TDocumentChargeSheetClass): IDocumentChargeSheetPerformingRule;
begin

  Result :=
    IDocumentChargeSheetPerformingRule(
      FChargeSheetPerformingRuleRegistry.GetInterface(
        DocumentChargeSheetKind
      )
    );
    
end;

function TDocumentChargeSheetRuleRegistry.GetDocumentChargeSheetRemovingRule(
  DocumentChargeSheetKind: TDocumentChargeSheetClass): IDocumentChargeSheetRemovingRule;
begin

  Result :=
    IDocumentChargeSheetRemovingRule(
      FChargeSheetRemovingRuleRegistry.GetInterface(DocumentChargeSheetKind)
    );
    
end;

function TDocumentChargeSheetRuleRegistry.GetDocumentChargeSheetViewingRule(
  DocumentChargeSheetKind: TDocumentChargeSheetClass): IDocumentChargeSheetViewingRule;
begin

  Result :=
    IDocumentChargeSheetViewingRule(
      FChargeSheetViewingRuleRegistry.GetInterface(
        DocumentChargeSheetKind
      )
    );

end;

function TDocumentChargeSheetRuleRegistry.
  GetDocumentChargeSheetWorkingRules(
    DocumentChargeSheetKind: TDocumentChargeSheetClass
  ): TDocumentChargeSheetWorkingRules;
begin

  Result :=
    TDocumentChargeSheetWorkingRules.Create(
      GetDocumentChargeSheetViewingRule(DocumentChargeSheetKind),
      GetDocumentChargeSheetChangingRule(DocumentChargeSheetKind),
      GetDocumentChargeSheetRemovingRule(DocumentChargeSheetKind),
      GetDocumentChargeSheetPerformingRule(DocumentChargeSheetKind),
      GetDocumentChargeSheetOverlappedPerformingRule(DocumentChargeSheetKind),
      GetDocumentChargeSheetIssuingRule(DocumentChargeSheetKind)
    );
  
end;

class function TDocumentChargeSheetRuleRegistry.
  GetInstance: TDocumentChargeSheetRuleRegistry;
begin

  if not Assigned(FInstance) then
    FInstance := TDocumentChargeSheetRuleRegistry.Create;

  Result := FInstance;

end;

procedure TDocumentChargeSheetRuleRegistry.RegisterDocumentChargeSheetChangingRule(
  DocumentChargeSheetKind: TDocumentChargeSheetClass;
  DocumentChargeSheetChangingRule: IDocumentChargeSheetChangingRule);
begin

  FChargeSheetChangingRuleRegistry.RegisterInterface(
    DocumentChargeSheetKind,
    DocumentChargeSheetChangingRule
  );

end;

procedure TDocumentChargeSheetRuleRegistry.RegisterDocumentChargeSheetIssuingRule(
  DocumentChargeSheetKind: TDocumentChargeSheetClass;
  DocumentChargeSheetIssuingRule: IDocumentChargeSheetIssuingRule
);
begin

  FChargeSheetIssuingRuleRegistry.RegisterInterface(
    DocumentChargeSheetKind,
    DocumentChargeSheetIssuingRule
  );
  
end;

procedure TDocumentChargeSheetRuleRegistry.RegisterDocumentChargeSheetOverlappedPerformingRule(
  DocumentChargeSheetKind: TDocumentChargeSheetClass;
  DocumentChargeSheetOverlappedPerformingRule: IDocumentChargeSheetOverlappedPerformingRule);
begin

  FChargeSheetOverlappedPerformingRuleRegistry.RegisterInterface(
    DocumentChargeSheetKind,
    DocumentChargeSheetOverlappedPerformingRule
  );

end;

procedure TDocumentChargeSheetRuleRegistry.RegisterDocumentChargeSheetPerformingRule(
  DocumentChargeSheetKind: TDocumentChargeSheetClass;
  DocumentChargeSheetPerformingRule: IDocumentChargeSheetPerformingRule);
begin

  FChargeSheetPerformingRuleRegistry.RegisterInterface(
    DocumentChargeSheetKind,
    DocumentChargeSheetPerformingRule
  );
  
end;

procedure TDocumentChargeSheetRuleRegistry.RegisterDocumentChargeSheetRemovingRule(
  DocumentChargeSheetKind: TDocumentChargeSheetClass;
  DocumentChargeSheetChangingRule: IDocumentChargeSheetRemovingRule);
begin

  FChargeSheetRemovingRuleRegistry.RegisterInterface(
    DocumentChargeSheetKind,
    DocumentChargeSheetChangingRule
  );
  
end;

procedure TDocumentChargeSheetRuleRegistry.RegisterDocumentChargeSheetViewingRule(
  DocumentChargeSheetKind: TDocumentChargeSheetClass;
  DocumentChargeSheetViewingRule: IDocumentChargeSheetViewingRule);
begin

  FChargeSheetViewingRuleRegistry.RegisterInterface(
    DocumentChargeSheetKind,
    DocumentChargeSheetViewingRule
  );
  
end;

procedure TDocumentChargeSheetRuleRegistry.RegisterStandardDocumentChargeSheetChangingRule(
  DocumentChargeSheetKind: TDocumentChargeSheetClass);
begin

  RegisterDocumentChargeSheetChangingRule(
    DocumentChargeSheetKind,
    TStandardDocumentChargeSheetChangingRule.Create(
      TEmployeeSubordinationSpecificationRegistry.Instance.GetEmployeeIsSameAsOrDeputySpecification
    )
  );

end;

procedure TDocumentChargeSheetRuleRegistry
  .RegisterStandardDocumentChargeSheetIssuingRule(
    DocumentChargeSheetKind: TDocumentChargeSheetClass
  );
var
    ChargeSheetIssuingRule: IDocumentChargeSheetIssuingRule;
begin

  if DocumentChargeSheetKind.InheritsFrom(TDocumentPerformingSheet) then begin

    ChargeSheetIssuingRule :=
      TStandardDocumentPerformingSheetIssuingRule.Create(
        TEmployeeSubordinationSpecificationRegistry.Instance.GetEmployeeIsSameAsOrDeputySpecification,
        GetDocumentChargeSheetPerformingRule(DocumentChargeSheetKind)
      );

  end

  else if DocumentChargeSheetKind.InheritsFrom(TDocumentAcquaitanceSheet) then
  begin

    ChargeSheetIssuingRule :=
      TStandardDocumentAcquaitanceSheetIssuingRule.Create(
        TEmployeeSubordinationSpecificationRegistry.Instance.GetEmployeeIsSameAsOrDeputySpecification
      );

  end

  else begin

    Raise TDomainException.Create(
      'Program error. Unknown charge sheet type to issuing rule registration'
    );
    
  end;
  
  RegisterDocumentChargeSheetIssuingRule(
    DocumentChargeSheetKind,
    ChargeSheetIssuingRule
  );
  
end;

procedure TDocumentChargeSheetRuleRegistry.RegisterStandardDocumentChargeSheetOverlappedPerformingRule(
  DocumentChargeSheetKind: TDocumentChargeSheetClass);
begin

  RegisterDocumentChargeSheetOverlappedPerformingRule(
    DocumentChargeSheetKind,
    TStandardDocumentChargeSheetOverlappedPerformingRule.Create(
      TEmployeeSubordinationSpecificationRegistry.Instance.GetEmployeeIsSameAsOrDeputySpecification
    )
  );
  
end;

procedure TDocumentChargeSheetRuleRegistry.RegisterStandardDocumentChargeSheetPerformingRule(
  DocumentChargeSheetKind: TDocumentChargeSheetClass);
var
    PerformingRule: IDocumentChargeSheetPerformingRule;
begin

  RegisterDocumentChargeSheetPerformingRule(
    DocumentChargeSheetKind,
    TStandardDocumentChargeSheetPerformingRule.Create(
      TEmployeeSubordinationSpecificationRegistry.Instance.GetEmployeeIsSameAsOrDeputySpecification
    )
  );
  
end;

procedure TDocumentChargeSheetRuleRegistry.RegisterStandardDocumentChargeSheetRemovingRule(
  DocumentChargeSheetKind: TDocumentChargeSheetClass);
begin

  RegisterDocumentChargeSheetRemovingRule(
    DocumentChargeSheetKind,
    TStandardDocumentChargeSheetRemovingRule.Create(
      TEmployeeSubordinationSpecificationRegistry
        .Instance
          .GetEmployeeIsSameAsOrDeputySpecification
    )
  );

end;

procedure TDocumentChargeSheetRuleRegistry.RegisterStandardDocumentChargeSheetViewingRule(
  DocumentChargeSheetKind: TDocumentChargeSheetClass);
begin

  RegisterDocumentChargeSheetViewingRule(
    DocumentChargeSheetKind,
    TStandardDocumentChargeSheetViewingRule.Create(
      TEmployeeSubordinationSpecificationRegistry.Instance.GetEmployeeIsSameAsOrDeputySpecification,
      TEmployeeSubordinationSpecificationRegistry.Instance.GetEmployeeIsSecretaryForAnyOfEmployeesSpecification,
      TEmployeeDistributionSpecificationRegistry.Instance.GetWorkspaceEmployeeDistributionSpecification
    )
  );
  
end;

procedure TDocumentChargeSheetRuleRegistry.RegisterAllStandardDocumentChargeSheetRules(
  DocumentChargeSheetKind: TDocumentChargeSheetClass
 );
begin

  RegisterStandardDocumentChargeSheetChangingRule(DocumentChargeSheetKind);
  RegisterStandardDocumentChargeSheetRemovingRule(DocumentChargeSheetKind);
  RegisterStandardDocumentChargeSheetViewingRule(DocumentChargeSheetKind);
  RegisterStandardDocumentChargeSheetPerformingRule(DocumentChargeSheetKind);
  RegisterStandardDocumentChargeSheetOverlappedPerformingRule(DocumentChargeSheetKind);
  RegisterStandardDocumentChargeSheetIssuingRule(DocumentChargeSheetKind);

end;

end.

