unit StandardDocumentChargeSheetViewingRule;

interface

uses

  StandardDocumentChargeSheetWorkingRule,
  DocumentChargeSheet,
  EmployeeIsSameAsOrDeputySpecification,
  EmployeeIsSecretaryForAnyOfEmployeesSpecification,
  WorkspaceEmployeeDistributionSpecification,
  DocumentChargeSheetWorkingRule,
  DocumentChargeSheetViewingRule,
  IDocumentChargeSheetUnit,
  Employee,
  SysUtils,
  Classes;

type

  TStandardDocumentChargeSheetViewingRule =
    class (
      TStandardDocumentChargeSheetWorkingRule,
      IDocumentChargeSheetViewingRule
    )

      protected

        FEmployeeIsSecretaryForAnyOfEmployeesSpecification:
          IEmployeeIsSecretaryForAnyOfEmployeesSpecification;

        FWorkspaceEmployeeDistributionSpecification:
          IWorkspaceEmployeeDistributionSpecification;

        procedure InternalEnsureThatIsSatisfiedFor(
          Employee: TEmployee;
          DocumentChargeSheet: TDocumentChargeSheet
        ); override;

      public

        constructor Create(

          EmployeeIsSameAsOrDeputySpecification:
            IEmployeeIsSameAsOrDeputySpecification;

          EmployeeIsSecretaryForAnyOfEmployeesSpecification:
            IEmployeeIsSecretaryForAnyOfEmployeesSpecification;

          WorkspaceEmployeeDistributionSpecification:
            IWorkspaceEmployeeDistributionSpecification
        );

        function EnsureEmployeeMayViewDocumentChargeSheet(
          Employee: TEmployee;
          DocumentChargeSheet: IDocumentChargeSheet
        ): TDocumentChargeSheetViewingRuleEnsuringResult;

        function MayEmployeeViewDocumentChargeSheet(
          Employee: TEmployee;
          DocumentChargeSheet: IDocumentChargeSheet
        ): TDocumentChargeSheetViewingRuleEnsuringResult;

    end;

implementation

uses

  Document,
  PersonnelOrder,
  VariantFunctions, DocumentSigningSpecification;

{ TStandardDocumentChargeSheetViewingRule }

constructor TStandardDocumentChargeSheetViewingRule.Create(

  EmployeeIsSameAsOrDeputySpecification:
    IEmployeeIsSameAsOrDeputySpecification;

  EmployeeIsSecretaryForAnyOfEmployeesSpecification:
    IEmployeeIsSecretaryForAnyOfEmployeesSpecification;

  WorkspaceEmployeeDistributionSpecification: IWorkspaceEmployeeDistributionSpecification
);
begin

  inherited Create(EmployeeIsSameAsOrDeputySpecification);

  FEmployeeIsSecretaryForAnyOfEmployeesSpecification :=
    EmployeeIsSecretaryForAnyOfEmployeesSpecification;

  FWorkspaceEmployeeDistributionSpecification :=
    WorkspaceEmployeeDistributionSpecification;

end;

procedure TStandardDocumentChargeSheetViewingRule.
  InternalEnsureThatIsSatisfiedFor(
    Employee: TEmployee;
    DocumentChargeSheet: TDocumentChargeSheet
  );
begin

  EnsureEmployeeMayViewDocumentChargeSheet(Employee, DocumentChargeSheet);

end;

function TStandardDocumentChargeSheetViewingRule
  .MayEmployeeViewDocumentChargeSheet(
    Employee: TEmployee;
    DocumentChargeSheet: IDocumentChargeSheet
  ): TDocumentChargeSheetViewingRuleEnsuringResult;
begin

  try

    Result :=
      EnsureEmployeeMayViewDocumentChargeSheet(
        Employee, DocumentChargeSheet
      );

  except

    on E: TDocumentChargeSheetViewingRuleException do
      Result := EmployeeMayNotViewDocumentChargeSheet;

  end;

end;

function TStandardDocumentChargeSheetViewingRule
  .EnsureEmployeeMayViewDocumentChargeSheet(
    Employee: TEmployee;
    DocumentChargeSheet: IDocumentChargeSheet
  ): TDocumentChargeSheetViewingRuleEnsuringResult;
begin

  if
    FEmployeeIsSameAsOrDeputySpecification.IsEmployeeSameAsOrDeputyForOther(
      Employee, DocumentChargeSheet.Issuer
    )
  then begin

    Result := EmployeeMayViewDocumentChargeSheetAsIssuer;
    Exit;

  end;

  if 
    FEmployeeIsSameAsOrDeputySpecification.IsEmployeeSameAsOrDeputyForOther(
      Employee, DocumentChargeSheet.Performer
    )
  then begin

    Result := EmployeeMayViewDocumentChargeSheetAsPerformer;
    Exit;

  end;

  if
    FEmployeeIsSecretaryForAnyOfEmployeesSpecification
      .IsEmployeeSecretaryForOther(Employee, DocumentChargeSheet.Performer)

     or

    FWorkspaceEmployeeDistributionSpecification
      .IsEmployeeWorkspaceIncludesOtherEmployee(Employee, DocumentChargeSheet.Performer)

  then begin

    Result := EmployeeMayViewDocumentChargeSheetAsAuthorized;
    Exit;

  end;

  Raise TDocumentChargeSheetViewingRuleException.CreateFmt(
    'Сотрудник "%s" не может ' +
    'просматривать поручение, ' +
    'выданное сотрудником "%s" ' +
    'сотруднику "%s"',
    [
      Employee.FullName,
      DocumentChargeSheet.Issuer.FullName,
      DocumentChargeSheet.Performer.FullName
    ]
  );

end;

end.
