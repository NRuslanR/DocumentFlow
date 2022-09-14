{ refactor: ���������� �� ��������� ������� }

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
            '�������� "%s" ��� ��������� �� ' +
            '����������',
            [
              FDocumentFullNameCompilationService.CompileFullNameForDocument(
                Document
              )
            ]
          );

  end;

  if Document.IsPerformed then begin

    raise TPerformingDocumentSendingRuleException.CreateFmt(
            '������ �������� �� ���������� ' +
            '�������� "%s", ��������� �� ��� ' +
            '��� �������� �����',
            [
              FDocumentFullNameCompilationService.CompileFullNameForDocument(
                Document
              )
            ]
          );

  end;

  if not Document.IsSigned then begin

    raise TPerformingDocumentSendingRuleException.CreateFmt(
            '������ �������� �� ���������� ' +
            '�������� "%s", ��������� �� ��� ' +
            '�� ��������',
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
            '��������� "%s" �� ����� ��������� ' +
            '�������� "%s" �� ����������, ' +
            '��������� �� �������� ����� �� ' +
            '����������� ����� ��������� ��� ' +
            '����������� �����������',
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
            '��� �������� ��������� "%s" ' +
            '�� ���������� �� ������ ' +
            '���������',
            [
              FDocumentFullNameCompilationService.CompileFullNameForDocument(
                Document
              )
            ]
          );

  end;
  
end;

end.
