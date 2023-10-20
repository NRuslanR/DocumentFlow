unit StandardDocumentChargeSheetPerformingRule;

interface

uses

  StandardDocumentChargeSheetWorkingRule,
  Employee,
  IDocumentChargeSheetUnit,
  DocumentChargeSheet,
  DocumentChargeSheetWorkingRule,
  DocumentChargeSheetPerformingRule,
  SysUtils,
  Classes;

type

  TStandardDocumentChargeSheetPerformingRule =
    class (
      TStandardDocumentChargeSheetWorkingRule,
      IDocumentChargeSheetPerformingRule
    )

      protected

        procedure RaiseExceptionIfChargeSheetIsNotValid(
          DocumentChargeSheet: TDocumentChargeSheet;
          Employee: TEmployee
        );

        function IsChargeSheetValid(
          ChargeSheet: TDocumentChargeSheet;
          Employee: TEmployee;
          var ErrorMessage: String
        ): Boolean; virtual;

        procedure RaiseExceptionIfDocumentChargeSheetTimeFrameIsExpired(
          Employee: TEmployee;
          DocumentChargeSheet: TDocumentChargeSheet
        );

        procedure RaiseExceptionIfEmployeeHasNotRightsForDocumentChargeSheetPerforming(
          Employee: TEmployee;
          DocumentChargeSheet: TDocumentChargeSheet
        );

      protected

        procedure InternalEnsureThatIsSatisfiedFor(
          Employee: TEmployee;
          DocumentChargeSheet: TDocumentChargeSheet
        ); override;

    end;

implementation

uses

  DocumentAcquaitanceSheet;
  
{ TStandardDocumentChargeSheetPerformingRule }

procedure TStandardDocumentChargeSheetPerformingRule.
  InternalEnsureThatIsSatisfiedFor(
    Employee: TEmployee;
    DocumentChargeSheet: TDocumentChargeSheet
  );
begin

  RaiseExceptionIfChargeSheetIsNotValid(
    DocumentChargeSheet, Employee
  );
                                        
  RaiseExceptionIfDocumentChargeSheetTimeFrameIsExpired(
    Employee, DocumentChargeSheet
  );

  RaiseExceptionIfEmployeeHasNotRightsForDocumentChargeSheetPerforming(
    Employee, DocumentChargeSheet
  );

end;

procedure TStandardDocumentChargeSheetPerformingRule.
  RaiseExceptionIfChargeSheetIsNotValid(
    DocumentChargeSheet: TDocumentChargeSheet;
    Employee: TEmployee
  );
var
    ErrorMessage: String;
begin

  if not IsChargeSheetValid(DocumentChargeSheet, Employee, ErrorMessage)
  then begin

    raise TDocumentChargeSheetWorkingRuleException.Create(ErrorMessage);

  end;

end;

function TStandardDocumentChargeSheetPerformingRule.IsChargeSheetValid(
  ChargeSheet: TDocumentChargeSheet;
  Employee: TEmployee;
  var ErrorMessage: String
): Boolean;
begin

  Result := not ChargeSheet.IsPerformed;

  if not Result then begin

    ErrorMessage :=
      Format(
        'Поручение, выданное сотруднику "%s", уже исполнено',
        [
          ChargeSheet.Performer.FullName
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
