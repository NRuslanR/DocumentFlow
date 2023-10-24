{ refactor: избавитьс€ от кадрового приказа }

unit StandardPerformingDocumentSendingRule;

interface

uses

  StandardEmployeeDocumentWorkingRule,
  EmployeeIsSameAsOrReplacingForOthersSpecification,
  IDocumentUnit,
  PersonnelOrder,
  EmployeeDocumentWorkingRule,
  Employee,
  SysUtils,
  Classes;

type

  TPerformingDocumentSendingRuleException = class (TEmployeeDocumentWorkingRuleException)

  end;
  
  TStandardPerformingDocumentSendingRule =
    class (TStandardEmployeeDocumentWorkingRule)

      protected

        procedure RaiseExceptionIfDocumentIsAtNotAllowedWorkCycleStage(
          Document: IDocument;
          SendingEmployee: TEmployee
        );

        procedure RaiseExceptionIfDocumentChargesWasNotAssigned(
          Document: IDocument
        );

        procedure RaiseExceptionIfEmployeeHasNotRightsForSendingDocumentToPerforming(
          Document: IDocument;
          SendingEmployee: TEmployee
        );
        
        procedure InternalEnsureThatIsSatisfiedFor(
          Employee: TEmployee;
          Document: IDocument
        ); override;

        procedure InternalEnsureThatIsSatisfiedForEmployeeOnly(
          Employee: TEmployee;
          Document: IDocument
        ); override;
        
    end;


implementation

uses

  Document;

{ TStandardPerformingDocumentSendingRule }

procedure TStandardPerformingDocumentSendingRule.
  InternalEnsureThatIsSatisfiedFor(
    Employee: TEmployee;
    Document: IDocument
  );
begin

  InternalEnsureThatIsSatisfiedForEmployeeOnly(
    Employee, Document
  );

  RaiseExceptionIfDocumentChargesWasNotAssigned(Document);

end;

procedure TStandardPerformingDocumentSendingRule.
  InternalEnsureThatIsSatisfiedForEmployeeOnly(
    Employee: TEmployee;
    Document: IDocument
  );
begin

  RaiseExceptionIfDocumentIsAtNotAllowedWorkCycleStage(
    Document, Employee
  );
  
  RaiseExceptionIfEmployeeHasNotRightsForSendingDocumentToPerforming(
    Document, Employee
  );

end;

procedure TStandardPerformingDocumentSendingRule.
  RaiseExceptionIfDocumentIsAtNotAllowedWorkCycleStage(
    Document: IDocument;
    SendingEmployee: TEmployee
  );
begin

  if Document.IsPerforming then begin

    raise TPerformingDocumentSendingRuleException.CreateFmt(
            'ƒокумент "%s" уже находитс€ на ' +
            'исполнении',
            [
              FDocumentFullNameCompilationService.CompileFullNameForDocument(
                Document
              )
            ]
          );

  end;

  if Document.IsPerformed then begin

    raise TPerformingDocumentSendingRuleException.CreateFmt(
            'Ќельз€ передать на исполнение ' +
            'документ "%s", поскольку он уже ' +
            'был исполнен ранее',
            [
              FDocumentFullNameCompilationService.CompileFullNameForDocument(
                Document
              )
            ]
          );

  end;

  if not Document.IsSigned then begin

    raise TPerformingDocumentSendingRuleException.CreateFmt(
            'Ќельз€ передать на исполнение ' +
            'документ "%s", поскольку он ещЄ ' +
            'не подписан',
            [
              FDocumentFullNameCompilationService.CompileFullNameForDocument(
                Document
              )
            ]
          );

  end;

end;

procedure TStandardPerformingDocumentSendingRule.
  RaiseExceptionIfEmployeeHasNotRightsForSendingDocumentToPerforming(
    Document: IDocument;
    SendingEmployee: TEmployee
  );
begin

  if
    not
    TDocument(Document.Self)
      .Specifications
        .DocumentSigningSpecification
          .IsEmployeeAnyOfDocumentSignersOrOnesCanMarkDocumentAsSigned(SendingEmployee, Document)
  then begin

    raise TPerformingDocumentSendingRuleException.CreateFmt(
            '—отрудник "%s" не может отправить ' +
            'документ "%s" на исполнение, ' +
            'поскольку не €вл€етс€ одним из ' +
            'подписантов этого документа или ' +
            'исполн€ющим об€занности',
            [
              SendingEmployee.FullName,
              FDocumentFullNameCompilationService.CompileFullNameForDocument(
                Document
              )
            ]
          );

  end;
  
end;

procedure TStandardPerformingDocumentSendingRule.
  RaiseExceptionIfDocumentChargesWasNotAssigned(
    Document: IDocument
  );
begin

  if Document.Charges.IsEmpty then begin

    raise TPerformingDocumentSendingRuleException.CreateFmt(
            'ƒл€ отправки документа "%s" ' +
            'на исполнение не заданы ' +
            'поручени€',
            [
              FDocumentFullNameCompilationService.CompileFullNameForDocument(
                Document
              )
            ]
          );

  end;
  
end;

end.
