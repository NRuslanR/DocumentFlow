unit StandardDocumentPerformingSheetIssuingRule;

interface

uses

  DocumentChargeSheetIssuingRule,
  StandardDocumentChargeSheetWorkingRule,
  DocumentChargeSheetPerformingRule,
  EmployeeIsSameAsOrDeputySpecification,
  DomainException,
  IDocumentChargeSheetUnit,
  DocumentChargeSheet,
  Employee,
  SysUtils;

type

  TStandardDocumentPerformingSheetIssuingRule =
    class (
      TStandardDocumentChargeSheetWorkingRule,
      IDocumentChargeSheetIssuingRule
    )

      private

        FDocumentChargeSheetPerformingRule: IDocumentChargeSheetPerformingRule;

      protected

        procedure InternalEnsureThatIsSatisfiedFor(
          Employee: TEmployee;
          DocumentChargeSheet: TDocumentChargeSheet
        ); override;

      public

        constructor Create(

          EmployeeIsSameAsOrDeputySpecification:
            IEmployeeIsSameAsOrDeputySpecification;

          DocumentChargeSheetPerformingRule:
            IDocumentChargeSheetPerformingRule
            
        );

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

{ TStandardDocumentPerformingSheetIssuingRule }

constructor TStandardDocumentPerformingSheetIssuingRule.Create(
  EmployeeIsSameAsOrDeputySpecification: IEmployeeIsSameAsOrDeputySpecification;
  DocumentChargeSheetPerformingRule: IDocumentChargeSheetPerformingRule
);
begin

  inherited Create(EmployeeIsSameAsOrDeputySpecification);

  FDocumentChargeSheetPerformingRule := DocumentChargeSheetPerformingRule;

end;

function TStandardDocumentPerformingSheetIssuingRule
  .CanEmployeeCanIssueSubordinateChargeSheet(
    Employee: TEmployee;
    DocumentChargeSheet: IDocumentChargeSheet
  ): Boolean;
begin

  Result := IsSatisfiedBy(Employee, DocumentChargeSheet);
  
end;

procedure TStandardDocumentPerformingSheetIssuingRule
  .EnsureEmployeeCanIssueSubordinateChargeSheet(
    Employee: TEmployee;
    DocumentChargeSheet: IDocumentChargeSheet
  );
begin

  EnsureThatIsSatisfiedFor(Employee, DocumentChargeSheet);
  
end;

procedure TStandardDocumentPerformingSheetIssuingRule
  .InternalEnsureThatIsSatisfiedFor(
    Employee: TEmployee;
    DocumentChargeSheet: TDocumentChargeSheet
  );
begin

  if
    not FDocumentChargeSheetPerformingRule.IsSatisfiedBy(
      Employee, DocumentChargeSheet
    )
  then begin

    Raise TDocumentChargeSheetIssuingRuleException.Create(
      'Отсутствуют права на выдачу подчинённых поручений'
    );

  end;

end;

end.
