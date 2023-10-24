unit StandardDocumentRemovingRule;

interface

uses

  DocumentRemovingRule,
  StandardEmployeeDocumentWorkingRule,
  Employee,
  IDocumentUnit,
  SysUtils,
  Classes;

type

  TStandardDocumentRemovingRule =
    class (TStandardEmployeeDocumentWorkingRule, IDocumentRemovingRule)

      protected

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

{ TStandardDocumentRemovingRule }

procedure TStandardDocumentRemovingRule.InternalEnsureThatIsSatisfiedFor(
  Employee: TEmployee;
  Document: IDocument
);
begin

  if
    Document.IsSentToSigning or
    Document.IsSigned
  then begin

    raise TDocumentRemovingRuleException.CreateFmt(
      'Сотрудник "%s" не может удалить ' +
      'документ, который находится на ' +
      'недопустимой для этого стадии рабочего цикла',
      [
        Employee.FullName
      ]
    );

  end;
  
  InternalEnsureThatIsSatisfiedForEmployeeOnly(Employee, Document);

end;

procedure TStandardDocumentRemovingRule.
  InternalEnsureThatIsSatisfiedForEmployeeOnly(
    Employee: TEmployee;
    Document: IDocument
  );
begin

  if not Document.Author.IsSameAs(Employee) then begin

    raise TDocumentRemovingRuleException.CreateFmt(
      'Сотрудник "%s" не может удалить документ, ' +
      'поскольку не является его автором',
      [
        Employee.FullName
      ]
    );
    
  end;

end;

end.
