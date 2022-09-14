unit StandardSigningDocumentSendingRule;

interface

uses

  StandardEmployeeDocumentWorkingRule,
  DocumentDraftingRule,
  EmployeeIsSameAsOrReplacingForOthersSpecification,
  DocumentFullNameCompilationService,
  AreEmployeesSubLeadersOfSameLeaderSpecification,
  AreEmployeesSecretariesOfSameLeaderSpecification,
  IDocumentUnit,
  EmployeeDocumentWorkingRule,
  Employee,
  SysUtils,
  Classes;

type

  TSigningDocumentSendingRuleException = class (TEmployeeDocumentWorkingRuleException)

  end;

  TStandardSigningDocumentSendingRule =
    class (TStandardEmployeeDocumentWorkingRule)

      protected

        FDocumentDraftingRule:
          IDocumentDraftingRule;

        FAreEmployeesSubLeadersOfSameLeaderSpecification:
          IAreEmployeesSubLeadersOfSameLeaderSpecification;

        FAreEmployeesSecretariesOfSameLeaderSpecification:
          IAreEmployeesSecretariesOfSameLeaderSpecification;
          
        procedure RaiseExceptionIfDocumentIsAtNotAllowedWorkCycleStage(
          Document: IDocument;
          SendingEmployee: TEmployee
        );
        
        procedure RaiseExceptionIfEmployeeHasNotRightsForSendingDocumentToSigning(
          Document: IDocument;
          SendingEmployee: TEmployee
        );

        procedure RaiseExceptionIfDocumentNotCorrectlyWrittenForSendingToSigning(
          Document: IDocument;
          SendingEmployee: TEmployee
        );

        procedure RaiseExceptionIfDocumentSignersWasNotBeAssigned(
          Document: IDocument
        );
        
        procedure InternalEnsureThatIsSatisfiedFor(
          Employee: TEmployee;
          Document: IDocument
        ); override;

        procedure InternalEnsureThatIsSatisfiedForEmployeeOnly(
          Employee: TEmployee;
          Document: IDocument
        ); override;

      public

        constructor Create(

          DocumentDraftingRule:
            IDocumentDraftingRule;
            
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

  Document,
  IDomainObjectListUnit;

{ TStandardSigningDocumentSendingRule }

constructor TStandardSigningDocumentSendingRule.Create(

  DocumentDraftingRule:
    IDocumentDraftingRule;

  EmployeeIsSameAsOrReplacingForOthersSpecification:
    IEmployeeIsSameAsOrReplacingForOthersSpecification;

  DocumentFullNameCompilationService:
    IDocumentFullNameCompilationService;

  AreEmployeesSubLeadersOfSameLeaderSpecification:
    IAreEmployeesSubLeadersOfSameLeaderSpecification;

  AreEmployeesSecretariesOfSameLeaderSpecification:
    IAreEmployeesSecretariesOfSameLeaderSpecification

);
begin

  inherited
    Create(
      EmployeeIsSameAsOrReplacingForOthersSpecification,
      DocumentFullNameCompilationService
    );

  FDocumentDraftingRule :=
    DocumentDraftingRule;

  FAreEmployeesSubLeadersOfSameLeaderSpecification :=
    AreEmployeesSubLeadersOfSameLeaderSpecification;

  FAreEmployeesSecretariesOfSameLeaderSpecification :=
    AreEmployeesSecretariesOfSameLeaderSpecification;
    
end;

procedure TStandardSigningDocumentSendingRule.
  InternalEnsureThatIsSatisfiedFor(
    Employee: TEmployee;
    Document: IDocument
  );
begin

  InternalEnsureThatIsSatisfiedForEmployeeOnly(Employee, Document);

  RaiseExceptionIfDocumentSignersWasNotBeAssigned(Document);
  
  RaiseExceptionIfDocumentNotCorrectlyWrittenForSendingToSigning(
    Document, Employee
  );
  
end;

procedure TStandardSigningDocumentSendingRule.
  InternalEnsureThatIsSatisfiedForEmployeeOnly(
    Employee: TEmployee;
    Document: IDocument
  );
begin

  RaiseExceptionIfDocumentIsAtNotAllowedWorkCycleStage(Document, Employee);

  RaiseExceptionIfEmployeeHasNotRightsForSendingDocumentToSigning(
    Document, Employee
  );

end;

procedure TStandardSigningDocumentSendingRule.
  RaiseExceptionIfDocumentIsAtNotAllowedWorkCycleStage(
    Document: IDocument;
    SendingEmployee: TEmployee
  );
begin

  if Document.IsSentToSigning then begin

    raise TSigningDocumentSendingRuleException.CreateFmt(
            'Документ "%s" уже находится ' +
            'на подписании',
            [
              FDocumentFullNameCompilationService.CompileFullNameForDocument(
                Document
              )
            ]
          );

  end;

  if Document.IsSigned then begin

    raise TSigningDocumentSendingRuleException.CreateFmt(
            'Документ "%s" уже подписан',
            [
              FDocumentFullNameCompilationService.CompileFullNameForDocument(
                Document
              )
            ]
          );

  end;

  if Document.IsApproving then begin

    raise TSigningDocumentSendingRuleException.CreateFmt(
      'Документ "%s" находится ' +
      'на этапе согласования',
      [
        FDocumentFullNameCompilationService.CompileFullNameForDocument(
          Document
        )
      ]
    );

  end;

  if Document.IsNotApproved then begin

    Raise TSigningDocumentSendingRuleException.CreateFmt(
      'Документ "%s" не прошёл стадию согласования ' +
      'для отправки на подпись',
      [
        FDocumentFullNameCompilationService.CompileFullNameForDocument(Document)
      ]
    );

  end;

end;

procedure TStandardSigningDocumentSendingRule.
  RaiseExceptionIfDocumentNotCorrectlyWrittenForSendingToSigning(
    Document: IDocument;
    SendingEmployee: TEmployee
  );
begin

  FDocumentDraftingRule.EnsureThatDocumentDraftedCorrectly(Document);
          
end;

procedure TStandardSigningDocumentSendingRule.
  RaiseExceptionIfDocumentSignersWasNotBeAssigned(
    Document: IDocument
  );
begin

  if Document.Signings.IsEmpty then
    raise TSigningDocumentSendingRuleException.CreateFmt(
            'Для отправки документа "%s" ' +
            'на подписание не указаны ' +
            'подписанты',
            [
              FDocumentFullNameCompilationService.CompileFullNameForDocument(
                Document
              )
            ]
          );
  
end;

procedure TStandardSigningDocumentSendingRule.
  RaiseExceptionIfEmployeeHasNotRightsForSendingDocumentToSigning(
    Document: IDocument;
    SendingEmployee: TEmployee
  );
begin

  if
    TDocument(Document.Self)
      .Specifications
        .DocumentSigningSpecification
          .IsEmployeeAnyOfDocumentSignersOrOnesCanMarkDocumentAsSigned(
            SendingEmployee, Document
          )
  then begin

    raise TSigningDocumentSendingRuleException.CreateFmt(
      'Сотрудник "%s" не может отправить ' +
      'документ на подпись, поскольку сам ' +
      'может его подписать или отметить подписанным',
      [
        SendingEmployee.FullName
      ]
    );

  end;

  if
      not (
        FEmployeeIsSameAsOrReplacingForOthersSpecification.
          IsEmployeeSameAsOrReplacingForOtherEmployee(
            SendingEmployee, Document.Author
          )

        or

        FEmployeeIsSameAsOrReplacingForOthersSpecification.
          IsEmployeeSameAsOrReplacingForOtherEmployee(
            Document.Author, SendingEmployee
          )
          
        or

        FAreEmployeesSecretariesOfSameLeaderSpecification.
          AreEmployeesSecretariesOfSameLeader(
            SendingEmployee, Document.Author
          )

        or

        FAreEmployeesSubLeadersOfSameLeaderSpecification
          .AreEmployeesSubLeadersOfSameLeader(
            SendingEmployee, Document.Author
          )
      )

  then begin

    raise TSigningDocumentSendingRuleException.CreateFmt(
            'Документ "%s" не может быть ' +
            'передан на подписание, ' +
            'поскольку сотрудник "%s" ' +
            'не является автором документа ' +
            'или его исполняющим обязанности',
            [
              FDocumentFullNameCompilationService.CompileFullNameForDocument(
                Document
              ),
              SendingEmployee.FullName
            ]
          );

  end;

end;

end.
