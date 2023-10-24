unit StandardDocumentAcquaitanceSheetIssuingRule;

interface

uses

  StandardDocumentChargeSheetWorkingRule,
  DocumentChargeSheetIssuingRule,
  DomainException,
  IDocumentChargeSheetUnit,
  DocumentChargeSheet,
  Employee,
  SysUtils;

type

  TStandardDocumentAcquaitanceSheetIssuingRule =
    class (
      TStandardDocumentChargeSheetWorkingRule,
      IDocumentChargeSheetIssuingRule
    )

      protected

        procedure InternalEnsureThatIsSatisfiedFor(
          Employee: TEmployee;
          DocumentChargeSheet: TDocumentChargeSheet
        ); override;

      public

        procedure EnsureEmployeeCanIssueSubordinateChargeSheet(
          Employee: TEmployee;
          DocumentChargeSheet: IDocumentChargeSheet
        );

        function CanEmployeeCanIssueSubordinateChargeSheet(
          Employee: TEmployee;
          DocumentChargeSheet: IDocumentChargeSheet
        ): Boolean;

    end;

implementation

{ TStandardDocumentAcquaitanceSheetIssuingRule }

function TStandardDocumentAcquaitanceSheetIssuingRule
  .CanEmployeeCanIssueSubordinateChargeSheet(
    Employee: TEmployee;
    DocumentChargeSheet: IDocumentChargeSheet
  ): Boolean;
begin

  Result := IsSatisfiedBy(Employee, DocumentChargeSheet);
  
end;

procedure TStandardDocumentAcquaitanceSheetIssuingRule
  .EnsureEmployeeCanIssueSubordinateChargeSheet(
    Employee: TEmployee;
    DocumentChargeSheet: IDocumentChargeSheet
  );
begin

  EnsureThatIsSatisfiedFor(Employee, DocumentChargeSheet);
  
end;

procedure TStandardDocumentAcquaitanceSheetIssuingRule
  .InternalEnsureThatIsSatisfiedFor(
    Employee: TEmployee;
    DocumentChargeSheet: TDocumentChargeSheet
  );
begin

  if
    not
      FEmployeeIsSameAsOrDeputySpecification
        .IsEmployeeSameAsOrDeputyForOtherOrViceVersa(
          Employee, DocumentChargeSheet.Performer
        )
  then begin

    Raise TDocumentChargeSheetIssuingRuleException.Create(
      'Отсутствуют права для выдачи подчинённого поручения на ознакомление'
    );
  
  end;

end;

end.
