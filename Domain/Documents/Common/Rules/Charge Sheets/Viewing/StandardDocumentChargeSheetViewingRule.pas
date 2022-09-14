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
  IDocumentUnit,
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
          DocumentChargeSheet: TDocumentChargeSheet;
          Document: IDocument
        ); override;

      protected

        function CanBeDocumentViewedBySignerAsChargeSheetIssuer(Document: IDocument): Boolean;

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
          DocumentChargeSheet: IDocumentChargeSheet;
          Document: IDocument
        ): TDocumentChargeSheetViewingRuleEnsuringResult; virtual;

        function MayEmployeeViewDocumentChargeSheet(
          Employee: TEmployee;
          DocumentChargeSheet: IDocumentChargeSheet;
          Document: IDocument
        ): TDocumentChargeSheetViewingRuleEnsuringResult; virtual;

    end;

implementation

uses

  Document,
  PersonnelOrder,
  VariantFunctions;

{ TStandardDocumentChargeSheetViewingRule }

function TStandardDocumentChargeSheetViewingRule.CanBeDocumentViewedBySignerAsChargeSheetIssuer(
  Document: IDocument): Boolean;
begin

  {
    refactor: получать в виде хэша в конструкторе список типов документов,
    которые могут быть просмотрены подписантами в качестве выдавших
    листы поручения. Это будет влиять на то, может ли сотрудник, будучи
    подписантом документа выдавать новые листы поручения после
    подписания
  }

  Result := TDocument(Document.Self) is TPersonnelOrder;
  
end;

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
    DocumentChargeSheet: TDocumentChargeSheet;
    Document: IDocument
  );
begin

  EnsureEmployeeMayViewDocumentChargeSheet(Employee, DocumentChargeSheet, Document);
  
end;

function TStandardDocumentChargeSheetViewingRule
  .MayEmployeeViewDocumentChargeSheet(
    Employee: TEmployee;
    DocumentChargeSheet: IDocumentChargeSheet;
    Document: IDocument
  ): TDocumentChargeSheetViewingRuleEnsuringResult;
begin

  try

    Result :=
      EnsureEmployeeMayViewDocumentChargeSheet(
        Employee, DocumentChargeSheet, Document
      );

  except

    on E: TDocumentChargeSheetViewingRuleException do
      Result := EmployeeMayNotViewDocumentChargeSheet;

  end;
  
end;

function TStandardDocumentChargeSheetViewingRule.
  EnsureEmployeeMayViewDocumentChargeSheet(
    Employee: TEmployee;
    DocumentChargeSheet: IDocumentChargeSheet;
    Document: IDocument
  ): TDocumentChargeSheetViewingRuleEnsuringResult;
var
    ChargeSheetObj: TDocumentChargeSheet;
    IsIssuerAnyOfSigners: Boolean;
begin

  Result := EmployeeMayNotViewDocumentChargeSheet;

  ChargeSheetObj := DocumentChargeSheet.Self as TDocumentChargeSheet;
  
  IsIssuerAnyOfSigners :=
    not CanBeDocumentViewedBySignerAsChargeSheetIssuer(Document)
    and
    TDocument(Document.Self)
      .Specifications
        .DocumentSigningSpecification
          .IsEmployeeAnyOfDocumentSigners(ChargeSheetObj.Issuer, Document);
      
  if
    FEmployeeIsSameAsOrDeputySpecification.IsEmployeeSameAsOrDeputyForOther(
      Employee, ChargeSheetObj.Issuer
    )
  then begin

    Result := 
      VarIfThen(
        IsIssuerAnyOfSigners,
        EmployeeMayViewDocumentChargeSheetAsAuthorized, 
        EmployeeMayViewDocumentChargeSheetAsIssuer
      );

  end;

  if 
    (Result <> EmployeeMayViewDocumentChargeSheetAsIssuer) 
    and 
    FEmployeeIsSameAsOrDeputySpecification.IsEmployeeSameAsOrDeputyForOther(
      Employee, ChargeSheetObj.Performer
    )
  then begin

    Result := EmployeeMayViewDocumentChargeSheetAsPerformer;

  end;

  if Result <> EmployeeMayNotViewDocumentChargeSheet then Exit;
  
  if (

    FEmployeeIsSecretaryForAnyOfEmployeesSpecification
      .IsEmployeeSecretaryForOther(
        Employee, ChargeSheetObj.Performer
      )

     or

    FWorkspaceEmployeeDistributionSpecification
      .IsEmployeeWorkspaceIncludesOtherEmployee(
        Employee, ChargeSheetObj.Performer
      )
     
   )
  then begin

    Result := EmployeeMayViewDocumentChargeSheetAsAuthorized;

  end

  else begin

    Raise TDocumentChargeSheetViewingRuleException.CreateFmt(
      'Сотрудник "%s" не может ' +
      'просматривать поручение, ' +
      'выданное сотрудником "%s" ' +
      'сотруднику "%s"',
      [
        Employee.FullName,
        ChargeSheetObj.Issuer.FullName,
        ChargeSheetObj.Performer.FullName
      ]
    );

  end;
  
end;

end.
