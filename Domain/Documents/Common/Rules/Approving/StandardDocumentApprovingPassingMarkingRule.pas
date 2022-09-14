unit StandardDocumentApprovingPassingMarkingRule;

interface

uses

  StandardEmployeeDocumentWorkingRule,
  EmployeeIsSameAsOrReplacingForOthersSpecification,
  IDocumentUnit,
  EmployeeDocumentWorkingRule,
  DocumentFullNameCompilationService,
  AreEmployeesSecretariesOfSameLeaderSpecification,
  Employee,
  SysUtils,
  Classes;

type

  TDocumentApprovingPassingMarkingRuleException = class (TEmployeeDocumentWorkingRuleException)

  end;
  
  TStandardDocumentApprovingPassingMarkingRule =
    class (TStandardEmployeeDocumentWorkingRule)

      protected

        FAreEmployeesSecretariesOfSameLeaderSpecification:
          IAreEmployeesSecretariesOfSameLeaderSpecification;
          
        procedure InternalEnsureThatIsSatisfiedFor(
          Employee: TEmployee;
          Document: IDocument
        ); override;

        procedure InternalEnsureThatIsSatisfiedForEmployeeOnly(
          Employee: TEmployee;
          Document: IDocument
        ); override;

      protected

        procedure RaiseExceptionIfDocumentIsAtNotAllowableStage(
          Document: IDocument
        );

        procedure RaiseExceptionIfEmployeeHasNoRightsForMarkingDocumentAsApprovingPassed(
          Employee: TEmployee;
          Document: IDocument
        );

      public

        constructor Create(
        
          EmployeeIsSameAsOrReplacingForOthersSpecification:
            IEmployeeIsSameAsOrReplacingForOthersSpecification;

          AreEmployeesSecretariesOfSameLeaderSpecification:
            IAreEmployeesSecretariesOfSameLeaderSpecification;

          DocumentFullNameCompilationService:
            IDocumentFullNameCompilationService
            
        );

    end;
  
implementation

uses

  Document,
  IDomainObjectUnit,
  IDomainObjectListUnit;

{ TStandardDocumentApprovingPassingMarkingRule }

constructor TStandardDocumentApprovingPassingMarkingRule.Create(
  EmployeeIsSameAsOrReplacingForOthersSpecification: IEmployeeIsSameAsOrReplacingForOthersSpecification;
  AreEmployeesSecretariesOfSameLeaderSpecification: IAreEmployeesSecretariesOfSameLeaderSpecification;
  DocumentFullNameCompilationService: IDocumentFullNameCompilationService);
begin

  inherited Create(
    EmployeeIsSameAsOrReplacingForOthersSpecification,
    DocumentFullNameCompilationService
  );

  FAreEmployeesSecretariesOfSameLeaderSpecification :=
    AreEmployeesSecretariesOfSameLeaderSpecification;
    
end;

procedure TStandardDocumentApprovingPassingMarkingRule.
  InternalEnsureThatIsSatisfiedFor(
    Employee: TEmployee;
    Document: IDocument
  );
begin

  InternalEnsureThatIsSatisfiedForEmployeeOnly(
    Employee, Document
  );
  
end;

procedure TStandardDocumentApprovingPassingMarkingRule.
  InternalEnsureThatIsSatisfiedForEmployeeOnly(
    Employee: TEmployee;
    Document: IDocument
  );
begin

  RaiseExceptionIfDocumentIsAtNotAllowableStage(Document);

  RaiseExceptionIfEmployeeHasNoRightsForMarkingDocumentAsApprovingPassed(
    Employee, Document
  );

end;

procedure TStandardDocumentApprovingPassingMarkingRule.
  RaiseExceptionIfDocumentIsAtNotAllowableStage(
    Document: IDocument
  );
begin

  if not Document.IsApproving then
    raise TDocumentApprovingPassingMarkingRuleException.CreateFmt(
            'Документ "%s" не может быть ' +
            'отмечен, как согласованный ' +
            'или несогласованный, поскольку ' +
            'он не находится на согласовании',
            [
              FDocumentFullNameCompilationService.CompileFullNameForDocument(
                Document
              )
            ]
          );
  
end;

procedure TStandardDocumentApprovingPassingMarkingRule.
  RaiseExceptionIfEmployeeHasNoRightsForMarkingDocumentAsApprovingPassed(
    Employee: TEmployee;
    Document: IDocument
);
begin

  if not Document.IsSentToSigning
     and (
       FEmployeeIsSameAsOrReplacingForOthersSpecification.
         IsEmployeeSameAsOrReplacingForOtherEmployee(
            Employee, Document.Author
         )
       or
       FAreEmployeesSecretariesOfSameLeaderSpecification.
         AreEmployeesSecretariesOfSameLeader(
            Employee, Document.Author
         )
     )
  then Exit;


  if
    not
    TDocument(Document.Self)
      .Specifications
        .DocumentSigningSpecification
          .IsEmployeeAnyOfDocumentSignersOrOnesCanMarkDocumentAsSigned(
            Employee, Document
          )
  then begin

    raise TDocumentApprovingPassingMarkingRuleException.CreateFmt(
            'У сотрудника "%s" недостаточно ' +
            'прав для завершения цикла ' +
            'согласования документа "%s"',
            [
              Employee.FullName,
              FDocumentFullNameCompilationService.CompileFullNameForDocument(
                Document
              )
            ]
          );

  end;

end;

end.
