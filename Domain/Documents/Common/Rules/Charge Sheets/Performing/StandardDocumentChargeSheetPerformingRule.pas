unit StandardDocumentChargeSheetPerformingRule;

interface

uses

  StandardDocumentChargeSheetWorkingRule,
  Employee,
  IDocumentChargeSheetUnit,
  DocumentChargeSheet,
  DocumentChargeSheetWorkingRule,
  DocumentChargeSheetPerformingRule,
  IDocumentUnit,
  SysUtils,
  Classes;

type

  TStandardDocumentChargeSheetPerformingRule =
    class (
      TStandardDocumentChargeSheetWorkingRule,
      IDocumentChargeSheetPerformingRule
    )

      protected

        procedure RaiseExceptionIfDocumentChargeSheetAlreadyPerformed(
          DocumentChargeSheet: TDocumentChargeSheet
        );

        procedure RaiseExceptionIfDocumentChargeSheetTimeFrameIsExpired(
          Employee: TEmployee;
          DocumentChargeSheet: TDocumentChargeSheet
        );

        procedure RaiseExceptionIfEmployeeHasNotRightsForDocumentChargeSheetPerforming(
          Employee: TEmployee;
          DocumentChargeSheet: TDocumentChargeSheet
        );

        procedure RaiseExceptionIfDocumentStateIsNotValid(
          Employee: TEmployee;
          DocumentChargeSheet: TDocumentChargeSheet;
          Document: IDocument
        );

      protected

        procedure InternalEnsureThatIsSatisfiedFor(
          Employee: TEmployee;
          DocumentChargeSheet: TDocumentChargeSheet;
          Document: IDocument
        ); override;

    end;

implementation

uses

  DocumentAcquaitanceSheet;
  
{ TStandardDocumentChargeSheetPerformingRule }

procedure TStandardDocumentChargeSheetPerformingRule.
  InternalEnsureThatIsSatisfiedFor(
    Employee: TEmployee;
    DocumentChargeSheet: TDocumentChargeSheet;
    Document: IDocument
  );
begin

  RaiseExceptionIfDocumentStateIsNotValid(
    Employee, DocumentChargeSheet, Document
  );

  RaiseExceptionIfDocumentChargeSheetAlreadyPerformed(
    DocumentChargeSheet
  );
                                        
  RaiseExceptionIfDocumentChargeSheetTimeFrameIsExpired(
    Employee, DocumentChargeSheet
  );

  RaiseExceptionIfEmployeeHasNotRightsForDocumentChargeSheetPerforming(
    Employee, DocumentChargeSheet
  );

end;

procedure TStandardDocumentChargeSheetPerformingRule.
  RaiseExceptionIfDocumentChargeSheetAlreadyPerformed(
    DocumentChargeSheet: TDocumentChargeSheet
  );
begin

  if DocumentChargeSheet.IsPerformed then begin
  
    raise TDocumentChargeSheetWorkingRuleException.CreateFmt(
            'Поручение, выданное сотруднику "%s"' +
            ', уже исполнено',
            [
              DocumentChargeSheet.Performer.FullName
            ]
          );

  end;

end;

procedure TStandardDocumentChargeSheetPerformingRule.
  RaiseExceptionIfDocumentChargeSheetTimeFrameIsExpired(
    Employee: TEmployee;
    DocumentChargeSheet: TDocumentChargeSheet
  );
begin

  {
    Истекший промежуток времени на
    исполнение поручения не отменяет
    возможность его исполнения
    на данный момент
  }
  
end;

procedure TStandardDocumentChargeSheetPerformingRule
  .RaiseExceptionIfDocumentStateIsNotValid(
    Employee: TEmployee;
    DocumentChargeSheet: TDocumentChargeSheet;
    Document: IDocument
  );
begin

  if DocumentChargeSheet.DocumentId <> Document.Identity then begin

    Raise TDocumentChargeSheetWorkingRuleException.CreateFmt(
      'Поручение для сотрудника "%s" не может быть выполнено, ' +
      'поскольку не относится к документу',
      [
        DocumentChargeSheet.Performer.FullName
      ]
    );

  end;

  if
    not (DocumentChargeSheet is TDocumentAcquaitanceSheet)
    and Document.IsPerformed
  then begin

    Raise TDocumentChargeSheetWorkingRuleException.CreateFmt(
      'Поручение для сотрудника "%s" не может ' +
      'быть выполнено, поскольку документ уже выполнен',
      [
        DocumentChargeSheet.Performer.FullName
      ]
    );

  end;

end;

procedure TStandardDocumentChargeSheetPerformingRule.
  RaiseExceptionIfEmployeeHasNotRightsForDocumentChargeSheetPerforming(
    Employee: TEmployee;
    DocumentChargeSheet: TDocumentChargeSheet
  );
begin

  if not Assigned(DocumentChargeSheet.Performer) then begin

    Raise TDocumentChargeSheetWorkingRuleException.CreateFmt(
            'Сотрудник "%s" не может исполнить ' +
            'поручение, поскольку для него ' +
            'не был назначен исполнитель',
            [
              Employee.FullName
            ]
          );

  end;

  if
      not (
        FEmployeeIsSameAsOrDeputySpecification.
          IsEmployeeSameAsOrDeputyForOther(
            Employee, DocumentChargeSheet.Performer
          )
        or
        DocumentChargeSheet.Performer.IsSubLeaderFor(Employee)
      )

  then begin

    Raise TDocumentChargeSheetWorkingRuleException.CreateFmt(
            'Сотрудник "%s" не может исполнить ' +
            'поручение, поскольку не является ' +
            'исполняющим обязанности для ' +
            'назначенного исполнителя "%s"',
            [
              Employee.FullName,
              DocumentChargeSheet.Performer.FullName
            ]
          );

  end;

end;

end.
