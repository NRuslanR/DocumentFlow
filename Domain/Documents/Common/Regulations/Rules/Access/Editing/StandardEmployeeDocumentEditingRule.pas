unit StandardEmployeeDocumentEditingRule;

interface

uses

  StandardEmployeeDocumentWorkingRule,
  IDocumentUnit,
  EmployeeIsSameAsOrReplacingForOthersSpecification,
  DocumentFullNameCompilationService,
  AreEmployeesSubLeadersOfSameLeaderSpecification,
  AreEmployeesSecretariesOfSameLeaderSpecification,
  EmployeeDocumentWorkingRule,
  Employee,
  SysUtils,
  Classes;

type

  TEmployeeDocumentEditingRuleException = class (TEmployeeDocumentWorkingRuleException)

  end;

  TStandardEmployeeDocumentEditingRule =
    class (TStandardEmployeeDocumentWorkingRule)

      protected

        FAreEmployeesSubLeadersOfSameLeaderSpecification:
          IAreEmployeesSubLeadersOfSameLeaderSpecification;

        FAreEmployeesSecretariesOfSameLeaderSpecification:
          IAreEmployeesSecretariesOfSameLeaderSpecification;

      protected

        function HasEmployeeRightsForDocumentEditing(
          Employee: TEmployee;
          Document: IDocument
        ): Boolean; virtual;
        
        procedure RaiseExceptionIfDocumentIsAtNotAllowedWorkCycleStageForEmployee(
          Document: IDocument;
          Employee: TEmployee
        );

        procedure RaiseEmployeeHasNotRightsForDocumentEditing(
          Employee: TEmployee;
          Document: IDocument
        );

      protected

        function IsEmployeeDocumentAuthorOrHisDeputyAllowedEditing(
          Employee: TEmployee;
          Document: IDocument
        ): Boolean;

        function IsEmployeeOneOfDocumentSignersOrDeputyAllowedEditing(
          Employee: TEmployee;
          Document: IDocument
        ): Boolean;
        
        procedure InternalEnsureThatIsSatisfiedFor(
          Employee: TEmployee;
          Document: IDocument
        ); override;

        procedure InternalEnsureThatIsSatisfiedForEmployeeOnly(
          Employee: TEmployee;
          Document: IDocument
        ); override;

      public

        destructor Destroy; override;

        constructor Create(
        
          EmployeeIsSameAsOrReplacingForOthersSpecification:
            IEmployeeIsSameAsOrReplacingForOthersSpecification;

          DocumentFullNameCompilationService:
            IDocumentFullNameCompilationService;

          AreEmployeesSubLeadersOfSameLeaderSpecification:
            IAreEmployeesSubLeadersOfSameLeaderSpecification;

          AreEmployeesSecretariesOfSameLeaderSpecification:
            IAreEmployeesSecretariesOfSameLeaderSpecification

        );

    end;
    
implementation

uses

  IDomainObjectListUnit;
  
{ TStandardEmployeeDocumentEditingRule }


constructor TStandardEmployeeDocumentEditingRule.Create(

  EmployeeIsSameAsOrReplacingForOthersSpecification:
    IEmployeeIsSameAsOrReplacingForOthersSpecification;

  DocumentFullNameCompilationService: IDocumentFullNameCompilationService;

  AreEmployeesSubLeadersOfSameLeaderSpecification:
    IAreEmployeesSubLeadersOfSameLeaderSpecification;

  AreEmployeesSecretariesOfSameLeaderSpecification:
    IAreEmployeesSecretariesOfSameLeaderSpecification

);
begin

  inherited Create(
    EmployeeIsSameAsOrReplacingForOthersSpecification,
    DocumentFullNameCompilationService
  );

  FAreEmployeesSubLeadersOfSameLeaderSpecification :=
    AreEmployeesSubLeadersOfSameLeaderSpecification;

  FAreEmployeesSecretariesOfSameLeaderSpecification :=
    AreEmployeesSecretariesOfSameLeaderSpecification;
    
end;

destructor TStandardEmployeeDocumentEditingRule.Destroy;
begin

  inherited;

end;

procedure TStandardEmployeeDocumentEditingRule.
  InternalEnsureThatIsSatisfiedFor(
    Employee: TEmployee;
    Document: IDocument
  );
begin

  InternalEnsureThatIsSatisfiedForEmployeeOnly(
    Employee, Document
  );
  
end;

procedure TStandardEmployeeDocumentEditingRule.
  InternalEnsureThatIsSatisfiedForEmployeeOnly(
    Employee: TEmployee;
    Document: IDocument
  );
begin

  RaiseExceptionIfDocumentIsAtNotAllowedWorkCycleStageForEmployee(
    Document, Employee
  );

  if not HasEmployeeRightsForDocumentEditing(Employee, Document) then
    RaiseEmployeeHasNotRightsForDocumentEditing(Employee, Document);
  
end;

function TStandardEmployeeDocumentEditingRule.HasEmployeeRightsForDocumentEditing(
  Employee: TEmployee;
  Document: IDocument
): Boolean;
begin

  Result :=
    IsEmployeeDocumentAuthorOrHisDeputyAllowedEditing(Employee, Document)
    or (
      IsEmployeeOneOfDocumentSignersOrDeputyAllowedEditing(Employee, Document)
      and not Document.IsRejectedFromSigning
    );
    
end;

procedure TStandardEmployeeDocumentEditingRule.RaiseEmployeeHasNotRightsForDocumentEditing(
  Employee: TEmployee; Document: IDocument);
begin

  Raise TEmployeeDocumentEditingRuleException.CreateFmt(
    'Сотрудник "%s" не имеет полномочий для ' +
    'внесения изменений в документ "%s"',
    [
      Employee.FullName,
      FDocumentFullNameCompilationService.CompileFullNameForDocument(Document)
    ]
  );
  
end;

procedure TStandardEmployeeDocumentEditingRule.
  RaiseExceptionIfDocumentIsAtNotAllowedWorkCycleStageForEmployee(
    Document: IDocument;
    Employee: TEmployee
  );
begin

  if Document.IsSigned then begin

    raise TEmployeeDocumentEditingRuleException.CreateFmt(
            'В документ "%s" уже не могут ' +
            'вноситься изменения, поскольку ' +
            'он подписан',
            [
              FDocumentFullNameCompilationService.CompileFullNameForDocument(
                Document
              )
            ]
          );

  end;

  if Document.IsApproving then begin

    raise TEmployeeDocumentEditingRuleException.CreateFmt(
            'В документ "%s" не могут вноситься ' +
            'изменения, поскольку на данный момент ' +
            'он находится на этапе согласования',
            [
              FDocumentFullNameCompilationService.CompileFullNameForDocument(
                Document
              )
            ]
          );

  end;
  
end;

function TStandardEmployeeDocumentEditingRule.
  IsEmployeeDocumentAuthorOrHisDeputyAllowedEditing(
    Employee: TEmployee;
    Document: IDocument
  ): Boolean;
begin

  if not Assigned(Document.Author) then begin

    Result := False;
    Exit;
    
  end;
  
  Result :=
    (
      FEmployeeIsSameAsOrReplacingForOthersSpecification.
        IsEmployeeSameAsOrReplacingForOtherEmployeeOrViceVersa(
          Employee, Document.Author
        )

      or

      FAreEmployeesSubLeadersOfSameLeaderSpecification.
        AreEmployeesSubLeadersOfSameLeader(
          Employee, Document.Author
        )

      or

      FAreEmployeesSecretariesOfSameLeaderSpecification.
        AreEmployeesSecretariesOfSameLeader(
          Employee, Document.Author
        )
    )
    and not (
      Document.IsSigning or
      Document.IsSentToSigning or
      Document.IsSigned
    );

end;

function TStandardEmployeeDocumentEditingRule.
  IsEmployeeOneOfDocumentSignersOrDeputyAllowedEditing(
    Employee: TEmployee;
    Document: IDocument
  ): Boolean;
var
    SpecificationResult:
      TEmployeeIsSameAsOrReplacingForOthersSpecificationResult;

    DocumentSigners: TEmployees;
begin

  DocumentSigners := nil;
  SpecificationResult := nil;

  try

    DocumentSigners := Document.FetchAllSigners;
    
    SpecificationResult :=
      FEmployeeIsSameAsOrReplacingForOthersSpecification.
        IsEmployeeSameAsOrReplacingForAnyOfEmployees(
          Employee, DocumentSigners
        );

    Result := SpecificationResult.IsSatisfied;

  finally

    FreeAndNil(SpecificationResult);
    FreeAndNil(DocumentSigners);
    
  end;

end;

end.
