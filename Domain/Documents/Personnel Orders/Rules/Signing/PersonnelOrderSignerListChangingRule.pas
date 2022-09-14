unit PersonnelOrderSignerListChangingRule;

interface

uses

  StandardDocumentSignerListChangingRule,
  Employee,
  Document,
  IDocumentUnit,
  PersonnelOrderSignerListFinder,
  DocumentSignerListChangingRule,
  DocumentFullNameCompilationService,
  EmployeeIsSameAsOrReplacingForOthersSpecification,
  AreEmployeesSubLeadersOfSameLeaderSpecification,
  AreEmployeesSecretariesOfSameLeaderSpecification,
  EmployeeIsLeaderForOtherSpecification,
  PersonnelOrder,
  PersonnelOrderSignerList,
  EmployeesWorkGroupMembershipSpecification,
  SysUtils;

type

  TPersonnelOrderSignerListChangingRule =
    class (TStandardEmployeeDocumentSignerListChangingRule)

      protected

        FPersonnelOrderSignerListFinder: IPersonnelOrderSignerListFinder;

      protected

        procedure RaiseSignerAssigningExceptionIfEmployeeHasNotRightsForAssigningAsSigner(
          Signer: TEmployee;
          Document: IDocument;
          AssigningEmployee: TEmployee
        ); override;

      public

        constructor Create(

          DocumentFullNameCompilationService:
            IDocumentFullNameCompilationService;

          EmployeeIsSameAsOrReplacingForOthersSpecification:
            IEmployeeIsSameAsOrReplacingForOthersSpecification;

          AreEmployeesSubLeadersOfSameLeaderSpecification:
            IAreEmployeesSubLeadersOfSameLeaderSpecification;

          AreEmployeesSecretariesOfSameLeaderSpecification:
            IAreEmployeesSecretariesOfSameLeaderSpecification;

          EmployeeIsLeaderForOtherSpecification:
            IEmployeeIsLeaderForOtherSpecification;

          EmployeesWorkGroupMembershipSpecification:
            IEmployeesWorkGroupMembershipSpecification;

          PersonnelOrderSignerListFinder: IPersonnelOrderSignerListFinder
        );

    end;
  
implementation

uses

  IDomainObjectBaseListUnit;

{ TPersonnelOrderSignerListChangingRule }

constructor TPersonnelOrderSignerListChangingRule.Create(

  DocumentFullNameCompilationService:
    IDocumentFullNameCompilationService;

  EmployeeIsSameAsOrReplacingForOthersSpecification:
    IEmployeeIsSameAsOrReplacingForOthersSpecification;

  AreEmployeesSubLeadersOfSameLeaderSpecification:
    IAreEmployeesSubLeadersOfSameLeaderSpecification;

  AreEmployeesSecretariesOfSameLeaderSpecification:
    IAreEmployeesSecretariesOfSameLeaderSpecification;

  EmployeeIsLeaderForOtherSpecification:
    IEmployeeIsLeaderForOtherSpecification;

  EmployeesWorkGroupMembershipSpecification:
    IEmployeesWorkGroupMembershipSpecification;
    
  PersonnelOrderSignerListFinder: IPersonnelOrderSignerListFinder
);
begin

  inherited Create(
    DocumentFullNameCompilationService,
    EmployeeIsSameAsOrReplacingForOthersSpecification,
    AreEmployeesSubLeadersOfSameLeaderSpecification,
    AreEmployeesSecretariesOfSameLeaderSpecification,
    EmployeeIsLeaderForOtherSpecification,
    EmployeesWorkGroupMembershipSpecification
  );

  FPersonnelOrderSignerListFinder := PersonnelOrderSignerListFinder;
  
end;

procedure TPersonnelOrderSignerListChangingRule.
  RaiseSignerAssigningExceptionIfEmployeeHasNotRightsForAssigningAsSigner(
    Signer: TEmployee;
    Document: IDocument;
    AssigningEmployee: TEmployee
  );
var
    PersonnelOrder: TPersonnelOrder;
begin

  PersonnelOrder := Document.Self as TPersonnelOrder;

  if
    not
    FPersonnelOrderSignerListFinder.IsPersonnelOrderEmployeeListIncludesEmployee(
      Signer.Identity
    )
  then begin

    raise TDocumentSignerListChangingRuleException.CreateFmt(
      'Сотрудник "%s" не входит в число лиц, ' +
      'имеющих возможность подписи кадровых приказов',
      [
        Signer.FullName
      ]
    );

  end;

end;

end.
