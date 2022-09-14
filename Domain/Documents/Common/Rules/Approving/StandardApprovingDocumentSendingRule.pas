unit StandardApprovingDocumentSendingRule;

interface

uses

  EmployeeIsSameAsOrReplacingForOthersSpecification,
  StandardEmployeeDocumentWorkingRule,
  EmployeeDocumentWorkingRule,
  AreEmployeesSubLeadersOfSameLeaderSpecification,
  AreEmployeesSecretariesOfSameLeaderSpecification,
  DocumentFullNameCompilationService,
  IDocumentUnit,
  DocumentDraftingRule,
  Employee,
  SysUtils,
  Classes;

type

  TDocumentApprovingDocumentSendingRuleException =
    class (TEmployeeDocumentWorkingRuleException)

    end;
    
  TStandardApprovingDocumentSendingRule =
    class (TStandardEmployeeDocumentWorkingRule)

      protected

        FDocumentDraftingRule: IDocumentDraftingRule;

        FAreEmployeesSubLeadersOfSameLeaderSpecification:
          IAreEmployeesSubLeadersOfSameLeaderSpecification;

        FAreEmployeesSecretariesOfSameLeaderSpecification:
          IAreEmployeesSecretariesOfSameLeaderSpecification;

      protected

        procedure RaiseExceptionIfDocumentIsNotAtAllowableStage(
          Document: IDocument
        );

        procedure RaiseExceptionIfEmployeeHasNotRightsForSendingDocumentToApproving(
          Employee: TEmployee;
          Document: IDocument
        );

        procedure RaiseExceptionIfDocumentApproversWasNotAssigned(
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

          AreEmployeesSubLeadersOfSameLeaderSpecification:
            IAreEmployeesSubLeadersOfSameLeaderSpecification;

          AreEmployeesSecretariesOfSameLeaderSpecification:
            IAreEmployeesSecretariesOfSameLeaderSpecification;

          DocumentFullNameCompilationService:
            IDocumentFullNameCompilationService
        );

    end;
    
implementation

uses

  Document,
  IDomainObjectListUnit;

{ TStandardApprovingDocumentSendingRule }

constructor TStandardApprovingDocumentSendingRule.Create(

  DocumentDraftingRule:
    IDocumentDraftingRule;
    
  EmployeeIsSameAsOrReplacingForOthersSpecification:
    IEmployeeIsSameAsOrReplacingForOthersSpecification;

  AreEmployeesSubLeadersOfSameLeaderSpecification:
    IAreEmployeesSubLeadersOfSameLeaderSpecification;

  AreEmployeesSecretariesOfSameLeaderSpecification:
    IAreEmployeesSecretariesOfSameLeaderSpecification;

  DocumentFullNameCompilationService: IDocumentFullNameCompilationService
);
begin

  inherited Create(
    EmployeeIsSameAsOrReplacingForOthersSpecification,
    DocumentFullNameCompilationService
  );

  FDocumentDraftingRule := DocumentDraftingRule;

  FAreEmployeesSubLeadersOfSameLeaderSpecification :=
    AreEmployeesSubLeadersOfSameLeaderSpecification;

  FAreEmployeesSecretariesOfSameLeaderSpecification :=
    AreEmployeesSecretariesOfSameLeaderSpecification;

end;

procedure TStandardApprovingDocumentSendingRule.
  InternalEnsureThatIsSatisfiedFor(
    Employee: TEmployee;
    Document: IDocument
  );
begin

  FDocumentDraftingRule.EnsureThatDocumentDraftedCorrectlyForApprovingSending(Document);
  
  InternalEnsureThatIsSatisfiedForEmployeeOnly(
    Employee, Document
  );
  
  RaiseExceptionIfDocumentApproversWasNotAssigned(Document);

end;

procedure TStandardApprovingDocumentSendingRule.
  InternalEnsureThatIsSatisfiedForEmployeeOnly(
    Employee: TEmployee;
    Document: IDocument
  );
begin

  RaiseExceptionIfDocumentIsNotAtAllowableStage(Document);
  
  RaiseExceptionIfEmployeeHasNotRightsForSendingDocumentToApproving(
    Employee, Document
  );

end;

procedure TStandardApprovingDocumentSendingRule.
  RaiseExceptionIfDocumentApproversWasNotAssigned(
    Document: IDocument
  );
begin

  if Document.Approvings.IsEmpty then begin

    raise TDocumentApprovingDocumentSendingRuleException.CreateFmt(
            '��� �������� ��������� "%s" ' +
            '�� ������������ �� ������� ' +
            '������������',
            [
              FDocumentFullNameCompilationService.CompileFullNameForDocument(
                Document
              )
            ]
          );

  end;

end;

procedure TStandardApprovingDocumentSendingRule.
  RaiseExceptionIfDocumentIsNotAtAllowableStage(
    Document: IDocument
  );
begin

  if Document.IsSigned then begin

    raise TDocumentApprovingDocumentSendingRuleException.CreateFmt(
            '�������� "%s" �� ����� ' +
            '��� ������� �� ������������, ' +
            '��� ��� �� ��� ��������',
            [
              FDocumentFullNameCompilationService.CompileFullNameForDocument(
                Document
              )
            ]
          );

  end;

  if Document.IsApproving then begin

    raise TDocumentApprovingDocumentSendingRuleException.CreateFmt(
            '�������� "%s" ��� ��������� ' +
            '�� ������������',
            [
              FDocumentFullNameCompilationService.CompileFullNameForDocument(
                Document
              )
            ]
          );

  end;

end;

procedure TStandardApprovingDocumentSendingRule.
  RaiseExceptionIfEmployeeHasNotRightsForSendingDocumentToApproving(
    Employee: TEmployee;
    Document: IDocument
  );
var
    IsEmployeeSigner: Boolean;
    IsEmployeeRelatedWithDocumentAuthor: Boolean;
begin

  if not (Document.IsSigning or Document.IsSentToSigning)
  then begin

    {
      <refactor: ��� ���������� ������ �
      ��������� ����� ������������ ������������.
      ��������������, ��������� refactor � ������
      ��������, ������� �������� ������ �������
      ������� ������
    }

    IsEmployeeRelatedWithDocumentAuthor :=
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
          );

    { refactor> }

  end

  else IsEmployeeRelatedWithDocumentAuthor := False;

  if not IsEmployeeRelatedWithDocumentAuthor then begin

    IsEmployeeSigner :=
      TDocument(Document.Self)
        .Specifications
          .DocumentSigningSpecification
            .IsEmployeeAnyOfDocumentSignersOrOnesCanMarkDocumentAsSigned(
              Employee, Document
            );

    if not IsEmployeeSigner or Document.IsRejectedFromSigning 
    then begin

      raise TDocumentApprovingDocumentSendingRuleException.CreateFmt(
        '��������� "%s" �� �������� ' +
        '������������ ������� ��� ' +
        '�������� ��������� "%s" �� ' +
        '������������',
        [
          Employee.FullName,
          FDocumentFullNameCompilationService.CompileFullNameForDocument(
            Document
          )
        ]
      );

    end;

  end;

end;

end.
