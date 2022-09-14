unit StandardEmployeeDocumentViewingRule;

interface

uses

  EmployeeIsSameAsOrReplacingForOthersSpecification,
  EmployeeIsSecretaryForAnyOfEmployeesSpecification,
  DocumentFullNameCompilationService,
  StandardEmployeeDocumentWorkingRule,
  DocumentApprovingCycleResultFinder,
  AreEmployeesSubLeadersOfSameLeaderSpecification,
  AreEmployeesSecretariesOfSameLeaderSpecification,
  WorkspaceEmployeeDistributionSpecification,
  EmployeeDocumentWorkingRule,
  Document,
  IDocumentUnit,
  Employee,
  SysUtils,
  Classes;

type

  TEmployeeDocumentViewingRuleException = class (TEmployeeDocumentWorkingRuleException)

  end;

  TStandardEmployeeDocumentViewingRule =
    class (TStandardEmployeeDocumentWorkingRule)

      protected

        FEmployeeIsSecretaryForAnyOfEmployeesSpecification:
          IEmployeeIsSecretaryForAnyOfEmployeesSpecification;

        FAreEmployeesSubLeadersOfSameLeaderSpecification:
          IAreEmployeesSubLeadersOfSameLeaderSpecification;

        FAreEmployeesSecretariesOfSameLeaderSpecification:
          IAreEmployeesSecretariesOfSameLeaderSpecification;
          
        FWorkspaceEmployeeDistributionSpecification: IWorkspaceEmployeeDistributionSpecification;
        
        FDocumentApprovingCycleResultFinder: IDocumentApprovingCycleResultFinder;

        procedure InternalEnsureThatIsSatisfiedFor(
          Employee: TEmployee;
          Document: IDocument
        ); override;

        procedure InternalEnsureThatIsSatisfiedForEmployeeOnly(
          Employee: TEmployee;
          Document: IDocument
        ); override;

      protected

        function HasEmployeeAccessRightsForDocumentViewing(
          Employee: TEmployee;
          Document: IDocument
        ): Boolean; virtual;

      protected

        function HasEmployeeRelationshipWithDocumentAuthor(
          TargetEmployee, Author: TEmployee
        ): Boolean;

        function HasEmployeeRelationshipWithAnyOfOtherEmployees(
          TargetEmployee: TEmployee;
          OtherEmployees: TEmployees
        ): Boolean;

        function IsEmployeeWorkspaceIncludesAnyOfDocumentApproversFromApprovingCycles(
          Employee: TEmployee;
          Document: IDocument
        ): Boolean;

        procedure RaiseExceptionAboutThatEmployeeHasNotRightsForDocumentViewing(
          Employee: TEmployee; Document: IDocument
        );
        
      public

        constructor Create(

          DocumentApprovingCycleResultFinder:
            IDocumentApprovingCycleResultFinder;

          DocumentFullNameCompilationService:
            IDocumentFullNameCompilationService;

          EmployeeIsSecretaryForAnyOfEmployeesSpecification:
            IEmployeeIsSecretaryForAnyOfEmployeesSpecification;

          EmployeeIsSameAsOrReplacingForOthersSpecification:
            IEmployeeIsSameAsOrReplacingForOthersSpecification;

          AreEmployeesSubLeadersOfSameLeaderSpecification:
            IAreEmployeesSubLeadersOfSameLeaderSpecification;

          AreEmployeesSecretariesOfSameLeaderSpecification:
            IAreEmployeesSecretariesOfSameLeaderSpecification;

          WorkspaceEmployeeDistributionSpecification:
            IWorkspaceEmployeeDistributionSpecification

        );
        
    end;

implementation

uses

  DocumentApprovings,
  DocumentApprovingCycleResult,
  Disposable,
  IDomainObjectListUnit,
  IDomainObjectBaseListUnit,
  IDomainObjectBaseUnit,
  DocumentSignings;

{ TStandardEmployeeDocumentViewingRule }

constructor TStandardEmployeeDocumentViewingRule.Create(

  DocumentApprovingCycleResultFinder:
    IDocumentApprovingCycleResultFinder;

  DocumentFullNameCompilationService:
    IDocumentFullNameCompilationService;

  EmployeeIsSecretaryForAnyOfEmployeesSpecification:
    IEmployeeIsSecretaryForAnyOfEmployeesSpecification;

  EmployeeIsSameAsOrReplacingForOthersSpecification:
    IEmployeeIsSameAsOrReplacingForOthersSpecification;

  AreEmployeesSubLeadersOfSameLeaderSpecification:
    IAreEmployeesSubLeadersOfSameLeaderSpecification;

  AreEmployeesSecretariesOfSameLeaderSpecification:
    IAreEmployeesSecretariesOfSameLeaderSpecification;

  WorkspaceEmployeeDistributionSpecification:
    IWorkspaceEmployeeDistributionSpecification

);
begin

  inherited Create(
    EmployeeIsSameAsOrReplacingForOthersSpecification,
    DocumentFullNameCompilationService
  );

  FEmployeeIsSecretaryForAnyOfEmployeesSpecification :=
    EmployeeIsSecretaryForAnyOfEmployeesSpecification;

  FAreEmployeesSubLeadersOfSameLeaderSpecification :=
    AreEmployeesSubLeadersOfSameLeaderSpecification;

  FAreEmployeesSecretariesOfSameLeaderSpecification :=
    AreEmployeesSecretariesOfSameLeaderSpecification;
    
  FWorkspaceEmployeeDistributionSpecification := WorkspaceEmployeeDistributionSpecification;
  
  FDocumentApprovingCycleResultFinder := DocumentApprovingCycleResultFinder;
  
end;

function TStandardEmployeeDocumentViewingRule.HasEmployeeAccessRightsForDocumentViewing(
  Employee: TEmployee;
  Document: IDocument
): Boolean;
var
    DocumentSigners: TEmployees;
    DocumentPerformers: TEmployees;
    DocumentApprovers: TEmployees;

    FreeDocumentSigners: IDomainObjectList;
    FreeDocumentPerformers: IDOmainObjectList;
    FreeDocumentApprovers: IDomainObjectList;
begin

  if HasEmployeeRelationshipWithDocumentAuthor(Employee, Document.Author)
  then begin

    Result := True;
    Exit;

  end;

  DocumentSigners := Document.FetchAllSigners;

  FreeDocumentSigners := DocumentSigners;

  DocumentPerformers := Document.FetchAllPerformers;

  FreeDocumentPerformers := DocumentPerformers;

  DocumentApprovers := Document.FetchAllApprovers;

  FreeDocumentApprovers := DocumentApprovers;

  if HasEmployeeRelationshipWithAnyOfOtherEmployees(
        Employee, DocumentSigners
     )
     or
     HasEmployeeRelationshipWithAnyOfOtherEmployees(
        Employee, DocumentPerformers
     )
     or
     HasEmployeeRelationshipWithAnyOfOtherEmployees(
        Employee, DocumentApprovers
     )
  then begin

    Result := True;
    Exit;

  end;

  if FWorkspaceEmployeeDistributionSpecification.IsEmployeeWorkspaceIncludesAnyOfOtherEmployees(
        Employee, DocumentSigners
     )
     or
     FWorkspaceEmployeeDistributionSpecification.IsEmployeeWorkspaceIncludesAnyOfOtherEmployees(
        Employee, DocumentPerformers
     )
     or
     FWorkspaceEmployeeDistributionSpecification.IsEmployeeWorkspaceIncludesAnyOfOtherEmployees(
        Employee, DocumentApprovers
     )
  then begin

    Result := True;
    Exit;

  end;

  Result :=
    IsEmployeeWorkspaceIncludesAnyOfDocumentApproversFromApprovingCycles(
      Employee, Document
    );

end;

function TStandardEmployeeDocumentViewingRule.
  HasEmployeeRelationshipWithAnyOfOtherEmployees(
    TargetEmployee: TEmployee;
    OtherEmployees: TEmployees
  ): Boolean;
var ReplacingSpecificationResult:
      TEmployeeIsSameAsOrReplacingForOthersSpecificationResult;

    SecretarySpecificationResult:
      TEmployeeIsSecretaryForAnyOfEmployeesSpecificationResult;
begin

  SecretarySpecificationResult := nil;
  ReplacingSpecificationResult := nil;

  try

    SecretarySpecificationResult :=
      FEmployeeIsSecretaryForAnyOfEmployeesSpecification.
        IsEmployeeSecretaryForAnyOfEmployees(
          TargetEmployee, OtherEmployees
        );

    if SecretarySpecificationResult.IsSatisfied then begin

      Result := True;
      Exit;
      
    end;

    SecretarySpecificationResult.Destroy;
    
    SecretarySpecificationResult :=
      FEmployeeIsSecretaryForAnyOfEmployeesSpecification.
        AreAnyOfEmployeesSecretaryForOtherEmployee(
          OtherEmployees, TargetEmployee
        );

    if SecretarySpecificationResult.IsSatisfied then begin

      Result := True;
      Exit;
      
    end;

    ReplacingSpecificationResult :=
      FEmployeeIsSameAsOrReplacingForOthersSpecification.
        IsEmployeeSameAsOrReplacingForAnyOfEmployees(
          TargetEmployee, OtherEmployees
        );

    if ReplacingSpecificationResult.IsSatisfied then begin

      Result := True;
      Exit;
      
    end;

    ReplacingSpecificationResult.Destroy;

    ReplacingSpecificationResult :=
      FEmployeeIsSameAsOrReplacingForOthersSpecification.
        AreAnyOfEmployeesSameAsOrReplacingForOtherEmployee(
          OtherEmployees, TargetEmployee
        );

    Result := ReplacingSpecificationResult.IsSatisfied;

  finally

    FreeAndNil(SecretarySpecificationResult);
    FreeAndNil(ReplacingSpecificationResult);

  end;

end;

function TStandardEmployeeDocumentViewingRule.
  HasEmployeeRelationshipWithDocumentAuthor(
    TargetEmployee, Author: TEmployee
  ): Boolean;
begin

  Result :=
    FWorkspaceEmployeeDistributionSpecification.IsEmployeeWorkspaceIncludesOtherEmployee(
      TargetEmployee, Author
    );

  if Result then Exit;
  
  Result :=
    FEmployeeIsSameAsOrReplacingForOthersSpecification.
      IsEmployeeSameAsOrReplacingForOtherEmployee(
        TargetEmployee, Author
      );

  if Result then Exit;

  if TargetEmployee.IsLeader then begin

    Result :=
      FEmployeeIsSecretaryForAnyOfEmployeesSpecification.
        IsEmployeeSecretaryForOther(Author, TargetEmployee)
      or
      FEmployeeIsSameAsOrReplacingForOthersSpecification.
        IsEmployeeSameAsOrReplacingForOtherEmployee(
          Author, TargetEmployee
        );

  end

  else if TargetEmployee.IsSubLeaderForTopLevelEmployee then begin

    Result :=
      FEmployeeIsSecretaryForAnyOfEmployeesSpecification.
        IsEmployeeSecretaryForOther(
          Author,
          TargetEmployee.TopLevelEmployee
        )
      or
      FAreEmployeesSubLeadersOfSameLeaderSpecification.
        AreEmployeesSubLeadersOfSameLeader(
          TargetEmployee,
          Author
        );

  end

  else if TargetEmployee.IsSecretaryForTopLevelEmployee then begin

    Result :=
      FAreEmployeesSecretariesOfSameLeaderSpecification.
        AreEmployeesSecretariesOfSameLeader(
          TargetEmployee,
          Author
        );

  end;

end;

procedure TStandardEmployeeDocumentViewingRule.
  InternalEnsureThatIsSatisfiedFor(
    Employee: TEmployee;
    Document: IDocument
  );
begin

  if not HasEmployeeAccessRightsForDocumentViewing(Employee, Document)
  then begin

    RaiseExceptionAboutThatEmployeeHasNotRightsForDocumentViewing(
      Employee, Document
    );

  end;

end;

procedure TStandardEmployeeDocumentViewingRule.
  InternalEnsureThatIsSatisfiedForEmployeeOnly(
    Employee: TEmployee;
    Document: IDocument
  );
begin

  InternalEnsureThatIsSatisfiedFor(Employee, Document);

end;

function TStandardEmployeeDocumentViewingRule.
  IsEmployeeWorkspaceIncludesAnyOfDocumentApproversFromApprovingCycles(
    Employee: TEmployee;
    Document: IDocument
  ): Boolean;
var
    DocumentApprovingCycleResults: TDocumentApprovingCycleResults;
    Free: IDomainObjectBaseList;

    AllCycleResultsApprovers: TEmployees;
    FreeAllCycleResultsApprovers: IDomainObjectBaseList;
    
    ReplacingSpecificationResult: TEmployeeIsSameAsOrReplacingForOthersSpecificationResult;
    FreeReplacingSpecificationResult: IDisposable;
begin

  DocumentApprovingCycleResults :=
    FDocumentApprovingCycleResultFinder.FindAllApprovingCycleResultsForDocument(
      Document.Identity
    );

  Free := DocumentApprovingCycleResults;

  if
    not Assigned(DocumentApprovingCycleResults)
    or DocumentApprovingCycleResults.IsEmpty
  then begin

    Result := False;

    Exit;

  end;

  AllCycleResultsApprovers := DocumentApprovingCycleResults.FetchAllApprovers;

  FreeAllCycleResultsApprovers := AllCycleResultsApprovers;

  ReplacingSpecificationResult:=
  
    FEmployeeIsSameAsOrReplacingForOthersSpecification
      .IsEmployeeSameAsOrReplacingForAnyOfEmployees(
        Employee, AllCycleResultsApprovers
      );

  FreeReplacingSpecificationResult := ReplacingSpecificationResult;

  Result :=
    ReplacingSpecificationResult.IsSatisfied
    or
    FWorkspaceEmployeeDistributionSpecification
      .IsEmployeeWorkspaceIncludesAnyOfOtherEmployees(
        Employee, AllCycleResultsApprovers
      );

end;

procedure TStandardEmployeeDocumentViewingRule.RaiseExceptionAboutThatEmployeeHasNotRightsForDocumentViewing(
  Employee: TEmployee; Document: IDocument);
begin

  raise TEmployeeDocumentViewingRuleException.CreateFmt(
    'У сотрудника "%s" отсутствуют права для ' +
    'просмотра документа "%s"',
    [
      Employee.FullName,
      FDocumentFullNameCompilationService.CompileFullNameForDocument(
        Document
      )
    ]
  );
         
end;

end.
