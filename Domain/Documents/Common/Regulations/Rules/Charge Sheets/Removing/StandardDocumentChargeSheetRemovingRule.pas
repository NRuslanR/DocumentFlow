unit StandardDocumentChargeSheetRemovingRule;

interface

uses

  DocumentChargeSheetRemovingRule,
  StandardDocumentChargeSheetWorkingRule,
  IDocumentChargeSheetUnit,
  DocumentChargeSheetWorkingRule,
  DocumentChargeSheet,
  EmployeeIsSameAsOrDeputySpecification,
  Employee,
  SysUtils,
  Classes;

type

  TStandardDocumentChargeSheetRemovingRule =
    class (
      TStandardDocumentChargeSheetWorkingRule,
      IDocumentChargeSheetRemovingRule
    )

      protected

        procedure RaiseEmployeeIsNotSameAsChargeSheetIssuerOrHisDeputyException(
          Employee: TEmployee;
          ChargeSheet: TDocumentChargeSheet
        );

        procedure RaiseExceptionIfChargeSheetStateIsNotValid(
          ChargeSheet: TDocumentChargeSheet;
          Employee: TEmployee
        );

        function IsChargeSheetStateValid(
          ChargeSheet: TDocumentChargeSheet;
          Employee: TEmployee;
          var ErrorMessage: String
        ): Boolean; virtual;

        procedure RaiseExceptionIfEmployeeIsNotSameAsChargeSheetIssuerOrHisDeputy(
          Employee: TEmployee;
          ChargeSheet: TDocumentChargeSheet
        );

      public

        constructor Create(
          EmployeeIsSameAsOrDeputySpecification:
            IEmployeeIsSameAsOrDeputySpecification
        );

        procedure EnsureThatIsSatisfiedFor(
          Employee: TEmployee;
          DocumentChargeSheet: IDocumentChargeSheet
        ); virtual;

        function IsSatisfiedBy(
          Employee: TEmployee;
          DocumentChargeSheet: IDocumentChargeSheet
        ): Boolean; virtual;
        
    end;

implementation

uses

  DocumentAcquaitanceSheet;
  
{ TStandardDocumentChargeSheetRemovingRule }

constructor TStandardDocumentChargeSheetRemovingRule.Create(
  EmployeeIsSameAsOrDeputySpecification:
    IEmployeeIsSameAsOrDeputySpecification
);
begin

  inherited Create(EmployeeIsSameAsOrDeputySpecification);
    
end;

function TStandardDocumentChargeSheetRemovingRule.IsSatisfiedBy(
  Employee: TEmployee;
  DocumentChargeSheet: IDocumentChargeSheet
): Boolean;
begin

  try

    EnsureThatIsSatisfiedFor(Employee, DocumentChargeSheet);

    Result := True;

  except

    on E: TDocumentChargeSheetRemovingRuleException do Result := False;

  end;

end;

procedure TStandardDocumentChargeSheetRemovingRule.EnsureThatIsSatisfiedFor(
  Employee: TEmployee;
  DocumentChargeSheet: IDocumentChargeSheet
);
var
    ChargeSheetObj: TDocumentChargeSheet;
begin

  ChargeSheetObj := TDocumentChargeSheet(DocumentChargeSheet.Self);

  RaiseExceptionIfChargeSheetStateIsNotValid(ChargeSheetObj, Employee);
  
  RaiseExceptionIfEmployeeIsNotSameAsChargeSheetIssuerOrHisDeputy(
    Employee, ChargeSheetObj
  );

end;

procedure TStandardDocumentChargeSheetRemovingRule.
  RaiseExceptionIfEmployeeIsNotSameAsChargeSheetIssuerOrHisDeputy(
    Employee: TEmployee;
    ChargeSheet: TDocumentChargeSheet
  );
begin

  if
    not
    FEmployeeIsSameAsOrDeputySpecification
      .IsEmployeeSameAsOrDeputyForOtherOrViceVersa(
        Employee, ChargeSheet.Issuer
      )
  then begin

    RaiseEmployeeIsNotSameAsChargeSheetIssuerOrHisDeputyException(
      Employee, ChargeSheet
    );

  end;
  
end;

procedure TStandardDocumentChargeSheetRemovingRule.
  RaiseEmployeeIsNotSameAsChargeSheetIssuerOrHisDeputyException(
    Employee: TEmployee;
    ChargeSheet: TDocumentChargeSheet
  );
begin

  Raise TDocumentChargeSheetRemovingRuleException.CreateFmt(
    '—отрудник "%s" не €вл€етс€ ' +
    'исполн€ющим об€занности дл€ сотрудника "%s"',
    [
      Employee.FullName,
      ChargeSheet.Issuer.FullName
    ]
  );

end;

procedure TStandardDocumentChargeSheetRemovingRule.RaiseExceptionIfChargeSheetStateIsNotValid(
  ChargeSheet: TDocumentChargeSheet;
  Employee: TEmployee
);
var
    ErrorMessage: String;
begin

  if not IsChargeSheetStateValid(ChargeSheet, Employee, ErrorMessage)
  then begin

    Raise TDocumentChargeSheetRemovingRuleException.Create(ErrorMessage);

  end;

end;

function TStandardDocumentChargeSheetRemovingRule
  .IsChargeSheetStateValid(
    ChargeSheet: TDocumentChargeSheet;
    Employee: TEmployee;
    var ErrorMessage: String
  ): Boolean;
begin

  Result := not ChargeSheet.IsPerformed;

  if not Result then begin

    ErrorMessage :=
      Format(
        'ѕоручение дл€ сотрудника "%s" уже выполнено',
        [
          ChargeSheet.Performer.FullName
        ]
      );

  end;

end;

end.
