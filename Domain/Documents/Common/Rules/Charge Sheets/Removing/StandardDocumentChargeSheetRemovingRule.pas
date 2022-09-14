unit StandardDocumentChargeSheetRemovingRule;

interface

uses

  DocumentChargeSheetRemovingRule,
  StandardDocumentChargeSheetWorkingRule,
  IDocumentChargeSheetUnit,
  DocumentChargeSheetWorkingRule,
  DocumentChargeSheet,
  IDocumentUnit,
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

        procedure RaiseChargeSheetAlreadyPerformedException(
          ChargeSheet: TDocumentChargeSheet
        );

        procedure RaiseEmployeeIsNotSameAsChargeSheetIssuerOrHisDeputyException(
          Employee: TEmployee;
          ChargeSheet: TDocumentChargeSheet
        );

        procedure RaiseExceptionIfChargeSheetAlreadyPerformed(
          Employee: TEmployee;
          ChargeSheet: TDocumentChargeSheet
        );

        procedure RaiseExceptionIfEmployeeIsNotSameAsChargeSheetIssuerOrHisDeputy(
          Employee: TEmployee;
          ChargeSheet: TDocumentChargeSheet
        );

        procedure RaiseExceptionIfDocumentStateIsNotValid(
          Employee: TEmployee;
          ChargeSheetObj: TDocumentChargeSheet;
          Document: IDocument
        );

      public

        constructor Create(
          EmployeeIsSameAsOrDeputySpecification:
            IEmployeeIsSameAsOrDeputySpecification
        );

        procedure EnsureThatIsSatisfiedFor(
          Employee: TEmployee;
          DocumentChargeSheet: IDocumentChargeSheet;
          Document: IDocument
        ); virtual;

        function IsSatisfiedBy(
          Employee: TEmployee;
          DocumentChargeSheet: IDocumentChargeSheet;
          Document: IDocument
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
  DocumentChargeSheet: IDocumentChargeSheet;
  Document: IDocument
): Boolean;
begin

  try

    EnsureThatIsSatisfiedFor(Employee, DocumentChargeSheet, Document);
    
    Result := True;

  except

    on E: TDocumentChargeSheetRemovingRuleException do Result := False;

  end;

end;

procedure TStandardDocumentChargeSheetRemovingRule.EnsureThatIsSatisfiedFor(
  Employee: TEmployee;
  DocumentChargeSheet: IDocumentChargeSheet;
  Document: IDocument
);
var
    ChargeSheetObj: TDocumentChargeSheet;
begin

  ChargeSheetObj := TDocumentChargeSheet(DocumentChargeSheet.Self);

  RaiseExceptionIfDocumentStateIsNotValid(Employee, ChargeSheetObj, Document);
  
  RaiseExceptionIfEmployeeIsNotSameAsChargeSheetIssuerOrHisDeputy(
    Employee, ChargeSheetObj
  );

  RaiseExceptionIfChargeSheetAlreadyPerformed(Employee, ChargeSheetObj);

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
    'Сотрудник "%s" не является ' +
    'исполняющим обязанности для сотрудника "%s"',
    [
      Employee.FullName,
      ChargeSheet.Issuer.FullName
    ]
  );

end;

procedure TStandardDocumentChargeSheetRemovingRule.RaiseExceptionIfChargeSheetAlreadyPerformed(
  Employee: TEmployee;
  ChargeSheet: TDocumentChargeSheet
);
begin

  if ChargeSheet.IsPerformed then
    RaiseChargeSheetAlreadyPerformedException(ChargeSheet);

end;

procedure TStandardDocumentChargeSheetRemovingRule.RaiseExceptionIfDocumentStateIsNotValid(
  Employee: TEmployee;
  ChargeSheetObj: TDocumentChargeSheet;
  Document: IDocument
);
begin

  if ChargeSheetObj.DocumentId <> Document.Identity then begin

    Raise TDocumentChargeSheetRemovingRuleException.CreateFmt(
      'Поручение для сотрудника "%s" не относится к документу',
      [
        ChargeSheetObj.Performer.FullName
      ]
    );

  end;

  if                  
    not (ChargeSheetObj is TDocumentAcquaitanceSheet)
    and Document.IsPerformed
  then begin
  
    Raise TDocumentChargeSheetRemovingRuleException.CreateFmt(
      'Поручение для сотрудника "%s" не может быть ' +
      'удалено, поскольку документ уже выполнен',
      [
        ChargeSheetObj.Performer.FullName
      ]
    );

  end;

end;

procedure TStandardDocumentChargeSheetRemovingRule.RaiseChargeSheetAlreadyPerformedException(
  ChargeSheet: TDocumentChargeSheet);
begin

  Raise TDocumentChargeSheetRemovingRuleException.CreateFmt(
    'Поручение для сотрудника "%s"' +
    'уже выполнено',
    [
      ChargeSheet.Performer.FullName
    ]
  );

end;

end.
